///|
#derive(Eq, Debug)
pub(all) enum SortMode2D {
  Depth
  Y
}

///|
pub extend SortMode2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SortMode2D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Sorting2d {
  layer : Int32
  group : Int32
  order : Int32
  mode : SortMode2D
}

///|
pub extend Sorting2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Sorting2d with Eq::{not_equal, equal}

///|
pub fn Sorting2d::Sorting2d(
  layer~ : Int32 = 0,
  group~ : Int32 = 0,
  order~ : Int32 = 0,
  mode~ : SortMode2D = Depth,
) -> Sorting2d {
  { layer, group, order, mode, }
}

///|
pub fn entity_sorting2d(world~ : @ecs.World, entity : @ecs.Entity) -> Sorting2d {
  (world.get_component(entity) : Sorting2d?).unwrap_or(Sorting2d())
}

///|
pub fn sort_depth_for_transform(
  global_transform : @transform.GlobalTransform,
  sorting : Sorting2d,
) -> Double {
  match sorting.mode {
    Depth => global_transform.translation().z
    Y => global_transform.translation().y
  }
}
