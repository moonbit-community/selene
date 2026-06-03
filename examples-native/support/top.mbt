// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
fn read_file_bytes_if_exists(path : String) -> Bytes? {
  if !@fs.path_exists(path) {
    return None
  }
  let result : Result[Bytes, Error] = try? @fs.read_file_to_bytes(path)
  match result {
    Ok(bytes) => Some(bytes)
    Err(_) => None
  }
}

///|
fn example_asset_candidates(game : String, path : String) -> Array[String] {
  let normalized = path.replace(old="\\", new="/")
  [
    normalized,
    game + "/" + normalized,
    "../examples/" + game + "/" + normalized,
    "../examples/" + normalized,
    "examples/" + game + "/" + normalized,
    "examples/" + normalized,
  ]
}

///|
pub fn read_example_asset(game : String, path : String) -> Bytes? {
  for candidate in example_asset_candidates(game, path) {
    if read_file_bytes_if_exists(candidate) is Some(bytes) {
      return Some(bytes)
    }
  }
  None
}
