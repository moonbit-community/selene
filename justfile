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
  moon test --target native --release --deny-warn
  moon -C selene-webgpu test src --target js --deny-warn
