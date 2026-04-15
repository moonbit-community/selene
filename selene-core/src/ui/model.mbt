///|
pub(all) enum UiScaleMode {
  Screen
  Viewport
} derive(Eq, Debug)

///|
let ui_scale_modes : Map[UInt, UiScaleMode] = Map::new()

///|
fn ui_scale_mode() -> UiScaleMode {
  let world_id = @ecs.require_current_world().id()
  ui_scale_modes.get_or_init(world_id, fn() { Screen })
}

///|
pub fn set_ui_scale_mode(mode : UiScaleMode) -> Unit {
  ui_scale_modes.set(@ecs.require_current_world().id(), mode)
}

///|
pub fn get_ui_scale_mode() -> UiScaleMode {
  ui_scale_mode()
}

///|
pub(all) enum Val {
  Auto
  Px(Double)
  Percent(Double)
} derive(Eq, Debug)

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

  fn new(left? : Val, right? : Val, top? : Val, bottom? : Val) -> UiRectValues
} derive(Eq, Debug)

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
} derive(Eq, Debug)

///|
pub fn UiInsets::zero() -> UiInsets {
  { left: 0.0, right: 0.0, top: 0.0, bottom: 0.0 }
}

///|
pub(all) enum Display {
  Block
  Flex
  Grid
  None
} derive(Eq, Debug)

///|
pub(all) enum PositionType {
  Relative
  Absolute
} derive(Eq, Debug)

///|
pub(all) enum FlexDirection {
  Row
  RowReverse
  Column
  ColumnReverse
} derive(Eq, Debug)

///|
pub(all) enum JustifyContent {
  Start
  End
  FlexStart
  FlexEnd
  Center
  Stretch
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq, Debug)

///|
pub(all) enum AlignItems {
  Start
  End
  FlexStart
  FlexEnd
  Center
  Baseline
  Stretch
} derive(Eq, Debug)

///|
pub(all) enum AlignContent {
  Start
  End
  FlexStart
  FlexEnd
  Center
  Stretch
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq, Debug)

///|
pub(all) enum FlexWrap {
  NoWrap
  Wrap
  WrapReverse
} derive(Eq, Debug)

///|
pub(all) enum GridAutoFlow {
  Row
  Column
  RowDense
  ColumnDense
} derive(Eq, Debug)

///|
pub(all) enum GridPlacement {
  Auto
  Line(Int)
  Span(Int)
} derive(Eq, Debug)

///|
pub(all) struct GridLine {
  start : GridPlacement
  end : GridPlacement

  fn new(start? : GridPlacement, end? : GridPlacement) -> GridLine
} derive(Eq, Debug)

///|
pub fn GridLine::new(
  start? : GridPlacement = Auto,
  end? : GridPlacement = Auto,
) -> GridLine {
  { start, end }
}

///|
pub(all) enum GridTrackRepetition {
  Count(Int)
  AutoFill
  AutoFit
} derive(Eq, Debug)

///|
pub(all) enum GridTrack {
  Auto
  Px(Double)
  Percent(Double)
  Fr(Double)
  MinContent
  MaxContent
  FitContent(GridTrack)
  MinMax(GridTrack, GridTrack)
  Repeat(GridTrackRepetition, Array[GridTrack])
} derive(Eq, Debug)

///|
pub fn align_content_start() -> AlignContent {
  Start
}

///|
pub fn align_content_end() -> AlignContent {
  End
}

///|
pub fn align_content_flex_start() -> AlignContent {
  FlexStart
}

///|
pub fn align_content_flex_end() -> AlignContent {
  FlexEnd
}

///|
pub fn align_content_center() -> AlignContent {
  Center
}

///|
pub fn align_content_stretch() -> AlignContent {
  Stretch
}

///|
pub fn align_content_space_between() -> AlignContent {
  SpaceBetween
}

///|
pub fn align_content_space_around() -> AlignContent {
  SpaceAround
}

///|
pub fn align_content_space_evenly() -> AlignContent {
  SpaceEvenly
}

///|
pub fn flex_wrap_no_wrap() -> FlexWrap {
  NoWrap
}

///|
pub fn flex_wrap_wrap() -> FlexWrap {
  Wrap
}

///|
pub fn flex_wrap_wrap_reverse() -> FlexWrap {
  WrapReverse
}

///|
pub fn grid_auto() -> GridTrack {
  Auto
}

///|
pub fn grid_px(value : Double) -> GridTrack {
  Px(value)
}

///|
pub fn grid_percent(value : Double) -> GridTrack {
  Percent(value)
}

///|
pub fn grid_fr(value : Double) -> GridTrack {
  Fr(value)
}

///|
pub fn grid_min_content() -> GridTrack {
  MinContent
}

///|
pub fn grid_max_content() -> GridTrack {
  MaxContent
}

///|
pub fn grid_fit_content(value : GridTrack) -> GridTrack {
  FitContent(value)
}

///|
pub fn grid_minmax(min : GridTrack, max : GridTrack) -> GridTrack {
  MinMax(min, max)
}

///|
pub fn grid_repeat_count(value : Int) -> GridTrackRepetition {
  Count(value)
}

///|
pub fn grid_repeat_auto_fill() -> GridTrackRepetition {
  AutoFill
}

///|
pub fn grid_repeat_auto_fit() -> GridTrackRepetition {
  AutoFit
}

///|
pub fn grid_repeat(
  repetition : GridTrackRepetition,
  tracks : Array[GridTrack],
) -> GridTrack {
  Repeat(repetition, tracks)
}

///|
pub fn grid_place_auto() -> GridPlacement {
  Auto
}

///|
pub fn grid_line_index(value : Int) -> GridPlacement {
  Line(value)
}

///|
pub fn grid_span(value : Int) -> GridPlacement {
  Span(value)
}

///|
pub fn grid_auto_flow_row() -> GridAutoFlow {
  Row
}

///|
pub fn grid_auto_flow_column() -> GridAutoFlow {
  Column
}

///|
pub fn grid_auto_flow_row_dense() -> GridAutoFlow {
  RowDense
}

///|
pub fn grid_auto_flow_column_dense() -> GridAutoFlow {
  ColumnDense
}

///|
pub(all) enum Overflow {
  Visible
  Clip
  Hidden
  Scroll
} derive(Eq, Debug)

///|
pub(all) enum OverflowClipBox {
  ContentBox
  PaddingBox
  BorderBox
} derive(Eq, Debug)

///|
pub(all) struct OverflowClipMargin {
  visual_box : OverflowClipBox
  margin : Double
} derive(Eq, Debug)

///|
pub fn OverflowClipMargin::content_box() -> OverflowClipMargin {
  { visual_box: ContentBox, margin: 0.0 }
}

///|
pub fn OverflowClipMargin::padding_box() -> OverflowClipMargin {
  { visual_box: PaddingBox, margin: 0.0 }
}

///|
pub fn OverflowClipMargin::border_box() -> OverflowClipMargin {
  { visual_box: BorderBox, margin: 0.0 }
}

///|
pub fn OverflowClipMargin::with_margin(
  self : OverflowClipMargin,
  margin : Double,
) -> OverflowClipMargin {
  { ..self, margin: @cmp.maximum(0.0, margin) }
}

///|
pub fn default_overflow_clip_margin() -> OverflowClipMargin {
  OverflowClipMargin::content_box()
}

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
  align_content : AlignContent?
  align_self : AlignItems?
  justify_items : AlignItems?
  justify_self : AlignItems?
  row_gap : Double
  column_gap : Double
  overflow_x : Overflow
  overflow_y : Overflow
  overflow_clip_margin : OverflowClipMargin
  flex_wrap : FlexWrap
  flex_basis : Val
  flex_grow : Double
  flex_shrink : Double
  aspect_ratio : Double?
  scrollbar_width : Double
  grid_template_rows : Array[GridTrack]
  grid_template_columns : Array[GridTrack]
  grid_auto_rows : Array[GridTrack]
  grid_auto_columns : Array[GridTrack]
  grid_auto_flow : GridAutoFlow
  grid_row : GridLine
  grid_column : GridLine
  active : Bool

  fn new(
    width? : Val,
    height? : Val,
    min_width? : Val,
    min_height? : Val,
    max_width? : Val,
    max_height? : Val,
    left? : Val,
    right? : Val,
    top? : Val,
    bottom? : Val,
    margin? : UiRectValues,
    padding? : UiRectValues,
    border? : UiRectValues,
    display? : Display,
    position_type? : PositionType,
    flex_direction? : FlexDirection,
    justify_content? : JustifyContent,
    align_items? : AlignItems,
    row_gap? : Double,
    column_gap? : Double,
    overflow_x? : Overflow,
    overflow_y? : Overflow,
    overflow_clip_margin? : OverflowClipMargin,
    flex_grow? : Double,
    flex_shrink? : Double,
    active? : Bool,
    align_content? : AlignContent?,
    align_self? : AlignItems?,
    justify_items? : AlignItems?,
    justify_self? : AlignItems?,
    flex_wrap? : FlexWrap,
    flex_basis? : Val,
    aspect_ratio? : Double?,
    scrollbar_width? : Double,
    grid_template_rows? : Array[GridTrack],
    grid_template_columns? : Array[GridTrack],
    grid_auto_rows? : Array[GridTrack],
    grid_auto_columns? : Array[GridTrack],
    grid_auto_flow? : GridAutoFlow,
    grid_row? : GridLine,
    grid_column? : GridLine,
  ) -> Node
} derive(Eq, Debug)

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
  overflow_clip_margin? : OverflowClipMargin = default_overflow_clip_margin(),
  flex_grow? : Double = 0.0,
  flex_shrink? : Double = 1.0,
  active? : Bool = true,
  align_content? : AlignContent? = None,
  align_self? : AlignItems? = None,
  justify_items? : AlignItems? = None,
  justify_self? : AlignItems? = None,
  flex_wrap? : FlexWrap = NoWrap,
  flex_basis? : Val = Auto,
  aspect_ratio? : Double? = None,
  scrollbar_width? : Double = 0.0,
  grid_template_rows? : Array[GridTrack] = [],
  grid_template_columns? : Array[GridTrack] = [],
  grid_auto_rows? : Array[GridTrack] = [],
  grid_auto_columns? : Array[GridTrack] = [],
  grid_auto_flow? : GridAutoFlow = Row,
  grid_row? : GridLine = GridLine::new(),
  grid_column? : GridLine = GridLine::new(),
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
    align_content,
    align_self,
    justify_items,
    justify_self,
    row_gap,
    column_gap,
    overflow_x,
    overflow_y,
    overflow_clip_margin,
    flex_wrap,
    flex_basis,
    flex_grow,
    flex_shrink,
    aspect_ratio,
    scrollbar_width,
    grid_template_rows,
    grid_template_columns,
    grid_auto_rows,
    grid_auto_columns,
    grid_auto_flow,
    grid_row,
    grid_column,
    active,
  }
}

///|
pub fn Node::absolute(
  offset : @math.Vec2,
  size? : @math.Vec2 = @math.Vec2(-1.0, -1.0),
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
  overflow_clip_margin? : OverflowClipMargin = default_overflow_clip_margin(),
  active? : Bool = true,
) -> Node {
  let (width, height) = if size[X] >= 0.0 && size[Y] >= 0.0 {
    (Val::Px(size[X]), Val::Px(size[Y]))
  } else {
    (Val::Auto, Val::Auto)
  }
  Node::new(
    width~,
    height~,
    left=Val::Px(offset[X]),
    top=Val::Px(offset[Y]),
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
    overflow_clip_margin~,
    active~,
  )
}

///|
pub(all) struct ComputedUiNode {
  position : @math.Vec2
  size : @math.Vec2
  content_position : @math.Vec2
  content_size : @math.Vec2
  border : UiInsets
  padding : UiInsets
}

///|
pub(all) struct GlobalUiNode {
  logical_rect : @math.Rect
  screen_rect : @math.Rect
  logical_content_rect : @math.Rect
  screen_content_rect : @math.Rect
  target_camera : @entity.Entity?
  target_viewport : @math.Rect
}

///|
pub(all) struct UiTargetCamera {
  camera : @entity.Entity

  fn new(camera : @entity.Entity) -> UiTargetCamera
} derive(Eq, Debug)

///|
pub fn UiTargetCamera::new(camera : @entity.Entity) -> UiTargetCamera {
  { camera, }
}

///|
pub(all) struct UiLayoutSpace {
  target_camera : @entity.Entity?
  viewport : @math.Rect

  fn new(
    viewport : @math.Rect,
    target_camera? : @entity.Entity?,
  ) -> UiLayoutSpace
}

///|
pub fn UiLayoutSpace::new(
  viewport : @math.Rect,
  target_camera? : @entity.Entity? = None,
) -> UiLayoutSpace {
  { target_camera, viewport }
}

///|
pub(all) struct CalculatedClip {
  clip : @math.Rect

  fn new(clip : @math.Rect) -> CalculatedClip
}

///|
pub fn CalculatedClip::new(clip : @math.Rect) -> CalculatedClip {
  { clip, }
}

///|
pub(all) struct LayoutConfig {
  use_rounding : Bool

  fn new(use_rounding? : Bool) -> LayoutConfig
} derive(Eq, Debug)

///|
pub fn LayoutConfig::new(use_rounding? : Bool = true) -> LayoutConfig {
  { use_rounding, }
}

///|
pub(all) struct ZIndex {
  value : Int

  fn new(value : Int) -> ZIndex
} derive(Eq, Debug)

///|
pub fn ZIndex::new(value : Int) -> ZIndex {
  { value, }
}

///|
pub(all) struct GlobalZIndex {
  value : Int

  fn new(value : Int) -> GlobalZIndex
} derive(Eq, Debug)

///|
pub fn GlobalZIndex::new(value : Int) -> GlobalZIndex {
  { value, }
}

///|
pub(all) struct ScrollPosition {
  mut x : Double
  mut y : Double
} derive(Eq, Debug)

///|
pub fn ScrollPosition::zero() -> ScrollPosition {
  { x: 0.0, y: 0.0 }
}

///|
pub(all) struct TabIndex {
  value : Int

  fn new(value : Int) -> TabIndex
} derive(Eq, Debug)

///|
pub fn TabIndex::new(value : Int) -> TabIndex {
  { value, }
}

///|
pub(all) enum FocusPolicy {
  Block
  Pass
} derive(Eq, Debug)

///|
pub(all) struct Focused {
  _tag : Unit

  fn new() -> Focused
}

///|
pub fn Focused::new() -> Focused {
  { _tag: () }
}

///|
pub(all) struct Focusable {
  _tag : Unit

  fn new() -> Focusable
}

///|
pub fn Focusable::new() -> Focusable {
  { _tag: () }
}

///|
pub(all) struct OverrideClip {
  _tag : Unit

  fn new() -> OverrideClip
} derive(Eq, Debug)

///|
pub fn OverrideClip::new() -> OverrideClip {
  { _tag: () }
}

///|
pub(all) struct RelativeCursorPosition {
  mut normalized : @math.Vec2?
  mut cursor_over : Bool

  fn new() -> RelativeCursorPosition
} derive(Eq, Debug)

///|
pub fn RelativeCursorPosition::new() -> RelativeCursorPosition {
  { normalized: None, cursor_over: false }
}

///|
pub fn RelativeCursorPosition::mouse_over(
  self : RelativeCursorPosition,
) -> Bool {
  self.cursor_over
}

///|
priv struct UiModelWorldStore {
  nodes : Map[@entity.Entity, Node]
  computed_ui_nodes : Map[@entity.Entity, ComputedUiNode]
  global_ui_nodes : Map[@entity.Entity, GlobalUiNode]
  ui_target_cameras : Map[@entity.Entity, UiTargetCamera]
  calculated_clips : Map[@entity.Entity, CalculatedClip]
  layout_configs : Map[@entity.Entity, LayoutConfig]
  z_indexes : Map[@entity.Entity, ZIndex]
  global_zindexes : Map[@entity.Entity, GlobalZIndex]
  scroll_positions : Map[@entity.Entity, ScrollPosition]
  tab_indexes : Map[@entity.Entity, TabIndex]
  focus_policies : Map[@entity.Entity, FocusPolicy]
  focusables : Map[@entity.Entity, Focusable]
  focuseds : Map[@entity.Entity, Focused]
  override_clips : Map[@entity.Entity, OverrideClip]
  relative_cursor_positions : Map[@entity.Entity, RelativeCursorPosition]
  tree_orders : Map[@entity.Entity, Int]
}

///|
let ui_model_world_stores : Map[UInt, UiModelWorldStore] = Map::new()

///|
fn ui_model_world_store() -> UiModelWorldStore {
  let world_id = @ecs.require_current_world().id()
  ui_model_world_stores.get_or_init(world_id, () => {
    nodes: Map::new(),
    computed_ui_nodes: Map::new(),
    global_ui_nodes: Map::new(),
    ui_target_cameras: Map::new(),
    calculated_clips: Map::new(),
    layout_configs: Map::new(),
    z_indexes: Map::new(),
    global_zindexes: Map::new(),
    scroll_positions: Map::new(),
    tab_indexes: Map::new(),
    focus_policies: Map::new(),
    focusables: Map::new(),
    focuseds: Map::new(),
    override_clips: Map::new(),
    relative_cursor_positions: Map::new(),
    tree_orders: Map::new(),
  })
}

///|
pub fn nodes() -> Map[@entity.Entity, Node] {
  ui_model_world_store().nodes
}

///|
pub fn computed_ui_nodes() -> Map[@entity.Entity, ComputedUiNode] {
  ui_model_world_store().computed_ui_nodes
}

///|
pub fn global_ui_nodes() -> Map[@entity.Entity, GlobalUiNode] {
  ui_model_world_store().global_ui_nodes
}

///|
pub fn ui_target_cameras() -> Map[@entity.Entity, UiTargetCamera] {
  ui_model_world_store().ui_target_cameras
}

///|
pub fn calculated_clips() -> Map[@entity.Entity, CalculatedClip] {
  ui_model_world_store().calculated_clips
}

///|
pub fn layout_configs() -> Map[@entity.Entity, LayoutConfig] {
  ui_model_world_store().layout_configs
}

///|
pub fn z_indexes() -> Map[@entity.Entity, ZIndex] {
  ui_model_world_store().z_indexes
}

///|
pub fn global_zindexes() -> Map[@entity.Entity, GlobalZIndex] {
  ui_model_world_store().global_zindexes
}

///|
pub fn scroll_positions() -> Map[@entity.Entity, ScrollPosition] {
  ui_model_world_store().scroll_positions
}

///|
pub fn tab_indexes() -> Map[@entity.Entity, TabIndex] {
  ui_model_world_store().tab_indexes
}

///|
pub fn focus_policies() -> Map[@entity.Entity, FocusPolicy] {
  ui_model_world_store().focus_policies
}

///|
pub fn focusables() -> Map[@entity.Entity, Focusable] {
  ui_model_world_store().focusables
}

///|
pub fn focuseds() -> Map[@entity.Entity, Focused] {
  ui_model_world_store().focuseds
}

///|
pub fn override_clips() -> Map[@entity.Entity, OverrideClip] {
  ui_model_world_store().override_clips
}

///|
pub fn relative_cursor_positions() -> Map[
  @entity.Entity,
  RelativeCursorPosition,
] {
  ui_model_world_store().relative_cursor_positions
}

///|
fn tree_orders() -> Map[@entity.Entity, Int] {
  ui_model_world_store().tree_orders
}

///|
fn global_zindex_value(entity : @entity.Entity) -> Int {
  global_zindexes().get(entity).map(fn(value) { value.value }).unwrap_or(0)
}

///|
fn zindex_value(entity : @entity.Entity) -> Int {
  z_indexes().get(entity).map(fn(value) { value.value }).unwrap_or(0)
}

///|
fn compare_ui_stacking(lhs : @entity.Entity, rhs : @entity.Entity) -> Int {
  let lg = global_zindex_value(lhs)
  let rg = global_zindex_value(rhs)
  if lg != rg {
    return lg - rg
  }
  let lz = zindex_value(lhs)
  let rz = zindex_value(rhs)
  if lz != rz {
    return lz - rz
  }
  let lt = tree_orders().get(lhs).unwrap_or(0)
  let rt = tree_orders().get(rhs).unwrap_or(0)
  if lt != rt {
    lt - rt
  } else {
    lhs.hash().compare(rhs.hash())
  }
}

///|
fn compare_ui_root_order(lhs : @entity.Entity, rhs : @entity.Entity) -> Int {
  let lg = global_zindex_value(lhs)
  let rg = global_zindex_value(rhs)
  if lg != rg {
    return lg - rg
  }
  let lz = zindex_value(lhs)
  let rz = zindex_value(rhs)
  if lz != rz {
    lz - rz
  } else {
    lhs.hash().compare(rhs.hash())
  }
}

///|
pub fn is_ui_entity(entity : @entity.Entity) -> Bool {
  nodes().contains(entity)
}

///|
fn full_screen_ui_viewport() -> @math.Rect {
  { position: @math.Vec2::zero(), size: @system.get_screen_size() }
}

///|
pub fn ui_layout_space(target_camera : @entity.Entity?) -> UiLayoutSpace {
  match target_camera {
    Some(target_camera) => {
      if !@transform.global_transforms().contains(target_camera) {
        return UiLayoutSpace::new(full_screen_ui_viewport())
      }
      for view in @camera.active_camera2d_views() {
        if view.entity == target_camera {
          return UiLayoutSpace::new(
            view.viewport,
            target_camera=Some(view.entity),
          )
        }
      }
      UiLayoutSpace::new(full_screen_ui_viewport())
    }
    None => UiLayoutSpace::new(full_screen_ui_viewport())
  }
}

///|
pub fn ui_layout_root_size(space : UiLayoutSpace) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => space.viewport.size
    Viewport => @system.unscale_vec2(space.viewport.size)
  }
}

///|
pub fn logical_to_screen_point(
  point : @math.Vec2,
  space : UiLayoutSpace,
) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => space.viewport.position + point
    Viewport => space.viewport.position + @system.ui_virtual_to_screen(point)
  }
}

///|
pub fn logical_to_screen_size(
  size : @math.Vec2,
  _space : UiLayoutSpace,
) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => size
    Viewport => @system.scale_vec2(size)
  }
}

///|
pub fn to_screen_rect(rect : @math.Rect, space : UiLayoutSpace) -> @math.Rect {
  {
    position: logical_to_screen_point(rect.position, space),
    size: logical_to_screen_size(rect.size, space),
  }
}

///|
fn top_level_ui_nodes() -> Array[@entity.Entity] {
  let roots : Array[@entity.Entity] = []
  for entity, node in nodes() {
    guard entity.is_alive() else { continue }
    guard node.active && node.display != None else { continue }
    match entity.get_parent() {
      Some(parent) => if !nodes().contains(parent) { roots.push(entity) }
      None => roots.push(entity)
    }
  }
  roots.sort_by(compare_ui_root_order)
  roots
}

///|
fn ui_children(entity : @entity.Entity) -> Array[@entity.Entity] {
  let children : Array[@entity.Entity] = []
  for child in entity.get_children() {
    if child.is_alive() && nodes().contains(child) {
      children.push(child)
    }
  }
  children
}
