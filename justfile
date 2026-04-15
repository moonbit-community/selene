set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

update:
  moon update

check:
  moon check --target all --deny-warn

build:
  moon build --target all

test:
  moon -C selene-core test src/math src/animation src/collision src/event src/transform src/render3d src/asset src/scene3d src/app src/editor_bridge src/physics3d src/ldtk src/tiled src/ui --manifest-path moon.mod.json

editor-build:
  moon -C selene-editor-frontend build frontend/web --target js --release --manifest-path moon.mod.json
  cp _build/js/release/build/Milky2018/selene_editor_frontend/frontend/web/web.js selene-editor-service/public/editor.js

editor-run port="47142":
  moon -C selene-editor-service run service --target native --manifest-path moon.mod.json -- --port {{port}}

editor port="47142": editor-build
  just editor-run {{port}}
