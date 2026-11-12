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
pub(all) enum A11yRole {
  Container
  Label
  Button
  CheckBox
  Slider
  TextInput
  Image
}

///|
#selene.component
pub(all) struct A11y {
  role : A11yRole
  mut label : String?
  mut value : String?
  mut focusable : Bool
  mut disabled : Bool
  mut selected : Bool?
  mut hidden : Bool
  action_callbacks : Array[
    (@moon_accesskit.Action, @moon_accesskit.ActionData?) -> Unit,
  ]
}

///|
pub fn A11y::A11y(
  role~ : A11yRole = Container,
  label~ : String? = None,
  value~ : String? = None,
  focusable~ : Bool = false,
  disabled~ : Bool = false,
  selected~ : Bool? = None,
  hidden~ : Bool = false,
) -> A11y {
  {
    role,
    label,
    value,
    focusable,
    disabled,
    selected,
    hidden,
    action_callbacks: [],
  }
}

///|
pub fn A11y::on_action(
  self : A11y,
  callback : (@moon_accesskit.Action, @moon_accesskit.ActionData?) -> Unit,
) -> Unit {
  self.action_callbacks.push(callback)
}

///|
pub fn A11y::on_click(self : A11y, callback : () -> Unit) -> Unit {
  self.on_action(fn(action, _data) { if action is Click { callback() } })
}
