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
priv struct A11yRuntime {
  mut latest_update : @moon_accesskit.TreeUpdate?
  entity_node_ids : @ecs.EntityTable[UInt64]
  current_node_entities : Map[@moon_accesskit.NodeId, @ecs.Entity]
}

///|
let a11y_runtime_key : @ecs.ResourceKey[A11yRuntime] = ResourceKey()

///|
fn a11y_runtime(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> A11yRuntime {
  a11y_runtime_key.get_or_insert_with(world, world => {
    latest_update: None,
    entity_node_ids: EntityTable(world),
    current_node_entities: {},
  })
}

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
  a11y_runtime().latest_update
}

///|
pub fn latest_tree_update_json() -> Json? {
  if a11y_runtime().latest_update is Some(update) {
    Some(update.to_json())
  } else {
    None
  }
}

///|
pub fn a11y_sync_system(state : A11yTree) -> Unit {
  state.runtime.entity_node_ids.retain((entity, _) => {
    state.entities.is_valid(entity)
  })
  let ordered = collect_ordered_semantic_entities(state~)
  let (roots, child_map) = build_hierarchy(state~, ordered)
  let update = build_tree_update(state~, ordered, roots, child_map)
  state.runtime.latest_update = Some(update)
  process_action_requests(state~)
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
fn auto_a11y(state~ : A11yTree, entity : @ecs.Entity) -> A11y? {
  if state.buttons.get(entity).map(value => value.0) is Some(button) {
    Some(A11y(role=Button, focusable=true, disabled=!button.enabled))
  } else if state.texts.get(entity).map(value => value.0) is Some(_) {
    Some(A11y(role=Label))
  } else if state.images.get(entity).map(value => value.0) is Some(_) {
    Some(A11y(role=Image))
  } else {
    None
  }
}

///|
fn get_a11y(state~ : A11yTree, entity : @ecs.Entity) -> A11y? {
  if state.semantics.get(entity).map(value => value.0) is Some(a11y) {
    if a11y.hidden {
      None
    } else {
      Some(a11y)
    }
  } else {
    auto_a11y(state~, entity)
  }
}

///|
fn ui_children(state~ : A11yTree, entity : @ecs.Entity) -> Array[@ecs.Entity] {
  let query_node = state.nodes
  let query_global_z_index = state.global_z_indices
  let query_z_index = state.z_indices
  let children : Array[@ecs.Entity] = []
  for child in state.hierarchy.children(entity) {
    if state.entities.is_alive(child) && query_node.contains(child) {
      children.push(child)
    }
  }
  children.sort_by(fn(lhs, rhs) {
    let lg = query_global_z_index
      .get(lhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    let rg = query_global_z_index
      .get(rhs)
      .map(fn(value) { value.value })
      .unwrap_or(0)
    if lg != rg {
      lg - rg
    } else {
      let lz = query_z_index
        .get(lhs)
        .map(fn(value) { value.value })
        .unwrap_or(0)
      let rz = query_z_index
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
  state~ : A11yTree,
  root : @ecs.Entity,
  ordered : Array[@ecs.Entity],
  seen : @set.Set[@ecs.Entity],
) -> Unit {
  if get_a11y(state~, root) is Some(_) && !seen.contains(root) {
    seen.add(root)
    ordered.push(root)
  }
  for child in ui_children(state~, root) {
    collect_semantic_descendants(state~, child, ordered, seen)
  }
}

///|
fn collect_ordered_semantic_entities(state~ : A11yTree) -> Array[@ecs.Entity] {
  let query_node = state.nodes
  let query_a11y = state.semantics
  let ordered : Array[@ecs.Entity] = []
  let seen : @set.Set[@ecs.Entity] = Set([])
  for entity, Single(_node) in query_node {
    guard state.entities.is_alive(entity) else { continue }
    match state.hierarchy.parent(entity) {
      Some(parent) => if query_node.contains(parent) { continue }
      None => ()
    }
    collect_semantic_descendants(state~, entity, ordered, seen)
  }
  for entity, _ in query_a11y {
    guard state.entities.is_alive(entity) else { continue }
    guard get_a11y(state~, entity) is Some(_) else { continue }
    if !seen.contains(entity) {
      seen.add(entity)
      ordered.push(entity)
    }
  }
  ordered
}

///|
fn find_semantic_parent(
  state~ : A11yTree,
  entity : @ecs.Entity,
) -> @ecs.Entity? {
  let mut parent = state.hierarchy.parent(entity)
  while parent is Some(p) {
    if get_a11y(state~, p) is Some(_) {
      return Some(p)
    }
    parent = state.hierarchy.parent(p)
  }
  None
}

///|
fn build_hierarchy(
  state~ : A11yTree,
  ordered : Array[@ecs.Entity],
) -> (Array[@ecs.Entity], @ecs.EntityTable[Array[@ecs.Entity]]) {
  let roots : Array[@ecs.Entity] = []
  let children : @ecs.EntityTable[Array[@ecs.Entity]] = state.children
  children.clear()
  for entity in ordered {
    if find_semantic_parent(state~, entity) is Some(parent) {
      children.get_or_init(parent, () => []).push(entity)
    } else {
      roots.push(entity)
    }
  }
  (roots, children)
}

///|
fn resolve_bounds(
  state~ : A11yTree,
  entity : @ecs.Entity,
) -> @moon_accesskit.Rect? {
  guard state.geometry.global_node(entity) is Some(node) else { return None }
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
fn effective_label(
  state~ : A11yTree,
  entity : @ecs.Entity,
  a11y : A11y,
) -> String? {
  if a11y.label is Some(label) {
    return Some(label)
  }
  if state.texts.get(entity).map(value => value.0) is Some(text) &&
    text.content != "" {
    Some(text.content)
  } else {
    None
  }
}

///|
fn is_clickable(state~ : A11yTree, entity : @ecs.Entity, a11y : A11y) -> Bool {
  let query_button = state.buttons
  query_button.contains(entity) || a11y.action_callbacks.length() > 0
}

///|
fn get_or_create_node_id(
  state~ : A11yTree,
  entity : @ecs.Entity,
) -> @moon_accesskit.NodeId {
  if state.runtime.entity_node_ids.get(entity) is Some(raw) {
    NodeId(raw)
  } else {
    let raw = next_node_id.val
    next_node_id.val = next_node_id.val + 1UL
    state.runtime.entity_node_ids.set(entity, raw)
    NodeId(raw)
  }
}

///|
fn focused_node_id(state~ : A11yTree) -> @moon_accesskit.NodeId {
  if state.input.focused_entity() is Some(entity) &&
    get_a11y(state~, entity) is Some(_) {
    get_or_create_node_id(state~, entity)
  } else {
    @moon_accesskit.NodeId::root()
  }
}

///|
fn build_tree_update(
  state~ : A11yTree,
  ordered : Array[@ecs.Entity],
  roots : Array[@ecs.Entity],
  child_map : @ecs.EntityTable[Array[@ecs.Entity]],
) -> @moon_accesskit.TreeUpdate {
  state.runtime.current_node_entities.clear()
  let update = @moon_accesskit.TreeUpdate(a11y_tree_id, focused_node_id(state~))
  let root = @moon_accesskit.Node(Window)
  root.set_label("Selene")
  let root_children : Array[@moon_accesskit.NodeId] = []
  for entity in roots {
    let id = get_or_create_node_id(state~, entity)
    root_children.push(id)
    state.runtime.current_node_entities.set(id, entity)
  }
  root.set_children(root_children)
  update.push_node(@moon_accesskit.NodeId::root(), root)

  for entity in ordered {
    guard get_a11y(state~, entity) is Some(a11y) else { continue }
    let id = get_or_create_node_id(state~, entity)
    state.runtime.current_node_entities.set(id, entity)
    let node = @moon_accesskit.Node(to_accesskit_role(a11y.role))
    if effective_label(state~, entity, a11y) is Some(label) {
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
    if resolve_bounds(state~, entity) is Some(bounds) {
      node.set_bounds(bounds)
    }
    if a11y.focusable && !a11y.disabled {
      node.add_action(Focus)
    }
    if is_clickable(state~, entity, a11y) && !a11y.disabled {
      node.add_action(Click)
    }
    let child_ids : Array[@moon_accesskit.NodeId] = []
    for child in child_map.get(entity).unwrap_or_default() {
      child_ids.push(get_or_create_node_id(state~, child))
    }
    node.set_children(child_ids)
    update.push_node(id, node)
  }
  update.set_tree(TreeInfo(@moon_accesskit.NodeId::root()))
  update
}

///|
/// Semantic UI queries, retained accessibility state, and UI event outputs.
struct A11yTree {
  runtime : A11yRuntime
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
  geometry : @ui.UiGeometryView
  input : @ui.UiInput
  clicks : @event.EventWriter[@ui.UiClickEvent]
  children : @ecs.EntityTable[Array[@ecs.Entity]]
  buttons : @ecs.Query[@ecs.Single[@ui.Button]]
  texts : @ecs.Query[@ecs.Single[@ui.Text]]
  images : @ecs.Query[@ecs.Single[@ui.UiImage]]
  semantics : @ecs.Query[@ecs.Single[A11y]]
  nodes : @ecs.Query[@ecs.Single[@ui.Node]]
  global_z_indices : @ecs.Query[@ecs.Single[@ui.GlobalZIndex]]
  z_indices : @ecs.Query[@ecs.Single[@ui.ZIndex]]
}

///|
pub fn A11yTree::A11yTree(world : @ecs.World) -> A11yTree {
  {
    runtime: a11y_runtime(world~),
    entities: Entities(world),
    hierarchy: Hierarchy(world),
    geometry: UiGeometryView(world),
    input: UiInput(world),
    clicks: @ui.click_event_bus.writer(world~),
    children: EntityTable(world),
    buttons: world.query(),
    texts: world.query(),
    images: world.query(),
    semantics: world.query(),
    nodes: world.query(),
    global_z_indices: world.query(),
    z_indices: world.query(),
  }
}

///|
pub impl @ecs.SystemParam for A11yTree with fn prepare(world) {
  let state = A11yTree(world)
  _ => state
}

///|
pub extend A11yTree with @ecs.SystemParam::{prepare}
