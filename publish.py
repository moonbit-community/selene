#!/usr/bin/env python3
"""
Publish script for Selene Game Engine
Copies all necessary files to the page directory for deployment
"""

import sys
import json
import re
import shutil
import subprocess
from pathlib import Path
from dataclasses import dataclass

# Project root directory
ROOT_DIR = Path(__file__).parent
PAGE_DIR = ROOT_DIR / "page"
EXAMPLES_DIR = ROOT_DIR / "examples"
WEB_EXAMPLES_DIR = EXAMPLES_DIR / "web"
BUILD_DIR = EXAMPLES_DIR / "_build" / "js" / "release" / "build"

SCRIPT_SRC_RE = re.compile(
    r'<script[^>]+src=["\']([^"\']+\.js)["\']',
    re.IGNORECASE,
)
VERSION_RE = re.compile(r"^\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$")

INTERNAL_MODULES = {
    "Milky2018/selene",
    "Milky2018/selene_webgpu",
    "Milky2018/selene_raylib",
    "Milky2018/selene-examples",
}


@dataclass(frozen=True)
class ModuleConfig:
    name: str
    path: Path


MODULES = [
    ModuleConfig("selene-core", ROOT_DIR / "selene-core"),
    ModuleConfig("selene-webgpu", ROOT_DIR / "selene-webgpu"),
    ModuleConfig("selene-raylib", ROOT_DIR / "selene-raylib"),
    ModuleConfig("examples", ROOT_DIR / "examples"),
]

PUBLISH_ORDER = ["selene-core", "selene-webgpu", "selene-raylib", "examples"]


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
    for module in MODULES:
        if module.name == name:
            return module
    raise ValueError(f"Unknown module: {name}")

def get_game_folders() -> list[str]:
    """Automatically detect game folders from examples/web."""
    if not WEB_EXAMPLES_DIR.exists():
        return []

    games: set[str] = set()
    for item in WEB_EXAMPLES_DIR.iterdir():
        if not item.is_dir():
            continue
        if item.name.startswith("."):
            continue
        games.add(item.name)

    return sorted(games)


def ensure_web_release_built(games: list[str]):
    """Ensure release JS artifacts exist before publishing pages."""
    missing: list[str] = []
    for game in games:
        js_path = BUILD_DIR / "web" / game / f"{game}.js"
        if not js_path.exists():
            missing.append(f"- {game}: {js_path.relative_to(ROOT_DIR)}")

    if not missing:
        return

    details = "\n".join(missing)
    raise RuntimeError(
        "Missing web release build artifacts:\n"
        f"{details}\n"
        "Run one of:\n"
        "  (cd examples && ./build_all.sh web)\n"
        "  (cd examples && moon build ./web/<game> --target js --release)"
    )


def copy_examples_index():
    """Copy examples/index.html to page/examples/index.html."""
    src = EXAMPLES_DIR / "index.html"
    dst = PAGE_DIR / "examples" / "index.html"
    if not src.exists():
        print("⚠ Warning: examples/index.html not found")
        return

    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    print("✓ Copied examples/index.html")


def clean_page_dir():
    """Clean the page directory but preserve HTML files"""
    PAGE_DIR.mkdir(parents=True, exist_ok=True)

    root_index = PAGE_DIR / "index.html"
    examples_index = PAGE_DIR / "examples" / "index.html"
    readme = PAGE_DIR / "README.md"

    saved_html: dict[str, str] = {}
    if root_index.exists():
        saved_html['root'] = root_index.read_text()
    if examples_index.exists():
        saved_html['examples'] = examples_index.read_text()
    if readme.exists():
        saved_html['readme'] = readme.read_text()

    if PAGE_DIR.exists():
        print(f"Cleaning {PAGE_DIR}...")
        for item in PAGE_DIR.iterdir():
            if item.is_dir():
                shutil.rmtree(item)
            else:
                item.unlink()

    PAGE_DIR.mkdir(parents=True, exist_ok=True)

    if 'root' in saved_html:
        root_index.write_text(saved_html['root'])
        print(f"✓ Preserved page/index.html")

    if 'examples' in saved_html:
        (PAGE_DIR / "examples").mkdir(parents=True, exist_ok=True)
        examples_index.write_text(saved_html['examples'])
        print(f"✓ Preserved page/examples/index.html")

    if 'readme' in saved_html:
        readme.write_text(saved_html['readme'])
        print(f"✓ Preserved page/README.md")

    print(f"Cleaned {PAGE_DIR} (preserved HTML files)")

def generate_asset_manifest(assets_dir: Path):
    """Generate assets-manifest.json for a game's assets folder"""
    if not assets_dir.exists() or not assets_dir.is_dir():
        return

    # Find all files in assets directory
    asset_files: list[str] = []
    for file in sorted(assets_dir.rglob("*")):
        if file.is_file():
            if file.name == "assets-manifest.json":
                continue
            # Get relative path from assets directory
            rel_path = file.relative_to(assets_dir)
            asset_files.append(str(rel_path))

    # Write manifest as JSON
    manifest_path = assets_dir / "assets-manifest.json"
    with open(manifest_path, 'w') as f:
        json.dump(asset_files, f, indent=2)

    return len(asset_files)

def copy_game_files(game_name: str):
    """Copy all files for a specific game"""
    game_src_dir = EXAMPLES_DIR / game_name
    game_web_dir = WEB_EXAMPLES_DIR / game_name
    game_page_dir = PAGE_DIR / "examples" / "web" / game_name

    if not game_web_dir.exists():
        print(f"⚠ Warning: {game_name} not found in examples/web, skipping")
        return

    game_page_dir.mkdir(parents=True, exist_ok=True)

    # Copy HTML file from examples/web/<game>/index.html
    index_html = game_web_dir / "index.html"
    if index_html.exists():
        shutil.copy2(index_html, game_page_dir / "index.html")
        print(f"✓ Copied {game_name}/index.html")
    else:
        print(f"⚠ Warning: index.html not found for {game_name}")

    # Copy assets folder from centralized examples/assets/<game>
    assets_src = EXAMPLES_DIR / "assets" / game_name
    if assets_src.exists() and assets_src.is_dir():
        assets_dst = PAGE_DIR / "assets" / game_name
        if assets_dst.exists():
            shutil.rmtree(assets_dst)
        shutil.copytree(assets_src, assets_dst)
        asset_count = len(list(assets_dst.rglob("*")))
        print(f"✓ Copied assets/{game_name}/ ({asset_count} files)")

        # Generate asset manifest
        manifest_count = generate_asset_manifest(assets_dst)
        if manifest_count:
            print(f"✓ Generated assets-manifest.json ({manifest_count} assets)")

    # Copy screenshot.png
    screenshot = game_src_dir / "screenshot.png"
    if screenshot.exists():
        shutil.copy2(screenshot, game_page_dir / "screenshot.png")
        print(f"✓ Copied {game_name}/screenshot.png")

    copy_compiled_javascript(game_name, index_html, game_page_dir)


def find_game_script_src(index_html: Path) -> str | None:
    if not index_html.exists():
        return None

    html = index_html.read_text(encoding="utf-8")
    script_srcs = SCRIPT_SRC_RE.findall(html)
    for script_src in script_srcs:
        if script_src.endswith("preload-assets.js"):
            continue
        return script_src
    return None


def copy_js_with_relative_path(
    game_name: str,
    source_dir: Path,
    game_page_dir: Path,
    script_src: str,
):
    js_src = resolve_script_src(source_dir, script_src)
    js_dst = (game_page_dir / script_src).resolve()
    if js_src is not None:
        js_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(js_src, js_dst)
        print(f"✓ Copied {game_name} JS: {script_src}")
        return True

    print(
        f"⚠ Warning: JavaScript not found for {game_name}: {js_src}. "
        "Did you run the build step?"
    )
    return False


def resolve_script_src(source_dir: Path, script_src: str) -> Path | None:
    normalized = script_src.replace("\\", "/")
    candidates: list[Path] = [(source_dir / script_src).resolve()]

    build_marker = "_build/"
    build_pos = normalized.find(build_marker)
    if build_pos != -1:
        build_suffix = normalized[build_pos + len(build_marker):]
        candidates.append((EXAMPLES_DIR / "_build" / build_suffix).resolve())

    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None


def copy_compiled_javascript(game_name: str, index_html: Path, game_page_dir: Path):
    script_src = find_game_script_src(index_html)
    if script_src:
        if copy_js_with_relative_path(game_name, index_html.parent, game_page_dir, script_src):
            return

    fallback_sources = [
        (
            BUILD_DIR / "web" / game_name / f"{game_name}.js",
            PAGE_DIR / "examples" / "_build" / "js" / "release" / "build" / "web" / game_name / f"{game_name}.js",
        ),
    ]

    for js_src, js_dst in fallback_sources:
        if not js_src.exists():
            continue
        js_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(js_src, js_dst)
        print(f"✓ Copied {game_name} JS from fallback: {js_src.relative_to(ROOT_DIR)}")
        return

    print(f"⚠ Warning: No compiled JavaScript found for {game_name}")

def publish_pages(argv: list[str]):
    """Publish pages for web deployment."""
    is_clean = len(argv) > 0 and argv[0] == "clean"

    if not is_clean:
        print("=" * 60)
        print("Publishing Selene Game Engine to page/")
        print("=" * 60)

    # Step 1: Detect games
    games = get_game_folders()
    if not games and not is_clean:
        print("⚠ No games found in examples directory!")
        return

    # Step 2: Ensure web release JS is built
    if not is_clean:
        ensure_web_release_built(games)

    # Step 3: Clean page directory (but preserve HTML files)
    clean_page_dir()
    print()
    if is_clean:
        return

    print(f"Found {len(games)} game(s): {', '.join(games)}")
    print()

    # Step 4: Copy examples landing page
    print("Copying examples landing page...")
    copy_examples_index()

    # Step 5: Copy the preload-assets script
    print("Copying preload-assets script...")
    preload_assets_script = EXAMPLES_DIR / "preload-assets.js"
    if preload_assets_script.exists():
        shutil.copy2(preload_assets_script, PAGE_DIR / "examples" / "preload-assets.js")
        print(f"✓ Copied preload-assets script")

    # Step 6: Copy each game
    print("Copying game files...")
    for game in games:
        print(f"\nProcessing {game}...")
        copy_game_files(game)

    print()
    print("=" * 60)
    print("✓ Publishing complete!")
    print(f"Output directory: {PAGE_DIR.absolute()}")
    print("=" * 60)


def run_module_quality_checks(module: ModuleConfig):
    """Run fmt/info/check and fail on any warning."""
    run_cmd(["moon", "fmt"], module.path, fail_on_warning=True)
    run_cmd(["moon", "info"], module.path, fail_on_warning=True)

    if module.name == "selene-core":
        run_cmd(["moon", "check", "--target", "all", "--deny-warn"], module.path, fail_on_warning=True)
        return

    if module.name == "selene-webgpu":
        run_cmd(["moon", "check", "--target", "js", "--deny-warn"], module.path, fail_on_warning=True)
        return

    if module.name == "selene-raylib":
        run_cmd(["moon", "check", "--target", "native", "--deny-warn"], module.path, fail_on_warning=True)
        return

    if module.name == "examples":
        web_root = module.path / "web"
        native_root = module.path / "native"
        web_packages = sorted(p for p in web_root.iterdir() if p.is_dir())
        native_packages = sorted(p for p in native_root.iterdir() if p.is_dir())
        if not web_packages or not native_packages:
            raise RuntimeError("examples/web/* or examples/native/* is empty")

        for pkg in web_packages:
            pkg_rel = f"./web/{pkg.name}"
            run_cmd(
                ["moon", "check", pkg_rel, "--target", "js", "--deny-warn"],
                module.path,
                fail_on_warning=True,
            )

        for pkg in native_packages:
            pkg_rel = f"./native/{pkg.name}"
            run_cmd(
                ["moon", "check", pkg_rel, "--target", "native", "--deny-warn"],
                module.path,
                fail_on_warning=True,
            )
        return

    raise RuntimeError(f"Unknown module for quality checks: {module.name}")


def rewrite_module_for_release(module: ModuleConfig, version: str):
    """Set module version and convert internal deps path refs to release versions."""
    manifest_path = module.path / "moon.mod.json"
    manifest = load_json(manifest_path)
    manifest["version"] = version
    deps = manifest.get("deps", {})

    for dep_name in INTERNAL_MODULES:
        if dep_name not in deps:
            continue
        dep_val = deps[dep_name]
        if isinstance(dep_val, dict):
            deps[dep_name] = version
        elif isinstance(dep_val, str):
            deps[dep_name] = version
        else:
            raise RuntimeError(f"Unsupported dep value for {dep_name} in {manifest_path}")

    manifest["deps"] = deps
    write_json(manifest_path, manifest)


def run_release_pipeline(version: str):
    print("=" * 60)
    print(f"Preparing publish pipeline for version {version}")
    print("=" * 60)
    print()

    print("[1/4] Running fmt/info/check on all modules...")
    for module in MODULES:
        print(f"\n==> Quality checks: {module.name}")
        run_module_quality_checks(module)

    print("\n[2/4] Rewriting module versions and internal deps...")
    for module in MODULES:
        rewrite_module_for_release(module, version)
        print(f"✓ Updated {module.name}/moon.mod.json")

    print("\n[3/4] Running moon update after manifest rewrites...")
    for module in MODULES:
        print(f"==> moon update: {module.name}")
        run_cmd(["moon", "update"], module.path, fail_on_warning=True)

    print("\n[4/4] Publishing modules in order...")
    for module_name in PUBLISH_ORDER:
        module = module_by_name(module_name)
        print(f"==> moon publish: {module.name}")
        run_cmd(["moon", "publish"], module.path, fail_on_warning=True)

    print("\n" + "=" * 60)
    print(f"✓ Release publish pipeline completed for {version}")
    print("=" * 60)


def main():
    args = sys.argv[1:]
    if len(args) == 1 and VERSION_RE.match(args[0]):
        run_release_pipeline(args[0])
        return

    publish_pages(args)


if __name__ == "__main__":
    main()
