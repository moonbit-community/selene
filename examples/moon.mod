name = "Milky2018/selene-examples"

version = "0.21.2"

import {
  "Milky2018/selene@0.39.1",
  "Milky2018/moon_rapier@0.5.2",
  "moonbitlang/x@0.5.7",
}

readme = "README.md"

repository = "https://github.com/moonbit-community/selene.git"

license = "Apache-2.0"

keywords = [ ]

description = ""

preferred_target = "js"

supported_targets = "all"

rule(
  name: "selene_codegen",
  command: "moon run ../selene-codegen --target wasm --target-dir _build/selene-codegen -- \"$input\" \"$output\"",
)
