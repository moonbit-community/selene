#!/usr/bin/env python3
"""
Page publish script for Selene examples.
"""

import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).parent
PAGE_DIR = ROOT_DIR / "page"
EXAMPLES_DIR = ROOT_DIR / "examples"
BUILD_DIR = ROOT_DIR / "_build" / "js" / "release" / "build"

SCRIPT_SRC_RE = re.compile(
    r'<script[^>]+src=["\']([^"\']+\.js)["\']',
    re.IGNORECASE,
)

LEGACY_UI_CHECK_REL_PATH = Path("scripts/check_no_legacy_ui.sh")
LEGACY_UI_CHECK_PATH = ROOT_DIR / LEGACY_UI_CHECK_REL_PATH


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


def ensure_no_legacy_ui_references():
    if not LEGACY_UI_CHECK_PATH.exists():
        raise RuntimeError(f"Missing legacy UI check script: {LEGACY_UI_CHECK_REL_PATH}")
    run_cmd(["bash", str(LEGACY_UI_CHECK_PATH)], ROOT_DIR, fail_on_warning=True)


def get_game_folders() -> list[str]:
    """Automatically detect game folders from examples/<game>/web."""
    if not EXAMPLES_DIR.exists():
        return []

    games: set[str] = set()
    for item in EXAMPLES_DIR.iterdir():
        if not item.is_dir():
            continue
        if item.name.startswith(".") or item.name in {"_build", "target"}:
            continue
        if not (item / "web" / "moon.pkg").exists():
            continue
        if not (item / "index.html").exists():
            continue
        games.add(item.name)

    return sorted(games)


def ensure_web_release_built(games: list[str]):
    """Ensure release JS artifacts exist before publishing pages."""
    missing: list[str] = []
    for game in games:
        js_path = BUILD_DIR / "Milky2018" / "selene-examples" / game / "web" / "web.js"
        if not js_path.exists():
            missing.append(f"- {game}: {js_path.relative_to(ROOT_DIR)}")

    if not missing:
        return

    details = "\n".join(missing)
    raise RuntimeError(
        "Missing web release build artifacts:\n"
        f"{details}\n"
        "Run one of:\n"
        "  (cd examples && moon build --release)\n"
        "  (cd examples && moon build ./<game>/web --target js --release)"
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
    """Clean the page directory but preserve HTML files."""
    PAGE_DIR.mkdir(parents=True, exist_ok=True)

    root_index = PAGE_DIR / "index.html"
    examples_index = PAGE_DIR / "examples" / "index.html"
    readme = PAGE_DIR / "README.md"

    saved_html: dict[str, str] = {}
    if root_index.exists():
        saved_html["root"] = root_index.read_text()
    if examples_index.exists():
        saved_html["examples"] = examples_index.read_text()
    if readme.exists():
        saved_html["readme"] = readme.read_text()

    if PAGE_DIR.exists():
        print(f"Cleaning {PAGE_DIR}...")
        for item in PAGE_DIR.iterdir():
            if item.is_dir():
                shutil.rmtree(item)
            else:
                item.unlink()

    PAGE_DIR.mkdir(parents=True, exist_ok=True)

    if "root" in saved_html:
        root_index.write_text(saved_html["root"])
        print("✓ Preserved page/index.html")

    if "examples" in saved_html:
        (PAGE_DIR / "examples").mkdir(parents=True, exist_ok=True)
        examples_index.write_text(saved_html["examples"])
        print("✓ Preserved page/examples/index.html")

    if "readme" in saved_html:
        readme.write_text(saved_html["readme"])
        print("✓ Preserved page/README.md")

    print(f"Cleaned {PAGE_DIR} (preserved HTML files)")


def generate_asset_manifest(assets_dir: Path):
    """Generate assets-manifest.json for a game's assets folder."""
    if not assets_dir.exists() or not assets_dir.is_dir():
        return

    asset_files: list[str] = []
    for file in sorted(assets_dir.rglob("*")):
        if file.is_file():
            if file.name == "assets-manifest.json":
                continue
            rel_path = file.relative_to(assets_dir)
            asset_files.append(str(rel_path))

    manifest_path = assets_dir / "assets-manifest.json"
    with open(manifest_path, "w") as f:
        json.dump(asset_files, f, indent=2)

    return len(asset_files)


def copy_game_files(game_name: str):
    """Copy all files for a specific game."""
    game_src_dir = EXAMPLES_DIR / game_name
    game_web_dir = game_src_dir / "web"
    game_page_dir = PAGE_DIR / "examples" / game_name

    if not game_web_dir.exists():
        print(f"⚠ Warning: {game_name} missing examples/{game_name}/web, skipping")
        return

    game_page_dir.mkdir(parents=True, exist_ok=True)

    index_html = game_src_dir / "index.html"
    if index_html.exists():
        shutil.copy2(index_html, game_page_dir / "index.html")
        print(f"✓ Copied {game_name}/index.html")
    else:
        print(f"⚠ Warning: index.html not found for {game_name}")

    project_manifest = game_src_dir / "selene.project.json"
    if project_manifest.exists():
        shutil.copy2(project_manifest, game_page_dir / "selene.project.json")
        print(f"✓ Copied {game_name}/selene.project.json")

    scenes_src = game_src_dir / "scenes"
    if scenes_src.exists() and scenes_src.is_dir():
        scenes_dst = game_page_dir / "scenes"
        if scenes_dst.exists():
            shutil.rmtree(scenes_dst)
        shutil.copytree(scenes_src, scenes_dst)
        scene_count = len(list(scenes_dst.rglob("*.scene.json")))
        print(f"✓ Copied {game_name}/scenes/ ({scene_count} scene files)")

    assets_src = game_src_dir / "assets"
    if assets_src.exists() and assets_src.is_dir():
        assets_dst = game_page_dir / "assets"
        if assets_dst.exists():
            shutil.rmtree(assets_dst)
        shutil.copytree(assets_src, assets_dst)
        asset_count = len(list(assets_dst.rglob("*")))
        print(f"✓ Copied {game_name}/assets/ ({asset_count} files)")

        scoped_assets_dir = assets_dst / game_name
        if scoped_assets_dir.exists() and scoped_assets_dir.is_dir():
            manifest_count = generate_asset_manifest(scoped_assets_dir)
            if manifest_count:
                print(
                    f"✓ Generated assets-manifest.json for {game_name} ({manifest_count} assets)"
                )

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
            BUILD_DIR / "Milky2018" / "selene-examples" / game_name / "web" / "web.js",
            PAGE_DIR / "_build" / "js" / "release" / "build" / "Milky2018" / "selene-examples" / game_name / "web" / "web.js",
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
        ensure_no_legacy_ui_references()

    games = get_game_folders()
    if not games and not is_clean:
        print("⚠ No games found in examples directory!")
        return

    if not is_clean:
        ensure_web_release_built(games)

    clean_page_dir()
    print()
    if is_clean:
        return

    print(f"Found {len(games)} game(s): {', '.join(games)}")
    print()

    print("Copying examples landing page...")
    copy_examples_index()

    print("Copying preload-assets script...")
    preload_assets_script = EXAMPLES_DIR / "preload-assets.js"
    if preload_assets_script.exists():
        shutil.copy2(preload_assets_script, PAGE_DIR / "examples" / "preload-assets.js")
        print("✓ Copied preload-assets script")

    print("Copying game files...")
    for game in games:
        print(f"\nProcessing {game}...")
        copy_game_files(game)

    print()
    print("=" * 60)
    print("✓ Publishing complete!")
    print(f"Output directory: {PAGE_DIR.absolute()}")
    print("=" * 60)


def main():
    publish_pages(sys.argv[1:])


if __name__ == "__main__":
    main()
