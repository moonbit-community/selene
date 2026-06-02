name = "Milky2018/selene_webgpu"

version = "0.34.4"

import {
  "Milky2018/selene@0.34.4",
  "Milky2018/moon_cosmic@0.3.0",
  "moonbit-community/js-ffi@0.4.2",
  "moonbit-community/rabbita@0.11.8",
}

readme = "README.md"

repository = "https://github.com/moonbit-community/selene.git"

license = "Apache-2.0"

keywords = [ "Game Engine" ]

description = "Default backend for Selene game engine."

preferred_target = "js"

options(
  source: "src",
)
