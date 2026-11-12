///|
pub struct AutoTileVisual {
  image_path : String?
  rect : @math.Rect?
  custom_size : @math.Vec2?
  anchor : @sprite.Anchor
}

///|
pub fn AutoTileVisual::AutoTileVisual(
  image_path~ : String? = None,
  rect~ : @math.Rect? = None,
  custom_size~ : @math.Vec2? = None,
  anchor~ : @sprite.Anchor = @sprite.default_anchor(),
) -> AutoTileVisual {
  { image_path, rect, custom_size, anchor, }
}

///|
pub type AutoTileVisualResolver = (AutoTileLayerSource, AutoTileSolvedTile) -> AutoTileVisual?

///|
pub struct AutoTileRuntimeContext {
  visual_resolver : AutoTileVisualResolver?
  z : Double
}

///|
pub fn AutoTileRuntimeContext::AutoTileRuntimeContext(
  visual_resolver~ : AutoTileVisualResolver? = None,
  z~ : Double = 0.0,
) -> AutoTileRuntimeContext {
  { visual_resolver, z, }
}

///|
priv struct RuntimeLayerState {
  source : AutoTileLayerSource
  tile_entities : Map[AutoTileGridPos, @ecs.Entity]
  context : AutoTileRuntimeContext
}

///|
let runtime_layers_key : @ecs.ResourceKey[@ecs.EntityTable[RuntimeLayerState]] = ResourceKey()

///|
fn runtime_layers() -> @ecs.EntityTable[RuntimeLayerState] {
  let world = @ecs.require_current_world()
  runtime_layers_key.get_or_insert_with(world, world => EntityTable(world))
}

///|
fn tile_position(
  source : AutoTileLayerSource,
  x : Int32,
  y : Int32,
) -> @math.Vec2 {
  Vec2(
    source.origin_x + (x.to_double() + 0.5) * source.tile_width,
    source.origin_y + (y.to_double() + 0.5) * source.tile_height,
  )
}

///|
fn apply_tile_visual(
  plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)],
  layer_entity : @ecs.Entity,
  source : AutoTileLayerSource,
  solved : AutoTileSolvedTile,
  context : AutoTileRuntimeContext,
) -> @ecs.Entity? {
  let visual = match context.visual_resolver {
    Some(resolve) => resolve(source, solved)
    None => None
  }
  guard visual is Some(visual) else { return None }
  let position = tile_position(source, solved.x, solved.y)
  let tile_entity = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
    plan,
    (
      Spatial(@transform.Transform::from_xyz(position.x, position.y, context.z)),
      Sprite(
        image=visual.image_path.map(fn(path) { @asset.load_image(path) }),
        rect=visual.rect,
        custom_size=visual.custom_size,
        anchor=visual.anchor,
      ),
    ),
    parent=layer_entity,
  )
  Some(tile_entity)
}

///|
fn destroy_layer_tiles(state : RuntimeLayerState) -> Unit {
  for _, tile_entity in state.tile_entities {
    @ecs.commands(@ecs.require_current_world()).delete(tile_entity)
  }
}

///|
pub fn register_runtime_layer(
  layer_entity : @ecs.Entity,
  source : AutoTileLayerSource,
  context~ : AutoTileRuntimeContext = AutoTileRuntimeContext(),
) -> Unit {
  let world = @ecs.require_current_world()
  guard layer_entity.is_valid_in(@ecs.require_current_world()) else { return }
  let layers = runtime_layers()
  layers.retain((entity, _) => entity.is_valid_in(world))
  if layers.get(layer_entity) is Some(previous) {
    destroy_layer_tiles(previous)
  }
  let state : RuntimeLayerState = { source, tile_entities: Map([]), context, }
  let plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)] = @ecs.commands(
    @ecs.require_current_world(),
  ).prepare_spawn()
  for solved in solve_autotile_layer(source) {
    let key = AutoTileGridPos::{ x: solved.x, y: solved.y, }
    if apply_tile_visual(plan, layer_entity, source, solved, context)
      is Some(tile_entity) {
      state.tile_entities.set(key, tile_entity)
    }
  }
  layers.set(layer_entity, state)
}

///|
fn apply_diff_to_runtime(
  layer_entity : @ecs.Entity,
  state : RuntimeLayerState,
  diff : AutoTileDiff,
) -> RuntimeLayerState {
  let tile_entities : Map[AutoTileGridPos, @ecs.Entity] = Map([])
  for key, value in state.tile_entities {
    tile_entities.set(key, value)
  }
  for removed in diff.removed_tiles {
    let key = AutoTileGridPos::{ x: removed.x, y: removed.y, }
    if tile_entities.get(key) is Some(entity_) {
      @ecs.commands(@ecs.require_current_world()).delete(entity_)
      ignore(tile_entities.remove(key))
    }
  }
  let plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)] = @ecs.commands(
    @ecs.require_current_world(),
  ).prepare_spawn()
  for changed in diff.changed_tiles {
    let key = AutoTileGridPos::{ x: changed.x, y: changed.y, }
    if tile_entities.get(key) is Some(entity_) {
      @ecs.commands(@ecs.require_current_world()).delete(entity_)
      ignore(tile_entities.remove(key))
    }
    if apply_tile_visual(
        plan,
        layer_entity,
        diff.source,
        changed,
        state.context,
      )
      is Some(entity_) {
      tile_entities.set(key, entity_)
    }
  }
  { source: diff.source, tile_entities, context: state.context, }
}

///|
pub fn set_runtime_cell(
  layer_entity : @ecs.Entity,
  x : Int32,
  y : Int32,
  terrain : Int32,
) -> Unit {
  let layers = runtime_layers()
  guard layer_entity.is_valid_in(@ecs.require_current_world()) &&
    layers.get(layer_entity) is Some(state) else {
    return
  }
  let diff = update_cell_and_resolve_diff(state.source, x, y, Some(terrain))
  layers.set(layer_entity, apply_diff_to_runtime(layer_entity, state, diff))
}

///|
pub fn remove_runtime_cell(
  layer_entity : @ecs.Entity,
  x : Int32,
  y : Int32,
) -> Unit {
  let layers = runtime_layers()
  guard layer_entity.is_valid_in(@ecs.require_current_world()) &&
    layers.get(layer_entity) is Some(state) else {
    return
  }
  let diff = update_cell_and_resolve_diff(state.source, x, y, None)
  layers.set(layer_entity, apply_diff_to_runtime(layer_entity, state, diff))
}

///|
pub fn rebuild_runtime_layer(layer_entity : @ecs.Entity) -> Unit {
  let layers = runtime_layers()
  guard layer_entity.is_valid_in(@ecs.require_current_world()) &&
    layers.get(layer_entity) is Some(state) else {
    return
  }
  register_runtime_layer(layer_entity, state.source, context=state.context)
}

///|
pub fn runtime_layer_source(layer_entity : @ecs.Entity) -> AutoTileLayerSource? {
  guard layer_entity.is_valid_in(@ecs.require_current_world()) else { None }
  runtime_layers().get(layer_entity).map(fn(state) { state.source })
}
