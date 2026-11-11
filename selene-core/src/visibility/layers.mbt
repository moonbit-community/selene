///|
#derive(Eq, Debug)
#selene.component
pub(all) struct RenderLayers {
  mask : UInt32
}

///|
pub extend RenderLayers with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RenderLayers with Eq::{not_equal, equal}

///|
pub fn render_layers() -> @ecs.ComponentStore[RenderLayers] {
  @ecs.components()
}

///|
pub fn RenderLayers::RenderLayers() -> RenderLayers {
  { mask: 1U, }
}

///|
pub fn layer(index : UInt32) -> RenderLayers {
  if index >= 63U {
    { mask: 0U, }
  } else {
    { mask: 1U << index.reinterpret_as_int(), }
  }
}

///|
pub fn layers(mask : UInt32) -> RenderLayers {
  { mask, }
}

///|
pub fn matches(lhs : RenderLayers, rhs : RenderLayers) -> Bool {
  (lhs.mask & rhs.mask) != 0U
}

///|
pub fn entity_render_layers(entity : @ecs.Entity) -> RenderLayers {
  render_layers().get(entity).unwrap_or(RenderLayers())
}
