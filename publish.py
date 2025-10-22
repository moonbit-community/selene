#!/usr/bin/env python3
"""
Publish script for Selene Game Engine
Copies all necessary files to the page directory for deployment
"""

import sys
import json
import shutil
from pathlib import Path

# Project root directory
ROOT_DIR = Path(__file__).parent
PAGE_DIR = ROOT_DIR / "page"
EXAMPLES_DIR = ROOT_DIR / "examples"
TARGET_DIR = EXAMPLES_DIR / "target" / "js" / "release" / "build"

def get_game_folders() -> list[str]:
    """Automatically detect game folders in examples directory"""
    if not EXAMPLES_DIR.exists():
        return []

    games: list[str] = []
    for item in EXAMPLES_DIR.iterdir():
        if not item.is_dir():
            continue
        if item.name.startswith('.') or item.name in ['target', '.mooncakes']:
            continue
        if (item / "index.html").exists():
            games.append(item.name)

    return sorted(games)

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
    game_page_dir = PAGE_DIR / "examples" / game_name

    if not game_src_dir.exists():
        print(f"⚠ Warning: {game_src_dir} not found, skipping {game_name}")
        return

    game_page_dir.mkdir(parents=True, exist_ok=True)

    # Copy HTML file
    index_html = game_src_dir / "index.html"
    if index_html.exists():
        shutil.copy2(index_html, game_page_dir / "index.html")
        print(f"✓ Copied {game_name}/index.html")

    # Copy assets folder
    assets_src = game_src_dir / "assets"
    if assets_src.exists() and assets_src.is_dir():
        assets_dst = game_page_dir / "assets"
        if assets_dst.exists():
            shutil.rmtree(assets_dst)
        shutil.copytree(assets_src, assets_dst)
        asset_count = len(list(assets_dst.rglob("*")))
        print(f"✓ Copied {game_name}/assets/ ({asset_count} files)")

        # Generate asset manifest
        manifest_count = generate_asset_manifest(assets_dst)
        if manifest_count:
            print(f"✓ Generated assets-manifest.json ({manifest_count} assets)")

    # Copy screenshot.png
    screenshot = game_src_dir / "screenshot.png"
    if screenshot.exists():
        shutil.copy2(screenshot, game_page_dir / "screenshot.png")
        print(f"✓ Copied {game_name}/screenshot.png")

    # Copy compiled JavaScript from target directory
    js_src = TARGET_DIR / game_name / f"{game_name}.js"
    if js_src.exists():
        # Create target directory structure in page
        target_page_dir = PAGE_DIR / "examples" / "target" / "js" / "release" / "build" / game_name
        target_page_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(js_src, target_page_dir / f"{game_name}.js")
        print(f"✓ Copied {game_name}.js to target/js/release/build/{game_name}/")
    else:
        print(f"⚠ Warning: {js_src} not found. Did you run 'moon build'?")

def main():
    """Main publish function"""
    is_clean = len(sys.argv) > 1 and sys.argv[1] == "clean"
    
    if not is_clean:
        print("=" * 60)
        print("Publishing Selene Game Engine to page/")
        print("=" * 60)

    # Step 1: Clean page directory (but preserve HTML files)
    clean_page_dir()
    print()
    if is_clean:
        return
    
    # Step 2: Detect games
    games = get_game_folders()
    if not games:
        print("⚠ No games found in examples directory!")
        return

    print(f"Found {len(games)} game(s): {', '.join(games)}")
    print()

    # Step 3: Copy the preload-assets script
    print("Copying preload-assets script...")
    preload_assets_script = EXAMPLES_DIR / "preload-assets.js"
    if preload_assets_script.exists():
        shutil.copy2(preload_assets_script, PAGE_DIR / "examples" / "preload-assets.js")
        print(f"✓ Copied preload-assets script")

    # Step 4: Copy each game
    print("Copying game files...")
    for game in games:
        print(f"\nProcessing {game}...")
        copy_game_files(game)

    print()
    print("=" * 60)
    print("✓ Publishing complete!")
    print(f"Output directory: {PAGE_DIR.absolute()}")
    print("=" * 60)

if __name__ == "__main__":
    main()
