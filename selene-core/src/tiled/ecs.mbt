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
fn tiled_ecs_set_entity_translation_2d(
  entity : @entity.Entity,
  position : @math.Vec2D,
) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3::new(
      position[X],
      position[Y],
      current.translation.z,
    ),
  })
}

///|
fn tiled_ecs_set_entity_depth(entity : @entity.Entity, z : Int) -> Unit {
  let current = @transform.transforms().get(entity).unwrap_or_default()
  @transform.transforms().set(entity, {
    ..current,
    translation: @math.Vec3::new(
      current.translation.x,
      current.translation.y,
      z.to_double(),
    ),
  })
}

///|
priv struct TiledSpriteAnimation {
  image : @asset.ImageHandle
  layout : @sprite.TextureAtlasLayoutHandle
  fps : Double
  loop_ : Bool
  color : @render.Color
  custom_size : @math.Vec2D?
  anchor : @sprite.Anchor
}

///|
fn tiled_transform_from_2d_affine(
  affine : @math.Transform,
) -> @transform.Transform {
  let x_axis = @math.Vec3::new(affine.a, affine.b, 0.0)
  let y_axis = @math.Vec3::new(affine.c, affine.d, 0.0)
  let mut scale_x = x_axis.length()
  let mut scale_y = y_axis.length()
  if scale_x <= 0.000000001 {
    scale_x = 1.0
  }
  if scale_y <= 0.000000001 {
    scale_y = 1.0
  }
  let basis_x = x_axis.scalar_div(scale_x)
  let mut basis_y = y_axis.scalar_div(scale_y)
  if basis_x.cross(basis_y).dot(@math.Vec3::z_axis()) < 0.0 {
    scale_y = -scale_y
    basis_y = -basis_y
  }
  {
    translation: @math.Vec3::new(affine.tx, affine.ty, 0.0),
    rotation: @math.Quat::from_basis(basis_x, basis_y, @math.Vec3::z_axis()),
    scale: @math.Vec3::new(scale_x, scale_y, 1.0),
  }
}

///|
fn tiled_sprite_animation_clip_asset(
  animation : TiledSpriteAnimation,
) -> @animation.AnimationClipHandle {
  let clip = @animation.AnimationClip::new("sprite/tiled")
  let layout = @sprite.texture_atlas_layout(animation.layout).unwrap()
  let keys : Array[@animation.ScalarKeyframe] = []
  let frame_duration = if animation.fps <= 0.0 {
    1.0
  } else {
    1.0 / animation.fps
  }
  for index in 0..<layout.rects.length() {
    keys.push({
      time: index.to_double() * frame_duration,
      value: index.to_double(),
      in_tangent: None,
      out_tangent: None,
    })
  }
  clip.add_curve_to_target(
    @animation.AnimationTargetId::new("self"),
    @animation.VariableCurve::scalar(
      @animation.texture_atlas_index_field(),
      keys,
      interpolation=@animation.ChannelInterpolation::Step,
    ),
  )
  if layout.rects.length() > 0 && !animation.loop_ {
    clip.duration = (layout.rects.length() - 1).to_double() * frame_duration
  } else if layout.rects.length() > 0 {
    clip.duration = layout.rects.length().to_double() * frame_duration
  }
  @animation.register_animation_clip_asset(clip)
}

///|
fn tiled_sprite_from_animation(
  animation : TiledSpriteAnimation,
  visible : Bool,
) -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(animation.image),
    texture_atlas=Some(@sprite.TextureAtlas::new(animation.layout)),
    color=animation.color,
    custom_size=animation.custom_size,
    anchor=animation.anchor,
    visible~,
  )
}

///|
fn tiled_install_sprite_animation(
  entity : @entity.Entity,
  animation : TiledSpriteAnimation,
) -> Unit {
  ignore(
    @animation.animation_players().get_or_init(entity, fn() {
      @animation.AnimationPlayer::new()
    }),
  )
  ignore(
    @animation.animation_transitions().get_or_init(entity, fn() {
      @animation.AnimationTransitions::new()
    }),
  )
  @animation.animation_target_ids().set(
    entity,
    @animation.AnimationTargetId::new("self"),
  )
  @animation.animated_bys().set(entity, @animation.AnimatedBy::new(entity))
  let (graph, nodes) = @animation.AnimationGraph::from_clips([
    tiled_sprite_animation_clip_asset(animation),
  ])
  @animation.animation_graph_handles().set(
    entity,
    @animation.register_animation_graph_asset(graph),
  )
  ignore(@animation.animation_players().get(entity).unwrap().play(nodes[0]))
}

///|
pub struct TiledSpawnSettings {
  position : @math.Vec2D
  zindex : Int
  layer_z_step : Int
  spawn_hidden_layers : Bool
  physics_settings : TiledPhysicsSettings?
  map_hook : ((TiledMapSpawnedEvent) -> Unit)?
  layer_hook : ((TiledLayerSpawnedEvent) -> Unit)?
  tile_hook : ((TiledTileSpawnedEvent) -> Unit)?
  object_hook : ((TiledObjectSpawnedEvent) -> Unit)?
  image_layer_hook : ((TiledImageLayerSpawnedEvent) -> Unit)?
}

///|
pub struct TiledMapInstance {
  map : TiledMap
}

///|
pub struct TiledLayerInstance {
  map_entity : @entity.Entity
  layer : TiledLayer
  effective_visible : Bool
  zindex : Int
}

///|
pub struct TiledTileInstance {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  gid : TiledGid
  tileset : TiledTileset
  cell : TiledCell
}

///|
pub struct TiledObjectInstance {
  map_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : TiledLayer
  object : TiledObject
}

///|
pub struct TiledImageLayerInstance {
  map_entity : @entity.Entity
  layer : TiledLayer
  image_layer : TiledImageLayer
  resolved_image_path : String?
}

///|
pub struct TiledProperties {
  values : Map[String, TiledPropertyValue]
}

///|
pub fn TiledProperties::get(
  self : TiledProperties,
  name : String,
) -> TiledPropertyValue? {
  self.values.get(name)
}

///|
pub struct TiledMapStorage {
  layers : Map[Int, @entity.Entity]
  objects : Map[Int, @entity.Entity]
  tiles : Map[Int, Array[@entity.Entity]]
}

///|
pub struct TiledParallaxLayer {
  base_offset : @math.Vec2D
  parallax_x : Double
  parallax_y : Double
}

///|
pub fn empty_tiled_map_storage() -> TiledMapStorage {
  { layers: Map::new(), objects: Map::new(), tiles: Map::new() }
}

///|
pub fn TiledMapStorage::layer_entity(
  self : TiledMapStorage,
  layer_id : Int,
) -> @entity.Entity? {
  self.layers.get(layer_id)
}

///|
pub fn TiledMapStorage::object_entity(
  self : TiledMapStorage,
  object_id : Int,
) -> @entity.Entity? {
  self.objects.get(object_id)
}

///|
pub fn TiledMapStorage::tile_entities(
  self : TiledMapStorage,
  global_tile_id : Int,
) -> Array[@entity.Entity] {
  self.tiles.get(global_tile_id).unwrap_or([])
}

///|
priv struct TiledEcsWorldStore {
  tiled_map_instances : Map[@entity.Entity, TiledMapInstance]
  tiled_layer_instances : Map[@entity.Entity, TiledLayerInstance]
  tiled_tile_instances : Map[@entity.Entity, TiledTileInstance]
  tiled_object_instances : Map[@entity.Entity, TiledObjectInstance]
  tiled_image_layer_instances : Map[@entity.Entity, TiledImageLayerInstance]
  tiled_properties : Map[@entity.Entity, TiledProperties]
  tiled_map_storages : Map[@entity.Entity, TiledMapStorage]
  tiled_parallax_layers : Map[@entity.Entity, TiledParallaxLayer]
}

///|
let tiled_ecs_world_stores : Map[UInt, TiledEcsWorldStore] = Map::new()

///|
fn tiled_ecs_world_store() -> TiledEcsWorldStore {
  let world_id = @ecs.require_current_world().id()
  tiled_ecs_world_stores.get_or_init(world_id, () => {
    tiled_map_instances: Map::new(),
    tiled_layer_instances: Map::new(),
    tiled_tile_instances: Map::new(),
    tiled_object_instances: Map::new(),
    tiled_image_layer_instances: Map::new(),
    tiled_properties: Map::new(),
    tiled_map_storages: Map::new(),
    tiled_parallax_layers: Map::new(),
  })
}

///|
pub fn tiled_map_instances() -> Map[@entity.Entity, TiledMapInstance] {
  tiled_ecs_world_store().tiled_map_instances
}

///|
pub fn tiled_layer_instances() -> Map[@entity.Entity, TiledLayerInstance] {
  tiled_ecs_world_store().tiled_layer_instances
}

///|
pub fn tiled_tile_instances() -> Map[@entity.Entity, TiledTileInstance] {
  tiled_ecs_world_store().tiled_tile_instances
}

///|
pub fn tiled_object_instances() -> Map[@entity.Entity, TiledObjectInstance] {
  tiled_ecs_world_store().tiled_object_instances
}

///|
pub fn tiled_image_layer_instances() -> Map[
  @entity.Entity,
  TiledImageLayerInstance,
] {
  tiled_ecs_world_store().tiled_image_layer_instances
}

///|
pub fn tiled_properties() -> Map[@entity.Entity, TiledProperties] {
  tiled_ecs_world_store().tiled_properties
}

///|
pub fn tiled_map_storages() -> Map[@entity.Entity, TiledMapStorage] {
  tiled_ecs_world_store().tiled_map_storages
}

///|
pub fn tiled_parallax_layers() -> Map[@entity.Entity, TiledParallaxLayer] {
  tiled_ecs_world_store().tiled_parallax_layers
}

///|
pub fn default_tiled_spawn_settings() -> TiledSpawnSettings {
  {
    position: @math.Vec2D::zero(),
    zindex: 0,
    layer_z_step: 10,
    spawn_hidden_layers: true,
    physics_settings: None,
    map_hook: None,
    layer_hook: None,
    tile_hook: None,
    object_hook: None,
    image_layer_hook: None,
  }
}

///|
pub fn load_and_spawn_tiled_map(
  path : String,
  settings? : TiledSpawnSettings = default_tiled_spawn_settings(),
) -> @entity.Entity {
  spawn_tiled_map(load_tiled_map(path), settings~)
}

///|
pub fn spawn_tiled_map(
  map : TiledMap,
  settings? : TiledSpawnSettings = default_tiled_spawn_settings(),
) -> @entity.Entity {
  let root = @entity.Entity::new()
  spawn_tiled_map_root(root, map, settings)
  root
}

///|
pub fn spawn_tiled_map_into_entity(
  root : @entity.Entity,
  map : TiledMap,
  settings? : TiledSpawnSettings = default_tiled_spawn_settings(),
) -> Unit {
  spawn_tiled_map_root(root, map, settings)
}

///|
pub fn respawn_tiled_map_into_entity(
  root : @entity.Entity,
  map : TiledMap,
  settings? : TiledSpawnSettings = default_tiled_spawn_settings(),
) -> Unit {
  clear_tiled_children(root)
  @entity.entity_flush_system(0.0)
  clear_tiled_root_components(root)
  spawn_tiled_map_root(root, map, settings)
}

///|
fn spawn_tiled_map_root(
  root : @entity.Entity,
  map : TiledMap,
  settings : TiledSpawnSettings,
) -> Unit {
  tiled_ecs_set_entity_translation_2d(root, settings.position)
  tiled_map_instances().set(root, { map, })
  tiled_map_storages().set(root, empty_tiled_map_storage())
  tiled_set_properties(root, map.properties)
  let map_event = { map_entity: root, map }
  tiled_map_spawned_event_bus.trigger(map_event, Some(root))
  if settings.map_hook is Some(map_hook) {
    map_hook(map_event)
  }
  ignore(spawn_tiled_layers(root, root, map, map.layers, settings, true, 0))
  if settings.physics_settings is Some(physics_settings) {
    spawn_tiled_map_physics(root, map, physics_settings)
  }
}

///|
fn spawn_tiled_layers(
  map_entity : @entity.Entity,
  parent_entity : @entity.Entity,
  map : TiledMap,
  layers : Array[TiledLayer],
  settings : TiledSpawnSettings,
  inherited_visible : Bool,
  next_layer_index : Int,
) -> Int {
  let mut layer_index = next_layer_index
  for layer in layers {
    let effective_visible = inherited_visible && layer.visible
    if !settings.spawn_hidden_layers && !effective_visible {
      continue
    }
    let layer_zindex = settings.zindex + layer_index * settings.layer_z_step
    layer_index += 1
    let layer_entity = parent_entity.spawn_child()
    tiled_ecs_set_entity_translation_2d(
      layer_entity,
      @math.Vec2D(layer.offset_x, layer.offset_y),
    )
    tiled_register_parallax_layer(layer_entity, layer)
    tiled_layer_instances().set(layer_entity, {
      map_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    })
    tiled_set_properties(layer_entity, layer.properties)
    tiled_register_layer_entity(map_entity, layer.id, layer_entity)
    let layer_event = {
      map_entity,
      layer_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    }
    tiled_layer_spawned_event_bus.trigger(layer_event, Some(layer_entity))
    if settings.layer_hook is Some(layer_hook) {
      layer_hook(layer_event)
    }
    match layer.kind {
      TileLayer(tile_layer) =>
        spawn_tiled_tile_layer(
          map_entity, layer_entity, map, layer, tile_layer, layer_zindex, effective_visible,
          settings,
        )
      ObjectLayer(object_layer) =>
        spawn_tiled_object_layer(
          map_entity, layer_entity, map, layer, object_layer, layer_zindex, effective_visible,
          settings,
        )
      GroupLayer(children) =>
        layer_index = spawn_tiled_layers(
          map_entity, layer_entity, map, children, settings, effective_visible, layer_index,
        )
      ImageLayer(image_layer) =>
        spawn_tiled_image_layer(
          map_entity, layer_entity, map, layer, image_layer, layer_zindex, effective_visible,
          settings,
        )
      Unknown(_) => ()
    }
  }
  layer_index
}

///|
fn spawn_tiled_tile_layer(
  map_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  tile_layer : TiledTileLayer,
  zindex : Int,
  visible : Bool,
  settings : TiledSpawnSettings,
) -> Unit {
  for cell in tile_layer.tile_cells() {
    if cell.gid.is_empty() {
      continue
    }
    guard map.tileset_for_gid(cell.gid.tile_id) is Some(tileset) else {
      continue
    }
    let tile_position = tiled_cell_position(map, tileset, cell)
    let tile_entity = layer_entity.spawn_child()
    let local_transform = tiled_transform_from_2d_affine(
      tiled_gid_transform(cell.gid, tiled_tileset_tile_size(map, tileset)),
    )
    @transform.transforms().set(tile_entity, local_transform)
    tiled_ecs_set_entity_translation_2d(
      tile_entity,
      tile_position +
      @math.Vec2D(local_transform.translation.x, local_transform.translation.y),
    )
    tiled_ecs_set_entity_depth(tile_entity, zindex)
    tiled_tile_instances().set(tile_entity, {
      map_entity,
      layer_entity,
      gid: cell.gid,
      tileset,
      cell,
    })
    tiled_register_tile_entity(map_entity, cell.gid.tile_id, tile_entity)
    tiled_set_tile_properties(tileset, cell.gid, tile_entity)
    let tile_event = {
      map_entity,
      layer_entity,
      tile_entity,
      layer,
      gid: cell.gid,
      tileset,
      cell,
    }
    tiled_tile_spawned_event_bus.trigger(tile_event, Some(tile_entity))
    if settings.tile_hook is Some(tile_hook) {
      tile_hook(tile_event)
    }
    guard build_tiled_tile_animation(map, tileset, cell.gid) is Some(animation) else {
      continue
    }
    @sprite.sprites().set(
      tile_entity,
      tiled_sprite_from_animation(animation, visible),
    )
    if animation.fps > 0.0 &&
      @sprite.texture_atlas_layout(animation.layout).map_or(false, fn(layout) {
        layout.rects.length() > 1
      }) {
      tiled_install_sprite_animation(tile_entity, animation)
    }
  }
}

///|
fn spawn_tiled_object_layer(
  map_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  object_layer : TiledObjectLayer,
  zindex : Int,
  visible : Bool,
  settings : TiledSpawnSettings,
) -> Unit {
  for object in object_layer.objects {
    let object_offset = match object.gid {
      Some(gid) =>
        match map.tileset_for_gid(gid.tile_id) {
          Some(tileset) => tiled_tile_object_position(map, tileset, object)
          None => tiled_plain_object_position(object)
        }
      None => tiled_plain_object_position(object)
    }
    let object_entity = layer_entity.spawn_child()
    tiled_ecs_set_entity_translation_2d(object_entity, object_offset)
    tiled_ecs_set_entity_depth(object_entity, zindex)
    tiled_object_instances().set(object_entity, {
      map_entity,
      layer_entity,
      layer,
      object,
    })
    tiled_set_properties(object_entity, object.properties)
    tiled_register_object_entity(map_entity, object.id, object_entity)
    let object_event = {
      map_entity,
      layer_entity,
      object_entity,
      layer,
      object,
    }
    tiled_object_spawned_event_bus.trigger(object_event, Some(object_entity))
    if settings.object_hook is Some(object_hook) {
      object_hook(object_event)
    }
    guard object.gid is Some(gid) else { continue }
    guard map.tileset_for_gid(gid.tile_id) is Some(tileset) else { continue }
    let object_size = tiled_object_size(map, tileset, object)
    let local_transform = tiled_transform_from_2d_affine(
      tiled_object_rotation_transform(object, object_size) *
      tiled_gid_transform(gid, object_size),
    )
    @transform.transforms().set(object_entity, local_transform)
    tiled_ecs_set_entity_translation_2d(
      object_entity,
      object_offset +
      @math.Vec2D(local_transform.translation.x, local_transform.translation.y),
    )
    guard build_tiled_tile_animation(map, tileset, gid, size=object_size)
      is Some(animation) else {
      continue
    }
    @sprite.sprites().set(
      object_entity,
      tiled_sprite_from_animation(animation, visible && object.visible),
    )
    if animation.fps > 0.0 &&
      @sprite.texture_atlas_layout(animation.layout).map_or(false, fn(layout) {
        layout.rects.length() > 1
      }) {
      tiled_install_sprite_animation(object_entity, animation)
    }
  }
}

///|
fn spawn_tiled_image_layer(
  map_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  image_layer : TiledImageLayer,
  zindex : Int,
  visible : Bool,
  settings : TiledSpawnSettings,
) -> Unit {
  let resolved_image_path = image_layer.image.map(path => map.resolve_path(path))
  tiled_image_layer_instances().set(layer_entity, {
    map_entity,
    layer,
    image_layer,
    resolved_image_path,
  })
  let image_layer_event = {
    map_entity,
    layer_entity,
    layer,
    image_layer,
    resolved_image_path,
  }
  tiled_image_layer_spawned_event_bus.trigger(
    image_layer_event,
    Some(layer_entity),
  )
  if settings.image_layer_hook is Some(image_layer_hook) {
    image_layer_hook(image_layer_event)
  }
  guard resolved_image_path is Some(image_path) else { return }
  tiled_ecs_set_entity_depth(layer_entity, zindex)
  let repeat = tiled_image_repeat_mode(image_layer)
  @sprite.sprites().set(
    layer_entity,
    @sprite.Sprite::new(
      image=Some(load_tiled_image(image_path)),
      custom_size=Some(tiled_map_world_size(map)),
      color=@render.Color::{ r: 255U, g: 255U, b: 255U, a: layer.opacity },
      anchor=@sprite.TopLeft,
      visible~,
      image_mode=@sprite.Tiled(repeat),
    ),
  )
}

///|
fn build_tiled_tile_animation(
  map : TiledMap,
  tileset : TiledTileset,
  gid : TiledGid,
  size? : @math.Vec2D,
) -> TiledSpriteAnimation? {
  let local_id = gid.tile_id - tileset.first_gid
  if local_id < 0 {
    return None
  }
  let tile_size = size.unwrap_or(tiled_tileset_tile_size(map, tileset))
  if tile_size[X] <= 0.0 || tile_size[Y] <= 0.0 {
    return None
  }
  if tileset.tile_definition(local_id) is Some(tile) &&
    tile.animation.length() > 0 {
    let (image, rects, fps) = tiled_animation_frames_from_definition(
      map,
      tileset,
      tile.animation,
      tile_size,
    )
    if rects.length() > 0 && image is Some(image) {
      return Some({
        image,
        layout: @sprite.register_texture_atlas_layout({
          size: tiled_layout_size(rects),
          rects,
        }),
        fps,
        loop_: true,
        color: @render.Color::{ r: 255U, g: 255U, b: 255U, a: 1.0 },
        custom_size: Some(tile_size),
        anchor: @sprite.TopLeft,
      })
    }
  }
  let visuals = tiled_visual_regions_for_local_tile(
    map, tileset, local_id, tile_size,
  )
  if visuals.length() == 0 {
    return None
  }
  let first = visuals[0]
  Some({
    image: first.0,
    layout: @sprite.register_texture_atlas_layout({
      size: tiled_layout_size([first.1]),
      rects: [first.1],
    }),
    fps: 0.0,
    loop_: false,
    color: @render.Color::{ r: 255U, g: 255U, b: 255U, a: 1.0 },
    custom_size: Some(tile_size),
    anchor: @sprite.TopLeft,
  })
}

///|
fn tiled_animation_frames_from_definition(
  map : TiledMap,
  tileset : TiledTileset,
  animation : Array[TiledAnimationFrame],
  frame_size : @math.Vec2D,
) -> (@asset.ImageHandle?, Array[@math.Rect], Double) {
  let visuals : Array[(@asset.ImageHandle, @math.Rect)] = []
  let step_ms = tiled_animation_step_ms(animation)
  for animated_frame in animation {
    let duration_ms = if animated_frame.duration_ms > 0 {
      animated_frame.duration_ms
    } else {
      step_ms
    }
    let repeat_count = if duration_ms <= 0 {
      1
    } else {
      (duration_ms + step_ms - 1) / step_ms
    }
    let visual_frames = tiled_visual_regions_for_local_tile(
      map,
      tileset,
      animated_frame.tile_id,
      frame_size,
    )
    if visual_frames.length() == 0 {
      continue
    }
    let visual = visual_frames[0]
    for _ in 0..<repeat_count {
      visuals.push(visual)
    }
  }
  if visuals.length() == 0 {
    return (None, [], 1000.0 / step_ms.to_double())
  }
  let first_image = visuals[0].0
  let rects : Array[@math.Rect] = []
  for visual in visuals {
    if visual.0 != first_image {
      rects.clear()
      rects.push(visuals[0].1)
      return (Some(first_image), rects, 0.0)
    }
    rects.push(visual.1)
  }
  (Some(first_image), rects, 1000.0 / step_ms.to_double())
}

///|
fn tiled_animation_step_ms(animation : Array[TiledAnimationFrame]) -> Int {
  let mut step_ms = 0
  for frame in animation {
    let duration_ms = if frame.duration_ms > 0 {
      frame.duration_ms
    } else {
      100
    }
    step_ms = if step_ms == 0 {
      duration_ms
    } else {
      tiled_gcd(step_ms, duration_ms)
    }
  }
  if step_ms <= 0 {
    100
  } else {
    step_ms
  }
}

///|
fn tiled_gcd(left : Int, right : Int) -> Int {
  let mut a = left.abs()
  let mut b = right.abs()
  while b != 0 {
    let remainder = a % b
    a = b
    b = remainder
  }
  a
}

///|
fn tiled_visual_regions_for_local_tile(
  map : TiledMap,
  tileset : TiledTileset,
  local_id : Int,
  frame_size : @math.Vec2D,
) -> Array[(@asset.ImageHandle, @math.Rect)] {
  if local_id < 0 || frame_size[X] <= 0.0 || frame_size[Y] <= 0.0 {
    return []
  }
  if tileset.tile_definition(local_id) is Some(tile) {
    if tile.image is Some(image_path) {
      let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
      return [
        (
          load_tiled_image(resolved_path),
          { position: @math.Vec2D::zero(), size: frame_size },
        ),
      ]
    }
  }
  guard tileset.image is Some(image_path) else { return [] }
  guard tiled_tileset_source_offset(map, tileset, local_id)
    is Some(source_offset) else {
    return []
  }
  let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
  [
    (
      load_tiled_image(resolved_path),
      { position: source_offset, size: frame_size },
    ),
  ]
}

///|
fn tiled_layout_size(rects : Array[@math.Rect]) -> @math.Vec2D {
  let mut max_x = 0.0
  let mut max_y = 0.0
  for rect in rects {
    let right = rect.position[X] + rect.size[X]
    let bottom = rect.position[Y] + rect.size[Y]
    if right > max_x {
      max_x = right
    }
    if bottom > max_y {
      max_y = bottom
    }
  }
  @math.Vec2D(max_x, max_y)
}

///|
fn tiled_tileset_source_offset(
  map : TiledMap,
  tileset : TiledTileset,
  local_id : Int,
) -> @math.Vec2D? {
  guard tileset.image is Some(_) else { return None }
  let tile_width = tileset.tile_width.unwrap_or(map.tile_width).to_double()
  let tile_height = tileset.tile_height.unwrap_or(map.tile_height).to_double()
  if tile_width <= 0.0 || tile_height <= 0.0 {
    return None
  }
  let columns = tileset.columns.unwrap_or(1)
  if columns <= 0 {
    return None
  }
  let column = local_id % columns
  let row = local_id / columns
  Some(
    @math.Vec2D(
      tileset.margin.to_double() +
      column.to_double() * (tile_width + tileset.spacing.to_double()),
      tileset.margin.to_double() +
      row.to_double() * (tile_height + tileset.spacing.to_double()),
    ),
  )
}

///|
fn tiled_tileset_tile_size(
  map : TiledMap,
  tileset : TiledTileset,
) -> @math.Vec2D {
  @math.Vec2D(
    tileset.tile_width.unwrap_or(map.tile_width).to_double(),
    tileset.tile_height.unwrap_or(map.tile_height).to_double(),
  )
}

///|
fn tiled_cell_position(
  map : TiledMap,
  tileset : TiledTileset,
  cell : TiledCell,
) -> @math.Vec2D {
  let tile_size = tiled_tileset_tile_size(map, tileset)
  match map.orientation.to_lower() {
    "isometric" => tiled_isometric_cell_position(map, tile_size, cell)
    "hexagonal" => tiled_hexagonal_cell_position(map, tile_size, cell)
    "staggered" => tiled_staggered_cell_position(map, tile_size, cell)
    _ => tiled_orthogonal_cell_position(map, tile_size, cell)
  }
}

///|
fn tiled_orthogonal_cell_position(
  map : TiledMap,
  tile_size : @math.Vec2D,
  cell : TiledCell,
) -> @math.Vec2D {
  @math.Vec2D(
    cell.x.to_double() * map.tile_width.to_double(),
    (cell.y + 1).to_double() * map.tile_height.to_double() - tile_size[Y],
  )
}

///|
fn tiled_isometric_cell_position(
  map : TiledMap,
  tile_size : @math.Vec2D,
  cell : TiledCell,
) -> @math.Vec2D {
  let tile_width = map.tile_width.to_double()
  let tile_height = map.tile_height.to_double()
  let half_width = tile_width / 2.0
  let half_height = tile_height / 2.0
  let origin_x = if map.height > 0 {
    (map.height - 1).to_double() * half_width
  } else {
    0.0
  }
  @math.Vec2D(
    (cell.x - cell.y).to_double() * half_width + origin_x,
    (cell.x + cell.y).to_double() * half_height + tile_height - tile_size[Y],
  )
}

///|
fn tiled_hexagonal_cell_position(
  map : TiledMap,
  tile_size : @math.Vec2D,
  cell : TiledCell,
) -> @math.Vec2D {
  tiled_staggered_layout_cell_position(
    map,
    tile_size,
    cell,
    map.hex_side_length.unwrap_or(0).to_double(),
  )
}

///|
fn tiled_staggered_cell_position(
  map : TiledMap,
  tile_size : @math.Vec2D,
  cell : TiledCell,
) -> @math.Vec2D {
  tiled_staggered_layout_cell_position(map, tile_size, cell, 0.0)
}

///|
fn tiled_staggered_layout_cell_position(
  map : TiledMap,
  tile_size : @math.Vec2D,
  cell : TiledCell,
  side_length : Double,
) -> @math.Vec2D {
  let tile_width = map.tile_width.to_double()
  let tile_height = map.tile_height.to_double()
  let axis = map.stagger_axis.map_or("y", fn(value) { value.to_lower() })
  if axis == "x" {
    let column_step = (tile_width + side_length) / 2.0
    let row_offset = if tiled_is_staggered_index(cell.x, map.stagger_index) {
      tile_height / 2.0
    } else {
      0.0
    }
    return @math.Vec2D(
      cell.x.to_double() * column_step,
      cell.y.to_double() * tile_height + row_offset + tile_height - tile_size[Y],
    )
  }
  let row_step = (tile_height + side_length) / 2.0
  let column_offset = if tiled_is_staggered_index(cell.y, map.stagger_index) {
    tile_width / 2.0
  } else {
    0.0
  }
  @math.Vec2D(
    cell.x.to_double() * tile_width + column_offset,
    cell.y.to_double() * row_step + tile_height - tile_size[Y],
  )
}

///|
fn tiled_is_staggered_index(index : Int, stagger_index : String?) -> Bool {
  let is_even = index.abs() % 2 == 0
  match stagger_index.map_or("odd", fn(value) { value.to_lower() }) {
    "even" => is_even
    _ => !is_even
  }
}

///|
fn tiled_plain_object_position(object : TiledObject) -> @math.Vec2D {
  @math.Vec2D(object.x, object.y)
}

///|
fn tiled_tile_object_position(
  map : TiledMap,
  tileset : TiledTileset,
  object : TiledObject,
) -> @math.Vec2D {
  let size = tiled_object_size(map, tileset, object)
  let origin_x = if map.orientation.to_lower() == "isometric" {
    object.x - size[X] / 2.0
  } else {
    object.x
  }
  @math.Vec2D(origin_x, object.y - size[Y])
}

///|
fn tiled_object_size(
  map : TiledMap,
  tileset : TiledTileset,
  object : TiledObject,
) -> @math.Vec2D {
  let default_size = tiled_tileset_tile_size(map, tileset)
  let width = if object.width > 0.0 { object.width } else { default_size[X] }
  let height = if object.height > 0.0 { object.height } else { default_size[Y] }
  @math.Vec2D(width, height)
}

///|
fn tiled_object_rotation_transform(
  object : TiledObject,
  size : @math.Vec2D,
) -> @math.Transform {
  if object.rotation == 0.0 {
    return @math.Transform::identity()
  }
  @math.Transform::from_translation(0.0, size[Y]) *
  @math.Transform::from_rotation_deg(object.rotation) *
  @math.Transform::from_translation(0.0, -size[Y])
}

///|
fn tiled_gid_transform(gid : TiledGid, size : @math.Vec2D) -> @math.Transform {
  let width = size[X]
  let height = size[Y]
  if width <= 0.0 || height <= 0.0 {
    return @math.Transform::identity()
  }
  let diagonal = if gid.flipped_diagonally {
    @math.Transform::new(a=0.0, b=height / width, c=width / height, d=0.0)
  } else {
    @math.Transform::identity()
  }
  let horizontal = if gid.flipped_horizontally {
    @math.Transform::flip_x(width)
  } else {
    @math.Transform::identity()
  }
  let vertical = if gid.flipped_vertically {
    @math.Transform::flip_y(height)
  } else {
    @math.Transform::identity()
  }
  vertical * horizontal * diagonal
}

///|
fn tiled_image_repeat_mode(image_layer : TiledImageLayer) -> @math.RepeatMode {
  match (image_layer.repeat_x, image_layer.repeat_y) {
    (true, true) => Repeat
    (true, false) => RepeatX
    (false, true) => RepeatY
    _ => NoRepeat
  }
}

///|
fn tiled_map_world_size(map : TiledMap) -> @math.Vec2D {
  @math.Vec2D(
    map.width.to_double() * map.tile_width.to_double(),
    map.height.to_double() * map.tile_height.to_double(),
  )
}

///|
fn load_tiled_image(path : String) -> @asset.ImageHandle {
  let image = @asset2.load_image(path)
  ignore(@asset.image_path(image))
  image
}

///|
pub fn tiled_parallax_system(_delta : Double) -> Unit {
  let camera_view_origin = tiled_camera_view_origin()
  for pair in tiled_parallax_layers().to_array() {
    let layer_entity = pair.0
    if !layer_entity.is_alive() {
      continue
    }
    let data = pair.1
    let offset = data.base_offset +
      @math.Vec2D(
        camera_view_origin[X] * (1.0 - data.parallax_x),
        camera_view_origin[Y] * (1.0 - data.parallax_y),
      )
    tiled_ecs_set_entity_translation_2d(layer_entity, offset)
  }
}

///|
fn tiled_camera_view_origin() -> @math.Vec2D {
  match tiled_ecs_active_camera2d_view() {
    Some((camera, camera_transform, projection)) =>
      camera.viewport_to_world_2d(
        camera_transform,
        projection,
        @math.Vec2D(0.0, 0.0),
      )
    None => @math.Vec2D::zero()
  }
}

///|
fn tiled_entity_global_transform(
  entity : @entity.Entity,
) -> @transform.GlobalTransform? {
  @transform.compute_global_transform(entity)
}

///|
fn tiled_ecs_active_camera2d_view() -> (
  @camera.Camera,
  @transform.GlobalTransform,
  @camera.OrthographicProjection,
)? {
  let mut selected : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
    Int,
  )? = None
  for entity, camera in @camera.cameras() {
    guard entity.is_alive() else { continue }
    guard camera.is_active else { continue }
    guard @camera.camera2ds().contains(entity) else { continue }
    let projection = @camera.orthographic_projections()
      .get(entity)
      .unwrap_or_default()
    guard tiled_entity_global_transform(entity) is Some(global) else {
      continue
    }
    match selected {
      Some((_, _, _, order)) if order >= camera.order => ()
      _ => selected = Some((camera, global, projection, camera.order))
    }
  }
  match selected {
    Some((camera, global, projection, _)) => Some((camera, global, projection))
    None => None
  }
}

///|
fn tiled_set_properties(
  entity : @entity.Entity,
  properties : Array[TiledProperty],
) -> Unit {
  if properties.length() == 0 {
    return
  }
  let values : Map[String, TiledPropertyValue] = Map::new()
  for property in properties {
    values.set(property.name, property.value)
  }
  tiled_properties().set(entity, { values, })
}

///|
fn tiled_register_layer_entity(
  map_entity : @entity.Entity,
  layer_id : Int,
  layer_entity : @entity.Entity,
) -> Unit {
  guard tiled_map_storages().get(map_entity) is Some(storage) else { return }
  storage.layers.set(layer_id, layer_entity)
}

///|
fn tiled_register_object_entity(
  map_entity : @entity.Entity,
  object_id : Int,
  object_entity : @entity.Entity,
) -> Unit {
  guard tiled_map_storages().get(map_entity) is Some(storage) else { return }
  storage.objects.set(object_id, object_entity)
}

///|
fn tiled_register_tile_entity(
  map_entity : @entity.Entity,
  global_tile_id : Int,
  tile_entity : @entity.Entity,
) -> Unit {
  guard global_tile_id > 0 else { return }
  guard tiled_map_storages().get(map_entity) is Some(storage) else { return }
  match storage.tiles.get(global_tile_id) {
    Some(existing) => existing.push(tile_entity)
    None => storage.tiles.set(global_tile_id, [tile_entity])
  }
}

///|
fn tiled_set_tile_properties(
  tileset : TiledTileset,
  gid : TiledGid,
  tile_entity : @entity.Entity,
) -> Unit {
  let local_id = gid.tile_id - tileset.first_gid
  if local_id < 0 {
    return
  }
  guard tileset.tile_definition(local_id) is Some(tile_def) else { return }
  tiled_set_properties(tile_entity, tile_def.properties)
}

///|
fn tiled_register_parallax_layer(
  layer_entity : @entity.Entity,
  layer : TiledLayer,
) -> Unit {
  if layer.parallax_x == 1.0 && layer.parallax_y == 1.0 {
    return
  }
  tiled_parallax_layers().set(layer_entity, {
    base_offset: @math.Vec2D(layer.offset_x, layer.offset_y),
    parallax_x: layer.parallax_x,
    parallax_y: layer.parallax_y,
  })
}
