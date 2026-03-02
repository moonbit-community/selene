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
pub(all) enum UiSpace {
  Virtual
  Screen
}

///|
pub(all) struct Ui {
  space : UiSpace
}

///|
pub fn Ui::new(space? : UiSpace = Virtual) -> Ui {
  Ui::{ space, }
}

///|
pub let uis : Map[@entity.Entity, Ui] = Map::new()

///|
pub const UI_ZINDEX = 100
