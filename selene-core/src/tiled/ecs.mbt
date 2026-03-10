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
pub let tiled_map_instances : Map[@entity.Entity, TiledMapInstance] = Map::new()

///|
pub let tiled_layer_instances : Map[@entity.Entity, TiledLayerInstance] = Map::new()

///|
pub let tiled_tile_instances : Map[@entity.Entity, TiledTileInstance] = Map::new()

///|
pub let tiled_object_instances : Map[@entity.Entity, TiledObjectInstance] = Map::new()

///|
pub let tiled_image_layer_instances : Map[
  @entity.Entity,
  TiledImageLayerInstance,
] = Map::new()

///|
pub let tiled_properties : Map[@entity.Entity, TiledProperties] = Map::new()

///|
pub let tiled_map_storages : Map[@entity.Entity, TiledMapStorage] = Map::new()

///|
pub let tiled_parallax_layers : Map[@entity.Entity, TiledParallaxLayer] = Map::new()

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
  @transform.positions.set(root, settings.position)
  tiled_map_instances.set(root, { map, })
  tiled_map_storages.set(root, empty_tiled_map_storage())
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
    let layer_entity = parent_entity.spawn_child(
      offset=@math.Vec2D(layer.offset_x, layer.offset_y),
    )
    tiled_register_parallax_layer(layer_entity, layer)
    tiled_layer_instances.set(layer_entity, {
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
    let tile_entity = layer_entity.spawn_child(
      offset=tiled_cell_position(map, tileset, cell),
    )
    tiled_tile_instances.set(tile_entity, {
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
    let sprite = @sprite.Sprite::from_animation(animation, zindex)
    sprite.visible = visible
    @sprite.sprites.set(tile_entity, sprite)
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
    let object_entity = layer_entity.spawn_child(offset=object_offset)
    tiled_object_instances.set(object_entity, {
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
    guard build_tiled_tile_animation(
        map,
        tileset,
        gid,
        size=object_size,
        extra_transform=tiled_object_rotation_transform(object, object_size),
      )
      is Some(animation) else {
      continue
    }
    let sprite = @sprite.Sprite::from_animation(animation, zindex)
    sprite.visible = visible && object.visible
    @sprite.sprites.set(object_entity, sprite)
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
  tiled_image_layer_instances.set(layer_entity, {
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
  let repeat = tiled_image_repeat_mode(image_layer)
  let picture = @sprite.Picture::from_image(
    tiled_map_world_size(map),
    load_tiled_image(image_path),
    repeat~,
    color={ r: 255U, g: 255U, b: 255U, a: layer.opacity },
  )
  let sprite = @sprite.Sprite::from_picture(picture, zindex)
  sprite.visible = visible
  @sprite.sprites.set(layer_entity, sprite)
}

///|
fn build_tiled_tile_animation(
  map : TiledMap,
  tileset : TiledTileset,
  gid : TiledGid,
  size? : @math.Vec2D,
  extra_transform? : @math.Transform = @math.Transform::identity(),
) -> @sprite.Animation? {
  let local_id = gid.tile_id - tileset.first_gid
  if local_id < 0 {
    return None
  }
  let tile_size = size.unwrap_or(tiled_tileset_tile_size(map, tileset))
  if tile_size[X] <= 0.0 || tile_size[Y] <= 0.0 {
    return None
  }
  let transform = extra_transform * tiled_gid_transform(gid, tile_size)
  if tileset.tile_definition(local_id) is Some(tile) &&
    tile.animation.length() > 0 {
    let (frames, fps) = tiled_animation_frames_from_definition(
      map,
      tileset,
      tile.animation,
      tile_size,
    )
    if frames.length() > 0 {
      return Some(@sprite.Animation::new(frames, loop_=true, fps~, transform~))
    }
  }
  let frames = tiled_visual_frames_for_local_tile(
    map, tileset, local_id, tile_size,
  )
  if frames.length() == 0 {
    return None
  }
  Some(@sprite.Animation::new(frames, loop_=false, fps=0.0, transform~))
}

///|
fn tiled_animation_frames_from_definition(
  map : TiledMap,
  tileset : TiledTileset,
  animation : Array[TiledAnimationFrame],
  frame_size : @math.Vec2D,
) -> (Array[@sprite.AnimationFrame], Double) {
  let frames : Array[@sprite.AnimationFrame] = []
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
    let visual_frames = tiled_visual_frames_for_local_tile(
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
      frames.push(visual)
    }
  }
  (frames, 1000.0 / step_ms.to_double())
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
fn tiled_visual_frames_for_local_tile(
  map : TiledMap,
  tileset : TiledTileset,
  local_id : Int,
  frame_size : @math.Vec2D,
) -> Array[@sprite.AnimationFrame] {
  if local_id < 0 || frame_size[X] <= 0.0 || frame_size[Y] <= 0.0 {
    return []
  }
  if tileset.tile_definition(local_id) is Some(tile) {
    if tile.image is Some(image_path) {
      let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
      return @sprite.frames_from_image_atlas(
        load_tiled_image(resolved_path),
        1,
        width=frame_size[X],
        height=frame_size[Y],
      )
    }
  }
  guard tileset.image is Some(image_path) else { return [] }
  guard tiled_tileset_source_offset(map, tileset, local_id)
    is Some(source_offset) else {
    return []
  }
  let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
  @sprite.frames_from_image_atlas(
    load_tiled_image(resolved_path),
    1,
    width=frame_size[X],
    height=frame_size[Y],
    offset=source_offset,
  )
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
  let camera_pos = @camera.get_position()
  for pair in tiled_parallax_layers.to_array() {
    let layer_entity = pair.0
    if !layer_entity.is_alive() {
      continue
    }
    let data = pair.1
    let offset = data.base_offset +
      @math.Vec2D(
        camera_pos[X] * (1.0 - data.parallax_x),
        camera_pos[Y] * (1.0 - data.parallax_y),
      )
    layer_entity.set_offset(offset)
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
  tiled_properties.set(entity, { values, })
}

///|
fn tiled_register_layer_entity(
  map_entity : @entity.Entity,
  layer_id : Int,
  layer_entity : @entity.Entity,
) -> Unit {
  guard tiled_map_storages.get(map_entity) is Some(storage) else { return }
  storage.layers.set(layer_id, layer_entity)
}

///|
fn tiled_register_object_entity(
  map_entity : @entity.Entity,
  object_id : Int,
  object_entity : @entity.Entity,
) -> Unit {
  guard tiled_map_storages.get(map_entity) is Some(storage) else { return }
  storage.objects.set(object_id, object_entity)
}

///|
fn tiled_register_tile_entity(
  map_entity : @entity.Entity,
  global_tile_id : Int,
  tile_entity : @entity.Entity,
) -> Unit {
  guard global_tile_id > 0 else { return }
  guard tiled_map_storages.get(map_entity) is Some(storage) else { return }
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
  tiled_parallax_layers.set(layer_entity, {
    base_offset: @math.Vec2D(layer.offset_x, layer.offset_y),
    parallax_x: layer.parallax_x,
    parallax_y: layer.parallax_y,
  })
}
