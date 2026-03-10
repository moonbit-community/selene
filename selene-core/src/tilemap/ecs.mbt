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
pub fn default_tiled_spawn_settings() -> TiledSpawnSettings {
  {
    position: @math.Vec2D::zero(),
    zindex: 0,
    layer_z_step: 10,
    spawn_hidden_layers: true,
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
  @transform.positions.set(root, settings.position)
  tiled_map_instances.set(root, { map, })
  ignore(spawn_tiled_layers(root, root, map, map.layers, settings, true, 0))
  root
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
    tiled_layer_instances.set(layer_entity, {
      map_entity,
      layer,
      effective_visible,
      zindex: layer_zindex,
    })
    match layer.kind {
      TileLayer(tile_layer) =>
        spawn_tiled_tile_layer(
          map_entity, layer_entity, map, layer, tile_layer, layer_zindex, effective_visible,
        )
      ObjectLayer(object_layer) =>
        spawn_tiled_object_layer(
          map_entity, layer_entity, map, layer, object_layer, layer_zindex, effective_visible,
        )
      GroupLayer(children) =>
        layer_index = spawn_tiled_layers(
          map_entity, layer_entity, map, children, settings, effective_visible, layer_index,
        )
      ImageLayer(image_layer) =>
        spawn_tiled_image_layer(
          map_entity, layer_entity, map, layer, image_layer, layer_zindex, effective_visible,
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
  _layer : TiledLayer,
  tile_layer : TiledTileLayer,
  zindex : Int,
  visible : Bool,
) -> Unit {
  if map.orientation != "orthogonal" {
    return
  }
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
) -> Unit {
  let resolved_image_path = image_layer.image.map(path => map.resolve_path(path))
  tiled_image_layer_instances.set(layer_entity, {
    map_entity,
    layer,
    image_layer,
    resolved_image_path,
  })
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
  let transform = extra_transform * tiled_gid_transform(gid, tile_size)
  if tileset.tile_definition(local_id) is Some(tile) {
    if tile.image is Some(image_path) {
      let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
      return Some(
        @sprite.Animation::single_frame_from_image(
          load_tiled_image(resolved_path),
          tile_size,
          transform~,
        ),
      )
    }
  }
  guard tileset.image is Some(image_path) else { return None }
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
  let source_offset = @math.Vec2D(
    tileset.margin.to_double() +
    column.to_double() * (tile_width + tileset.spacing.to_double()),
    tileset.margin.to_double() +
    row.to_double() * (tile_height + tileset.spacing.to_double()),
  )
  let resolved_path = map.resolve_tileset_asset_path(tileset, image_path)
  Some(
    @sprite.Animation::single_frame_from_image(
      load_tiled_image(resolved_path),
      tile_size,
      transform~,
      offset=source_offset,
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
  @math.Vec2D(
    cell.x.to_double() * map.tile_width.to_double(),
    (cell.y + 1).to_double() * map.tile_height.to_double() - tile_size[Y],
  )
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
  @math.Vec2D(object.x, object.y - size[Y])
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
