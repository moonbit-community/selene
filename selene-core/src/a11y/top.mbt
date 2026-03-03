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
/// Explicit accessibility semantics attached to entities.
pub let a11ys : Map[@entity.Entity, A11y] = Map::new()

///|
let a11y_tree_id : @moon_accesskit.TreeId = @moon_accesskit.TreeId::root()

///|
let focused_entity : Ref[@entity.Entity?] = { val: None }

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
  a11ys.set(entity, a11y)
}

///|
pub fn get_focused_entity() -> @entity.Entity? {
  focused_entity.val
}

///|
pub fn focus(entity : @entity.Entity) -> Unit {
  set_focus(Some(entity), true)
}

///|
pub fn blur() -> Unit {
  set_focus(None, true)
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
  let focusables = collect_focusables(ordered)
  sanitize_focus(focusables)
  handle_keyboard_navigation(focusables)
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
  guard @ui.uis.get(entity) is Some(_)
  if @collision.pickables.contains(entity) {
    Some(A11y::new(role=Button, focusable=true))
  } else {
    None
  }
}

///|
fn get_a11y(entity : @entity.Entity) -> A11y? {
  if a11ys.get(entity) is Some(a11y) {
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
fn collect_ordered_semantic_entities() -> Array[@entity.Entity] {
  let ordered = []
  let seen : Map[@entity.Entity, Bool] = Map::new()
  collect_semantic_descendants(@style.screen_root, ordered, seen)
  collect_semantic_descendants(@style.screen_pixel_root, ordered, seen)
  for entity, _ in a11ys {
    guard entity.is_alive() else { continue }
    guard @ui.uis.get(entity) is Some(_)
    guard get_a11y(entity) is Some(_)
    if !seen.contains(entity) {
      seen.set(entity, true)
      ordered.push(entity)
    }
  }
  ordered
}

///|
fn collect_semantic_descendants(
  root : @entity.Entity,
  ordered : Array[@entity.Entity],
  seen : Map[@entity.Entity, Bool],
) -> Unit {
  for child in root.get_children() {
    if child.is_alive() {
      if get_a11y(child) is Some(_) && !seen.contains(child) {
        seen.set(child, true)
        ordered.push(child)
      }
      collect_semantic_descendants(child, ordered, seen)
    }
  }
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
  let roots = []
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
fn collect_focusables(ordered : Array[@entity.Entity]) -> Array[@entity.Entity] {
  let focusables = []
  for entity in ordered {
    guard get_a11y(entity) is Some(a11y)
    if a11y.focusable && !a11y.disabled {
      focusables.push(entity)
    }
  }
  focusables
}

///|
fn sanitize_focus(focusables : Array[@entity.Entity]) -> Unit {
  if focused_entity.val is Some(current) {
    if !focusables.contains(current) {
      focused_entity.val = None
    }
  }
}

///|
fn set_focus(new_focus : @entity.Entity?, emit_callbacks : Bool) -> Unit {
  let old_focus = focused_entity.val
  if old_focus is Some(old) && new_focus is Some(newf) && old == newf {
    return
  }
  focused_entity.val = new_focus
  if emit_callbacks {
    if old_focus is Some(old) {
      invoke_action_callbacks(old, @moon_accesskit.Action::Blur, None)
    }
    if new_focus is Some(newf) {
      invoke_action_callbacks(newf, @moon_accesskit.Action::Focus, None)
    }
  }
}

///|
fn move_focus(focusables : Array[@entity.Entity], step : Int) -> Unit {
  if focusables.is_empty() {
    set_focus(None, true)
    return
  }
  if focused_entity.val is None {
    if step >= 0 {
      set_focus(Some(focusables[0]), true)
    } else {
      set_focus(Some(focusables[focusables.length() - 1]), true)
    }
    return
  }
  let current = focused_entity.val.unwrap()
  let mut index = -1
  for i in 0..<focusables.length() {
    if focusables[i] == current {
      index = i
      break
    }
  }
  if index < 0 {
    if step >= 0 {
      set_focus(Some(focusables[0]), true)
    } else {
      set_focus(Some(focusables[focusables.length() - 1]), true)
    }
    return
  }
  let mut next_index = index + step
  if next_index < 0 {
    next_index = focusables.length() - 1
  }
  if next_index >= focusables.length() {
    next_index = 0
  }
  set_focus(Some(focusables[next_index]), true)
}

///|
fn handle_keyboard_navigation(focusables : Array[@entity.Entity]) -> Unit {
  if @inputs.is_just_pressed(@inputs.ArrowRight) ||
    @inputs.is_just_pressed(@inputs.ArrowDown) {
    move_focus(focusables, 1)
  }
  if @inputs.is_just_pressed(@inputs.ArrowLeft) ||
    @inputs.is_just_pressed(@inputs.ArrowUp) {
    move_focus(focusables, -1)
  }
  if (
      @inputs.is_just_pressed(@inputs.Enter) ||
      @inputs.is_just_pressed(@inputs.Space)
    ) &&
    focused_entity.val is Some(focused) {
    dispatch_action(focused, @moon_accesskit.Action::Click, None)
  }
}

///|
fn resolve_size(entity : @entity.Entity) -> @math.Vec2D? {
  if @style.layout_sizes.get(entity) is Some(size) {
    return Some(size)
  }
  if @collision.shapes.get(entity) is Some(shape) {
    match shape {
      Rect(size~, ..) => return Some(size)
    }
  }
  if @sprite.sprites.get(entity) is Some(sprite) {
    match sprite.sprite_type {
      Picture(picture) => Some(picture.transform.apply_to_vec2d(picture.size))
      Animation(animation, ..) =>
        if animation.frames.length() > 0 {
          Some(animation.transform.apply_to_vec2d(animation.frames[0].size))
        } else {
          None
        }
      Text(_text) => Some(@math.Vec2D(48.0, 24.0))
      ColorRect(rect) => Some(rect.size)
      ColorCircle(circle) =>
        Some(@math.Vec2D(circle.radius * 2.0, circle.radius * 2.0))
    }
  } else {
    None
  }
}

///|
fn resolve_bounds(entity : @entity.Entity) -> @moon_accesskit.Rect? {
  guard @ui.uis.get(entity) is Some(ui)
  guard @position.positions.get(entity) is Some(position)
  guard resolve_size(entity) is Some(size)
  let (screen_pos, screen_size) = match ui.space {
    Virtual =>
      (@system.ui_virtual_to_screen(position.0), @system.scale_vec2(size))
    Screen => (position.0, size)
  }
  Some(
    @moon_accesskit.Rect::new(
      screen_pos[X],
      screen_pos[Y],
      screen_pos[X] + screen_size[X],
      screen_pos[Y] + screen_size[Y],
    ),
  )
}

///|
fn effective_label(entity : @entity.Entity, a11y : A11y) -> String? {
  if a11y.label is Some(label) {
    return Some(label)
  }
  if @sprite.sprites.get(entity) is Some(sprite) {
    match sprite.sprite_type {
      Text(text) => if text.content != "" { Some(text.content) } else { None }
      _ => None
    }
  } else {
    None
  }
}

///|
fn is_clickable(entity : @entity.Entity, a11y : A11y) -> Bool {
  @collision.pickables.contains(entity) || a11y.action_callbacks.length() > 0
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
  if focused_entity.val is Some(entity) && get_a11y(entity) is Some(_) {
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
  let root_children = []
  for entity in roots {
    let id = get_or_create_node_id(entity)
    root_children.push(id)
    current_node_entities.set(id, entity)
  }
  root.set_children(root_children)
  update.push_node(@moon_accesskit.NodeId::root(), root)

  for entity in ordered {
    guard get_a11y(entity) is Some(a11y)
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
    let child_ids = []
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
  guard a11ys.get(entity) is Some(a11y) else { return }
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
  guard get_a11y(entity) is Some(a11y)
  if a11y.disabled {
    return
  }
  match action {
    Focus => set_focus(Some(entity), true)
    Blur =>
      if focused_entity.val is Some(current) && current == entity {
        set_focus(None, true)
      }
    Click => {
      @collision.emit_pickable_just_pressed(entity)
      invoke_action_callbacks(entity, action, data)
    }
    _ => invoke_action_callbacks(entity, action, data)
  }
}

///|
fn process_action_requests() -> Unit {
  for request in pending_action_requests {
    guard request.target_tree() == a11y_tree_id else { continue }
    guard current_node_entities.get(request.target_node()) is Some(entity)
    dispatch_action(entity, request.action(), request.data())
  }
  pending_action_requests.clear()
}
