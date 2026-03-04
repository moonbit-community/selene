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
pub(all) enum LayoutDirection {
  Overlay
  Row
  Column
} derive(Eq)

///|
pub(all) enum MainAxisAlign {
  Start
  Center
  End
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq)

///|
pub(all) enum CrossAxisAlign {
  Start
  Center
  End
  Stretch
} derive(Eq)

///|
pub(all) enum NodeSize {
  Auto
  Fixed(@math.Vec2D)
  FillViewport
  FillScreen
}

///|
pub(all) struct Node {
  mut size : NodeSize
  mut layout : LayoutDirection
  mut space : UiSpace
  mut padding : @math.Vec2D
  mut gap : @math.Vec2D
  mut offset : @math.Vec2D
  mut justify : MainAxisAlign
  mut align : CrossAxisAlign
  mut active : Bool
}

///|
pub fn Node::new(
  size? : NodeSize = Auto,
  layout? : LayoutDirection = Overlay,
  space? : UiSpace = Virtual,
  padding? : @math.Vec2D = @math.Vec2D::zero(),
  gap? : @math.Vec2D = @math.Vec2D::zero(),
  offset? : @math.Vec2D = @math.Vec2D::zero(),
  justify? : MainAxisAlign = Start,
  align? : CrossAxisAlign = Stretch,
  active? : Bool = true,
) -> Node {
  { size, layout, space, padding, gap, offset, justify, align, active }
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
pub(all) struct Button {
  mut enabled : Bool
  trigger : @inputs.MouseButton
  hit_size : @math.Vec2D
}

///|
pub fn Button::new(
  enabled? : Bool = true,
  trigger? : @inputs.MouseButton = @inputs.MouseButton::Left,
  hit_size? : @math.Vec2D = @math.Vec2D::zero(),
) -> Button {
  { enabled, trigger, hit_size }
}

///|
pub(all) enum Interaction {
  None
  Hovered
  Pressed
} derive(Eq)

///|
pub struct InteractionEvent {
  entity : @entity.Entity
  previous : Interaction
  current : Interaction
}

///|
pub let uis : Map[@entity.Entity, Ui] = Map::new()

///|
pub let nodes : Map[@entity.Entity, Node] = Map::new()

///|
pub let layout_sizes : Map[@entity.Entity, @math.Vec2D] = Map::new()

///|
pub let buttons : Map[@entity.Entity, Button] = Map::new()

///|
pub let interactions : Map[@entity.Entity, Interaction] = Map::new()

///|
let frame_interaction_events : Array[InteractionEvent] = []

///|
pub const UI_ZINDEX = 100

///|
pub let virtual_root : @entity.Entity = @entity.Entity::new()

///|
pub let screen_root : @entity.Entity = @entity.Entity::new()

///|
fn init {
  @position.positions.set(virtual_root, @math.Vec2D::zero())
  @position.positions.set(screen_root, @math.Vec2D::zero())
  uis.set(virtual_root, Ui::new(space=Virtual))
  uis.set(screen_root, Ui::new(space=Screen))
  nodes.set(
    virtual_root,
    Node::new(size=FillViewport, layout=Overlay, space=Virtual),
  )
  nodes.set(
    screen_root,
    Node::new(size=FillScreen, layout=Overlay, space=Screen),
  )
}

///|
pub fn interaction_events() -> Array[InteractionEvent] {
  frame_interaction_events
}

///|
pub fn add_node(
  parent : @entity.Entity,
  node? : Node = Node::new(),
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> @entity.Entity {
  let child = parent.spawn_child(offset~)
  nodes.set(child, node)
  uis.set(child, Ui::new(space=node.space))
  child
}

///|
pub fn add_button(
  parent : @entity.Entity,
  node? : Node = Node::new(),
  button? : Button = Button::new(),
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> @entity.Entity {
  let child = add_node(parent, node~, offset~)
  buttons.set(child, button)
  interactions.set(child, Interaction::None)
  child
}

///|
pub fn ui_layout_system(_delta : Double) -> Unit {
  layout_sizes.clear()
  let roots : Array[@entity.Entity] = []
  for entity, node in nodes {
    guard entity.is_alive() else { continue }
    guard node.active else { continue }
    if entity.get_parent() is Some(parent) && nodes.contains(parent) {
      continue
    }
    roots.push(entity)
  }
  for root in roots {
    layout_node_tree(root)
  }
}

///|
pub fn ui_button_system(_delta : Double) -> Unit {
  clear_interaction_events()
  let mouse_screen = @inputs.mouse.pos
  let mouse_virtual = @system.screen_to_ui_virtual(mouse_screen)
  for entity, button in buttons {
    if !entity.is_alive() {
      continue
    }
    let previous = interactions.get(entity).unwrap_or(Interaction::None)
    let current = resolve_button_interaction(
      entity, button, mouse_screen, mouse_virtual,
    )
    if previous != current {
      interactions.set(entity, current)
      frame_interaction_events.push({ entity, previous, current })
    }
  }
}

///|
fn clear_interaction_events() -> Unit {
  frame_interaction_events.clear()
}

///|
fn layout_node_tree(root : @entity.Entity) -> Unit {
  let taffy : @moon_taffy.TaffyTree[@entity.Entity] = @moon_taffy.TaffyTree::new()
  let node_entities : Array[@entity.Entity] = []
  let root_node = build_taffy_node(
    taffy,
    node_entities,
    root,
    @math.Vec2D::zero(),
    None,
  )
  guard root_node is Some(root_node) else { return }
  let compute_result : Result[Unit, @moon_taffy.TaffyError] = try? taffy.compute_layout(
    root_node,
    @moon_taffy.Size::max_content(),
  )
  match compute_result {
    Ok(_) => ()
    Err(_) => return
  }
  for node_id, entity in node_entities {
    let layout_result : Result[@moon_taffy.Layout, @moon_taffy.TaffyError] = try? taffy.layout(
      node_id,
    )
    match layout_result {
      Ok(layout) => {
        let size = @math.Vec2D(layout.size.width, layout.size.height)
        layout_sizes.set(entity, size)
        if entity.is_child() {
          entity.set_offset(@math.Vec2D(layout.location.x, layout.location.y))
        }
      }
      Err(_) => continue
    }
  }
}

///|
fn build_taffy_node(
  taffy : @moon_taffy.TaffyTree[@entity.Entity],
  node_entities : Array[@entity.Entity],
  entity : @entity.Entity,
  parent_overlay_shift : @math.Vec2D,
  parent_layout : LayoutDirection?,
) -> Int? {
  guard nodes.get(entity) is Some(node) else { return None }
  guard node.active else { return None }
  uis.set(entity, Ui::new(space=node.space))
  let next_parent_overlay_shift = match node.layout {
    Overlay => node.padding
    _ => @math.Vec2D::zero()
  }
  let child_node_ids : Array[Int] = []
  for child in entity.get_children() {
    if build_taffy_node(
        taffy,
        node_entities,
        child,
        next_parent_overlay_shift,
        Some(node.layout),
      )
      is Some(child_node_id) {
      child_node_ids.push(child_node_id)
    }
  }
  let taffy_style = node_to_taffy_style(
    node, parent_overlay_shift, parent_layout,
  )
  let node_id = taffy.new_leaf_with_context(taffy_style, entity)
  if child_node_ids.length() > 0 {
    let set_children_result : Result[Unit, @moon_taffy.TaffyError] = try? taffy.set_children(
      node_id, child_node_ids,
    )
    match set_children_result {
      Ok(_) => ()
      Err(_) => return None
    }
  }
  node_entities.push(entity)
  Some(node_id)
}

///|
fn node_to_taffy_style(
  node : Node,
  parent_overlay_shift : @math.Vec2D,
  parent_layout : LayoutDirection?,
) -> @moon_taffy.Style {
  let mut taffy_style = @moon_taffy.Style::default()
  taffy_style = match node.layout {
    Row =>
      taffy_style
      .with_display(@moon_taffy.display_flex())
      .with_flex_direction(@moon_taffy.flex_direction_row())
      .with_justify_content(main_axis_align_to_taffy(node.justify))
      .with_align_items(cross_axis_align_to_taffy(node.align))
      .with_padding(
        @moon_taffy.Rect::new(
          left=@moon_taffy.length(node.padding[X]),
          right=@moon_taffy.length(0.0),
          top=@moon_taffy.length(node.padding[Y]),
          bottom=@moon_taffy.length(0.0),
        ),
      )
      .with_gap(
        @moon_taffy.Size::new(
          width=@moon_taffy.length(node.gap[X]),
          height=@moon_taffy.length(node.gap[Y]),
        ),
      )
    Column =>
      taffy_style
      .with_display(@moon_taffy.display_flex())
      .with_flex_direction(@moon_taffy.flex_direction_column())
      .with_justify_content(main_axis_align_to_taffy(node.justify))
      .with_align_items(cross_axis_align_to_taffy(node.align))
      .with_padding(
        @moon_taffy.Rect::new(
          left=@moon_taffy.length(node.padding[X]),
          right=@moon_taffy.length(0.0),
          top=@moon_taffy.length(node.padding[Y]),
          bottom=@moon_taffy.length(0.0),
        ),
      )
      .with_gap(
        @moon_taffy.Size::new(
          width=@moon_taffy.length(node.gap[X]),
          height=@moon_taffy.length(node.gap[Y]),
        ),
      )
    Overlay => taffy_style.with_display(@moon_taffy.display_grid())
  }
  taffy_style = match resolve_node_size(node) {
    Some(size) =>
      taffy_style.with_size(
        @moon_taffy.Size::new(
          width=@moon_taffy.length(non_negative(size[X])),
          height=@moon_taffy.length(non_negative(size[Y])),
        ),
      )
    None => taffy_style
  }
  taffy_style = match parent_layout {
    Some(Overlay) =>
      taffy_style.with_grid_row_start(1).with_grid_column_start(1)
    _ => taffy_style
  }
  let offset_x = node.offset[X] + parent_overlay_shift[X]
  let offset_y = node.offset[Y] + parent_overlay_shift[Y]
  if offset_x == 0.0 && offset_y == 0.0 {
    taffy_style
  } else {
    taffy_style
    .with_position(@moon_taffy.position_relative())
    .with_inset(
      @moon_taffy.Rect::new(
        left=@moon_taffy.length(offset_x),
        right=@moon_taffy.auto(),
        top=@moon_taffy.length(offset_y),
        bottom=@moon_taffy.auto(),
      ),
    )
  }
}

///|
fn main_axis_align_to_taffy(
  value : MainAxisAlign,
) -> @moon_taffy.JustifyContent {
  match value {
    Start => @moon_taffy.justify_content_flex_start()
    Center => @moon_taffy.justify_content_center()
    End => @moon_taffy.justify_content_flex_end()
    SpaceBetween => @moon_taffy.justify_content_space_between()
    SpaceAround => @moon_taffy.justify_content_space_around()
    SpaceEvenly => @moon_taffy.justify_content_space_evenly()
  }
}

///|
fn cross_axis_align_to_taffy(value : CrossAxisAlign) -> @moon_taffy.AlignItems {
  match value {
    Start => @moon_taffy.align_items_flex_start()
    Center => @moon_taffy.align_items_center()
    End => @moon_taffy.align_items_flex_end()
    Stretch => @moon_taffy.align_items_stretch()
  }
}

///|
fn resolve_node_size(node : Node) -> @math.Vec2D? {
  match node.size {
    Auto => None
    Fixed(size) => Some(size)
    FillViewport => Some(@system.get_viewport_size())
    FillScreen => Some(@system.get_screen_size())
  }
}

///|
fn resolve_button_interaction(
  entity : @entity.Entity,
  button : Button,
  mouse_screen : @math.Vec2D,
  mouse_virtual : @math.Vec2D,
) -> Interaction {
  if !button.enabled {
    return Interaction::None
  }
  let size = layout_sizes.get(entity).unwrap_or(button.hit_size)
  if size[X] <= 0.0 || size[Y] <= 0.0 {
    return Interaction::None
  }
  let ui_space = nodes
    .get(entity)
    .map_or(uis.get(entity).map_or(UiSpace::Virtual, ui => ui.space), node => {
      node.space
    })
  let point = match ui_space {
    UiSpace::Virtual => mouse_virtual
    UiSpace::Screen => mouse_screen
  }
  let position = resolve_entity_position(entity)
  if !point_in_rect(point, position, size) {
    return Interaction::None
  }
  if @inputs.is_mouse_pressed(button.trigger) {
    Interaction::Pressed
  } else {
    Interaction::Hovered
  }
}

///|
fn resolve_entity_position(entity : @entity.Entity) -> @math.Vec2D {
  if entity.get_parent() is Some(parent) {
    resolve_entity_position(parent) + entity.get_offset()
  } else {
    @position.positions.get(entity).map_or(@math.Vec2D::zero(), p => p.0)
  }
}

///|
fn point_in_rect(
  point : @math.Vec2D,
  rect_position : @math.Vec2D,
  rect_size : @math.Vec2D,
) -> Bool {
  point[X] >= rect_position[X] &&
  point[X] <= rect_position[X] + rect_size[X] &&
  point[Y] >= rect_position[Y] &&
  point[Y] <= rect_position[Y] + rect_size[Y]
}

///|
fn non_negative(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else {
    value
  }
}
