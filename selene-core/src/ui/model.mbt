///|
#derive(Eq, Debug)
pub(all) enum UiScaleMode {
  Screen
  Viewport
}

///|
pub extend UiScaleMode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiScaleMode with Eq::{not_equal, equal}

///|
let ui_scale_mode_key : @ecs.ResourceKey[UiScaleMode] = ResourceKey()

///|
fn ui_scale_mode() -> UiScaleMode {
  ui_scale_mode_key.get_or_insert_with(@ecs.require_current_world(), _ => Screen)
}

///|
pub fn set_ui_scale_mode(mode : UiScaleMode) -> Unit {
  ui_scale_mode_key.insert_in(@ecs.require_current_world(), mode)
}

///|
pub fn get_ui_scale_mode() -> UiScaleMode {
  ui_scale_mode()
}

///|
#derive(Eq, Debug)
pub(all) enum Val {
  Auto
  Px(Double)
  Percent(Double)
}

///|
pub extend Val with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Val with Eq::{not_equal, equal}

///|
pub fn Val::px(value : Double) -> Val {
  Px(value)
}

///|
pub fn Val::percent(value : Double) -> Val {
  Percent(value)
}

///|
#derive(Eq, Debug)
pub(all) struct UiRectValues {
  left : Val
  right : Val
  top : Val
  bottom : Val
}

///|
pub extend UiRectValues with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiRectValues with Eq::{not_equal, equal}

///|
pub fn UiRectValues::all(value : Double) -> UiRectValues {
  let px = Val::px(value)
  { left: px, right: px, top: px, bottom: px, }
}

///|
pub fn UiRectValues::UiRectValues(
  left~ : Val = Auto,
  right~ : Val = Auto,
  top~ : Val = Auto,
  bottom~ : Val = Auto,
) -> UiRectValues {
  { left, right, top, bottom, }
}

///|
pub fn UiRectValues::px(
  left~ : Double = 0.0,
  right~ : Double = left,
  top~ : Double = left,
  bottom~ : Double = top,
) -> UiRectValues {
  { left: Px(left), right: Px(right), top: Px(top), bottom: Px(bottom), }
}

///|
#derive(Eq, Debug)
pub(all) struct UiInsets {
  left : Double
  right : Double
  top : Double
  bottom : Double
}

///|
pub extend UiInsets with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiInsets with Eq::{not_equal, equal}

///|
pub fn UiInsets::zero() -> UiInsets {
  { left: 0.0, right: 0.0, top: 0.0, bottom: 0.0, }
}

///|
#derive(Eq, Debug)
pub(all) enum Display {
  Block
  Flex
  Grid
  None
}

///|
pub extend Display with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Display with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum PositionType {
  Relative
  Absolute
}

///|
pub extend PositionType with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PositionType with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum FlexDirection {
  Row
  RowReverse
  Column
  ColumnReverse
}

///|
pub extend FlexDirection with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FlexDirection with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
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
}

///|
pub extend JustifyContent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend JustifyContent with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum AlignItems {
  Start
  End
  FlexStart
  FlexEnd
  Center
  Baseline
  Stretch
}

///|
pub extend AlignItems with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AlignItems with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
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
}

///|
pub extend AlignContent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AlignContent with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum FlexWrap {
  NoWrap
  Wrap
  WrapReverse
}

///|
pub extend FlexWrap with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FlexWrap with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum GridAutoFlow {
  Row
  Column
  RowDense
  ColumnDense
}

///|
pub extend GridAutoFlow with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GridAutoFlow with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum GridPlacement {
  Auto
  Line(Int32)
  Span(Int32)
}

///|
pub extend GridPlacement with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GridPlacement with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct GridLine {
  start : GridPlacement
  end : GridPlacement
}

///|
pub extend GridLine with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GridLine with Eq::{not_equal, equal}

///|
pub fn GridLine::GridLine(
  start~ : GridPlacement = Auto,
  end~ : GridPlacement = Auto,
) -> GridLine {
  { start, end, }
}

///|
#derive(Eq, Debug)
pub(all) enum GridTrackRepetition {
  Count(Int32)
  AutoFill
  AutoFit
}

///|
pub extend GridTrackRepetition with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GridTrackRepetition with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
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
}

///|
pub extend GridTrack with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GridTrack with Eq::{not_equal, equal}

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
pub fn grid_repeat_count(value : Int32) -> GridTrackRepetition {
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
pub fn grid_line_index(value : Int32) -> GridPlacement {
  Line(value)
}

///|
pub fn grid_span(value : Int32) -> GridPlacement {
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
#derive(Eq, Debug)
pub(all) enum Overflow {
  Visible
  Clip
  Hidden
  Scroll
}

///|
pub extend Overflow with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Overflow with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum OverflowClipBox {
  ContentBox
  PaddingBox
  BorderBox
}

///|
pub extend OverflowClipBox with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend OverflowClipBox with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct OverflowClipMargin {
  visual_box : OverflowClipBox
  margin : Double
}

///|
pub extend OverflowClipMargin with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend OverflowClipMargin with Eq::{not_equal, equal}

///|
pub fn OverflowClipMargin::content_box() -> OverflowClipMargin {
  { visual_box: ContentBox, margin: 0.0, }
}

///|
pub fn OverflowClipMargin::padding_box() -> OverflowClipMargin {
  { visual_box: PaddingBox, margin: 0.0, }
}

///|
pub fn OverflowClipMargin::border_box() -> OverflowClipMargin {
  { visual_box: BorderBox, margin: 0.0, }
}

///|
pub fn OverflowClipMargin::with_margin(
  self : OverflowClipMargin,
  margin : Double,
) -> OverflowClipMargin {
  { ..self, margin: @cmp.maximum(0.0, margin), }
}

///|
#derive(Eq, Debug)
#selene.component
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
}

///|
pub extend Node with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Node with Eq::{not_equal, equal}

///|
pub fn Node::Node(
  width~ : Val = Auto,
  height~ : Val = Auto,
  min_width~ : Val = Auto,
  min_height~ : Val = Auto,
  max_width~ : Val = Auto,
  max_height~ : Val = Auto,
  left~ : Val = Auto,
  right~ : Val = Auto,
  top~ : Val = Auto,
  bottom~ : Val = Auto,
  margin~ : UiRectValues = UiRectValues::all(0.0),
  padding~ : UiRectValues = UiRectValues::all(0.0),
  border~ : UiRectValues = UiRectValues::all(0.0),
  display~ : Display = Flex,
  position_type~ : PositionType = Relative,
  flex_direction~ : FlexDirection = Column,
  justify_content~ : JustifyContent = Start,
  align_items~ : AlignItems = Stretch,
  row_gap~ : Double = 0.0,
  column_gap~ : Double = 0.0,
  overflow_x~ : Overflow = Visible,
  overflow_y~ : Overflow = Visible,
  overflow_clip_margin~ : OverflowClipMargin = OverflowClipMargin::content_box(),
  flex_grow~ : Double = 0.0,
  flex_shrink~ : Double = 1.0,
  active~ : Bool = true,
  align_content~ : AlignContent? = None,
  align_self~ : AlignItems? = None,
  justify_items~ : AlignItems? = None,
  justify_self~ : AlignItems? = None,
  flex_wrap~ : FlexWrap = NoWrap,
  flex_basis~ : Val = Auto,
  aspect_ratio~ : Double? = None,
  scrollbar_width~ : Double = 0.0,
  grid_template_rows~ : Array[GridTrack] = [],
  grid_template_columns~ : Array[GridTrack] = [],
  grid_auto_rows~ : Array[GridTrack] = [],
  grid_auto_columns~ : Array[GridTrack] = [],
  grid_auto_flow~ : GridAutoFlow = Row,
  grid_row~ : GridLine = GridLine(),
  grid_column~ : GridLine = GridLine(),
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
  size~ : @math.Vec2 = Vec2(-1.0, -1.0),
  padding~ : UiRectValues = UiRectValues::all(0.0),
  border~ : UiRectValues = UiRectValues::all(0.0),
  display~ : Display = Flex,
  flex_direction~ : FlexDirection = Column,
  justify_content~ : JustifyContent = Start,
  align_items~ : AlignItems = Stretch,
  row_gap~ : Double = 0.0,
  column_gap~ : Double = 0.0,
  overflow_x~ : Overflow = Visible,
  overflow_y~ : Overflow = Visible,
  overflow_clip_margin~ : OverflowClipMargin = OverflowClipMargin::content_box(),
  active~ : Bool = true,
) -> Node {
  let (width, height) = if size.x >= 0.0 && size.y >= 0.0 {
    (Val::Px(size.x), Val::Px(size.y))
  } else {
    (Auto, Auto)
  }
  Node(
    width~,
    height~,
    left=Px(offset.x),
    top=Px(offset.y),
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
  max_scroll_position : @math.Vec2
  border : UiInsets
  padding : UiInsets
}

///|
pub(all) struct GlobalUiNode {
  logical_rect : @math.Rect
  screen_rect : @math.Rect
  logical_content_rect : @math.Rect
  screen_content_rect : @math.Rect
  target_camera : @ecs.Entity?
  target_viewport : @math.Rect
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct UiTargetCamera {
  camera : @ecs.Entity
}

///|
pub extend UiTargetCamera with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiTargetCamera with Eq::{not_equal, equal}

///|
pub fn UiTargetCamera::UiTargetCamera(camera : @ecs.Entity) -> UiTargetCamera {
  { camera, }
}

///|
pub(all) struct UiLayoutSpace {
  target_camera : @ecs.Entity?
  viewport : @math.Rect
}

///|
pub fn UiLayoutSpace::UiLayoutSpace(
  viewport : @math.Rect,
  target_camera~ : @ecs.Entity? = None,
) -> UiLayoutSpace {
  { target_camera, viewport, }
}

///|
pub(all) struct CalculatedClip {
  clip : @math.Rect
}

///|
pub fn CalculatedClip::CalculatedClip(clip : @math.Rect) -> CalculatedClip {
  { clip, }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct LayoutConfig {
  use_rounding : Bool
}

///|
pub extend LayoutConfig with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend LayoutConfig with Eq::{not_equal, equal}

///|
pub fn LayoutConfig::LayoutConfig(use_rounding~ : Bool = true) -> LayoutConfig {
  { use_rounding, }
}

///|
/// Orders sibling UI nodes while keeping each sibling's ordinary descendant
/// subtree contiguous in the final UI stack.
#derive(Eq, Debug)
#selene.component
pub(all) struct ZIndex {
  value : Int32
}

///|
pub extend ZIndex with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ZIndex with Eq::{not_equal, equal}

///|
pub fn ZIndex::ZIndex(value : Int32) -> ZIndex {
  { value, }
}

///|
/// Lifts a UI node and its ordinary descendants into the global UI root order.
/// A descendant with its own `GlobalZIndex` becomes another global root.
#derive(Eq, Debug)
#selene.component
pub(all) struct GlobalZIndex {
  value : Int32
}

///|
pub extend GlobalZIndex with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend GlobalZIndex with Eq::{not_equal, equal}

///|
pub fn GlobalZIndex::GlobalZIndex(value : Int32) -> GlobalZIndex {
  { value, }
}

///|
#derive(Eq, Debug)
pub(all) struct ScrollPosition {
  mut x : Double
  mut y : Double
}

///|
pub extend ScrollPosition with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ScrollPosition with Eq::{not_equal, equal}

///|
pub fn ScrollPosition::zero() -> ScrollPosition {
  { x: 0.0, y: 0.0, }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct TabIndex {
  value : Int32
}

///|
pub extend TabIndex with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TabIndex with Eq::{not_equal, equal}

///|
pub fn TabIndex::TabIndex(value : Int32) -> TabIndex {
  { value, }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) enum FocusPolicy {
  Block
  Pass
}

///|
pub extend FocusPolicy with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FocusPolicy with Eq::{not_equal, equal}

///|
priv struct Focused {
  _tag : Unit
}

///|
fn Focused::Focused() -> Focused {
  { _tag: (), }
}

///|
#selene.component
pub(all) struct Focusable {
  _tag : Unit
}

///|
pub fn Focusable::Focusable() -> Focusable {
  { _tag: (), }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct OverrideClip {
  _tag : Unit
}

///|
pub extend OverrideClip with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend OverrideClip with Eq::{not_equal, equal}

///|
pub fn OverrideClip::OverrideClip() -> OverrideClip {
  { _tag: (), }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct RelativeCursorPosition {
  mut normalized : @math.Vec2?
  mut cursor_over : Bool
}

///|
pub extend RelativeCursorPosition with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RelativeCursorPosition with Eq::{not_equal, equal}

///|
pub fn RelativeCursorPosition::RelativeCursorPosition() -> RelativeCursorPosition {
  { normalized: None, cursor_over: false, }
}

///|
pub fn RelativeCursorPosition::mouse_over(
  self : RelativeCursorPosition,
) -> Bool {
  self.cursor_over
}

///|
priv struct UiModelWorldStore {
  scroll_positions : @ecs.EntityTable[ScrollPosition]
  tree_orders : @ecs.EntityTable[Int32]
  geometry : @ecs.EntityTable[UiGeometry]
  calculated_clips : @ecs.EntityTable[CalculatedClip]
  focuseds : @ecs.EntityTable[Focused]
  interactions : @ecs.EntityTable[Interaction]
  ui_stack_entities : Array[@ecs.Entity]
  extracted_entities : Array[@ecs.Entity]
}

///|
let ui_model_world_store_key : @ecs.ResourceKey[UiModelWorldStore] = ResourceKey()

///|
fn UiModelWorldStore::UiModelWorldStore(
  world : @ecs.World,
) -> UiModelWorldStore {
  {
    scroll_positions: EntityTable(world),
    tree_orders: EntityTable(world),
    geometry: EntityTable(world),
    calculated_clips: EntityTable(world),
    focuseds: EntityTable(world),
    interactions: EntityTable(world),
    ui_stack_entities: [],
    extracted_entities: [],
  }
}

///|
fn ui_model_world_store() -> UiModelWorldStore {
  ui_model_world_store_key.get_or_insert_with(@ecs.require_current_world(), world => {
    UiModelWorldStore(world)
  })
}

///|
priv struct UiGeometry {
  computed : ComputedUiNode
  global : GlobalUiNode
}

///|
fn ui_geometry() -> @ecs.EntityTable[UiGeometry] {
  ui_model_world_store().geometry
}

///|
pub fn computed_ui_node(entity : @ecs.Entity) -> ComputedUiNode? {
  ui_geometry().get(entity).map(geometry => geometry.computed)
}

///|
pub fn global_ui_node(entity : @ecs.Entity) -> GlobalUiNode? {
  ui_geometry().get(entity).map(geometry => geometry.global)
}

///|
fn calculated_clips() -> @ecs.EntityTable[CalculatedClip] {
  ui_model_world_store().calculated_clips
}

///|
fn scroll_positions() -> @ecs.EntityTable[ScrollPosition] {
  ui_model_world_store().scroll_positions
}

///|
fn focuseds() -> @ecs.EntityTable[Focused] {
  ui_model_world_store().focuseds
}

///|
fn tree_orders() -> @ecs.EntityTable[Int32] {
  ui_model_world_store().tree_orders
}

///|
fn ui_stack() -> Array[@ecs.Entity] {
  ui_model_world_store().ui_stack_entities
}

///|
fn global_zindex_value(world~ : @ecs.World, entity : @ecs.Entity) -> Int32 {
  (world.get_component(entity) : GlobalZIndex?)
  .map(fn(value) { value.value })
  .unwrap_or(0)
}

///|
fn zindex_value(world~ : @ecs.World, entity : @ecs.Entity) -> Int32 {
  (world.get_component(entity) : ZIndex?)
  .map(fn(value) { value.value })
  .unwrap_or(0)
}

///|
fn compare_ui_root_order(
  world~ : @ecs.World,
  lhs : @ecs.Entity,
  rhs : @ecs.Entity,
) -> Int32 {
  let lg = global_zindex_value(world~, lhs)
  let rg = global_zindex_value(world~, rhs)
  if lg != rg {
    return lg - rg
  }
  let lz = zindex_value(world~, lhs)
  let rz = zindex_value(world~, rhs)
  if lz != rz {
    lz - rz
  } else {
    lhs.hash().compare(rhs.hash())
  }
}

///|
pub fn is_ui_entity(world~ : @ecs.World, entity : @ecs.Entity) -> Bool {
  let query_node : @ecs.Query[@ecs.Single[Node]] = world.query()
  query_node.contains(entity)
}

///|
fn full_screen_ui_viewport() -> @math.Rect {
  { position: @math.Vec2::zero(), size: @window.get_screen_size(), }
}

///|
pub fn ui_layout_space(
  world~ : @ecs.World,
  target_camera : @ecs.Entity?,
) -> UiLayoutSpace {
  match target_camera {
    Some(target_camera) => {
      if !(@transform.global_transform(world~, target_camera) is Some(_)) {
        return UiLayoutSpace(full_screen_ui_viewport())
      }
      for view in @camera.active_camera2d_views(world~) {
        if view.entity == target_camera {
          return UiLayoutSpace(view.viewport, target_camera=Some(view.entity))
        }
      }
      UiLayoutSpace(full_screen_ui_viewport())
    }
    None => UiLayoutSpace(full_screen_ui_viewport())
  }
}

///|
pub fn ui_layout_root_size(space : UiLayoutSpace) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => space.viewport.size
    Viewport => @window.unscale_vec2(space.viewport.size)
  }
}

///|
pub fn logical_to_screen_point(
  point : @math.Vec2,
  space : UiLayoutSpace,
) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => space.viewport.position + point
    Viewport => space.viewport.position + @window.ui_virtual_to_screen(point)
  }
}

///|
pub fn logical_to_screen_size(
  size : @math.Vec2,
  _space : UiLayoutSpace,
) -> @math.Vec2 {
  match get_ui_scale_mode() {
    Screen => size
    Viewport => @window.scale_vec2(size)
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
fn top_level_ui_nodes(world~ : @ecs.World) -> Array[@ecs.Entity] {
  let query_node : @ecs.Query[@ecs.Single[Node]] = world.query()
  let roots : Array[@ecs.Entity] = []
  for entity, Single(node) in query_node {
    guard entity.is_alive() else { continue }
    guard node.active && node.display != None else { continue }
    match entity.get_parent() {
      Some(parent) => if !query_node.contains(parent) { roots.push(entity) }
      None => roots.push(entity)
    }
  }
  roots.sort_by((a, b) => compare_ui_root_order(world~, a, b))
  roots
}

///|
fn ui_children(world~ : @ecs.World, entity : @ecs.Entity) -> Array[@ecs.Entity] {
  let query_node : @ecs.Query[@ecs.Single[Node]] = world.query()
  let children : Array[@ecs.Entity] = []
  for child in entity.get_children() {
    if child.is_alive() && query_node.contains(child) {
      children.push(child)
    }
  }
  children
}

///|
fn is_stacked_ui_entity(world~ : @ecs.World, entity : @ecs.Entity) -> Bool {
  guard entity.is_alive() &&
    ui_geometry().contains(entity) &&
    (world.get_component(entity) : Node?) is Some(node) else {
    return false
  }
  node.active && node.display != None && @visibility.is_visible(entity)
}

///|
fn compare_ui_stack_root(
  world~ : @ecs.World,
  lhs : @ecs.Entity,
  rhs : @ecs.Entity,
) -> Int32 {
  let global_order = global_zindex_value(world~, lhs).compare(
    global_zindex_value(world~, rhs),
  )
  if global_order != 0 {
    return global_order
  }
  let local_order = zindex_value(world~, lhs).compare(zindex_value(world~, rhs))
  if local_order != 0 {
    return local_order
  }
  let tree_order = tree_orders()
    .get(lhs)
    .unwrap_or(0)
    .compare(tree_orders().get(rhs).unwrap_or(0))
  if tree_order != 0 {
    tree_order
  } else {
    lhs.hash().compare(rhs.hash())
  }
}

///|
fn compare_ui_stack_sibling(
  world~ : @ecs.World,
  lhs : @ecs.Entity,
  rhs : @ecs.Entity,
) -> Int32 {
  let local_order = zindex_value(world~, lhs).compare(zindex_value(world~, rhs))
  if local_order != 0 {
    return local_order
  }
  let tree_order = tree_orders()
    .get(lhs)
    .unwrap_or(0)
    .compare(tree_orders().get(rhs).unwrap_or(0))
  if tree_order != 0 {
    tree_order
  } else {
    lhs.hash().compare(rhs.hash())
  }
}

///|
fn rebuild_ui_stack(world~ : @ecs.World) -> Unit {
  let query_global_z_index : @ecs.Query[@ecs.Single[GlobalZIndex]] = world.query()
  let ordered = ui_stack()
  ordered.clear()
  let roots : Array[@ecs.Entity] = []
  for entity, _ in ui_geometry() {
    guard is_stacked_ui_entity(world~, entity) else { continue }
    let hierarchy_root = match entity.get_parent() {
      Some(parent) => !is_stacked_ui_entity(world~, parent)
      None => true
    }
    if hierarchy_root || query_global_z_index.contains(entity) {
      roots.push(entity)
    }
  }
  roots.sort_by((a, b) => compare_ui_stack_root(world~, a, b))
  let pending : Array[@ecs.Entity] = []
  for root in roots {
    pending.push(root)
    while pending.pop() is Some(entity) {
      ordered.push(entity)
      let children : Array[@ecs.Entity] = []
      for child in ui_children(world~, entity) {
        guard !query_global_z_index.contains(child) else { continue }
        guard is_stacked_ui_entity(world~, child) else { continue }
        children.push(child)
      }
      children.sort_by((a, b) => compare_ui_stack_sibling(world~, a, b))
      let mut index = children.length() - 1
      while index >= 0 {
        pending.push(children[index])
        index -= 1
      }
    }
  }
}

///|
/// Reads the clipping rectangle calculated by the latest UI layout pass.
pub fn calculated_clip(entity : @ecs.Entity) -> CalculatedClip? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  calculated_clips().get(entity)
}

///|
/// Returns a copy of the stored scroll position. Use set_scroll_position to
/// request a change; layout clamps the position to the current scroll bounds.
pub fn scroll_position(entity : @ecs.Entity) -> ScrollPosition? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  scroll_positions().get(entity).map(position => { ..position, })
}

///|
/// Requests a scroll position for a UI node in the active World. The next
/// layout pass clamps it to the node's scroll bounds. Copies the input value.
pub fn set_scroll_position(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  position : ScrollPosition,
) -> Unit {
  let query_node : @ecs.Query[@ecs.Single[Node]] = world.query()
  guard entity.is_valid_in(@ecs.require_current_world()) &&
    query_node.contains(entity) else {
    return
  }
  scroll_positions().set(entity, { ..position, })
}

///|
/// Whether this live entity currently has UI focus. Change focus with focus
/// or blur so the focus state and focus events remain synchronized.
pub fn is_focused(entity : @ecs.Entity) -> Bool {
  entity.is_alive() && focuseds().contains(entity)
}
