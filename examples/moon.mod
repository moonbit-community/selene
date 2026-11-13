name = "Milky2018/selene-examples"

version = "0.21.2"

import {
  "Milky2018/selene@0.39.1",
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
  command: "moonx Milky2018/selene_codegen@0.40.0-beta3 \"$input\" \"$output\"",
)
