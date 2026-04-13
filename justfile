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
