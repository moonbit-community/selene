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
let pending_action_requests : Array[@moon_accesskit.ActionRequest] = []

///|
pub fn submit_action_request(request : @moon_accesskit.ActionRequest) -> Unit {
  pending_action_requests.push(request)
}

///|
fn invoke_action_callbacks(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  action : @moon_accesskit.Action,
  data : @moon_accesskit.ActionData?,
) -> Unit {
  let query_a11y : @ecs.Query[A11y] = world.query()
  guard query_a11y.get(entity) is Some(a11y) else { return }
  for callback in a11y.action_callbacks {
    callback(action, data)
  }
}

///|
fn dispatch_action(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  action : @moon_accesskit.Action,
  data : @moon_accesskit.ActionData?,
) -> Unit {
  guard get_a11y(world~, entity) is Some(a11y) else { return }
  if a11y.disabled {
    return
  }
  match action {
    Focus => @ui.focus(entity)
    Blur => @ui.blur()
    Click => {
      @ui.click_event_bus.send({ entity, button: Left, })
      invoke_action_callbacks(world~, entity, action, data)
    }
    _ => invoke_action_callbacks(world~, entity, action, data)
  }
}

///|
fn process_action_requests(world~ : @ecs.World) -> Unit {
  for request in pending_action_requests {
    guard request.target_tree() == a11y_tree_id else { continue }
    guard a11y_runtime().current_node_entities.get(request.target_node())
      is Some(entity) else {
      continue
    }
    dispatch_action(world~, entity, request.action(), request.data())
  }
  pending_action_requests.clear()
}
