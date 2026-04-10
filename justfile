set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

update:
  moon -C selene-core update
  moon -C selene-webgpu update
  moon -C selene-raylib update
  moon -C selene-tools update
  moon -C selene-editor-shared update
  moon -C selene-editor-frontend update
  moon -C selene-editor-service update
  moon -C selene-editor-specs update
  moon -C examples update

check:
  moon -C selene-core check --deny-warn
  moon -C selene-webgpu check --deny-warn
  moon -C selene-raylib check --deny-warn
  moon -C selene-tools check --deny-warn
  moon -C selene-editor-shared check --deny-warn
  moon -C selene-editor-frontend check --deny-warn
  moon -C selene-editor-service check --deny-warn
  moon -C selene-editor-specs check --deny-warn
  moon -C examples check --deny-warn

build:
  moon -C selene-core build
  moon -C selene-webgpu build
  moon -C selene-raylib build
  moon -C selene-tools build
  moon -C selene-editor-shared build
  moon -C selene-editor-frontend build
  moon -C selene-editor-service build
  moon -C selene-editor-specs build
  moon -C examples build

test:
  moon -C selene-core test src/math src/animation src/collision src/event src/transform src/render3d src/asset src/scene3d src/app src/editor_bridge src/physics3d src/ldtk src/tiled src/ui --manifest-path moon.mod.json
