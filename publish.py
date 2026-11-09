#!/usr/bin/env python3
"""
Release publish script for Selene modules.
"""

import os
import re
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path

ROOT_DIR = Path(__file__).parent
EXAMPLE_MODULE_DIRS = [
    ROOT_DIR / "examples",
    ROOT_DIR / "examples-web",
]
CHANGELOG_REL_PATH = Path("docs/CHANGELOG.md")
CHANGELOG_PATH = ROOT_DIR / CHANGELOG_REL_PATH

VERSION_CORE = r"(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)"
STABLE_VERSION_RE = re.compile(rf"^{VERSION_CORE}$")
CODEGEN_BETA_RE = re.compile(rf"^{VERSION_CORE}-beta[1-9]\d*$")
CODEGEN_PIN_FILES = [
    ".github/workflows/build.yaml",
    "examples/moon.mod",
    "examples-web/moon.mod",
    "selene-codegen/README.md",
    "selene-core/src/ecs/README.md",
]
INTERNAL_MODULES = {
    "Milky2018/selene",
    "Milky2018/selene_webgpu",
}


@dataclass(frozen=True)
class ModuleConfig:
    name: str
    path: Path


RELEASE_MODULES = [
    ModuleConfig("selene-core", ROOT_DIR / "selene-core"),
    ModuleConfig("selene-webgpu", ROOT_DIR / "selene-webgpu"),
    ModuleConfig("selene-codegen", ROOT_DIR / "selene-codegen"),
]

ENGINE_PUBLISH_ORDER = [
    "selene-core",
    "selene-webgpu",
]

LEGACY_UI_CHECK_REL_PATH = Path("scripts/check_no_legacy_ui.sh")
LEGACY_UI_CHECK_PATH = ROOT_DIR / LEGACY_UI_CHECK_REL_PATH


def changelog_has_version(version: str, changelog_text: str) -> bool:
    heading_patterns = [
        rf"^##\s*\[{re.escape(version)}\](?:\s*-.*)?$",
        rf"^##\s*\[v{re.escape(version)}\](?:\s*-.*)?$",
        rf"^##\s+{re.escape(version)}(?:\s*-.*)?$",
        rf"^##\s+v{re.escape(version)}(?:\s*-.*)?$",
    ]
    return any(re.search(pattern, changelog_text, flags=re.MULTILINE) for pattern in heading_patterns)


def ensure_changelog_entry_exists(version: str):
    if not CHANGELOG_PATH.exists():
        raise RuntimeError(f"Missing changelog file: {CHANGELOG_REL_PATH}")

    changelog_text = CHANGELOG_PATH.read_text(encoding="utf-8")
    if changelog_has_version(version, changelog_text):
        return

    raise RuntimeError(
        "Missing changelog entry for release version "
        f"{version} in {CHANGELOG_REL_PATH}.\n"
        "Please add a section header like:\n"
        f"  ## [{version}] - YYYY-MM-DD"
    )


def run_cmd(
    cmd: list[str],
    cwd: Path,
    *,
    fail_on_warning: bool = False,
    env: dict[str, str] | None = None,
):
    print(f"$ (cd {cwd} && {' '.join(cmd)})")
    proc = subprocess.run(
        cmd,
        cwd=cwd,
        text=True,
        capture_output=True,
        check=False,
        env=env,
    )

    if proc.stdout:
        print(proc.stdout, end="" if proc.stdout.endswith("\n") else "\n")
    if proc.stderr:
        print(proc.stderr, end="" if proc.stderr.endswith("\n") else "\n")

    if proc.returncode != 0:
        raise RuntimeError(
            f"Command failed with exit code {proc.returncode}: {' '.join(cmd)}"
        )

    if fail_on_warning:
        merged = f"{proc.stdout}\n{proc.stderr}"
        if has_warning(merged):
            raise RuntimeError(f"Warning detected: {' '.join(cmd)}")


def run_publish_cmd(module: ModuleConfig):
    # `moon publish` currently prints workspace preferred-target warnings even when
    # package validation succeeds. Treat publish as strict on exit code only:
    # non-zero exits (including HTTP 409 duplicated version) still fail fast.
    run_cmd(
        ["moon", "-C", str(module.path), "publish"],
        ROOT_DIR,
        fail_on_warning=False,
        env={**os.environ, "MOON_WORK": "off"} if module.name == "selene-codegen" else None,
    )


def has_warning(output: str) -> bool:
    filtered_lines = []
    for line in output.splitlines():
        if re.match(
            r"^Warning: Skipping package `[^`]+` for `moon info`: it does not support target backend `wasm-gc`$",
            line,
        ):
            continue
        filtered_lines.append(line)
    output = "\n".join(filtered_lines)
    patterns = [
        r"(^|\s)WARN(\s|:)",
        r"^Warning:",
        r"warnings?,",
        r"warnings?\.",
        r"warnings?\)",
    ]
    return any(re.search(pat, output, flags=re.MULTILINE) for pat in patterns)


def module_by_name(name: str) -> ModuleConfig:
    for module in RELEASE_MODULES:
        if module.name == name:
            return module
    raise ValueError(f"Unknown module: {name}")


def module_manifest_path(module: ModuleConfig) -> Path:
    return module.path / "moon.mod"


def module_relative_path(module: ModuleConfig, path: str) -> str:
    return str(Path(path).relative_to(module.path))


def module_info_entries(module: ModuleConfig) -> list[tuple[str, str]]:
    if module.name == "selene-core":
        return [
            (str(module.path / "src"), "js"),
            (str(module.path / "src"), "native"),
        ]
    if module.name == "selene-webgpu":
        return [(str(module.path / "src"), "js")]
    if module.name == "selene-codegen":
        return [(str(module.path), "wasm")]
    raise RuntimeError(f"Unknown module for info generation: {module.name}")


def ensure_no_legacy_ui_references():
    if not LEGACY_UI_CHECK_PATH.exists():
        raise RuntimeError(f"Missing legacy UI check script: {LEGACY_UI_CHECK_REL_PATH}")
    run_cmd(["bash", str(LEGACY_UI_CHECK_PATH)], ROOT_DIR, fail_on_warning=True)


def run_module_quality_checks(module: ModuleConfig):
    """Run fmt/info/check and fail on any warning."""
    info_entries = module_info_entries(module)

    run_cmd(
        ["moon", "-C", str(module.path), "fmt", "."],
        ROOT_DIR,
        fail_on_warning=True,
    )
    for info_entry_path, info_target in info_entries:
        run_cmd(
            [
                "moon",
                "-C",
                str(module.path),
                "info",
                module_relative_path(module, info_entry_path),
                "--target",
                info_target,
            ],
            ROOT_DIR,
            fail_on_warning=True,
        )

    if module.name == "selene-core":
        check_targets = ["js", "native"]
    elif module.name == "selene-webgpu":
        check_targets = ["js"]
    elif module.name == "selene-codegen":
        check_targets = ["wasm"]
    else:
        raise RuntimeError(f"Unknown module for quality checks: {module.name}")

    for target in check_targets:
        run_cmd(
            [
                "moon",
                "-C",
                str(module.path),
                "check",
                ".",
                "--target",
                target,
                "--deny-warn",
            ],
            ROOT_DIR,
            fail_on_warning=True,
        )


def rewrite_module_for_release(module: ModuleConfig, version: str):
    """Set module version and update internal deps for the current moon.mod format."""
    manifest_path = module_manifest_path(module)
    manifest_text = manifest_path.read_text(encoding="utf-8")
    manifest_text = re.sub(
        r'^version\s*=\s*"[^"]+"$',
        f'version = "{version}"',
        manifest_text,
        count=1,
        flags=re.MULTILINE,
    )
    manifest_text = rewrite_moon_mod_internal_imports(manifest_text, version)
    manifest_path.write_text(manifest_text, encoding="utf-8")


def sync_examples_internal_deps(version: str):
    """Keep example modules' internal Selene deps on the current release version."""
    for module_dir in EXAMPLE_MODULE_DIRS:
        manifest_path = module_dir / "moon.mod"
        manifest_text = manifest_path.read_text(encoding="utf-8")
        manifest_text = rewrite_moon_mod_internal_imports(manifest_text, version)
        manifest_path.write_text(manifest_text, encoding="utf-8")


def rewrite_moon_mod_internal_imports(manifest_text: str, version: str) -> str:
    def rewrite_import_block(match: re.Match[str]) -> str:
        block = match.group(0)
        for dep_name in INTERNAL_MODULES:
            dep_pattern = re.compile(
                rf'"{re.escape(dep_name)}(?:@[^"]+)?"',
            )
            block = dep_pattern.sub(f'"{dep_name}@{version}"', block)
        return block

    return re.sub(
        r"import\s*\{[^}]*\}",
        rewrite_import_block,
        manifest_text,
        count=1,
        flags=re.MULTILINE | re.DOTALL,
    )


def sync_codegen_pins(version: str):
    changes = {}
    for relative_path in CODEGEN_PIN_FILES:
        path = ROOT_DIR / relative_path
        content, count = re.subn(
            r"Milky2018/selene_codegen@[0-9][0-9A-Za-z.+-]*",
            f"Milky2018/selene_codegen@{version}",
            path.read_text(encoding="utf-8"),
        )
        if count == 0:
            raise RuntimeError(f"Missing codegen version pin in {relative_path}")
        changes[path] = content
    for path, content in changes.items():
        path.write_text(content, encoding="utf-8")


def wait_for_codegen(version: str):
    command = [
        "moonx",
        f"Milky2018/selene_codegen@{version}",
        "--check",
        "selene-codegen/main.mbt",
    ]
    for attempt in range(12):
        proc = subprocess.run(
            command, cwd=ROOT_DIR, text=True, capture_output=True, check=False,
        )
        if proc.returncode == 0:
            return
        output = proc.stdout + proc.stderr
        if "Prebuilt wasm asset does not exist" not in output:
            raise RuntimeError(output)
        if attempt < 11:
            print("Waiting for the published codegen Wasm asset...", flush=True)
            time.sleep(5)
    raise RuntimeError(f"Published codegen Wasm asset is unavailable for {version}")


def sync_generated_sources(version: str):
    tracked = subprocess.check_output(
        ["git", "ls-files", "-z", "--", "*.mbt"], cwd=ROOT_DIR,
    )
    sources = [path for path in tracked.decode("utf-8").split("\0") if path]
    for output in sources:
        if not output.endswith(".g.mbt"):
            continue
        if not (ROOT_DIR / output).read_text(encoding="utf-8").startswith(
            "// Generated by Selene codegen."
        ):
            continue
        source = output[: -len(".g.mbt")] + ".mbt"
        run_cmd(
            ["moonx", f"Milky2018/selene_codegen@{version}", source, output],
            ROOT_DIR,
            fail_on_warning=True,
        )
    run_cmd(
        ["moonx", f"Milky2018/selene_codegen@{version}", "--check", *sources],
        ROOT_DIR,
        fail_on_warning=True,
    )


def run_codegen_release(version: str):
    module = module_by_name("selene-codegen")
    run_module_quality_checks(module)
    rewrite_module_for_release(module, version)
    run_cmd(["moon", "-C", str(module.path), "update"], ROOT_DIR, fail_on_warning=True)
    run_cmd(
        ["moon", "-C", str(module.path), "test", ".", "--deny-warn"],
        ROOT_DIR,
        fail_on_warning=True,
    )
    run_publish_cmd(module)
    wait_for_codegen(version)
    sync_codegen_pins(version)
    sync_generated_sources(version)


def run_release_pipeline(version: str):
    ensure_changelog_entry_exists(version)
    ensure_no_legacy_ui_references()

    print(f"Publishing codegen {version} and validating its pinned consumers...")
    run_codegen_release(version)
    engine_modules = [module_by_name(name) for name in ENGINE_PUBLISH_ORDER]

    print("Running warning-free engine quality checks...")
    for module in engine_modules:
        run_module_quality_checks(module)

    print("Updating engine and example versions...")
    for module in engine_modules:
        rewrite_module_for_release(module, version)
    sync_examples_internal_deps(version)
    for module in engine_modules:
        run_cmd(["moon", "-C", str(module.path), "update"], ROOT_DIR, fail_on_warning=True)
    for module_dir in EXAMPLE_MODULE_DIRS:
        run_cmd(["moon", "-C", str(module_dir), "update"], ROOT_DIR, fail_on_warning=True)

    run_cmd(["moon", "check", "--target", "all", "--deny-warn"], ROOT_DIR, fail_on_warning=True)
    run_cmd(["moon", "test", "--deny-warn"], ROOT_DIR, fail_on_warning=True)

    print("Publishing core, then WebGPU...")
    for index, module in enumerate(engine_modules):
        run_publish_cmd(module)
        for remaining in engine_modules[index + 1:]:
            run_cmd(["moon", "-C", str(remaining.path), "update"], ROOT_DIR, fail_on_warning=True)

    print("Synchronizing the released workspace...")
    for module in RELEASE_MODULES:
        run_cmd(["moon", "-C", str(module.path), "update"], ROOT_DIR, fail_on_warning=True)
    for module_dir in EXAMPLE_MODULE_DIRS:
        run_cmd(["moon", "-C", str(module_dir), "update"], ROOT_DIR, fail_on_warning=True)
    print(f"Release publish pipeline completed for {version}")


def main():
    args = sys.argv[1:]
    if len(args) == 2 and CODEGEN_BETA_RE.fullmatch(args[0]) and args[1] == "--codegen-only":
        run_codegen_release(args[0])
        return
    if len(args) == 1 and STABLE_VERSION_RE.fullmatch(args[0]):
        run_release_pipeline(args[0])
        return

    print("Usage:")
    print("  python3 publish.py <x.y.z>")
    print("  python3 publish.py <x.y.z-betaN> --codegen-only")
    print("  python3 publish_pages.py [clean]")
    raise SystemExit(2)


if __name__ == "__main__":
    main()
