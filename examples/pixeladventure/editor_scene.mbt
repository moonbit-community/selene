///|
let pixeladventure_player_component_kind : String = "PixelAdventurePlayer"

///|
let pixeladventure_bird_component_kind : String = "PixelAdventureBird"

///|
let pixeladventure_apple_component_kind : String = "PixelAdventureApple"

///|
let pixeladventure_flag_component_kind : String = "PixelAdventureFlag"

///|
let pixeladventure_terrain_component_kind : String = "PixelAdventureTerrain"

///|
let terrain_tile_size : Int = 16

///|
priv struct PixelAdventurePlayerComponent {} derive(FromJson)

///|
priv struct PixelAdventureBirdComponent {} derive(FromJson)

///|
priv struct PixelAdventureAppleComponent {} derive(FromJson)

///|
priv struct PixelAdventureFlagComponent {} derive(FromJson)

///|
priv struct PixelAdventureTerrainComponent {
  solid : Bool
  collider_group : String
} derive(FromJson)

///|
priv struct TerrainPlacement {
  tile_x : Int
  tile_y : Int
  solid : Bool
  collider_group : String
}

///|
priv struct LoadedLevelScene {
  player_entity : @entity.Entity
  camera_entity : @entity.Entity
  world_size : @math.Vec2D
}

///|
priv struct PixelAdventureProjectContext {
  root : String
  manifest : @editor_bridge.ProjectManifest
}

fn path_join(base : String, child : String) -> String {
  if child.has_prefix("/") {
    child
  } else if base == "" {
    child
  } else if base.has_suffix("/") {
    base + child
  } else {
    base + "/" + child
  }
}

fn read_json_asset(path : String) -> Json? {
  guard @asset.read_bytes(path) is Some(bytes) else {
    return None
  }
  let source = bytes.to_unchecked_string()
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  match parsed {
    Ok(json) => Some(json)
    Err(_) => None
  }
}

fn validation_error_string(errors : Array[@editor_bridge.ValidationError]) -> String {
  errors.to_json().stringify()
}

fn pixeladventure_project_root_candidates() -> Array[String] {
  let suffixes = ["", "pixeladventure", "examples/pixeladventure"]
  let roots : Array[String] = []
  let mut depth = 0
  while depth <= 8 {
    let mut prefix = "."
    let mut index = 0
    while index < depth {
      prefix = path_join(prefix, "..")
      index += 1
    }
    for suffix in suffixes {
      let candidate = if suffix == "" {
        prefix
      } else {
        path_join(prefix, suffix)
      }
      roots.push(candidate)
    }
    depth += 1
  }
  roots
}

fn load_pixeladventure_project_context() -> PixelAdventureProjectContext {
  let manifest_name = @editor_bridge.project_manifest_file_name("")
  let roots = pixeladventure_project_root_candidates()
  for root in roots {
    let manifest_path = path_join(root, manifest_name)
    guard read_json_asset(manifest_path) is Some(json) else {
      continue
    }
    let manifest : @editor_bridge.ProjectManifest = try {
      @json.from_json(json)
    } catch {
      err =>
        abort(
          "Failed to decode pixeladventure project manifest at " +
          manifest_path + ": " + err.to_string(),
        )
    }
    let errors = @editor_bridge.validate_project_manifest(manifest)
    guard errors.is_empty() else {
      abort(
        "Failed to validate pixeladventure project manifest at " +
        manifest_path + ": " + validation_error_string(errors),
      )
    }
    return {
      root,
      manifest,
    }
  }
  if @env.current_dir() is Some(_) {
    for root in roots {
      let manifest_path = path_join(root, manifest_name)
      let manifest_result : Result[@editor_bridge.ProjectManifest, Error] = try?
        @editor_bridge.read_project_manifest(manifest_path)
      match manifest_result {
        Ok(manifest) => return { root, manifest }
        Err(_) => ()
      }
    }
  }
  abort(
    "Failed to locate pixeladventure project manifest. Tried: " +
    roots.join(", "),
  )
}

fn load_pixeladventure_scene_document(
  project : PixelAdventureProjectContext,
) -> @editor_bridge.SceneDocument {
  let scene_path = path_join(project.root, project.manifest.startup_scene)
  if read_json_asset(scene_path) is Some(json) {
    let scene : @editor_bridge.SceneDocument = try {
      @json.from_json(json)
    } catch {
      err => abort("Failed to decode pixeladventure startup scene: " + err.to_string())
    }
    let errors = @editor_bridge.validate_scene_document(scene)
    guard errors.is_empty() else {
      abort(
        "Failed to validate pixeladventure startup scene " + scene_path + ": " +
        validation_error_string(errors),
      )
    }
    return scene
  }
  if @env.current_dir() is Some(_) {
    let fallback : Result[@editor_bridge.SceneDocument, Error] = try?
      @editor_bridge.read_scene_document(scene_path)
    match fallback {
      Ok(scene) => return scene
      Err(_) => ()
    }
  }
  abort("Failed to read pixeladventure startup scene bytes: " + scene_path)
}

fn decode_atlas_asset_document(
  path : String,
  json : Json,
) -> @editor_bridge.AtlasAssetDocument {
  let atlas : @editor_bridge.AtlasAssetDocument = try {
    @json.from_json(json)
  } catch {
    err => abort("Failed to decode atlas asset " + path + ": " + err.to_string())
  }
  let errors = @editor_bridge.validate_atlas_asset_document(atlas)
  guard errors.is_empty() else {
    abort(
      "Failed to validate atlas asset " + path + ": " +
      validation_error_string(errors),
    )
  }
  atlas
}

fn decode_animation_asset_document(
  path : String,
  json : Json,
) -> @editor_bridge.AnimationAssetDocument {
  let animation : @editor_bridge.AnimationAssetDocument = try {
    @json.from_json(json)
  } catch {
    err => abort("Failed to decode animation asset " + path + ": " + err.to_string())
  }
  let errors = @editor_bridge.validate_animation_asset_document(animation)
  guard errors.is_empty() else {
    abort(
      "Failed to validate animation asset " + path + ": " +
      validation_error_string(errors),
    )
  }
  animation
}

///|
pub fn pixeladventure_startup_scene_document() -> @editor_bridge.SceneDocument {
  load_pixeladventure_scene_document(load_pixeladventure_project_context())
}

fn push_unique_path(paths : Array[String], path : String?) -> Unit {
  guard path is Some(value) else {
    return
  }
  guard value != "" && !paths.contains(value) else {
    return
  }
  paths.push(value)
}

fn scene_referenced_animation_assets(
  scene : @editor_bridge.SceneDocument,
) -> Array[String] {
  let paths : Array[String] = []
  for entity in scene.entities {
    if entity.component("AnimationPlayer") is Some(component) {
      let decoded : @editor_bridge.AnimationPlayerComponent? =
        @editor_bridge.decode_component(Some(component))
      match decoded {
        Some(data) => push_unique_path(paths, data.animation_asset_path)
        None => ()
      }
    }
  }
  paths
}

fn scene_referenced_atlas_assets(
  scene : @editor_bridge.SceneDocument,
) -> Array[String] {
  let paths : Array[String] = []
  for entity in scene.entities {
    if entity.component("TextureAtlas") is Some(component) {
      let decoded : @editor_bridge.TextureAtlasComponent? =
        @editor_bridge.decode_component(Some(component))
      match decoded {
        Some(data) => push_unique_path(paths, data.atlas_asset_path)
        None => ()
      }
    }
  }
  paths
}

fn animation_referenced_atlas_assets(
  animations : Map[String, @editor_bridge.AnimationAssetDocument],
) -> Array[String] {
  let paths : Array[String] = []
  for _, animation in animations {
    if animation.atlas_asset_path != "" &&
      !paths.contains(animation.atlas_asset_path) {
      paths.push(animation.atlas_asset_path)
    }
  }
  paths
}

///|
fn load_pixeladventure_atlas_assets(
  root : String,
  scene : @editor_bridge.SceneDocument,
  animations : Map[String, @editor_bridge.AnimationAssetDocument],
) -> Map[String, @editor_bridge.AtlasAssetDocument] {
  let assets : Map[String, @editor_bridge.AtlasAssetDocument] = {}
  let paths = scene_referenced_atlas_assets(scene)
  for path in animation_referenced_atlas_assets(animations) {
    if !paths.contains(path) {
      paths.push(path)
    }
  }
  for relative_path in paths {
    let atlas_path = path_join(root, relative_path)
    if read_json_asset(atlas_path) is Some(json) {
      assets.set(relative_path, decode_atlas_asset_document(atlas_path, json))
      continue
    }
    if @env.current_dir() is Some(_) {
      let fallback : Result[@editor_bridge.AtlasAssetDocument, Error] = try?
        @editor_bridge.read_atlas_asset_document(atlas_path)
      match fallback {
        Ok(atlas) => {
          assets.set(relative_path, atlas)
          continue
        }
        Err(_) => ()
      }
    }
    abort("Failed to read atlas asset bytes: " + atlas_path)
  }
  assets
}

///|
fn load_pixeladventure_animation_assets(
  root : String,
  scene : @editor_bridge.SceneDocument,
) -> Map[String, @editor_bridge.AnimationAssetDocument] {
  let assets : Map[String, @editor_bridge.AnimationAssetDocument] = {}
  let paths = scene_referenced_animation_assets(scene)
  for relative_path in paths {
    let animation_path = path_join(root, relative_path)
    if read_json_asset(animation_path) is Some(json) {
      assets.set(
        relative_path,
        decode_animation_asset_document(animation_path, json),
      )
      continue
    }
    if @env.current_dir() is Some(_) {
      let fallback : Result[@editor_bridge.AnimationAssetDocument, Error] = try?
        @editor_bridge.read_animation_asset_document(animation_path)
      match fallback {
        Ok(animation) => {
          assets.set(relative_path, animation)
          continue
        }
        Err(_) => ()
      }
    }
    abort("Failed to read animation asset bytes: " + animation_path)
  }
  assets
}

///|
fn set_entity_z(entity : @entity.Entity, z : Double) -> Unit {
  let transform = @transform.transforms().get(entity).unwrap_or(
    @transform.Transform::identity(),
  )
  @transform.transforms().set(
    entity,
    transform.with_translation(
      @math.Vec3::new(
        transform.translation.x,
        transform.translation.y,
        z,
      ),
    ),
  )
}

///|
fn apply_pixeladventure_player_component(
  entity : @entity.Entity,
  component : @editor_bridge.ComponentDocument,
  _context : @editor_bridge.AssetInstantiationContext,
) -> Unit {
  let parsed : PixelAdventurePlayerComponent? = @editor_bridge.decode_component(
    Some(component),
  )
  guard parsed is Some(_) else {
    return
  }
  configure_player_entity(entity)
}

///|
fn apply_pixeladventure_bird_component(
  entity : @entity.Entity,
  component : @editor_bridge.ComponentDocument,
  _context : @editor_bridge.AssetInstantiationContext,
) -> Unit {
  let parsed : PixelAdventureBirdComponent? = @editor_bridge.decode_component(
    Some(component),
  )
  guard parsed is Some(_) else {
    return
  }
  configure_bird_entity(entity)
}

///|
fn apply_pixeladventure_apple_component(
  entity : @entity.Entity,
  component : @editor_bridge.ComponentDocument,
  _context : @editor_bridge.AssetInstantiationContext,
) -> Unit {
  let parsed : PixelAdventureAppleComponent? = @editor_bridge.decode_component(
    Some(component),
  )
  guard parsed is Some(_) else {
    return
  }
  configure_apple_entity(entity)
}

///|
fn apply_pixeladventure_flag_component(
  entity : @entity.Entity,
  component : @editor_bridge.ComponentDocument,
  _context : @editor_bridge.AssetInstantiationContext,
) -> Unit {
  let parsed : PixelAdventureFlagComponent? = @editor_bridge.decode_component(
    Some(component),
  )
  guard parsed is Some(_) else {
    return
  }
  configure_flag_entity(entity)
}

///|
fn apply_pixeladventure_terrain_component(
  entity : @entity.Entity,
  component : @editor_bridge.ComponentDocument,
  _context : @editor_bridge.AssetInstantiationContext,
) -> Unit {
  let parsed : PixelAdventureTerrainComponent? = @editor_bridge.decode_component(
    Some(component),
  )
  guard parsed is Some(_) else {
    return
  }
  set_entity_z(entity, PLAYER_Z)
}

///|
fn pixeladventure_custom_component_appliers() -> Map[
  String,
  @editor_bridge.CustomComponentApplier,
] {
  let appliers : Map[String, @editor_bridge.CustomComponentApplier] = {}
  appliers.set(
    pixeladventure_player_component_kind,
    apply_pixeladventure_player_component,
  )
  appliers.set(
    pixeladventure_bird_component_kind,
    apply_pixeladventure_bird_component,
  )
  appliers.set(
    pixeladventure_apple_component_kind,
    apply_pixeladventure_apple_component,
  )
  appliers.set(
    pixeladventure_flag_component_kind,
    apply_pixeladventure_flag_component,
  )
  appliers.set(
    pixeladventure_terrain_component_kind,
    apply_pixeladventure_terrain_component,
  )
  appliers
}

///|
fn scene_entity_ids_with_component(
  scene : @editor_bridge.SceneDocument,
  kind : String,
) -> Array[String] {
  let ids : Array[String] = []
  for entity in scene.entities {
    if entity.component(kind) is Some(_) {
      ids.push(entity.id)
    }
  }
  ids
}

///|
fn require_single_scene_entity_id(
  scene : @editor_bridge.SceneDocument,
  kind : String,
  label : String,
) -> String {
  let ids = scene_entity_ids_with_component(scene, kind)
  guard ids.length() == 1 else {
    abort(label + " count mismatch: " + ids.length().to_string())
  }
  ids[0]
}

///|
fn terrain_placements_from_scene(
  scene : @editor_bridge.SceneDocument,
) -> Array[TerrainPlacement] {
  let placements : Array[TerrainPlacement] = []
  for entity in scene.entities {
    guard entity.component(pixeladventure_terrain_component_kind) is Some(
      terrain_component,
    ) else {
      continue
    }
    let terrain_data : PixelAdventureTerrainComponent = match
      @editor_bridge.decode_component(Some(terrain_component)) {
      Some(data) => data
      None => continue
    }
    let transform = @editor_bridge.decoded_transform(entity)
    placements.push({
      tile_x: (transform.translation.x / terrain_tile_size.to_double()).to_int(),
      tile_y: (transform.translation.y / terrain_tile_size.to_double()).to_int(),
      solid: terrain_data.solid,
      collider_group: terrain_data.collider_group,
    })
  }
  placements
}

///|
fn scene_world_size(
  scene : @editor_bridge.SceneDocument,
) -> @math.Vec2D {
  let placements = terrain_placements_from_scene(scene)
  guard !placements.is_empty() else {
    return @math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
  }
  let mut max_x = 0
  let mut max_y = 0
  for placement in placements {
    if placement.tile_x > max_x {
      max_x = placement.tile_x
    }
    if placement.tile_y > max_y {
      max_y = placement.tile_y
    }
  }
  @math.Vec2D(
    (max_x + 1).to_double() * terrain_tile_size.to_double(),
    (max_y + 1).to_double() * terrain_tile_size.to_double(),
  )
}

///|
fn build_terrain_colliders_from_scene(scene : @editor_bridge.SceneDocument) -> Unit {
  let rows : Map[Int, Array[Int]] = {}
  for placement in terrain_placements_from_scene(scene) {
    if !placement.solid || placement.collider_group != "grass" {
      continue
    }
    rows.get_or_init(placement.tile_y, fn() { [] }).push(placement.tile_x)
  }
  let tile_size_d = terrain_tile_size.to_double()
  for y, columns in rows {
    columns.sort()
    let mut cursor = 0
    while cursor < columns.length() {
      let start_x = columns[cursor]
      let mut end_x = start_x
      cursor += 1
      while cursor < columns.length() && columns[cursor] == end_x + 1 {
        end_x = columns[cursor]
        cursor += 1
      }
      spawn_terrain_collider(
        @math.Vec2D(
          start_x.to_double() * tile_size_d,
          y.to_double() * tile_size_d,
        ),
        @math.Vec2D(
          (end_x - start_x + 1).to_double() * tile_size_d,
          tile_size_d,
        ),
      )
    }
  }
}

///|
fn load_level_scene() -> LoadedLevelScene {
  let project = load_pixeladventure_project_context()
  let root = project.root
  let scene = load_pixeladventure_scene_document(project)
  let animation_assets = load_pixeladventure_animation_assets(root, scene)
  let atlas_assets = load_pixeladventure_atlas_assets(
    root,
    scene,
    animation_assets,
  )
  let context = @editor_bridge.asset_instantiation_context(
    atlas_assets=atlas_assets,
    animation_assets=animation_assets,
    custom_component_appliers=pixeladventure_custom_component_appliers(),
  )
  let runtime = @editor_bridge.instantiate_scene_document_with_context(
    scene,
    context,
  )
  let player_entity = runtime.entity(
    require_single_scene_entity_id(
      scene,
      pixeladventure_player_component_kind,
      "PixelAdventurePlayer",
    ),
  ).unwrap_or_else(fn() { panic() })
  let camera_entity = runtime.entity(
    require_single_scene_entity_id(scene, "Camera2d", "Camera2d"),
  ).unwrap_or_else(fn() { panic() })
  let world_size = scene_world_size(scene)
  build_terrain_colliders_from_scene(scene)
  {
    player_entity,
    camera_entity,
    world_size,
  }
}
