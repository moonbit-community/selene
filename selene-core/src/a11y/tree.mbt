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
let a11y_tree_id : @moon_accesskit.TreeId = @moon_accesskit.TreeId::root()

///|
let latest_tree_update_ref : Ref[@moon_accesskit.TreeUpdate?] = { val: None, }

///|
let entity_node_ids : Map[@ecs.Entity, UInt64] = Map([])

///|
let current_node_entities : Map[@moon_accesskit.NodeId, @ecs.Entity] = Map([])

///|
let next_node_id : Ref[UInt64] = { val: 1UL, }

///|
pub fn tree_id() -> @moon_accesskit.TreeId {
  a11y_tree_id
}

///|
pub fn get_focused_entity() -> @ecs.Entity? {
  @ui.focused_entity()
}

///|
pub fn focus(entity : @ecs.Entity) -> Unit {
  @ui.focus(entity)
}

///|
pub fn blur() -> Unit {
  @ui.blur()
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
    Container => GenericContainer
    Label => Label
    Button => Button
    CheckBox => CheckBox
    Slider => Slider
    TextInput => TextInput
    Image => Image
  }
}

///|
fn auto_a11y(entity : @ecs.Entity) -> A11y? {
  if @ui.buttons().get(entity) is Some(button) {
    Some(A11y(role=Button, focusable=true, disabled=!button.enabled))
  } else if @ui.texts().get(entity) is Some(_) {
    Some(A11y(role=Label))
  } else if @ui.ui_images().get(entity) is Some(_) {
    Some(A11y(role=Image))
  } else {
    None
  }
}

///|
fn get_a11y(entity : @ecs.Entity) -> A11y? {
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
fn ui_children(entity : @ecs.Entity) -> Array[@ecs.Entity] {
  let children : Array[@ecs.Entity] = []
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
        lhs.hash().compare(rhs.hash())
      }
    }
  })
  children
}

///|
fn collect_semantic_descendants(
  root : @ecs.Entity,
  ordered : Array[@ecs.Entity],
  seen : Map[@ecs.Entity, Bool],
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
fn collect_ordered_semantic_entities() -> Array[@ecs.Entity] {
  let ordered : Array[@ecs.Entity] = []
  let seen : Map[@ecs.Entity, Bool] = Map([])
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
fn find_semantic_parent(entity : @ecs.Entity) -> @ecs.Entity? {
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
  ordered : Array[@ecs.Entity],
) -> (Array[@ecs.Entity], Map[@ecs.Entity, Array[@ecs.Entity]]) {
  let roots : Array[@ecs.Entity] = []
  let children : Map[@ecs.Entity, Array[@ecs.Entity]] = Map([])
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
fn resolve_bounds(entity : @ecs.Entity) -> @moon_accesskit.Rect? {
  guard @ui.global_ui_node(entity) is Some(node) else { return None }
  Some(
    Rect(
      node.screen_rect.position.x,
      node.screen_rect.position.y,
      node.screen_rect.position.x + node.screen_rect.size.x,
      node.screen_rect.position.y + node.screen_rect.size.y,
    ),
  )
}

///|
fn effective_label(entity : @ecs.Entity, a11y : A11y) -> String? {
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
fn is_clickable(entity : @ecs.Entity, a11y : A11y) -> Bool {
  @ui.buttons().contains(entity) || a11y.action_callbacks.length() > 0
}

///|
fn get_or_create_node_id(entity : @ecs.Entity) -> @moon_accesskit.NodeId {
  if entity_node_ids.get(entity) is Some(raw) {
    NodeId(raw)
  } else {
    let raw = next_node_id.val
    next_node_id.val = next_node_id.val + 1UL
    entity_node_ids.set(entity, raw)
    NodeId(raw)
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
  ordered : Array[@ecs.Entity],
  roots : Array[@ecs.Entity],
  child_map : Map[@ecs.Entity, Array[@ecs.Entity]],
) -> @moon_accesskit.TreeUpdate {
  current_node_entities.clear()
  let update = @moon_accesskit.TreeUpdate(a11y_tree_id, focused_node_id())
  let root = @moon_accesskit.Node(Window)
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
    let node = @moon_accesskit.Node(to_accesskit_role(a11y.role))
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
      node.add_action(Focus)
    }
    if is_clickable(entity, a11y) && !a11y.disabled {
      node.add_action(Click)
    }
    let child_ids : Array[@moon_accesskit.NodeId] = []
    for child in child_map.get(entity).unwrap_or_default() {
      child_ids.push(get_or_create_node_id(child))
    }
    node.set_children(child_ids)
    update.push_node(id, node)
  }
  update.set_tree(TreeInfo(@moon_accesskit.NodeId::root()))
  update
}
