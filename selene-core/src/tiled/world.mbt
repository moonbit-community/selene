///|
fn tiled_world_set_entity_translation_2d(
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
fn tiled_world_entity_translation_2d(entity : @entity.Entity) -> @math.Vec2D? {
  @transform.transforms()
  .get(entity)
  .map(fn(transform) {
    @math.Vec2D(transform.translation.x, transform.translation.y)
  })
}

///|
pub struct TiledWorldMap {
  file_name : String
  x : Int
  y : Int
  width : Int?
  height : Int?
}

///|
pub struct TiledWorldPattern {
  regexp : String
  multiplier_x : Int
  multiplier_y : Int
  offset_x : Int
  offset_y : Int
  map_width : Int
  map_height : Int
}

///|
pub struct TiledWorld {
  only_show_adjacent_maps : Bool
  maps : Array[TiledWorldMap]
  patterns : Array[TiledWorldPattern]
  source_path : String?
}

///|
pub struct TiledWorldLoadedMap {
  index : Int
  world_map : TiledWorldMap
  resolved_map_path : String
  map : TiledMap
  spawnable : Bool
}

///|
pub struct TiledWorldInstance {
  world : TiledWorld
  settings : TiledWorldSpawnSettings
  loaded_maps : Array[TiledWorldLoadedMap]
  spawned_maps : Map[Int, @entity.Entity]
}

///|
pub struct TiledWorldMapInstance {
  world_entity : @entity.Entity
  map_entity : @entity.Entity
  world_map : TiledWorldMap
  resolved_map_path : String
}

///|
pub struct TiledWorldSpawnSettings {
  position : @math.Vec2D
  map_z_step : Int
  map_settings : TiledSpawnSettings
  focus_map_path : String?
  chunking : @math.Vec2D?
  world_hook : ((TiledWorldSpawnedEvent) -> Unit)?
  world_map_hook : ((TiledWorldMapSpawnedEvent) -> Unit)?
}

///|
priv struct TiledWorldRuntimeStore {
  tiled_world_instances : Map[@entity.Entity, TiledWorldInstance]
  tiled_world_map_instances : Map[@entity.Entity, TiledWorldMapInstance]
}

///|
let tiled_world_runtime_stores : Map[UInt, TiledWorldRuntimeStore] = Map::new()

///|
fn tiled_world_runtime_store() -> TiledWorldRuntimeStore {
  let world_id = @ecs.require_current_world().id()
  tiled_world_runtime_stores.get_or_init(world_id, () => {
    tiled_world_instances: Map::new(),
    tiled_world_map_instances: Map::new(),
  })
}

///|
pub fn tiled_world_instances() -> Map[@entity.Entity, TiledWorldInstance] {
  tiled_world_runtime_store().tiled_world_instances
}

///|
pub fn tiled_world_map_instances() -> Map[@entity.Entity, TiledWorldMapInstance] {
  tiled_world_runtime_store().tiled_world_map_instances
}

///|
pub fn empty_tiled_world() -> TiledWorld {
  { only_show_adjacent_maps: false, maps: [], patterns: [], source_path: None }
}

///|
pub fn default_tiled_world_spawn_settings() -> TiledWorldSpawnSettings {
  {
    position: @math.Vec2D::zero(),
    map_z_step: 1000,
    map_settings: default_tiled_spawn_settings(),
    focus_map_path: None,
    chunking: None,
    world_hook: None,
    world_map_hook: None,
  }
}

///|
pub fn load_tiled_world(path : String) -> TiledWorld {
  guard load_tiled_text_document(path) is Some(source) else {
    return empty_tiled_world()
  }
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  guard parsed is Ok(document) else { return empty_tiled_world() }
  guard json_object(document) is Some(root_object) else {
    return empty_tiled_world()
  }
  {
    only_show_adjacent_maps: field_bool(root_object, "onlyShowAdjacentMaps").unwrap_or(
      false,
    ),
    maps: parse_tiled_world_maps(field_json(root_object, "maps")),
    patterns: parse_tiled_world_patterns(field_json(root_object, "patterns")),
    source_path: Some(path),
  }
}

///|
pub fn load_and_spawn_tiled_world(
  path : String,
  settings? : TiledWorldSpawnSettings = default_tiled_world_spawn_settings(),
) -> @entity.Entity {
  spawn_tiled_world(load_tiled_world(path), settings~)
}

///|
pub fn spawn_tiled_world(
  world : TiledWorld,
  settings? : TiledWorldSpawnSettings = default_tiled_world_spawn_settings(),
) -> @entity.Entity {
  let world_entity = @entity.Entity::new()
  spawn_tiled_world_root(world_entity, world, settings)
  world_entity
}

///|
pub fn spawn_tiled_world_into_entity(
  root : @entity.Entity,
  world : TiledWorld,
  settings? : TiledWorldSpawnSettings = default_tiled_world_spawn_settings(),
) -> Unit {
  spawn_tiled_world_root(root, world, settings)
}

///|
pub fn respawn_tiled_world_into_entity(
  root : @entity.Entity,
  world : TiledWorld,
  settings? : TiledWorldSpawnSettings = default_tiled_world_spawn_settings(),
) -> Unit {
  clear_tiled_children(root)
  @entity.entity_flush_system(0.0)
  clear_tiled_root_components(root)
  spawn_tiled_world_root(root, world, settings)
}

///|
fn spawn_tiled_world_root(
  world_entity : @entity.Entity,
  world : TiledWorld,
  settings : TiledWorldSpawnSettings,
) -> Unit {
  tiled_world_set_entity_translation_2d(world_entity, settings.position)
  let loaded_maps_raw = tiled_world_load_maps(world)
  let focus_path = settings.focus_map_path.map(path => {
    world.resolve_map_path(path)
  })
  let loaded_maps : Array[TiledWorldLoadedMap] = []
  for index, loaded_map in loaded_maps_raw {
    loaded_maps.push({
      index,
      world_map: loaded_map.world_map,
      resolved_map_path: loaded_map.resolved_map_path,
      map: loaded_map.map,
      spawnable: tiled_world_should_spawn_map(
        loaded_maps_raw, loaded_map, focus_path, world,
      ),
    })
  }
  let spawned_maps : Map[Int, @entity.Entity] = Map::new()
  tiled_world_instances().set(world_entity, {
    world,
    settings,
    loaded_maps,
    spawned_maps,
  })
  let world_event = { world_entity, world }
  tiled_world_spawned_event_bus.trigger(world_event, Some(world_entity))
  if settings.world_hook is Some(world_hook) {
    world_hook(world_event)
  }
  if settings.chunking is Some(_) {
    tiled_world_update_chunking(world_entity)
  } else {
    for index, loaded_map in loaded_maps {
      if loaded_map.spawnable {
        tiled_world_spawn_loaded_map(world_entity, index)
      }
    }
  }
}

///|
pub fn tiled_world_chunking_system(_delta : Double) -> Unit {
  for entity in tiled_world_instances().to_array().map(pair => pair.0) {
    if !entity.is_alive() {
      continue
    }
    guard tiled_world_instances().get(entity) is Some(instance) else {
      continue
    }
    if instance.settings.chunking is Some(_) {
      tiled_world_update_chunking(entity)
    }
  }
}

///|
fn tiled_world_update_chunking(world_entity : @entity.Entity) -> Unit {
  guard tiled_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  guard instance.settings.chunking is Some(margin) else { return }
  let (view_min, view_max) = tiled_camera_view_bounds()
  let view_min = view_min - margin
  let view_max = view_max + margin

  guard tiled_world_entity_translation_2d(world_entity) is Some(world_pos) else {
    return
  }
  let world_origin = world_pos
  let map_offset = instance.settings.map_settings.position

  let visible : Array[Int] = []
  for loaded in instance.loaded_maps {
    if !loaded.spawnable {
      continue
    }
    let (min, max) = tiled_world_loaded_map_bounds(
      world_origin + map_offset,
      loaded,
    )
    if min[X] <= view_max[X] &&
      max[X] >= view_min[X] &&
      min[Y] <= view_max[Y] &&
      max[Y] >= view_min[Y] {
      visible.push(loaded.index)
    }
  }

  for pair in instance.spawned_maps.to_array() {
    let idx = pair.0
    if !visible.contains(idx) {
      let map_entity = pair.1
      despawn_tiled_tree(map_entity)
      instance.spawned_maps.remove(idx)
    }
  }

  for idx in visible {
    if instance.spawned_maps.contains(idx) {
      continue
    }
    tiled_world_spawn_loaded_map(world_entity, idx)
  }
}

///|
fn tiled_camera_view_bounds() -> (@math.Vec2D, @math.Vec2D) {
  match tiled_world_active_camera2d_view() {
    Some((camera, camera_transform, projection)) => {
      let screen_size = @system.get_screen_size()
      let corners = [
        camera.viewport_to_world_2d(
          camera_transform,
          projection,
          @math.Vec2D(0.0, 0.0),
        ),
        camera.viewport_to_world_2d(
          camera_transform,
          projection,
          @math.Vec2D(screen_size[X], 0.0),
        ),
        camera.viewport_to_world_2d(
          camera_transform,
          projection,
          @math.Vec2D(0.0, screen_size[Y]),
        ),
        camera.viewport_to_world_2d(
          camera_transform,
          projection,
          @math.Vec2D(screen_size[X], screen_size[Y]),
        ),
      ]
      let min_x = corners.fold(init=corners[0][X], fn(acc, corner) {
        if corner[X] < acc {
          corner[X]
        } else {
          acc
        }
      })
      let min_y = corners.fold(init=corners[0][Y], fn(acc, corner) {
        if corner[Y] < acc {
          corner[Y]
        } else {
          acc
        }
      })
      let max_x = corners.fold(init=corners[0][X], fn(acc, corner) {
        if corner[X] > acc {
          corner[X]
        } else {
          acc
        }
      })
      let max_y = corners.fold(init=corners[0][Y], fn(acc, corner) {
        if corner[Y] > acc {
          corner[Y]
        } else {
          acc
        }
      })
      (@math.Vec2D(min_x, min_y), @math.Vec2D(max_x, max_y))
    }
    None => (@math.Vec2D::zero(), @system.get_viewport_size())
  }
}

///|
fn tiled_world_entity_global_transform(
  entity : @entity.Entity,
) -> @transform.GlobalTransform? {
  @transform.compute_global_transform(entity)
}

///|
fn tiled_world_active_camera2d_view() -> (
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
    guard tiled_world_entity_global_transform(entity) is Some(global) else {
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
fn tiled_world_spawn_loaded_map(
  world_entity : @entity.Entity,
  index : Int,
) -> Unit {
  guard tiled_world_instances().get(world_entity) is Some(instance) else {
    return
  }
  if index < 0 || index >= instance.loaded_maps.length() {
    return
  }
  let loaded_map = instance.loaded_maps[index]
  if !loaded_map.spawnable {
    return
  }
  let child_offset = @math.Vec2D(
    loaded_map.world_map.x.to_double() +
    instance.settings.map_settings.position[X],
    loaded_map.world_map.y.to_double() +
    instance.settings.map_settings.position[Y],
  )
  let map_entity = world_entity.spawn_child()
  let map_settings = {
    ..instance.settings.map_settings,
    position: child_offset,
    zindex: instance.settings.map_settings.zindex +
    index * instance.settings.map_z_step,
  }
  spawn_tiled_map_root(map_entity, loaded_map.map, map_settings)
  let world_map_event = {
    world_entity,
    map_entity,
    world_map: loaded_map.world_map,
    map: loaded_map.map,
    resolved_map_path: loaded_map.resolved_map_path,
  }
  tiled_world_map_instances().set(map_entity, {
    world_entity,
    map_entity,
    world_map: loaded_map.world_map,
    resolved_map_path: loaded_map.resolved_map_path,
  })
  instance.spawned_maps.set(index, map_entity)
  tiled_world_map_spawned_event_bus.trigger(world_map_event, Some(map_entity))
  if instance.settings.world_map_hook is Some(world_map_hook) {
    world_map_hook(world_map_event)
  }
}

///|
fn tiled_world_loaded_map_bounds(
  origin : @math.Vec2D,
  loaded_map : TiledWorldLoadedMap,
) -> (@math.Vec2D, @math.Vec2D) {
  let width = loaded_map.world_map.width.unwrap_or(
    loaded_map.map.width * loaded_map.map.tile_width,
  )
  let height = loaded_map.world_map.height.unwrap_or(
    loaded_map.map.height * loaded_map.map.tile_height,
  )
  let min = origin +
    @math.Vec2D(
      loaded_map.world_map.x.to_double(),
      loaded_map.world_map.y.to_double(),
    )
  (min, min + @math.Vec2D(width.to_double(), height.to_double()))
}

///|
pub fn TiledWorld::resolve_map_path(self : TiledWorld, path : String) -> String {
  if is_absolute_path(path) {
    return path
  }
  match self.source_path {
    Some(source_path) => resolve_relative_asset_path(source_path, path)
    None => path
  }
}

///|
pub fn TiledWorld::map(self : TiledWorld, file_name : String) -> TiledWorldMap? {
  for map in tiled_world_collect_maps(self) {
    if map.file_name == file_name {
      return Some(map)
    }
  }
  None
}

///|
priv struct LoadedTiledWorldMap {
  world_map : TiledWorldMap
  resolved_map_path : String
  map : TiledMap
}

///|
fn parse_tiled_world_maps(maps_json : Json?) -> Array[TiledWorldMap] {
  guard maps_json is Some(maps_value) else { return [] }
  guard json_array(maps_value) is Some(items) else { return [] }
  let maps : Array[TiledWorldMap] = []
  for item in items {
    guard json_object(item) is Some(object) else { continue }
    guard field_string(object, "fileName") is Some(file_name) else { continue }
    maps.push({
      file_name,
      x: field_int(object, "x").unwrap_or(0),
      y: field_int(object, "y").unwrap_or(0),
      width: field_int(object, "width"),
      height: field_int(object, "height"),
    })
  }
  maps
}

///|
fn parse_tiled_world_patterns(
  patterns_json : Json?,
) -> Array[TiledWorldPattern] {
  guard patterns_json is Some(patterns_value) else { return [] }
  guard json_array(patterns_value) is Some(items) else { return [] }
  let patterns : Array[TiledWorldPattern] = []
  for item in items {
    guard json_object(item) is Some(object) else { continue }
    guard field_string(object, "regexp") is Some(regexp) else { continue }
    let multiplier_x = field_int(object, "multiplierX").unwrap_or(1)
    let multiplier_y = field_int(object, "multiplierY").unwrap_or(1)
    patterns.push({
      regexp,
      multiplier_x,
      multiplier_y,
      offset_x: field_int(object, "offsetX").unwrap_or(0),
      offset_y: field_int(object, "offsetY").unwrap_or(0),
      map_width: field_int(object, "mapWidth").unwrap_or(multiplier_x),
      map_height: field_int(object, "mapHeight").unwrap_or(multiplier_y),
    })
  }
  patterns
}

///|
fn tiled_world_collect_maps(world : TiledWorld) -> Array[TiledWorldMap] {
  let resolved_paths : Map[String, Bool] = Map::new()
  let maps : Array[TiledWorldMap] = []
  for world_map in world.maps {
    let resolved = world.resolve_map_path(world_map.file_name)
    if resolved_paths.get(resolved) is Some(_) {
      continue
    }
    resolved_paths.set(resolved, true)
    maps.push(world_map)
  }
  for world_map in tiled_world_expand_patterns(world) {
    let resolved = world.resolve_map_path(world_map.file_name)
    if resolved_paths.get(resolved) is Some(_) {
      continue
    }
    resolved_paths.set(resolved, true)
    maps.push(world_map)
  }
  maps
}

///|
fn tiled_world_expand_patterns(world : TiledWorld) -> Array[TiledWorldMap] {
  if world.patterns.length() == 0 {
    return []
  }
  let file_names = tiled_world_scan_directory_files(world)
  if file_names.length() == 0 {
    return []
  }
  let maps : Array[TiledWorldMap] = []
  for pattern in world.patterns {
    for map in tiled_world_expand_pattern(pattern, file_names) {
      maps.push(map)
    }
  }
  maps
}

///|
fn tiled_world_expand_pattern(
  pattern : TiledWorldPattern,
  file_names : Array[String],
) -> Array[TiledWorldMap] {
  guard tiled_world_compile_pattern_regex(pattern.regexp) is Some(regex) else {
    return []
  }
  let maps : Array[TiledWorldMap] = []
  for file_name in file_names {
    guard tiled_world_match_pattern_regex(regex, file_name) is Some((x, y)) else {
      continue
    }
    maps.push({
      file_name,
      x: x * pattern.multiplier_x + pattern.offset_x,
      y: y * pattern.multiplier_y + pattern.offset_y,
      width: Some(pattern.map_width),
      height: Some(pattern.map_height),
    })
  }
  maps
}

///|
fn tiled_world_scan_directory_files(world : TiledWorld) -> Array[String] {
  guard world.source_path is Some(source_path) else { return [] }
  let directory = tiled_world_directory_path(source_path)
  let listed : Result[Array[String], @fs.IOError] = try? @fs.read_dir(directory)
  guard listed is Ok(entries) else { return [] }
  let file_names : Array[String] = []
  for entry in entries {
    let resolved = world.resolve_map_path(entry)
    let is_file : Result[Bool, @fs.IOError] = try? @fs.is_file(resolved)
    if is_file is Ok(true) {
      file_names.push(entry)
    }
  }
  file_names.sort()
  file_names
}

///|
fn tiled_world_directory_path(source_path : String) -> String {
  let last_slash = source_path.rev_find("/")
  let last_backslash = source_path.rev_find("\\")
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
    "."
  } else if last_sep == 0 {
    source_path.unsafe_substring(start=0, end=1)
  } else {
    source_path.unsafe_substring(start=0, end=last_sep)
  }
}

///|
priv enum TiledPatternQuantifier {
  ExactlyOne
  ZeroOrMore
  OneOrMore
  ZeroOrOne
}

///|
priv enum TiledPatternAtom {
  Empty
  Literal(Char)
  AnyChar
  Digit
  Space
  Word
  CharClass(Bool, Array[(Char, Char)])
  Group(Array[TiledPatternToken], Int?)
}

///|
priv struct TiledPatternToken {
  atom : TiledPatternAtom
  quantifier : TiledPatternQuantifier
}

///|
priv struct TiledWorldPatternRegex {
  tokens : Array[TiledPatternToken]
  capture_count : Int
}

///|
priv enum TiledPatternClassPiece {
  Char(Char)
  Ranges(Array[(Char, Char)])
}

///|
fn tiled_world_compile_pattern_regex(
  source : String,
) -> TiledWorldPatternRegex? {
  let chars = source.to_array()
  guard tiled_world_parse_pattern_tokens(chars, 0, 0, None)
    is Some((tokens, next_index, capture_count)) else {
    return None
  }
  if next_index != chars.length() {
    return None
  }
  Some({ tokens, capture_count })
}

///|
fn tiled_world_parse_pattern_tokens(
  chars : Array[Char],
  start_index : Int,
  capture_index : Int,
  stop_char : Char?,
) -> (Array[TiledPatternToken], Int, Int)? {
  let tokens : Array[TiledPatternToken] = []
  let mut index = start_index
  let mut next_capture_index = capture_index
  while index < chars.length() {
    if stop_char is Some(stop) && chars[index] == stop {
      return Some((tokens, index + 1, next_capture_index))
    }
    guard tiled_world_parse_pattern_atom(chars, index, next_capture_index)
      is Some((atom, atom_end, updated_capture_index)) else {
      return None
    }
    next_capture_index = updated_capture_index
    let mut quantifier = ExactlyOne
    if atom_end < chars.length() {
      match chars[atom_end] {
        '*' => {
          quantifier = ZeroOrMore
          index = atom_end + 1
        }
        '+' => {
          quantifier = OneOrMore
          index = atom_end + 1
        }
        '?' => {
          quantifier = ZeroOrOne
          index = atom_end + 1
        }
        _ => index = atom_end
      }
    } else {
      index = atom_end
    }
    tokens.push({ atom, quantifier })
  }
  if stop_char is Some(_) {
    None
  } else {
    Some((tokens, index, next_capture_index))
  }
}

///|
fn tiled_world_parse_pattern_atom(
  chars : Array[Char],
  start_index : Int,
  capture_index : Int,
) -> (TiledPatternAtom, Int, Int)? {
  if start_index >= chars.length() {
    return None
  }
  match chars[start_index] {
    '(' => {
      let mut group_capture : Int? = Some(capture_index + 1)
      let mut group_start = start_index + 1
      if group_start + 1 < chars.length() &&
        chars[group_start] == '?' &&
        chars[group_start + 1] == ':' {
        group_capture = None
        group_start += 2
      }
      let inner_capture_index = match group_capture {
        Some(index) => index
        None => capture_index
      }
      guard tiled_world_parse_pattern_tokens(
          chars,
          group_start,
          inner_capture_index,
          Some(')'),
        )
        is Some((group_tokens, next_index, updated_capture_index)) else {
        return None
      }
      Some(
        (Group(group_tokens, group_capture), next_index, updated_capture_index),
      )
    }
    '[' =>
      if tiled_world_parse_pattern_char_class(chars, start_index)
        is Some((negated, ranges, next_index)) {
        Some((CharClass(negated, ranges), next_index, capture_index))
      } else {
        None
      }
    '\\' =>
      if tiled_world_parse_escape_atom(chars, start_index)
        is Some((atom, next_index)) {
        Some((atom, next_index, capture_index))
      } else {
        None
      }
    '^' | '$' => Some((Empty, start_index + 1, capture_index))
    '.' => Some((AnyChar, start_index + 1, capture_index))
    '|' | '{' | '}' | ')' => None
    ch => Some((Literal(ch), start_index + 1, capture_index))
  }
}

///|
fn tiled_world_parse_escape_atom(
  chars : Array[Char],
  start_index : Int,
) -> (TiledPatternAtom, Int)? {
  if start_index + 1 >= chars.length() {
    return None
  }
  let escaped = chars[start_index + 1]
  match escaped {
    'd' => Some((Digit, start_index + 2))
    'D' => Some((CharClass(true, [('0', '9')]), start_index + 2))
    's' => Some((Space, start_index + 2))
    'S' => Some((CharClass(true, tiled_world_space_ranges()), start_index + 2))
    'w' => Some((Word, start_index + 2))
    'W' => Some((CharClass(true, tiled_world_word_ranges()), start_index + 2))
    ch => Some((Literal(ch), start_index + 2))
  }
}

///|
fn tiled_world_parse_pattern_char_class(
  chars : Array[Char],
  start_index : Int,
) -> (Bool, Array[(Char, Char)], Int)? {
  let mut index = start_index + 1
  let mut negated = false
  if index < chars.length() && chars[index] == '^' {
    negated = true
    index += 1
  }
  let ranges : Array[(Char, Char)] = []
  let mut has_content = false
  while index < chars.length() {
    if chars[index] == ']' && has_content {
      return Some((negated, ranges, index + 1))
    }
    has_content = true
    guard tiled_world_parse_pattern_class_piece(chars, index)
      is Some((left, after_left)) else {
      return None
    }
    if left is Char(left_char) &&
      after_left + 1 < chars.length() &&
      chars[after_left] == '-' &&
      chars[after_left + 1] != ']' &&
      tiled_world_parse_pattern_class_piece(chars, after_left + 1)
      is Some((right, after_right)) {
      if right is Char(right_char) {
        ranges.push((left_char, right_char))
      } else {
        ranges.push((left_char, left_char))
        ranges.push(('-', '-'))
        tiled_world_push_pattern_class_piece_ranges(ranges, right)
      }
      index = after_right
      continue
    }
    tiled_world_push_pattern_class_piece_ranges(ranges, left)
    index = after_left
  }
  None
}

///|
fn tiled_world_parse_pattern_class_piece(
  chars : Array[Char],
  start_index : Int,
) -> (TiledPatternClassPiece, Int)? {
  if start_index >= chars.length() {
    return None
  }
  let ch = chars[start_index]
  if ch != '\\' {
    return Some((Char(ch), start_index + 1))
  }
  if start_index + 1 >= chars.length() {
    return None
  }
  match chars[start_index + 1] {
    'd' => Some((Ranges([('0', '9')]), start_index + 2))
    's' => Some((Ranges(tiled_world_space_ranges()), start_index + 2))
    'w' => Some((Ranges(tiled_world_word_ranges()), start_index + 2))
    escaped => Some((Char(escaped), start_index + 2))
  }
}

///|
fn tiled_world_push_pattern_class_piece_ranges(
  ranges : Array[(Char, Char)],
  piece : TiledPatternClassPiece,
) -> Unit {
  match piece {
    Char(ch) => ranges.push((ch, ch))
    Ranges(more) =>
      for range in more {
        ranges.push(range)
      }
  }
}

///|
fn tiled_world_word_ranges() -> Array[(Char, Char)] {
  [('a', 'z'), ('A', 'Z'), ('0', '9'), ('_', '_')]
}

///|
fn tiled_world_space_ranges() -> Array[(Char, Char)] {
  [
    (' ', ' '),
    ('\n', '\n'),
    ('\r', '\r'),
    ('\t', '\t'),
    ('\u{0b}', '\u{0b}'),
    ('\f', '\f'),
  ]
}

///|
fn tiled_world_match_pattern_regex(
  regex : TiledWorldPatternRegex,
  file_name : String,
) -> (Int, Int)? {
  let chars = file_name.to_array()
  let captures = tiled_world_empty_captures(regex.capture_count)
  guard tiled_world_match_pattern_tokens(
      regex.tokens,
      0,
      chars,
      file_name,
      0,
      captures,
    )
    is Some((next_position, matched_captures)) else {
    return None
  }
  if next_position != chars.length() || matched_captures.length() < 3 {
    return None
  }
  guard matched_captures[1] is Some(raw_x) else { return None }
  guard matched_captures[2] is Some(raw_y) else { return None }
  guard tiled_world_capture_int(raw_x) is Some(x) else { return None }
  guard tiled_world_capture_int(raw_y) is Some(y) else { return None }
  Some((x, y))
}

///|
fn tiled_world_empty_captures(capture_count : Int) -> Array[String?] {
  let captures : Array[String?] = []
  let mut index = 0
  while index <= capture_count {
    captures.push(None)
    index += 1
  }
  captures
}

///|
fn tiled_world_clone_captures(captures : Array[String?]) -> Array[String?] {
  captures.map(item => item)
}

///|
fn tiled_world_match_pattern_tokens(
  tokens : Array[TiledPatternToken],
  token_index : Int,
  chars : Array[Char],
  source : String,
  position : Int,
  captures : Array[String?],
) -> (Int, Array[String?])? {
  if token_index >= tokens.length() {
    return Some((position, captures))
  }
  let token = tokens[token_index]
  let min_repeat = match token.quantifier {
    ExactlyOne => 1
    OneOrMore => 1
    ZeroOrOne => 0
    ZeroOrMore => 0
  }
  let max_repeat = match token.quantifier {
    ExactlyOne => 1
    ZeroOrOne => 1
    OneOrMore => chars.length() - position + 1
    ZeroOrMore => chars.length() - position + 1
  }
  let states : Array[(Int, Array[String?])] = [(position, captures)]
  let mut repeat_count = 0
  while repeat_count < max_repeat {
    let state = states[states.length() - 1]
    guard tiled_world_match_pattern_atom_once(
        token.atom,
        chars,
        source,
        state.0,
        state.1,
      )
      is Some((next_position, next_captures)) else {
      break
    }
    states.push((next_position, next_captures))
    repeat_count += 1
    if next_position == state.0 {
      break
    }
  }
  let mut count = states.length() - 1
  while true {
    if count >= min_repeat &&
      tiled_world_match_pattern_tokens(
        tokens,
        token_index + 1,
        chars,
        source,
        states[count].0,
        states[count].1,
      )
      is Some(result) {
      return Some(result)
    }
    if count == 0 {
      break
    }
    count -= 1
  }
  None
}

///|
fn tiled_world_match_pattern_atom_once(
  atom : TiledPatternAtom,
  chars : Array[Char],
  source : String,
  position : Int,
  captures : Array[String?],
) -> (Int, Array[String?])? {
  match atom {
    Empty => Some((position, tiled_world_clone_captures(captures)))
    Literal(expected) =>
      if position < chars.length() && chars[position] == expected {
        Some((position + 1, tiled_world_clone_captures(captures)))
      } else {
        None
      }
    AnyChar =>
      if position < chars.length() {
        Some((position + 1, tiled_world_clone_captures(captures)))
      } else {
        None
      }
    Digit =>
      if position < chars.length() && tiled_world_is_digit_char(chars[position]) {
        Some((position + 1, tiled_world_clone_captures(captures)))
      } else {
        None
      }
    Space =>
      if position < chars.length() && tiled_world_is_space_char(chars[position]) {
        Some((position + 1, tiled_world_clone_captures(captures)))
      } else {
        None
      }
    Word =>
      if position < chars.length() && tiled_world_is_word_char(chars[position]) {
        Some((position + 1, tiled_world_clone_captures(captures)))
      } else {
        None
      }
    CharClass(negated, ranges) =>
      if position < chars.length() {
        let in_class = tiled_world_char_in_ranges(chars[position], ranges)
        if in_class != negated {
          Some((position + 1, tiled_world_clone_captures(captures)))
        } else {
          None
        }
      } else {
        None
      }
    Group(group_tokens, capture_index) => {
      guard tiled_world_match_pattern_tokens(
          group_tokens,
          0,
          chars,
          source,
          position,
          tiled_world_clone_captures(captures),
        )
        is Some((next_position, group_captures)) else {
        return None
      }
      if capture_index is Some(index) && index < group_captures.length() {
        group_captures[index] = Some(source[position:next_position].to_string())
      }
      Some((next_position, group_captures))
    }
  }
}

///|
fn tiled_world_char_in_ranges(ch : Char, ranges : Array[(Char, Char)]) -> Bool {
  for range in ranges {
    if ch >= range.0 && ch <= range.1 {
      return true
    }
  }
  false
}

///|
fn tiled_world_is_digit_char(ch : Char) -> Bool {
  ch >= '0' && ch <= '9'
}

///|
fn tiled_world_is_space_char(ch : Char) -> Bool {
  ch == ' ' ||
  ch == '\n' ||
  ch == '\r' ||
  ch == '\t' ||
  ch == '\u{0b}' ||
  ch == '\f'
}

///|
fn tiled_world_is_word_char(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') ||
  (ch >= 'A' && ch <= 'Z') ||
  tiled_world_is_digit_char(ch) ||
  ch == '_'
}

///|
fn tiled_world_capture_int(source : String) -> Int? {
  let parsed : Result[Int, Error] = try? @string.parse_int(source[:])
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn tiled_world_load_maps(world : TiledWorld) -> Array[LoadedTiledWorldMap] {
  let loaded_maps : Array[LoadedTiledWorldMap] = []
  for world_map in tiled_world_collect_maps(world) {
    let resolved_map_path = world.resolve_map_path(world_map.file_name)
    let map = load_tiled_map(resolved_map_path)
    loaded_maps.push({ world_map, resolved_map_path, map })
  }
  loaded_maps
}

///|
fn tiled_world_should_spawn_map(
  loaded_maps : Array[LoadedTiledWorldMap],
  candidate : LoadedTiledWorldMap,
  focus_path : String?,
  world : TiledWorld,
) -> Bool {
  if !world.only_show_adjacent_maps {
    return true
  }
  guard focus_path is Some(target_path) else { return true }
  let mut focus_map : LoadedTiledWorldMap? = None
  for item in loaded_maps {
    if item.resolved_map_path == target_path {
      focus_map = Some(item)
      break
    }
  }
  guard focus_map is Some(focus_map) else { return true }
  if candidate.resolved_map_path == target_path {
    return true
  }
  tiled_world_maps_touch_or_overlap(focus_map, candidate)
}

///|
fn tiled_world_maps_touch_or_overlap(
  left_map : LoadedTiledWorldMap,
  right_map : LoadedTiledWorldMap,
) -> Bool {
  let left = tiled_world_map_bounds(left_map)
  let right = tiled_world_map_bounds(right_map)
  left.0 <= right.2 &&
  left.2 >= right.0 &&
  left.1 <= right.3 &&
  left.3 >= right.1
}

///|
fn tiled_world_map_bounds(
  loaded_map : LoadedTiledWorldMap,
) -> (Int, Int, Int, Int) {
  let width = loaded_map.world_map.width.unwrap_or(
    loaded_map.map.width * loaded_map.map.tile_width,
  )
  let height = loaded_map.world_map.height.unwrap_or(
    loaded_map.map.height * loaded_map.map.tile_height,
  )
  (
    loaded_map.world_map.x,
    loaded_map.world_map.y,
    loaded_map.world_map.x + width,
    loaded_map.world_map.y + height,
  )
}
