///|
pub(all) enum UiScaleMode {
  Screen
  Viewport
} derive(Eq, Show)

///|
pub let ui_scale_mode : Ref[UiScaleMode] = { val: Screen }

///|
pub fn set_ui_scale_mode(mode : UiScaleMode) -> Unit {
  ui_scale_mode.val = mode
}

///|
pub fn get_ui_scale_mode() -> UiScaleMode {
  ui_scale_mode.val
}

///|
pub(all) enum Val {
  Auto
  Px(Double)
  Percent(Double)
} derive(Eq, Show)

///|
pub fn Val::px(value : Double) -> Val {
  Px(value)
}

///|
pub fn Val::percent(value : Double) -> Val {
  Percent(value)
}

///|
pub(all) struct UiRectValues {
  left : Val
  right : Val
  top : Val
  bottom : Val
} derive(Eq, Show)

///|
pub fn UiRectValues::all(value : Double) -> UiRectValues {
  let px = Val::px(value)
  { left: px, right: px, top: px, bottom: px }
}

///|
pub fn UiRectValues::new(
  left? : Val = Auto,
  right? : Val = Auto,
  top? : Val = Auto,
  bottom? : Val = Auto,
) -> UiRectValues {
  { left, right, top, bottom }
}

///|
pub fn UiRectValues::px(
  left? : Double = 0.0,
  right? : Double = left,
  top? : Double = left,
  bottom? : Double = top,
) -> UiRectValues {
  { left: Px(left), right: Px(right), top: Px(top), bottom: Px(bottom) }
}

///|
pub(all) struct UiInsets {
  left : Double
  right : Double
  top : Double
  bottom : Double
} derive(Eq, Show)

///|
pub fn UiInsets::zero() -> UiInsets {
  { left: 0.0, right: 0.0, top: 0.0, bottom: 0.0 }
}

///|
pub(all) enum Display {
  Flex
  None
} derive(Eq, Show)

///|
pub(all) enum PositionType {
  Relative
  Absolute
} derive(Eq, Show)

///|
pub(all) enum FlexDirection {
  Row
  Column
} derive(Eq, Show)

///|
pub(all) enum JustifyContent {
  Start
  Center
  End
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq, Show)

///|
pub(all) enum AlignItems {
  Start
  Center
  End
  Stretch
} derive(Eq, Show)

///|
pub(all) enum Overflow {
  Visible
  Clip
  Scroll
} derive(Eq, Show)

///|
pub(all) struct Node {
  width : Val
  height : Val
  min_width : Val
  min_height : Val
  max_width : Val
  max_height : Val
  left : Val
  right : Val
  top : Val
  bottom : Val
  margin : UiRectValues
  padding : UiRectValues
  border : UiRectValues
  display : Display
  position_type : PositionType
  flex_direction : FlexDirection
  justify_content : JustifyContent
  align_items : AlignItems
  row_gap : Double
  column_gap : Double
  overflow_x : Overflow
  overflow_y : Overflow
  flex_grow : Double
  flex_shrink : Double
  active : Bool
} derive(Eq, Show)

///|
pub fn Node::new(
  width? : Val = Auto,
  height? : Val = Auto,
  min_width? : Val = Auto,
  min_height? : Val = Auto,
  max_width? : Val = Auto,
  max_height? : Val = Auto,
  left? : Val = Auto,
  right? : Val = Auto,
  top? : Val = Auto,
  bottom? : Val = Auto,
  margin? : UiRectValues = UiRectValues::all(0.0),
  padding? : UiRectValues = UiRectValues::all(0.0),
  border? : UiRectValues = UiRectValues::all(0.0),
  display? : Display = Flex,
  position_type? : PositionType = Relative,
  flex_direction? : FlexDirection = Column,
  justify_content? : JustifyContent = Start,
  align_items? : AlignItems = Stretch,
  row_gap? : Double = 0.0,
  column_gap? : Double = 0.0,
  overflow_x? : Overflow = Visible,
  overflow_y? : Overflow = Visible,
  flex_grow? : Double = 0.0,
  flex_shrink? : Double = 1.0,
  active? : Bool = true,
) -> Node {
  {
    width,
    height,
    min_width,
    min_height,
    max_width,
    max_height,
    left,
    right,
    top,
    bottom,
    margin,
    padding,
    border,
    display,
    position_type,
    flex_direction,
    justify_content,
    align_items,
    row_gap,
    column_gap,
    overflow_x,
    overflow_y,
    flex_grow,
    flex_shrink,
    active,
  }
}

///|
pub fn Node::absolute(
  offset : @math.Vec2D,
  size? : @math.Vec2D = @math.Vec2D(-1.0, -1.0),
  padding? : UiRectValues = UiRectValues::all(0.0),
  border? : UiRectValues = UiRectValues::all(0.0),
  display? : Display = Flex,
  flex_direction? : FlexDirection = Column,
  justify_content? : JustifyContent = Start,
  align_items? : AlignItems = Stretch,
  row_gap? : Double = 0.0,
  column_gap? : Double = 0.0,
  overflow_x? : Overflow = Visible,
  overflow_y? : Overflow = Visible,
  active? : Bool = true,
) -> Node {
  let (width, height) = if size[X] >= 0.0 && size[Y] >= 0.0 {
    (Px(size[X]), Px(size[Y]))
  } else {
    (Auto, Auto)
  }
  Node::new(
    width~,
    height~,
    left=Px(offset[X]),
    top=Px(offset[Y]),
    padding~,
    border~,
    display~,
    position_type=Absolute,
    flex_direction~,
    justify_content~,
    align_items~,
    row_gap~,
    column_gap~,
    overflow_x~,
    overflow_y~,
    active~,
  )
}

///|
pub(all) struct ComputedUiNode {
  position : @math.Vec2D
  size : @math.Vec2D
  content_position : @math.Vec2D
  content_size : @math.Vec2D
  border : UiInsets
  padding : UiInsets
}

///|
pub(all) struct GlobalUiNode {
  logical_rect : @math.Rect
  screen_rect : @math.Rect
  logical_content_rect : @math.Rect
  screen_content_rect : @math.Rect
}

///|
pub(all) struct UiZIndex {
  value : Int
} derive(Eq, Show)

///|
pub fn UiZIndex::new(value : Int) -> UiZIndex {
  { value, }
}

///|
pub(all) struct ScrollPosition {
  mut x : Double
  mut y : Double
} derive(Eq, Show)

///|
pub fn ScrollPosition::zero() -> ScrollPosition {
  { x: 0.0, y: 0.0 }
}

///|
pub(all) struct TabIndex {
  value : Int
} derive(Eq, Show)

///|
pub fn TabIndex::new(value : Int) -> TabIndex {
  { value, }
}

///|
pub(all) enum FocusPolicy {
  Block
  Pass
} derive(Eq, Show)

///|
pub(all) struct Focused {
  _tag : Unit
}

///|
pub fn Focused::new() -> Focused {
  { _tag: () }
}

///|
pub(all) struct Focusable {
  _tag : Unit
}

///|
pub fn Focusable::new() -> Focusable {
  { _tag: () }
}

///|
pub let nodes : Map[@entity.Entity, Node] = Map::new()

///|
pub let computed_ui_nodes : Map[@entity.Entity, ComputedUiNode] = Map::new()

///|
pub let global_ui_nodes : Map[@entity.Entity, GlobalUiNode] = Map::new()

///|
pub let ui_zindexes : Map[@entity.Entity, UiZIndex] = Map::new()

///|
pub let scroll_positions : Map[@entity.Entity, ScrollPosition] = Map::new()

///|
pub let tab_indexes : Map[@entity.Entity, TabIndex] = Map::new()

///|
pub let focus_policies : Map[@entity.Entity, FocusPolicy] = Map::new()

///|
pub let focusables : Map[@entity.Entity, Focusable] = Map::new()

///|
pub let focuseds : Map[@entity.Entity, Focused] = Map::new()

///|
let screen_clip_rects : Map[@entity.Entity, @math.Rect] = Map::new()

///|
let tree_orders : Map[@entity.Entity, Int] = Map::new()

///|
pub fn is_ui_entity(entity : @entity.Entity) -> Bool {
  nodes.contains(entity)
}

///|
fn logical_to_screen_point(point : @math.Vec2D) -> @math.Vec2D {
  match get_ui_scale_mode() {
    Screen => point
    Viewport => @system.ui_virtual_to_screen(point)
  }
}

///|
fn logical_to_screen_size(size : @math.Vec2D) -> @math.Vec2D {
  match get_ui_scale_mode() {
    Screen => size
    Viewport => @system.scale_vec2(size)
  }
}

///|
fn to_screen_rect(rect : @math.Rect) -> @math.Rect {
  {
    position: logical_to_screen_point(rect.position),
    size: logical_to_screen_size(rect.size),
  }
}

///|
fn top_level_ui_nodes() -> Array[@entity.Entity] {
  let roots : Array[@entity.Entity] = []
  for entity, node in nodes {
    guard entity.is_alive() else { continue }
    guard node.active && node.display != None else { continue }
    match entity.get_parent() {
      Some(parent) => if !nodes.contains(parent) { roots.push(entity) }
      None => roots.push(entity)
    }
  }
  roots.sort_by(fn(lhs, rhs) {
    let lz = ui_zindexes.get(lhs).map(fn(value) { value.value }).unwrap_or(0)
    let rz = ui_zindexes.get(rhs).map(fn(value) { value.value }).unwrap_or(0)
    if lz != rz {
      lz - rz
    } else {
      lhs.to_string().compare(rhs.to_string())
    }
  })
  roots
}

///|
fn ui_children(entity : @entity.Entity) -> Array[@entity.Entity] {
  let children : Array[@entity.Entity] = []
  for child in entity.get_children() {
    if child.is_alive() && nodes.contains(child) {
      children.push(child)
    }
  }
  children
}
