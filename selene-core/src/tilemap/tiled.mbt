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
let tiled_gid_flip_horizontal_flag : Int = 0x80000000

///|
let tiled_gid_flip_vertical_flag : Int = 0x40000000

///|
let tiled_gid_flip_diagonal_flag : Int = 0x20000000

///|
let tiled_gid_mask : Int = 0x1fffffff

///|
pub enum TiledPropertyValue {
  None
  String(String)
  Int(Int)
  Float(Double)
  Bool(Bool)
  Color(String)
  File(String)
  Object(Int)
  Custom(Json)
}

///|
pub struct TiledProperty {
  name : String
  value : TiledPropertyValue
}

///|
pub struct TiledGid {
  raw : Int
  tile_id : Int
  flipped_horizontally : Bool
  flipped_vertically : Bool
  flipped_diagonally : Bool
}

///|
pub struct TiledChunk {
  x : Int
  y : Int
  width : Int
  height : Int
  data : Array[TiledGid]
}

///|
pub struct TiledCell {
  x : Int
  y : Int
  gid : TiledGid
}

///|
pub struct TiledTileLayer {
  width : Int
  height : Int
  x : Int
  y : Int
  start_x : Int
  start_y : Int
  encoding : String?
  compression : String?
  data : Array[TiledGid]
  chunks : Array[TiledChunk]
}

///|
pub struct TiledPoint {
  x : Double
  y : Double
}

///|
pub struct TiledText {
  text : String
  wrap : Bool
  color : String?
  bold : Bool
  italic : Bool
  underline : Bool
  strikeout : Bool
  kerning : Bool
  pixel_size : Int?
  font_family : String?
  horizontal_align : String?
  vertical_align : String?
}

///|
pub struct TiledObject {
  id : Int
  name : String
  object_type : String
  class_name : String?
  gid : TiledGid?
  x : Double
  y : Double
  width : Double
  height : Double
  rotation : Double
  visible : Bool
  point : Bool
  ellipse : Bool
  polygon : Array[TiledPoint]
  polyline : Array[TiledPoint]
  text : TiledText?
  properties : Array[TiledProperty]
}

///|
pub struct TiledObjectLayer {
  draw_order : String
  objects : Array[TiledObject]
}

///|
pub struct TiledImageLayer {
  image : String?
  transparent_color : String?
  repeat_x : Bool
  repeat_y : Bool
}

///|
pub struct TiledTileDefinition {
  id : Int
  object_type : String?
  class_name : String?
  image : String?
  probability : Double?
  properties : Array[TiledProperty]
  object_layer : TiledObjectLayer?
}

///|
pub struct TiledTileset {
  first_gid : Int
  source : String?
  name : String?
  class_name : String?
  tile_width : Int?
  tile_height : Int?
  tile_count : Int?
  columns : Int?
  spacing : Int
  margin : Int
  image : String?
  image_width : Int?
  image_height : Int?
  properties : Array[TiledProperty]
  tiles : Array[TiledTileDefinition]
}

///|
pub enum TiledLayerKind {
  TileLayer(TiledTileLayer)
  ObjectLayer(TiledObjectLayer)
  GroupLayer(Array[TiledLayer])
  ImageLayer(TiledImageLayer)
  Unknown(String)
}

///|
pub struct TiledLayer {
  id : Int
  name : String
  layer_type : String
  class_name : String?
  opacity : Double
  visible : Bool
  offset_x : Double
  offset_y : Double
  parallax_x : Double
  parallax_y : Double
  tint_color : String?
  properties : Array[TiledProperty]
  kind : TiledLayerKind
}

///|
pub struct TiledMap {
  width : Int
  height : Int
  tile_width : Int
  tile_height : Int
  infinite : Bool
  orientation : String
  render_order : String
  background_color : String?
  next_layer_id : Int
  next_object_id : Int
  source_path : String?
  layers : Array[TiledLayer]
  tilesets : Array[TiledTileset]
  properties : Array[TiledProperty]
}

///|
pub fn empty_tiled_gid() -> TiledGid {
  {
    raw: 0,
    tile_id: 0,
    flipped_horizontally: false,
    flipped_vertically: false,
    flipped_diagonally: false,
  }
}

///|
pub fn decode_tiled_gid(raw : Int) -> TiledGid {
  if raw <= 0 {
    return empty_tiled_gid()
  }
  {
    raw,
    tile_id: raw & tiled_gid_mask,
    flipped_horizontally: (raw & tiled_gid_flip_horizontal_flag) != 0,
    flipped_vertically: (raw & tiled_gid_flip_vertical_flag) != 0,
    flipped_diagonally: (raw & tiled_gid_flip_diagonal_flag) != 0,
  }
}

///|
pub fn encode_tiled_gid(gid : TiledGid) -> Int {
  let mut raw = gid.tile_id & tiled_gid_mask
  if gid.flipped_horizontally {
    raw = raw | tiled_gid_flip_horizontal_flag
  }
  if gid.flipped_vertically {
    raw = raw | tiled_gid_flip_vertical_flag
  }
  if gid.flipped_diagonally {
    raw = raw | tiled_gid_flip_diagonal_flag
  }
  raw
}

///|
pub fn TiledGid::is_empty(self : TiledGid) -> Bool {
  self.tile_id <= 0
}

///|
pub fn empty_tiled_map() -> TiledMap {
  {
    width: 0,
    height: 0,
    tile_width: 0,
    tile_height: 0,
    infinite: false,
    orientation: "orthogonal",
    render_order: "right-down",
    background_color: None,
    next_layer_id: 0,
    next_object_id: 0,
    source_path: None,
    layers: [],
    tilesets: [],
    properties: [],
  }
}

///|
pub fn load_tiled_map(path : String) -> TiledMap {
  guard @asset.read_bytes(path) is Some(bytes) else { return empty_tiled_map() }
  let source = bytes.to_unchecked_string()
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  match parsed {
    Ok(document) => {
      let map = TiledMap::from_tiled_json(document)
      { ..map, source_path: Some(path) }
    }
    Err(_) => empty_tiled_map()
  }
}

///|
pub fn TiledMap::from_tiled_json(json : Json) -> TiledMap {
  guard json_object(json) is Some(root_object) else { return empty_tiled_map() }
  {
    width: field_int(root_object, "width").unwrap_or(0),
    height: field_int(root_object, "height").unwrap_or(0),
    tile_width: field_int(root_object, "tilewidth").unwrap_or(0),
    tile_height: field_int(root_object, "tileheight").unwrap_or(0),
    infinite: field_bool(root_object, "infinite").unwrap_or(false),
    orientation: field_string(root_object, "orientation").unwrap_or(
      "orthogonal",
    ),
    render_order: field_string(root_object, "renderorder").unwrap_or(
      "right-down",
    ),
    background_color: field_string(root_object, "backgroundcolor"),
    next_layer_id: field_int(root_object, "nextlayerid").unwrap_or(0),
    next_object_id: field_int(root_object, "nextobjectid").unwrap_or(0),
    source_path: None,
    layers: parse_layers(field_json(root_object, "layers")),
    tilesets: parse_tilesets(field_json(root_object, "tilesets")),
    properties: parse_properties(field_json(root_object, "properties")),
  }
}

///|
pub fn TiledMap::resolve_path(self : TiledMap, path : String) -> String {
  if is_absolute_path(path) {
    path
  } else {
    match self.source_path {
      Some(source_path) => resolve_relative_asset_path(source_path, path)
      None => path
    }
  }
}

///|
pub fn TiledMap::layer(self : TiledMap, name : String) -> TiledLayer? {
  for layer in self.layers {
    if layer.name == name {
      return Some(layer)
    }
  }
  None
}

///|
pub fn TiledMap::layer_by_id(self : TiledMap, id : Int) -> TiledLayer? {
  for layer in self.layers {
    if layer.id == id {
      return Some(layer)
    }
  }
  None
}

///|
pub fn TiledMap::tile_layer(self : TiledMap, name : String) -> TiledTileLayer? {
  guard self.layer(name) is Some(layer) else { return None }
  match layer.kind {
    TileLayer(tile_layer) => Some(tile_layer)
    _ => None
  }
}

///|
pub fn TiledMap::object_layer(
  self : TiledMap,
  name : String,
) -> TiledObjectLayer? {
  guard self.layer(name) is Some(layer) else { return None }
  match layer.kind {
    ObjectLayer(object_layer) => Some(object_layer)
    _ => None
  }
}

///|
pub fn TiledMap::tileset_for_gid(
  self : TiledMap,
  global_gid : Int,
) -> TiledTileset? {
  if global_gid <= 0 {
    return None
  }
  let mut selected : TiledTileset? = None
  let mut selected_first_gid = -1
  for tileset in self.tilesets {
    if tileset.first_gid <= global_gid &&
      tileset.first_gid >= selected_first_gid {
      selected = Some(tileset)
      selected_first_gid = tileset.first_gid
    }
  }
  selected
}

///|
pub fn TiledMap::property(
  self : TiledMap,
  name : String,
) -> TiledPropertyValue? {
  find_property_value(self.properties, name)
}

///|
pub fn TiledLayer::property(
  self : TiledLayer,
  name : String,
) -> TiledPropertyValue? {
  find_property_value(self.properties, name)
}

///|
pub fn TiledObject::property(
  self : TiledObject,
  name : String,
) -> TiledPropertyValue? {
  find_property_value(self.properties, name)
}

///|
pub fn TiledTileset::property(
  self : TiledTileset,
  name : String,
) -> TiledPropertyValue? {
  find_property_value(self.properties, name)
}

///|
pub fn TiledObjectLayer::object(
  self : TiledObjectLayer,
  name : String,
) -> TiledObject? {
  for object in self.objects {
    if object.name == name {
      return Some(object)
    }
  }
  None
}

///|
pub fn TiledTileLayer::tile_gid_at(
  self : TiledTileLayer,
  x : Int,
  y : Int,
) -> TiledGid {
  if self.chunks.length() > 0 {
    for chunk in self.chunks {
      if x < chunk.x || y < chunk.y {
        continue
      }
      if x >= chunk.x + chunk.width || y >= chunk.y + chunk.height {
        continue
      }
      let local_x = x - chunk.x
      let local_y = y - chunk.y
      let index = local_y * chunk.width + local_x
      if index < 0 || index >= chunk.data.length() {
        return empty_tiled_gid()
      }
      return chunk.data[index]
    }
    return empty_tiled_gid()
  }
  let origin_x = if self.start_x != 0 { self.start_x } else { self.x }
  let origin_y = if self.start_y != 0 { self.start_y } else { self.y }
  let local_x = x - origin_x
  let local_y = y - origin_y
  if local_x < 0 || local_y < 0 {
    return empty_tiled_gid()
  }
  if local_x >= self.width || local_y >= self.height {
    return empty_tiled_gid()
  }
  let index = local_y * self.width + local_x
  if index < 0 || index >= self.data.length() {
    return empty_tiled_gid()
  }
  self.data[index]
}

///|
pub fn TiledTileLayer::tile_cells(self : TiledTileLayer) -> Array[TiledCell] {
  let cells : Array[TiledCell] = []
  if self.chunks.length() > 0 {
    for chunk in self.chunks {
      if chunk.width <= 0 {
        continue
      }
      for index, gid in chunk.data {
        let local_x = index % chunk.width
        let local_y = index / chunk.width
        cells.push({ x: chunk.x + local_x, y: chunk.y + local_y, gid })
      }
    }
    return cells
  }
  let origin_x = if self.start_x != 0 { self.start_x } else { self.x }
  let origin_y = if self.start_y != 0 { self.start_y } else { self.y }
  if self.width <= 0 {
    return cells
  }
  for index, gid in self.data {
    let local_x = index % self.width
    let local_y = index / self.width
    cells.push({ x: origin_x + local_x, y: origin_y + local_y, gid })
  }
  cells
}

///|
fn parse_layers(layers_json : Json?) -> Array[TiledLayer] {
  guard layers_json is Some(layers_value) else { return [] }
  guard json_array(layers_value) is Some(layer_values) else { return [] }
  let layers : Array[TiledLayer] = []
  for layer_value in layer_values {
    guard json_object(layer_value) is Some(layer_object) else { continue }
    layers.push(parse_layer(layer_object))
  }
  layers
}

///|
fn parse_layer(layer_object : Map[String, Json]) -> TiledLayer {
  let layer_type = field_string(layer_object, "type").unwrap_or("")
  let kind : TiledLayerKind = match layer_type {
    "tilelayer" => TileLayer(parse_tile_layer(layer_object))
    "objectgroup" => ObjectLayer(parse_object_layer(layer_object))
    "group" => GroupLayer(parse_layers(field_json(layer_object, "layers")))
    "imagelayer" => ImageLayer(parse_image_layer(layer_object))
    _ => Unknown(layer_type)
  }
  {
    id: field_int(layer_object, "id").unwrap_or(0),
    name: field_string(layer_object, "name").unwrap_or(""),
    layer_type,
    class_name: field_string(layer_object, "class"),
    opacity: field_number(layer_object, "opacity").unwrap_or(1.0),
    visible: field_bool(layer_object, "visible").unwrap_or(true),
    offset_x: field_number(layer_object, "offsetx").unwrap_or(0.0),
    offset_y: field_number(layer_object, "offsety").unwrap_or(0.0),
    parallax_x: field_number(layer_object, "parallaxx").unwrap_or(1.0),
    parallax_y: field_number(layer_object, "parallaxy").unwrap_or(1.0),
    tint_color: field_string(layer_object, "tintcolor"),
    properties: parse_properties(field_json(layer_object, "properties")),
    kind,
  }
}

///|
fn parse_tile_layer(layer_object : Map[String, Json]) -> TiledTileLayer {
  {
    width: field_int(layer_object, "width").unwrap_or(0),
    height: field_int(layer_object, "height").unwrap_or(0),
    x: field_int(layer_object, "x").unwrap_or(0),
    y: field_int(layer_object, "y").unwrap_or(0),
    start_x: field_int(layer_object, "startx").unwrap_or(0),
    start_y: field_int(layer_object, "starty").unwrap_or(0),
    encoding: field_string(layer_object, "encoding"),
    compression: field_string(layer_object, "compression"),
    data: parse_gid_array(field_json(layer_object, "data")),
    chunks: parse_chunks(field_json(layer_object, "chunks")),
  }
}

///|
fn parse_chunks(chunks_json : Json?) -> Array[TiledChunk] {
  guard chunks_json is Some(chunks_value) else { return [] }
  guard json_array(chunks_value) is Some(chunk_values) else { return [] }
  let chunks : Array[TiledChunk] = []
  for chunk_value in chunk_values {
    guard json_object(chunk_value) is Some(chunk_object) else { continue }
    chunks.push({
      x: field_int(chunk_object, "x").unwrap_or(0),
      y: field_int(chunk_object, "y").unwrap_or(0),
      width: field_int(chunk_object, "width").unwrap_or(0),
      height: field_int(chunk_object, "height").unwrap_or(0),
      data: parse_gid_array(field_json(chunk_object, "data")),
    })
  }
  chunks
}

///|
fn parse_gid_array(data_json : Json?) -> Array[TiledGid] {
  guard data_json is Some(data_value) else { return [] }
  guard json_array(data_value) is Some(items) else { return [] }
  let gids : Array[TiledGid] = []
  for item in items {
    if json_int(item) is Some(raw) {
      gids.push(decode_tiled_gid(raw))
    } else if json_number(item) is Some(number) {
      gids.push(decode_tiled_gid(number.to_int()))
    } else {
      gids.push(empty_tiled_gid())
    }
  }
  gids
}

///|
fn parse_object_layer(layer_object : Map[String, Json]) -> TiledObjectLayer {
  {
    draw_order: field_string(layer_object, "draworder").unwrap_or("topdown"),
    objects: parse_objects(field_json(layer_object, "objects")),
  }
}

///|
fn parse_objects(objects_json : Json?) -> Array[TiledObject] {
  guard objects_json is Some(objects_value) else { return [] }
  guard json_array(objects_value) is Some(object_values) else { return [] }
  let objects : Array[TiledObject] = []
  for object_value in object_values {
    guard json_object(object_value) is Some(object_object) else { continue }
    objects.push(parse_object(object_object))
  }
  objects
}

///|
fn parse_object(object_object : Map[String, Json]) -> TiledObject {
  {
    id: field_int(object_object, "id").unwrap_or(0),
    name: field_string(object_object, "name").unwrap_or(""),
    object_type: field_string(object_object, "type").unwrap_or(""),
    class_name: field_string(object_object, "class"),
    gid: field_int(object_object, "gid").map(fn(raw) { decode_tiled_gid(raw) }),
    x: field_number(object_object, "x").unwrap_or(0.0),
    y: field_number(object_object, "y").unwrap_or(0.0),
    width: field_number(object_object, "width").unwrap_or(0.0),
    height: field_number(object_object, "height").unwrap_or(0.0),
    rotation: field_number(object_object, "rotation").unwrap_or(0.0),
    visible: field_bool(object_object, "visible").unwrap_or(true),
    point: field_bool(object_object, "point").unwrap_or(false),
    ellipse: field_bool(object_object, "ellipse").unwrap_or(false),
    polygon: parse_points(field_json(object_object, "polygon")),
    polyline: parse_points(field_json(object_object, "polyline")),
    text: parse_text(field_json(object_object, "text")),
    properties: parse_properties(field_json(object_object, "properties")),
  }
}

///|
fn parse_points(points_json : Json?) -> Array[TiledPoint] {
  guard points_json is Some(points_value) else { return [] }
  guard json_array(points_value) is Some(point_values) else { return [] }
  let points : Array[TiledPoint] = []
  for point_value in point_values {
    guard json_object(point_value) is Some(point_object) else { continue }
    points.push({
      x: field_number(point_object, "x").unwrap_or(0.0),
      y: field_number(point_object, "y").unwrap_or(0.0),
    })
  }
  points
}

///|
fn parse_text(text_json : Json?) -> TiledText? {
  guard text_json is Some(text_value) else { return None }
  guard json_object(text_value) is Some(text_object) else { return None }
  Some({
    text: field_string(text_object, "text").unwrap_or(""),
    wrap: field_bool(text_object, "wrap").unwrap_or(false),
    color: field_string(text_object, "color"),
    bold: field_bool(text_object, "bold").unwrap_or(false),
    italic: field_bool(text_object, "italic").unwrap_or(false),
    underline: field_bool(text_object, "underline").unwrap_or(false),
    strikeout: field_bool(text_object, "strikeout").unwrap_or(false),
    kerning: field_bool(text_object, "kerning").unwrap_or(true),
    pixel_size: field_int(text_object, "pixelsize"),
    font_family: field_string(text_object, "fontfamily"),
    horizontal_align: field_string(text_object, "halign"),
    vertical_align: field_string(text_object, "valign"),
  })
}

///|
fn parse_image_layer(layer_object : Map[String, Json]) -> TiledImageLayer {
  {
    image: field_string(layer_object, "image"),
    transparent_color: field_string(layer_object, "transparentcolor"),
    repeat_x: field_bool(layer_object, "repeatx").unwrap_or(false),
    repeat_y: field_bool(layer_object, "repeaty").unwrap_or(false),
  }
}

///|
fn parse_tilesets(tilesets_json : Json?) -> Array[TiledTileset] {
  guard tilesets_json is Some(tilesets_value) else { return [] }
  guard json_array(tilesets_value) is Some(tileset_values) else { return [] }
  let tilesets : Array[TiledTileset] = []
  for tileset_value in tileset_values {
    guard json_object(tileset_value) is Some(tileset_object) else { continue }
    tilesets.push(parse_tileset(tileset_object))
  }
  tilesets
}

///|
fn parse_tileset(tileset_object : Map[String, Json]) -> TiledTileset {
  {
    first_gid: field_int(tileset_object, "firstgid").unwrap_or(1),
    source: field_string(tileset_object, "source"),
    name: field_string(tileset_object, "name"),
    class_name: field_string(tileset_object, "class"),
    tile_width: field_int(tileset_object, "tilewidth"),
    tile_height: field_int(tileset_object, "tileheight"),
    tile_count: field_int(tileset_object, "tilecount"),
    columns: field_int(tileset_object, "columns"),
    spacing: field_int(tileset_object, "spacing").unwrap_or(0),
    margin: field_int(tileset_object, "margin").unwrap_or(0),
    image: field_string(tileset_object, "image"),
    image_width: field_int(tileset_object, "imagewidth"),
    image_height: field_int(tileset_object, "imageheight"),
    properties: parse_properties(field_json(tileset_object, "properties")),
    tiles: parse_tile_definitions(field_json(tileset_object, "tiles")),
  }
}

///|
fn parse_tile_definitions(tiles_json : Json?) -> Array[TiledTileDefinition] {
  guard tiles_json is Some(tiles_value) else { return [] }
  guard json_array(tiles_value) is Some(tile_values) else { return [] }
  let tiles : Array[TiledTileDefinition] = []
  for tile_value in tile_values {
    guard json_object(tile_value) is Some(tile_object) else { continue }
    tiles.push({
      id: field_int(tile_object, "id").unwrap_or(0),
      object_type: field_string(tile_object, "type"),
      class_name: field_string(tile_object, "class"),
      image: field_string(tile_object, "image"),
      probability: field_number(tile_object, "probability"),
      properties: parse_properties(field_json(tile_object, "properties")),
      object_layer: field_object(tile_object, "objectgroup").map(fn(group) {
        parse_object_layer(group)
      }),
    })
  }
  tiles
}

///|
fn parse_properties(properties_json : Json?) -> Array[TiledProperty] {
  guard properties_json is Some(properties_value) else { return [] }
  guard json_array(properties_value) is Some(property_values) else { return [] }
  let properties : Array[TiledProperty] = []
  for property_value in property_values {
    guard json_object(property_value) is Some(property_object) else { continue }
    properties.push({
      name: field_string(property_object, "name").unwrap_or(""),
      value: parse_property_value(property_object),
    })
  }
  properties
}

///|
fn parse_property_value(
  property_object : Map[String, Json],
) -> TiledPropertyValue {
  let type_name = field_string(property_object, "type").map(fn(value) {
    value.to_lower()
  })
  let value = field_json(property_object, "value")
  match type_name {
    Some("string") =>
      String(value.map_or("", fn(item) { json_string(item).unwrap_or("") }))
    Some("int") =>
      Int(value.map_or(0, fn(item) { json_int(item).unwrap_or(0) }))
    Some("float") =>
      Float(value.map_or(0.0, fn(item) { json_number(item).unwrap_or(0.0) }))
    Some("bool") =>
      Bool(value.map_or(false, fn(item) { json_bool(item).unwrap_or(false) }))
    Some("color") =>
      Color(value.map_or("", fn(item) { json_string(item).unwrap_or("") }))
    Some("file") =>
      File(value.map_or("", fn(item) { json_string(item).unwrap_or("") }))
    Some("object") =>
      Object(value.map_or(0, fn(item) { json_int(item).unwrap_or(0) }))
    Some(_) =>
      match value {
        Some(item) => Custom(item)
        None => None
      }
    None => infer_property_value(value)
  }
}

///|
fn infer_property_value(value : Json?) -> TiledPropertyValue {
  guard value is Some(item) else { return None }
  if json_string(item) is Some(text) {
    return String(text)
  }
  if json_bool(item) is Some(flag) {
    return Bool(flag)
  }
  if json_number(item) is Some(number) {
    let as_int = number.to_int()
    if as_int.to_double() == number {
      return Int(as_int)
    }
    return Float(number)
  }
  match item {
    Object(_) => Custom(item)
    Array(_) => Custom(item)
    _ => None
  }
}

///|
fn find_property_value(
  properties : Array[TiledProperty],
  name : String,
) -> TiledPropertyValue? {
  for property in properties {
    if property.name == name {
      return Some(property.value)
    }
  }
  None
}

///|
fn is_absolute_path(path : String) -> Bool {
  if path.contains(":\\") {
    return true
  }
  if path.has_prefix("/") {
    return true
  }
  path.has_prefix("\\\\")
}

///|
fn resolve_relative_asset_path(scene_path : String, uri : String) -> String {
  if uri.length() == 0 {
    return uri
  }
  if is_absolute_path(uri) {
    return uri
  }
  let last_slash = scene_path.rev_find("/")
  let last_backslash = scene_path.rev_find("\\")
  let last_sep = match (last_slash, last_backslash) {
    (Some(slash), Some(backslash)) =>
      if slash > backslash {
        slash
      } else {
        backslash
      }
    (Some(slash), None) => slash
    (None, Some(backslash)) => backslash
    (None, None) => -1
  }
  if last_sep < 0 {
    uri
  } else {
    scene_path.unsafe_substring(start=0, end=last_sep + 1) + uri
  }
}

///|
fn json_object(value : Json) -> Map[String, Json]? {
  json_decode(value)
}

///|
fn json_array(value : Json) -> Array[Json]? {
  json_decode(value)
}

///|
fn json_string(value : Json) -> String? {
  json_decode(value)
}

///|
fn json_number(value : Json) -> Double? {
  json_decode(value)
}

///|
fn json_int(value : Json) -> Int? {
  json_decode(value)
}

///|
fn json_bool(value : Json) -> Bool? {
  json_decode(value)
}

///|
fn[T : @json.FromJson] json_decode(value : Json) -> T? {
  let parsed : Result[T, @json.JsonDecodeError] = try? @json.from_json(value)
  match parsed {
    Ok(output) => Some(output)
    Err(_) => None
  }
}

///|
fn field_json(object : Map[String, Json], key : String) -> Json? {
  object.get(key)
}

///|
fn field_object(object : Map[String, Json], key : String) -> Map[String, Json]? {
  if field_json(object, key) is Some(value) {
    json_object(value)
  } else {
    None
  }
}

///|
fn field_string(object : Map[String, Json], key : String) -> String? {
  if field_json(object, key) is Some(value) {
    json_string(value)
  } else {
    None
  }
}

///|
fn field_number(object : Map[String, Json], key : String) -> Double? {
  if field_json(object, key) is Some(value) {
    json_number(value)
  } else {
    None
  }
}

///|
fn field_int(object : Map[String, Json], key : String) -> Int? {
  if field_json(object, key) is Some(value) {
    json_int(value)
  } else {
    None
  }
}

///|
fn field_bool(object : Map[String, Json], key : String) -> Bool? {
  if field_json(object, key) is Some(value) {
    json_bool(value)
  } else {
    None
  }
}
