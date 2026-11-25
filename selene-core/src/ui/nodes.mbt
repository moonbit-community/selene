///|
/// Component queries and retained UI data used by layout and drawing.
struct UiNodes {
  model : UiModelWorldStore
  layout : UiLayoutRuntime
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
  visibility : @visibility.VisibilityState
  display : @window.Display
  scale_mode : Ref[UiScaleMode]
  cameras : Array[@camera.Camera2dView]
  text : @ecs.Query[@ecs.Single[Text]]
  ui_image : @ecs.Query[@ecs.Single[UiImage]]
  node : @ecs.Query[@ecs.Single[Node]]
  ui_target_camera : @ecs.Query[@ecs.Single[UiTargetCamera]]
  layout_config : @ecs.Query[@ecs.Single[LayoutConfig]]
  override_clip : @ecs.Query[@ecs.Single[OverrideClip]]
  z_index : @ecs.Query[@ecs.Single[ZIndex]]
  global_z_index : @ecs.Query[@ecs.Single[GlobalZIndex]]
  box_shadow : @ecs.Query[@ecs.Single[BoxShadow]]
  border_radius : @ecs.Query[@ecs.Single[BorderRadius]]
  material_node : @ecs.Query[@ecs.Single[MaterialNode]]
  background_color : @ecs.Query[@ecs.Single[BackgroundColor]]
  border_color : @ecs.Query[@ecs.Single[BorderColor]]
  outline : @ecs.Query[@ecs.Single[Outline]]
  text_font : @ecs.Query[@ecs.Single[TextFont]]
  text_color : @ecs.Query[@ecs.Single[TextColor]]
  text_layout : @ecs.Query[@ecs.Single[TextLayout]]
}

///|
pub impl @ecs.SystemParam for UiNodes with fn prepare(world) {
  let nodes : UiNodes = {
    model: ui_model_world_store(world~),
    layout: ui_layout_runtime(world~),
    entities: Entities(world),
    hierarchy: Hierarchy(world),
    visibility: VisibilityState(world),
    display: Display(world),
    scale_mode: ui_scale_mode_key.get_or_insert_with(world, _ => Ref(Screen)),
    cameras: [],
    text: world.query(),
    ui_image: world.query(),
    node: world.query(),
    ui_target_camera: world.query(),
    layout_config: world.query(),
    override_clip: world.query(),
    z_index: world.query(),
    global_z_index: world.query(),
    box_shadow: world.query(),
    border_radius: world.query(),
    material_node: world.query(),
    background_color: world.query(),
    border_color: world.query(),
    outline: world.query(),
    text_font: world.query(),
    text_color: world.query(),
    text_layout: world.query(),
  }
  world => { ..nodes, cameras: @camera.active_camera2d_views(world~), }
}

///|
pub extend UiNodes with @ecs.SystemParam::{prepare}

///|
pub fn UiNodes::UiNodes(world : @ecs.World) -> UiNodes {
  let fetch : (@ecs.World) -> UiNodes = @ecs.SystemParam::prepare(world)
  fetch(world)
}

///|
fn UiNodes::global_node(self : UiNodes, entity : @ecs.Entity) -> GlobalUiNode? {
  self.model.geometry.get(entity).map(value => value.global)
}

///|
fn UiNodes::text_layout(self : UiNodes, entity : @ecs.Entity) -> TextLayout {
  self.text_layout.get(entity).map_or(TextLayout(), value => value.0)
}

///|
fn UiNodes::text_style_for(
  self : UiNodes,
  entity : @ecs.Entity,
) -> @render2d_types.TextStyle2D? {
  guard self.text.contains(entity) else { return None }
  let font = self.text_font.get(entity).map_or(TextFont(), value => value.0)
  let color = self.text_color
    .get(entity)
    .map_or(default_text_color(), value => value.0)
  let layout = self.text_layout(entity)
  Some({
    font: font.font_handle,
    family: font.family,
    size: font.size,
    color: color.color,
    align: layout.align,
    baseline: layout.baseline,
  })
}

///|
fn UiNodes::ui_layout_space(
  self : UiNodes,
  target : @ecs.Entity?,
) -> UiLayoutSpace {
  if target is Some(target) {
    for camera in self.cameras {
      if camera.entity == target {
        return UiLayoutSpace(camera.viewport, target_camera=Some(target))
      }
    }
  }
  UiLayoutSpace({
    position: @math.Vec2::zero(),
    size: self.display.screen_size(),
  })
}

///|
fn UiNodes::layout_root_size(
  self : UiNodes,
  space : UiLayoutSpace,
) -> @math.Vec2 {
  match self.scale_mode.val {
    Screen => space.viewport.size
    Viewport => space.viewport.size.scalar_mul(1.0 / self.display.zoom())
  }
}

///|
fn UiNodes::screen_rect(
  self : UiNodes,
  rect : @math.Rect,
  space : UiLayoutSpace,
) -> @math.Rect {
  let zoom = match self.scale_mode.val {
    Screen => 1.0
    Viewport => self.display.zoom()
  }
  {
    position: space.viewport.position + rect.position.scalar_mul(zoom),
    size: rect.size.scalar_mul(zoom),
  }
}
