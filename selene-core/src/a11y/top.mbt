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
pub fn A11y::new(
  role? : A11yRole = Container,
  label? : String? = None,
  value? : String? = None,
  focusable? : Bool = false,
  disabled? : Bool = false,
  selected? : Bool? = None,
  hidden? : Bool = false,
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

///|
priv struct A11yWorldStore {
  a11ys : Map[@entity.Entity, A11y]
}

///|
let a11y_world_stores : Map[UInt, A11yWorldStore] = Map::new()

///|
fn a11y_world_store() -> A11yWorldStore {
  let world_id = @ecs.require_current_world().id()
  a11y_world_stores.get_or_init(world_id, () => { a11ys: Map::new() })
}

///|
pub fn a11ys() -> Map[@entity.Entity, A11y] {
  a11y_world_store().a11ys
}

///|
let a11y_tree_id : @moon_accesskit.TreeId = @moon_accesskit.TreeId::root()

///|
let latest_tree_update_ref : Ref[@moon_accesskit.TreeUpdate?] = { val: None }

///|
let pending_action_requests : Array[@moon_accesskit.ActionRequest] = []

///|
let entity_node_ids : Map[@entity.Entity, UInt64] = Map::new()

///|
let current_node_entities : Map[@moon_accesskit.NodeId, @entity.Entity] = Map::new()

///|
let next_node_id : Ref[UInt64] = { val: 1UL }

///|
pub fn tree_id() -> @moon_accesskit.TreeId {
  a11y_tree_id
}

///|
pub fn attach(entity : @entity.Entity, a11y : A11y) -> Unit {
  a11ys().set(entity, a11y)
}

///|
pub fn get_focused_entity() -> @entity.Entity? {
  @ui.focused_entity()
}

///|
pub fn focus(entity : @entity.Entity) -> Unit {
  @ui.focus(entity)
}

///|
pub fn blur() -> Unit {
  @ui.blur()
}

///|
pub fn submit_action_request(request : @moon_accesskit.ActionRequest) -> Unit {
  pending_action_requests.push(request)
}

///|
pub fn latest_tree_update() -> @moon_accesskit.TreeUpdate? {
  latest_tree_update_ref.val
}

///|
pub fn latest_tree_update_json() -> Json? {
  if latest_tree_update_ref.val is Some(update) {
    Some(update.to_json())
  } else {
    None
  }
}

///|
pub fn a11y_sync_system(_delta : Double) -> Unit {
  let ordered = collect_ordered_semantic_entities()
  let (roots, child_map) = build_hierarchy(ordered)
  let update = build_tree_update(ordered, roots, child_map)
  latest_tree_update_ref.val = Some(update)
  process_action_requests()
}

///|
fn to_accesskit_role(role : A11yRole) -> @moon_accesskit.Role {
  match role {
    Container => @moon_accesskit.Role::GenericContainer
    Label => @moon_accesskit.Role::Label
    Button => @moon_accesskit.Role::Button
    CheckBox => @moon_accesskit.Role::CheckBox
    Slider => @moon_accesskit.Role::Slider
    TextInput => @moon_accesskit.Role::TextInput
    Image => @moon_accesskit.Role::Image
  }
}

///|
fn auto_a11y(entity : @entity.Entity) -> A11y? {
  if @ui.buttons().get(entity) is Some(button) {
    Some(A11y::new(role=Button, focusable=true, disabled=!button.enabled))
  } else if @ui.texts().get(entity) is Some(_) {
    Some(A11y::new(role=Label))
  } else if @ui.ui_images().get(entity) is Some(_) {
    Some(A11y::new(role=Image))
  } else {
    None
  }
}

///|
fn get_a11y(entity : @entity.Entity) -> A11y? {
  if a11ys().get(entity) is Some(a11y) {
    if a11y.hidden {
      None
    } else {
      Some(a11y)
    }
  } else {
    auto_a11y(entity)
  }
}

///|
fn ui_children(entity : @entity.Entity) -> Array[@entity.Entity] {
  let children : Array[@entity.Entity] = []
  for child in entity.get_children() {
    if child.is_alive() && @ui.nodes().contains(child) {
      children.push(child)
    }
  }
  children.sort_by(fn(lhs, rhs) {
    let lg = @ui.global_zindexes()
      .get(lhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    let rg = @ui.global_zindexes()
      .get(rhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    if lg != rg {
      lg - rg
    } else {
      let lz = @ui.z_indexes()
        .get(lhs)
        .map(fn(value) { value.value })
        .unwrap_or(0)
      let rz = @ui.z_indexes()
        .get(rhs)
        .map(fn(value) { value.value })
        .unwrap_or(0)
      if lz != rz {
        lz - rz
      } else {
        lhs.to_string().compare(rhs.to_string())
      }
    }
  })
  children
}

///|
fn collect_semantic_descendants(
  root : @entity.Entity,
  ordered : Array[@entity.Entity],
  seen : Map[@entity.Entity, Bool],
) -> Unit {
  if get_a11y(root) is Some(_) && !seen.contains(root) {
    seen.set(root, true)
    ordered.push(root)
  }
  for child in ui_children(root) {
    collect_semantic_descendants(child, ordered, seen)
  }
}

///|
fn collect_ordered_semantic_entities() -> Array[@entity.Entity] {
  let ordered : Array[@entity.Entity] = []
  let seen : Map[@entity.Entity, Bool] = Map::new()
  for entity, _node in @ui.nodes() {
    guard entity.is_alive() else { continue }
    match entity.get_parent() {
      Some(parent) => if @ui.nodes().contains(parent) { continue }
      None => ()
    }
    collect_semantic_descendants(entity, ordered, seen)
  }
  for entity, _ in a11ys() {
    guard entity.is_alive() else { continue }
    guard get_a11y(entity) is Some(_) else { continue }
    if !seen.contains(entity) {
      seen.set(entity, true)
      ordered.push(entity)
    }
  }
  ordered
}

///|
fn find_semantic_parent(entity : @entity.Entity) -> @entity.Entity? {
  let mut parent = entity.get_parent()
  while parent is Some(p) {
    if get_a11y(p) is Some(_) {
      return Some(p)
    }
    parent = p.get_parent()
  }
  None
}

///|
fn build_hierarchy(
  ordered : Array[@entity.Entity],
) -> (Array[@entity.Entity], Map[@entity.Entity, Array[@entity.Entity]]) {
  let roots : Array[@entity.Entity] = []
  let children : Map[@entity.Entity, Array[@entity.Entity]] = Map::new()
  for entity in ordered {
    if find_semantic_parent(entity) is Some(parent) {
      children.get_or_init(parent, () => []).push(entity)
    } else {
      roots.push(entity)
    }
  }
  (roots, children)
}

///|
fn resolve_bounds(entity : @entity.Entity) -> @moon_accesskit.Rect? {
  guard @ui.global_ui_nodes().get(entity) is Some(node) else { return None }
  Some(
    @moon_accesskit.Rect::new(
      node.screen_rect.position[X],
      node.screen_rect.position[Y],
      node.screen_rect.position[X] + node.screen_rect.size[X],
      node.screen_rect.position[Y] + node.screen_rect.size[Y],
    ),
  )
}

///|
fn effective_label(entity : @entity.Entity, a11y : A11y) -> String? {
  if a11y.label is Some(label) {
    return Some(label)
  }
  if @ui.texts().get(entity) is Some(text) && text.content != "" {
    Some(text.content)
  } else {
    None
  }
}

///|
fn is_clickable(entity : @entity.Entity, a11y : A11y) -> Bool {
  @ui.buttons().contains(entity) || a11y.action_callbacks.length() > 0
}

///|
fn get_or_create_node_id(entity : @entity.Entity) -> @moon_accesskit.NodeId {
  if entity_node_ids.get(entity) is Some(raw) {
    @moon_accesskit.NodeId::new(raw)
  } else {
    let raw = next_node_id.val
    next_node_id.val = next_node_id.val + 1UL
    entity_node_ids.set(entity, raw)
    @moon_accesskit.NodeId::new(raw)
  }
}

///|
fn focused_node_id() -> @moon_accesskit.NodeId {
  if get_focused_entity() is Some(entity) && get_a11y(entity) is Some(_) {
    get_or_create_node_id(entity)
  } else {
    @moon_accesskit.NodeId::root()
  }
}

///|
fn build_tree_update(
  ordered : Array[@entity.Entity],
  roots : Array[@entity.Entity],
  child_map : Map[@entity.Entity, Array[@entity.Entity]],
) -> @moon_accesskit.TreeUpdate {
  current_node_entities.clear()
  let update = @moon_accesskit.TreeUpdate::new(a11y_tree_id, focused_node_id())
  let root = @moon_accesskit.Node::new(@moon_accesskit.Role::Window)
  root.set_label("Selene")
  let root_children : Array[@moon_accesskit.NodeId] = []
  for entity in roots {
    let id = get_or_create_node_id(entity)
    root_children.push(id)
    current_node_entities.set(id, entity)
  }
  root.set_children(root_children)
  update.push_node(@moon_accesskit.NodeId::root(), root)

  for entity in ordered {
    guard get_a11y(entity) is Some(a11y) else { continue }
    let id = get_or_create_node_id(entity)
    current_node_entities.set(id, entity)
    let node = @moon_accesskit.Node::new(to_accesskit_role(a11y.role))
    if effective_label(entity, a11y) is Some(label) {
      node.set_label(label)
    }
    if a11y.value is Some(value) {
      node.set_value(value)
    }
    if a11y.disabled {
      node.set_disabled()
    }
    if a11y.selected is Some(selected) {
      node.set_selected(selected)
    }
    if resolve_bounds(entity) is Some(bounds) {
      node.set_bounds(bounds)
    }
    if a11y.focusable && !a11y.disabled {
      node.add_action(@moon_accesskit.Action::Focus)
    }
    if is_clickable(entity, a11y) && !a11y.disabled {
      node.add_action(@moon_accesskit.Action::Click)
    }
    let child_ids : Array[@moon_accesskit.NodeId] = []
    for child in child_map.get(entity).unwrap_or_default() {
      child_ids.push(get_or_create_node_id(child))
    }
    node.set_children(child_ids)
    update.push_node(id, node)
  }
  update.set_tree(@moon_accesskit.Tree::new(@moon_accesskit.NodeId::root()))
  update
}

///|
fn invoke_action_callbacks(
  entity : @entity.Entity,
  action : @moon_accesskit.Action,
  data : @moon_accesskit.ActionData?,
) -> Unit {
  guard a11ys().get(entity) is Some(a11y) else { return }
  for callback in a11y.action_callbacks {
    callback(action, data)
  }
}

///|
fn dispatch_action(
  entity : @entity.Entity,
  action : @moon_accesskit.Action,
  data : @moon_accesskit.ActionData?,
) -> Unit {
  guard get_a11y(entity) is Some(a11y) else { return }
  if a11y.disabled {
    return
  }
  match action {
    Focus => @ui.focus(entity)
    Blur => @ui.blur()
    Click => {
      @ui.click_event_bus.send({ entity, button: @inputs.MouseButton::Left })
      invoke_action_callbacks(entity, action, data)
    }
    _ => invoke_action_callbacks(entity, action, data)
  }
}

///|
fn process_action_requests() -> Unit {
  for request in pending_action_requests {
    guard request.target_tree() == a11y_tree_id else { continue }
    guard current_node_entities.get(request.target_node()) is Some(entity) else {
      continue
    }
    dispatch_action(entity, request.action(), request.data())
  }
  pending_action_requests.clear()
}
