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
    let candidates = try {
      @editor_bridge.project_manifest_candidates(root)
    } catch {
      _ => []
    }
    if candidates.is_empty() {
      continue
    }
    let manifest_path = path_join(root, manifest_name)
    let manifest = try {
      @editor_bridge.read_project_manifest(manifest_path)
    } catch {
      err =>
        abort(
          "Failed to read pixeladventure project manifest at " +
          manifest_path + ": " + err.to_string(),
        )
    }
    return {
      root,
      manifest,
    }
  }
  abort(
    "Failed to locate pixeladventure project manifest. Tried: " +
    roots.join(", "),
  )
}

///|
fn pixeladventure_startup_scene_document() -> @editor_bridge.SceneDocument {
  let context = load_pixeladventure_project_context()
  let scene_path = path_join(context.root, context.manifest.startup_scene)
  try {
    @editor_bridge.read_scene_document(scene_path)
  } catch {
    err => abort("Failed to read pixeladventure startup scene: " + err.to_string())
  }
}

///|
fn load_pixeladventure_atlas_assets(
  root : String,
) -> Map[String, @editor_bridge.AtlasAssetDocument] {
  let assets : Map[String, @editor_bridge.AtlasAssetDocument] = {}
  let refs = try {
    @editor_bridge.list_atlas_assets(root)
  } catch {
    err => abort("Failed to list atlas assets: " + err.to_string())
  }
  for atlas_ref in refs {
    let atlas_path = path_join(root, atlas_ref.path)
    let asset = try {
      @editor_bridge.read_atlas_asset_document(atlas_path)
    } catch {
      err =>
        abort(
          "Failed to read atlas asset " + atlas_ref.path + ": " +
          err.to_string(),
        )
    }
    assets.set(atlas_ref.path, asset)
  }
  assets
}

///|
fn load_pixeladventure_animation_assets(
  root : String,
) -> Map[String, @editor_bridge.AnimationAssetDocument] {
  let assets : Map[String, @editor_bridge.AnimationAssetDocument] = {}
  let refs = try {
    @editor_bridge.list_animation_assets(root)
  } catch {
    err => abort("Failed to list animation assets: " + err.to_string())
  }
  for animation_ref in refs {
    let animation_path = path_join(root, animation_ref.path)
    let asset = try {
      @editor_bridge.read_animation_asset_document(animation_path)
    } catch {
      err =>
        abort(
          "Failed to read animation asset " + animation_ref.path + ": " +
          err.to_string(),
        )
    }
    assets.set(animation_ref.path, asset)
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
  let scene = pixeladventure_startup_scene_document()
  let context = @editor_bridge.asset_instantiation_context(
    atlas_assets=load_pixeladventure_atlas_assets(root),
    animation_assets=load_pixeladventure_animation_assets(root),
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
