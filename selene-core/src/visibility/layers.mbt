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
pub fn entity_render_layers(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> RenderLayers {
  (world.get_component(entity) : RenderLayers?).unwrap_or(RenderLayers())
}
