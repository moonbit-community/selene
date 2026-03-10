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
priv struct TiledXmlNode {
  name : String
  attributes : Array[(String, String)]
  children : Array[TiledXmlNode]
  text : String
}

///|
pub fn TiledMap::from_tiled_xml(source : String) -> TiledMap {
  guard parse_tiled_xml_root(source) is Some(root) else {
    return empty_tiled_map()
  }
  if root.name != "map" {
    return empty_tiled_map()
  }
  parse_tiled_xml_map(root)
}

///|
fn parse_tiled_xml_tileset_document(
  source : String,
  first_gid : Int,
  source_path : String,
) -> TiledTileset? {
  guard parse_tiled_xml_root(source) is Some(root) else { return None }
  if root.name != "tileset" {
    return None
  }
  Some(
    parse_tiled_xml_tileset(root, first_gid~, source_override=Some(source_path)),
  )
}

///|
fn parse_tiled_xml_root(source : String) -> TiledXmlNode? {
  let reader = @xml.Reader::from_string(source)
  let parsed : Result[TiledXmlNode?, @xml.XmlError] = try? read_tiled_xml_root(
    reader,
  )
  match parsed {
    Ok(root) => root
    Err(_) => None
  }
}

///|
fn read_tiled_xml_root(
  reader : @xml.Reader,
) -> TiledXmlNode? raise @xml.XmlError {
  while true {
    match reader.read_event() {
      Start(element) => return Some(read_tiled_xml_node(reader, element))
      Empty(element) =>
        return Some(tiled_xml_node(element.name, element.attributes))
      Text(_) => continue
      CData(_) => continue
      Comment(_) => continue
      PI(..) => continue
      Decl(..) => continue
      DocType(_) => continue
      Eof => return None
      End(_) => continue
    }
  }
  abort("unreachable")
}

///|
fn read_tiled_xml_node(
  reader : @xml.Reader,
  element : @xml.XmlElement,
) -> TiledXmlNode raise @xml.XmlError {
  let children : Array[TiledXmlNode] = []
  let text = StringBuilder::new()
  while true {
    match reader.read_event() {
      Start(child) => children.push(read_tiled_xml_node(reader, child))
      Empty(child) =>
        children.push(tiled_xml_node(child.name, child.attributes))
      Text(content) => text.write_string(content)
      CData(content) => text.write_string(content)
      Comment(_) => ()
      PI(..) => ()
      Decl(..) => ()
      DocType(_) => ()
      End(_) =>
        return {
          name: element.name,
          attributes: element.attributes,
          children,
          text: text.to_string(),
        }
      Eof =>
        return tiled_xml_node(
          element.name,
          element.attributes,
          children~,
          text=text.to_string(),
        )
    }
  }
  abort("unreachable")
}

///|
fn tiled_xml_node(
  name : String,
  attributes : Array[(String, String)],
  children? : Array[TiledXmlNode] = [],
  text? : String = "",
) -> TiledXmlNode {
  { name, attributes, children, text }
}

///|
fn parse_tiled_xml_map(root : TiledXmlNode) -> TiledMap {
  {
    width: xml_int_attr(root, "width").unwrap_or(0),
    height: xml_int_attr(root, "height").unwrap_or(0),
    tile_width: xml_int_attr(root, "tilewidth").unwrap_or(0),
    tile_height: xml_int_attr(root, "tileheight").unwrap_or(0),
    hex_side_length: xml_int_attr(root, "hexsidelength"),
    stagger_axis: xml_attr(root, "staggeraxis"),
    stagger_index: xml_attr(root, "staggerindex"),
    infinite: xml_bool_attr(root, "infinite").unwrap_or(false),
    orientation: xml_attr(root, "orientation").unwrap_or("orthogonal"),
    render_order: xml_attr(root, "renderorder").unwrap_or("right-down"),
    background_color: xml_attr(root, "backgroundcolor"),
    next_layer_id: xml_int_attr(root, "nextlayerid").unwrap_or(0),
    next_object_id: xml_int_attr(root, "nextobjectid").unwrap_or(0),
    source_path: None,
    layers: parse_tiled_xml_layers(root),
    tilesets: parse_tiled_xml_tilesets(root),
    properties: parse_tiled_xml_properties(root),
  }
}

///|
fn parse_tiled_xml_layers(root : TiledXmlNode) -> Array[TiledLayer] {
  let layers : Array[TiledLayer] = []
  for child in root.children {
    if child.name == "layer" ||
      child.name == "objectgroup" ||
      child.name == "group" ||
      child.name == "imagelayer" {
      layers.push(parse_tiled_xml_layer(child))
    }
  }
  layers
}

///|
fn parse_tiled_xml_layer(node : TiledXmlNode) -> TiledLayer {
  let layer_type = match node.name {
    "layer" => "tilelayer"
    "objectgroup" => "objectgroup"
    "group" => "group"
    "imagelayer" => "imagelayer"
    other => other
  }
  let kind : TiledLayerKind = match node.name {
    "layer" => TileLayer(parse_tiled_xml_tile_layer(node))
    "objectgroup" => ObjectLayer(parse_tiled_xml_object_layer(node))
    "group" => GroupLayer(parse_tiled_xml_layers(node))
    "imagelayer" => ImageLayer(parse_tiled_xml_image_layer(node))
    other => Unknown(other)
  }
  {
    id: xml_int_attr(node, "id").unwrap_or(0),
    name: xml_attr(node, "name").unwrap_or(""),
    layer_type,
    class_name: xml_attr(node, "class"),
    opacity: xml_double_attr(node, "opacity").unwrap_or(1.0),
    visible: xml_bool_attr(node, "visible").unwrap_or(true),
    offset_x: xml_double_attr(node, "offsetx").unwrap_or(0.0),
    offset_y: xml_double_attr(node, "offsety").unwrap_or(0.0),
    parallax_x: xml_double_attr(node, "parallaxx").unwrap_or(1.0),
    parallax_y: xml_double_attr(node, "parallaxy").unwrap_or(1.0),
    tint_color: xml_attr(node, "tintcolor"),
    properties: parse_tiled_xml_properties(node),
    kind,
  }
}

///|
fn parse_tiled_xml_tile_layer(node : TiledXmlNode) -> TiledTileLayer {
  let data = xml_child(node, "data")
  {
    width: xml_int_attr(node, "width").unwrap_or(0),
    height: xml_int_attr(node, "height").unwrap_or(0),
    x: xml_int_attr(node, "x").unwrap_or(0),
    y: xml_int_attr(node, "y").unwrap_or(0),
    start_x: xml_int_attr(node, "startx").unwrap_or(0),
    start_y: xml_int_attr(node, "starty").unwrap_or(0),
    encoding: data.bind(fn(node) { xml_attr(node, "encoding") }),
    compression: data.bind(fn(node) { xml_attr(node, "compression") }),
    data: data.map_or([], parse_tiled_xml_gid_data),
    chunks: data.map_or([], parse_tiled_xml_chunks),
  }
}

///|
fn parse_tiled_xml_chunks(data_node : TiledXmlNode) -> Array[TiledChunk] {
  let chunks : Array[TiledChunk] = []
  for chunk in xml_children(data_node, "chunk") {
    chunks.push({
      x: xml_int_attr(chunk, "x").unwrap_or(0),
      y: xml_int_attr(chunk, "y").unwrap_or(0),
      width: xml_int_attr(chunk, "width").unwrap_or(0),
      height: xml_int_attr(chunk, "height").unwrap_or(0),
      data: parse_tiled_xml_gid_data(chunk),
    })
  }
  chunks
}

///|
fn parse_tiled_xml_gid_data(data_node : TiledXmlNode) -> Array[TiledGid] {
  let encoding = xml_attr(data_node, "encoding")
  if encoding == Some("base64") {
    return parse_tiled_base64_gids(
      xml_text(data_node),
      compression=xml_attr(data_node, "compression"),
    )
  }
  if encoding == Some("csv") {
    return parse_tiled_gid_csv(xml_text(data_node))
  }
  if encoding is Some(_) && encoding != Some("csv") {
    return []
  }
  let tiles = xml_children(data_node, "tile")
  if tiles.length() > 0 {
    return tiles.map(fn(tile) {
      decode_tiled_gid(xml_int_attr(tile, "gid").unwrap_or(0))
    })
  }
  parse_tiled_xml_gid_text(xml_text(data_node))
}

///|
fn parse_tiled_xml_gid_text(text : String) -> Array[TiledGid] {
  let gids : Array[TiledGid] = []
  let mut token = StringBuilder::new()
  for ch in text.to_array() {
    if ch == ',' || is_tiled_xml_whitespace(ch) {
      let token_string = token.to_string()
      if token_string.length() > 0 {
        gids.push(
          decode_tiled_gid(parse_xml_int_text(token_string).unwrap_or(0)),
        )
        token = StringBuilder::new()
      }
      continue
    }
    token.write_char(ch)
  }
  let token_string = token.to_string()
  if token_string.length() > 0 {
    gids.push(decode_tiled_gid(parse_xml_int_text(token_string).unwrap_or(0)))
  }
  gids
}

///|
fn parse_tiled_xml_object_layer(node : TiledXmlNode) -> TiledObjectLayer {
  {
    draw_order: xml_attr(node, "draworder").unwrap_or("topdown"),
    objects: xml_children(node, "object").map(parse_tiled_xml_object),
  }
}

///|
fn parse_tiled_xml_object(node : TiledXmlNode) -> TiledObject {
  {
    id: xml_int_attr(node, "id").unwrap_or(0),
    name: xml_attr(node, "name").unwrap_or(""),
    object_type: xml_attr(node, "type").unwrap_or(""),
    class_name: xml_attr(node, "class"),
    gid: xml_int_attr(node, "gid").map(decode_tiled_gid),
    x: xml_double_attr(node, "x").unwrap_or(0.0),
    y: xml_double_attr(node, "y").unwrap_or(0.0),
    width: xml_double_attr(node, "width").unwrap_or(0.0),
    height: xml_double_attr(node, "height").unwrap_or(0.0),
    rotation: xml_double_attr(node, "rotation").unwrap_or(0.0),
    visible: xml_bool_attr(node, "visible").unwrap_or(true),
    point: xml_child(node, "point") is Some(_),
    ellipse: xml_child(node, "ellipse") is Some(_),
    polygon: xml_child(node, "polygon").map_or([], parse_tiled_xml_points),
    polyline: xml_child(node, "polyline").map_or([], parse_tiled_xml_points),
    text: xml_child(node, "text").map(parse_tiled_xml_text),
    properties: parse_tiled_xml_properties(node),
  }
}

///|
fn parse_tiled_xml_points(node : TiledXmlNode) -> Array[TiledPoint] {
  let points = xml_attr(node, "points").unwrap_or("")
  let parsed : Array[TiledPoint] = []
  for token in points.split(" ") {
    if token.length() == 0 {
      continue
    }
    let coords = token.split(",").to_array()
    if coords.length() != 2 {
      continue
    }
    parsed.push({
      x: parse_xml_double_text(coords[0].to_string()).unwrap_or(0.0),
      y: parse_xml_double_text(coords[1].to_string()).unwrap_or(0.0),
    })
  }
  parsed
}

///|
fn parse_tiled_xml_text(node : TiledXmlNode) -> TiledText {
  {
    text: xml_text(node),
    wrap: xml_bool_attr(node, "wrap").unwrap_or(false),
    color: xml_attr(node, "color"),
    bold: xml_bool_attr(node, "bold").unwrap_or(false),
    italic: xml_bool_attr(node, "italic").unwrap_or(false),
    underline: xml_bool_attr(node, "underline").unwrap_or(false),
    strikeout: xml_bool_attr(node, "strikeout").unwrap_or(false),
    kerning: xml_bool_attr(node, "kerning").unwrap_or(true),
    pixel_size: xml_int_attr(node, "pixelsize"),
    font_family: xml_attr(node, "fontfamily"),
    horizontal_align: xml_attr(node, "halign"),
    vertical_align: xml_attr(node, "valign"),
  }
}

///|
fn parse_tiled_xml_image_layer(node : TiledXmlNode) -> TiledImageLayer {
  let image = xml_child(node, "image")
  {
    image: image.bind(fn(img) { xml_attr(img, "source") }),
    transparent_color: image.bind(fn(img) { xml_attr(img, "trans") }),
    repeat_x: xml_bool_attr(node, "repeatx").unwrap_or(false),
    repeat_y: xml_bool_attr(node, "repeaty").unwrap_or(false),
  }
}

///|
fn parse_tiled_xml_tilesets(root : TiledXmlNode) -> Array[TiledTileset] {
  let tilesets : Array[TiledTileset] = []
  for child in xml_children(root, "tileset") {
    tilesets.push(parse_tiled_xml_tileset(child))
  }
  tilesets
}

///|
fn parse_tiled_xml_tileset(
  node : TiledXmlNode,
  first_gid? : Int = 1,
  source_override? : String?,
) -> TiledTileset {
  let image = xml_child(node, "image")
  {
    first_gid,
    source: source_override.unwrap_or(xml_attr(node, "source")),
    name: xml_attr(node, "name"),
    class_name: xml_attr(node, "class"),
    tile_width: xml_int_attr(node, "tilewidth"),
    tile_height: xml_int_attr(node, "tileheight"),
    tile_count: xml_int_attr(node, "tilecount"),
    columns: xml_int_attr(node, "columns"),
    spacing: xml_int_attr(node, "spacing").unwrap_or(0),
    margin: xml_int_attr(node, "margin").unwrap_or(0),
    image: image.bind(fn(img) { xml_attr(img, "source") }),
    image_width: image.bind(fn(img) { xml_int_attr(img, "width") }),
    image_height: image.bind(fn(img) { xml_int_attr(img, "height") }),
    properties: parse_tiled_xml_properties(node),
    tiles: xml_children(node, "tile").map(parse_tiled_xml_tile_definition),
  }
}

///|
fn parse_tiled_xml_tile_definition(node : TiledXmlNode) -> TiledTileDefinition {
  {
    id: xml_int_attr(node, "id").unwrap_or(0),
    object_type: xml_attr(node, "type"),
    class_name: xml_attr(node, "class"),
    image: xml_child(node, "image").bind(fn(img) { xml_attr(img, "source") }),
    probability: xml_double_attr(node, "probability"),
    animation: parse_tiled_xml_tile_animation_frames(node),
    properties: parse_tiled_xml_properties(node),
    object_layer: xml_child(node, "objectgroup").map(
      parse_tiled_xml_object_layer,
    ),
  }
}

///|
fn parse_tiled_xml_tile_animation_frames(
  tile_node : TiledXmlNode,
) -> Array[TiledAnimationFrame] {
  guard xml_child(tile_node, "animation") is Some(animation_node) else {
    return []
  }
  let frames : Array[TiledAnimationFrame] = []
  for frame_node in xml_children(animation_node, "frame") {
    frames.push({
      tile_id: xml_int_attr(frame_node, "tileid").unwrap_or(0),
      duration_ms: xml_int_attr(frame_node, "duration").unwrap_or(100),
    })
  }
  frames
}

///|
fn parse_tiled_xml_properties(node : TiledXmlNode) -> Array[TiledProperty] {
  guard xml_child(node, "properties") is Some(properties_node) else {
    return []
  }
  xml_children(properties_node, "property").map(parse_tiled_xml_property)
}

///|
fn parse_tiled_xml_property(node : TiledXmlNode) -> TiledProperty {
  let name = xml_attr(node, "name").unwrap_or("")
  let property_type = xml_attr(node, "type")
  let raw_value = xml_attr(node, "value").unwrap_or(xml_text(node))
  let value : TiledPropertyValue = match property_type {
    Some("string") => String(raw_value)
    Some("int") => Int(parse_xml_int_text(raw_value).unwrap_or(0))
    Some("float") => Float(parse_xml_double_text(raw_value).unwrap_or(0.0))
    Some("bool") => Bool(parse_xml_bool_text(raw_value).unwrap_or(false))
    Some("color") => Color(raw_value)
    Some("file") => File(raw_value)
    Some("object") => Object(parse_xml_int_text(raw_value).unwrap_or(0))
    Some(_) => String(raw_value)
    None => infer_tiled_xml_property_value(raw_value)
  }
  { name, value }
}

///|
fn infer_tiled_xml_property_value(value : String) -> TiledPropertyValue {
  if value.length() == 0 {
    return None
  }
  if parse_xml_bool_text(value) is Some(bool_value) {
    return Bool(bool_value)
  }
  if parse_xml_int_text(value) is Some(int_value) {
    return Int(int_value)
  }
  if parse_xml_double_text(value) is Some(float_value) {
    return Float(float_value)
  }
  String(value)
}

///|
fn xml_attr(node : TiledXmlNode, key : String) -> String? {
  for attribute in node.attributes {
    if attribute.0 == key {
      return Some(attribute.1)
    }
  }
  None
}

///|
fn xml_child(node : TiledXmlNode, name : String) -> TiledXmlNode? {
  for child in node.children {
    if child.name == name {
      return Some(child)
    }
  }
  None
}

///|
fn xml_children(node : TiledXmlNode, name : String) -> Array[TiledXmlNode] {
  node.children.filter(fn(child) { child.name == name })
}

///|
fn xml_text(node : TiledXmlNode) -> String {
  node.text.trim().to_string()
}

///|
fn xml_int_attr(node : TiledXmlNode, key : String) -> Int? {
  xml_attr(node, key).bind(parse_xml_int_text)
}

///|
fn xml_double_attr(node : TiledXmlNode, key : String) -> Double? {
  xml_attr(node, key).bind(parse_xml_double_text)
}

///|
fn xml_bool_attr(node : TiledXmlNode, key : String) -> Bool? {
  xml_attr(node, key).bind(parse_xml_bool_text)
}

///|
fn parse_xml_int_text(text : String) -> Int? {
  let parsed : Result[Int, @strconv.StrConvError] = try? @strconv.parse_int(
    text.trim(),
  )
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn parse_xml_double_text(text : String) -> Double? {
  let parsed : Result[Double, @strconv.StrConvError] = try? @strconv.parse_double(
    text.trim(),
  )
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn parse_xml_bool_text(text : String) -> Bool? {
  let normalized = text.trim().to_string()
  if normalized == "1" ||
    normalized == "true" ||
    normalized == "True" ||
    normalized == "TRUE" {
    Some(true)
  } else if normalized == "0" ||
    normalized == "false" ||
    normalized == "False" ||
    normalized == "FALSE" {
    Some(false)
  } else {
    None
  }
}

///|
fn is_tiled_xml_whitespace(ch : Char) -> Bool {
  ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t'
}
