import contextlib
import io
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import publish


class PublishTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        modules = [
            publish.ModuleConfig(name, self.root / name)
            for name in ("selene-core", "selene-webgpu", "selene-codegen")
        ]
        for module in modules:
            module.path.mkdir()
            (module.path / "moon.mod").write_text(
                'version = "0.39.2"\nimport { "Milky2018/selene@0.39.1" }\n'
            )
        self.examples = [self.root / "examples", self.root / "examples-web"]
        for example in self.examples:
            example.mkdir()
            (example / "moon.mod").write_text(
                'version = "0.21.2"\nimport { "Milky2018/selene@0.39.1" }\n'
            )
        for relative in publish.CODEGEN_PIN_FILES:
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            with path.open("a") as file:
                file.write('moonx Milky2018/selene_codegen@0.39.2 "$input" "$output"\n')
        changelog = self.root / "CHANGELOG.md"
        changelog.write_text("## [Unreleased]\n\n## [0.40.0] - 2026-11-06\n")
        self.stack = contextlib.ExitStack()
        self.addCleanup(self.stack.close)
        for name, value in {
            "ROOT_DIR": self.root,
            "RELEASE_MODULES": modules,
            "EXAMPLE_MODULE_DIRS": self.examples,
            "CHANGELOG_PATH": changelog,
        }.items():
            self.stack.enter_context(patch.object(publish, name, value))
        self.stack.enter_context(contextlib.redirect_stdout(io.StringIO()))
        self.events = []
        self.stack.enter_context(patch.object(
            publish, "run_module_quality_checks",
            side_effect=lambda module: self.events.append("quality:" + module.name),
        ))
        self.stack.enter_context(patch.object(
            publish, "run_publish_cmd",
            side_effect=lambda module: self.events.append("publish:" + module.name),
        ))
        self.stack.enter_context(patch.object(
            publish, "wait_for_codegen",
            side_effect=lambda version: self.events.append("ready:" + version),
        ))
        self.stack.enter_context(patch.object(
            publish, "sync_generated_sources",
            side_effect=lambda version: self.events.append("generated:" + version),
        ))
        self.stack.enter_context(patch.object(publish, "ensure_no_legacy_ui_references"))
        self.commands = self.stack.enter_context(patch.object(
            publish, "run_cmd",
            side_effect=lambda command, *args, **kwargs: self.events.append(
                "command:" + " ".join(command)
            ),
        ))

    def test_beta_updates_codegen_and_pins_without_rewriting_engine_versions(self):
        engine_paths = [
            self.root / name / "moon.mod" for name in ("selene-core", "selene-webgpu")
        ]
        engine_before = {path: path.read_text() for path in engine_paths}
        with patch.object(publish.sys, "argv", ["publish.py", "0.40.0-beta1", "--codegen-only"]):
            publish.main()
        self.assertIn('version = "0.40.0-beta1"', (self.root / "selene-codegen/moon.mod").read_text())
        for path, content in engine_before.items():
            self.assertEqual(path.read_text(), content)
        for example in self.examples:
            self.assertIn('version = "0.21.2"', (example / "moon.mod").read_text())
            self.assertIn('selene@0.39.1', (example / "moon.mod").read_text())
        for relative in publish.CODEGEN_PIN_FILES:
            self.assertIn("selene_codegen@0.40.0-beta1", (self.root / relative).read_text())
        self.assertEqual(
            [event for event in self.events if event.startswith("publish:")],
            ["publish:selene-codegen"],
        )
        self.assertLess(self.events.index("ready:0.40.0-beta1"), self.events.index("generated:0.40.0-beta1"))

    def test_stable_release_publishes_codegen_and_validates_before_core_and_webgpu(self):
        publish.rewrite_module_for_release(
            publish.module_by_name("selene-codegen"), "0.40.0-beta2"
        )
        publish.sync_codegen_pins("0.40.0-beta2")
        publish.run_release_pipeline("0.40.0")
        self.assertEqual(
            [event for event in self.events if event.startswith("publish:")],
            ["publish:selene-codegen", "publish:selene-core", "publish:selene-webgpu"],
        )
        generated = self.events.index("generated:0.40.0")
        self.assertLess(generated, self.events.index("quality:selene-core"))
        self.assertLess(
            self.events.index("command:moon test --deny-warn"),
            self.events.index("publish:selene-core"),
        )
        for relative in publish.CODEGEN_PIN_FILES:
            self.assertIn("selene_codegen@0.40.0 ", (self.root / relative).read_text())
        for module in publish.RELEASE_MODULES:
            self.assertIn('version = "0.40.0"', (module.path / "moon.mod").read_text())
        for example in self.examples:
            self.assertIn('selene@0.40.0', (example / "moon.mod").read_text())

    def test_failed_workspace_validation_stops_engine_publication(self):
        def run(command, *args, **kwargs):
            if command == ["moon", "check", "--target", "all", "--deny-warn"]:
                raise RuntimeError("workspace check failed")
        self.commands.side_effect = run
        with self.assertRaisesRegex(RuntimeError, "workspace check failed"):
            publish.run_release_pipeline("0.40.0")
        self.assertEqual(
            [event for event in self.events if event.startswith("publish:")],
            ["publish:selene-codegen"],
        )

    def test_cli_rejects_stable_codegen_only_and_engine_prereleases(self):
        for args in (
            ["0.40.0", "--codegen-only"],
            ["0.40.0-beta1"],
            ["0.40.0-beta0", "--codegen-only"],
        ):
            with self.subTest(args=args), patch.object(publish.sys, "argv", ["publish.py", *args]):
                with self.assertRaises(SystemExit) as error:
                    publish.main()
                self.assertEqual(error.exception.code, 2)
        self.assertEqual(self.events, [])

    def test_missing_codegen_asset_leaves_existing_consumer_pins_in_place(self):
        original = {
            relative: (self.root / relative).read_text()
            for relative in publish.CODEGEN_PIN_FILES
        }
        with patch.object(publish, "wait_for_codegen", side_effect=RuntimeError("asset unavailable")):
            with self.assertRaisesRegex(RuntimeError, "asset unavailable"):
                publish.run_codegen_release("0.40.0-beta1")
        for relative, content in original.items():
            self.assertEqual((self.root / relative).read_text(), content)

    def test_missing_stable_changelog_entry_prevents_publication(self):
        with self.assertRaisesRegex(RuntimeError, "Missing changelog entry"):
            publish.run_release_pipeline("0.41.0")
        self.assertEqual(self.events, [])

    def test_pin_sync_validates_every_file_before_writing(self):
        first = self.root / publish.CODEGEN_PIN_FILES[0]
        original = first.read_text()
        (self.root / publish.CODEGEN_PIN_FILES[-1]).write_text("missing pin\n")
        with self.assertRaisesRegex(RuntimeError, "Missing codegen version pin"):
            publish.sync_codegen_pins("0.40.0-beta2")
        self.assertEqual(first.read_text(), original)




class GeneratedSourceTests(unittest.TestCase):
    def test_new_generator_regenerates_companions_before_checking_sources(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "state.mbt").write_text("#selene.resource\nstruct State {}\n")
            (root / "state.g.mbt").write_text("// Generated by Selene codegen. DO NOT EDIT.\n")
            with patch.object(publish, "ROOT_DIR", root):
                with patch.object(publish.subprocess, "check_output", return_value=b"state.mbt\0state.g.mbt\0"):
                    with patch.object(publish, "run_cmd") as run:
                        publish.sync_generated_sources("0.40.0-beta2")
        self.assertEqual(
            [call.args[0] for call in run.call_args_list],
            [
                ["moonx", "Milky2018/selene_codegen@0.40.0-beta2", "state.mbt", "state.g.mbt"],
                ["moonx", "Milky2018/selene_codegen@0.40.0-beta2", "--check", "state.mbt", "state.g.mbt"],
            ],
        )


class CodegenAvailabilityTests(unittest.TestCase):
    def test_wait_retries_only_a_missing_published_wasm_asset(self):
        responses = [
            subprocess.CompletedProcess([], 255, "", "Prebuilt wasm asset does not exist"),
            subprocess.CompletedProcess([], 0, "", ""),
        ]
        with patch.object(publish.subprocess, "run", side_effect=responses) as run:
            with patch.object(publish.time, "sleep") as sleep:
                with contextlib.redirect_stdout(io.StringIO()):
                    publish.wait_for_codegen("0.40.0-beta1")
        self.assertEqual(run.call_count, 2)
        sleep.assert_called_once_with(5)

    def test_wait_fails_immediately_on_other_errors(self):
        failure = subprocess.CompletedProcess([], 255, "", "checksum mismatch")
        with patch.object(publish.subprocess, "run", return_value=failure) as run:
            with patch.object(publish.time, "sleep") as sleep:
                with self.assertRaisesRegex(RuntimeError, "checksum mismatch"):
                    publish.wait_for_codegen("0.40.0-beta1")
        self.assertEqual(run.call_count, 1)
        sleep.assert_not_called()


if __name__ == "__main__":
    unittest.main()
