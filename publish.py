#!/usr/bin/env python3
"""
Release publish script for Selene modules.
"""

import json
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT_DIR = Path(__file__).parent
EXAMPLES_DIR = ROOT_DIR / "examples"
EXAMPLES_MANIFEST_PATH = EXAMPLES_DIR / "moon.mod.json"
CHANGELOG_REL_PATH = Path("docs/CHANGELOG.md")
CHANGELOG_PATH = ROOT_DIR / CHANGELOG_REL_PATH

VERSION_RE = re.compile(r"^\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$")

INTERNAL_MODULES = {
    "Milky2018/selene",
    "Milky2018/selene_webgpu",
    "Milky2018/selene_raylib",
    "Milky2018/selene_tools",
    "Milky2018/selene_editor_shared",
    "Milky2018/selene_editor_frontend",
    "Milky2018/selene_editor_service",
}


@dataclass(frozen=True)
class ModuleConfig:
    name: str
    path: Path


RELEASE_MODULES = [
    ModuleConfig("selene-core", ROOT_DIR / "selene-core"),
    ModuleConfig("selene-webgpu", ROOT_DIR / "selene-webgpu"),
    ModuleConfig("selene-raylib", ROOT_DIR / "selene-raylib"),
    ModuleConfig("selene-tools", ROOT_DIR / "selene-tools"),
    ModuleConfig("selene-editor-shared", ROOT_DIR / "selene-editor-shared"),
    ModuleConfig("selene-editor-frontend", ROOT_DIR / "selene-editor-frontend"),
    ModuleConfig("selene-editor-service", ROOT_DIR / "selene-editor-service"),
]

PUBLISH_ORDER = [
    "selene-core",
    "selene-webgpu",
    "selene-raylib",
    "selene-tools",
    "selene-editor-shared",
    "selene-editor-frontend",
    "selene-editor-service",
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


def run_cmd(cmd: list[str], cwd: Path, *, fail_on_warning: bool = False):
    print(f"$ (cd {cwd} && {' '.join(cmd)})")
    proc = subprocess.run(
        cmd,
        cwd=cwd,
        text=True,
        capture_output=True,
        check=False,
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


def has_warning(output: str) -> bool:
    patterns = [
        r"(^|\s)WARN(\s|:)",
        r"^Warning:",
        r"warnings?,",
        r"warnings?\.",
        r"warnings?\)",
    ]
    return any(re.search(pat, output, flags=re.MULTILINE) for pat in patterns)


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, data: dict):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def module_by_name(name: str) -> ModuleConfig:
    for module in RELEASE_MODULES:
        if module.name == name:
            return module
    raise ValueError(f"Unknown module: {name}")


def module_manifest_path(module: ModuleConfig) -> Path:
    return module.path / "moon.mod.json"


def module_info_entries(module: ModuleConfig) -> list[tuple[str, str]]:
    if module.name == "selene-core":
        return [
            (str(module.path / "src"), "js"),
            (str(module.path / "src"), "native"),
        ]
    if module.name == "selene-webgpu":
        return [(str(module.path / "src"), "js")]
    if module.name == "selene-raylib":
        return [(str(module.path / "src"), "native")]
    if module.name == "selene-tools":
        return [(str(module.path), "native")]
    if module.name == "selene-editor-shared":
        return [
            (str(module.path / "shared"), "js"),
            (str(module.path / "shared"), "native"),
            (str(module.path / "preview_bridge"), "js"),
            (str(module.path / "preview_bridge"), "native"),
        ]
    if module.name == "selene-editor-frontend":
        return [
            (str(module.path / "frontend"), "js"),
            (str(module.path / "preview"), "js"),
        ]
    if module.name == "selene-editor-service":
        return [
            (str(module.path / "service"), "native"),
        ]
    raise RuntimeError(f"Unknown module for info generation: {module.name}")


def ensure_no_legacy_ui_references():
    if not LEGACY_UI_CHECK_PATH.exists():
        raise RuntimeError(f"Missing legacy UI check script: {LEGACY_UI_CHECK_REL_PATH}")
    run_cmd(["bash", str(LEGACY_UI_CHECK_PATH)], ROOT_DIR, fail_on_warning=True)


def run_module_quality_checks(module: ModuleConfig):
    """Run fmt/info/check and fail on any warning."""
    manifest_path = module_manifest_path(module)
    info_entries = module_info_entries(module)

    run_cmd(
        ["moon", "fmt", str(module.path), "--manifest-path", str(manifest_path)],
        ROOT_DIR,
        fail_on_warning=True,
    )
    for info_entry_path, info_target in info_entries:
        run_cmd(
            [
                "moon",
                "info",
                info_entry_path,
                "--target",
                info_target,
                "--manifest-path",
                str(manifest_path),
            ],
            ROOT_DIR,
            fail_on_warning=True,
        )

    if module.name == "selene-core":
        check_targets = ["js", "native"]
    elif module.name == "selene-webgpu":
        check_targets = ["js"]
    elif module.name == "selene-raylib":
        check_targets = ["native"]
    elif module.name == "selene-tools":
        check_targets = ["native"]
    elif module.name == "selene-editor-shared":
        check_targets = ["js", "native"]
    elif module.name == "selene-editor-frontend":
        check_targets = ["js"]
    elif module.name == "selene-editor-service":
        check_targets = ["native"]
    else:
        raise RuntimeError(f"Unknown module for quality checks: {module.name}")

    for target in check_targets:
        run_cmd(
            [
                "moon",
                "check",
                str(module.path),
                "--target",
                target,
                "--deny-warn",
                "--manifest-path",
                str(manifest_path),
            ],
            ROOT_DIR,
            fail_on_warning=True,
        )


def rewrite_module_for_release(module: ModuleConfig, version: str):
    """Set module version and update internal deps to path+version form."""
    manifest_path = module_manifest_path(module)
    manifest = load_json(manifest_path)
    manifest["version"] = version
    deps = manifest.get("deps", {})

    for dep_name in INTERNAL_MODULES:
        if dep_name not in deps:
            continue
        dep_val = deps[dep_name]
        if isinstance(dep_val, dict):
            rewritten = dict(dep_val)
            rewritten["version"] = version
            deps[dep_name] = rewritten
        elif isinstance(dep_val, str):
            deps[dep_name] = version
        else:
            raise RuntimeError(f"Unsupported dep value for {dep_name} in {manifest_path}")

    manifest["deps"] = deps
    write_json(manifest_path, manifest)


def sync_examples_internal_deps(version: str):
    """Keep examples local deps in path+version form for the current Selene version."""
    manifest = load_json(EXAMPLES_MANIFEST_PATH)
    deps = manifest.get("deps", {})

    for dep_name in INTERNAL_MODULES:
        if dep_name not in deps:
            continue
        dep_val = deps[dep_name]
        if isinstance(dep_val, dict):
            rewritten = dict(dep_val)
            rewritten["version"] = version
            deps[dep_name] = rewritten
        elif isinstance(dep_val, str):
            deps[dep_name] = version
        else:
            raise RuntimeError(f"Unsupported dep value for {dep_name} in {EXAMPLES_MANIFEST_PATH}")

    manifest["deps"] = deps
    write_json(EXAMPLES_MANIFEST_PATH, manifest)


def run_release_pipeline(version: str):
    ensure_changelog_entry_exists(version)

    print("=" * 60)
    print(f"Preparing publish pipeline for version {version}")
    print("=" * 60)
    print()

    print("[0/5] Checking for legacy UI references...")
    ensure_no_legacy_ui_references()

    print("\n[1/5] Running fmt/info/check on all modules...")
    for module in RELEASE_MODULES:
        print(f"\n==> Quality checks: {module.name}")
        run_module_quality_checks(module)

    print("\n[2/5] Rewriting module versions and internal deps...")
    for module in RELEASE_MODULES:
        rewrite_module_for_release(module, version)
        print(f"✓ Updated {module.name}/moon.mod.json")
    sync_examples_internal_deps(version)
    print("✓ Updated examples/moon.mod.json internal deps")

    print("\n[3/5] Running moon update after manifest rewrites...")
    for module in RELEASE_MODULES:
        print(f"==> moon update: {module.name}")
        run_cmd(
            ["moon", "update", "--manifest-path", str(module_manifest_path(module))],
            ROOT_DIR,
            fail_on_warning=True,
        )
    print("==> moon update: examples")
    run_cmd(
        ["moon", "update", "--manifest-path", str(EXAMPLES_MANIFEST_PATH)],
        ROOT_DIR,
        fail_on_warning=True,
    )

    print("\n[4/5] Publishing modules in order...")
    for idx, module_name in enumerate(PUBLISH_ORDER):
        module = module_by_name(module_name)
        print(f"==> moon publish: {module.name}")
        run_cmd(
            ["moon", "publish", "--manifest-path", str(module_manifest_path(module))],
            ROOT_DIR,
            fail_on_warning=True,
        )
        if idx < len(PUBLISH_ORDER) - 1:
            print("==> moon update for remaining modules...")
            for next_module_name in PUBLISH_ORDER[idx + 1:]:
                next_module = module_by_name(next_module_name)
                run_cmd(
                    ["moon", "update", "--manifest-path", str(module_manifest_path(next_module))],
                    ROOT_DIR,
                    fail_on_warning=True,
                )

    print("\n[5/5] Running final moon update to sync local workspace...")
    for module in RELEASE_MODULES:
        print(f"==> moon update: {module.name}")
        run_cmd(
            ["moon", "update", "--manifest-path", str(module_manifest_path(module))],
            ROOT_DIR,
            fail_on_warning=True,
        )
    print("==> moon update: examples")
    run_cmd(
        ["moon", "update", "--manifest-path", str(EXAMPLES_MANIFEST_PATH)],
        ROOT_DIR,
        fail_on_warning=True,
    )

    print("\n" + "=" * 60)
    print(f"✓ Release publish pipeline completed for {version}")
    print("=" * 60)


def main():
    args = sys.argv[1:]
    if len(args) == 1 and VERSION_RE.match(args[0]):
        run_release_pipeline(args[0])
        return

    print("Usage:")
    print("  python3 publish.py <x.y.z>")
    print("  python3 publish_pages.py [clean]")
    raise SystemExit(2)


if __name__ == "__main__":
    main()
