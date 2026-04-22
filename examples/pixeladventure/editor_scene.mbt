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
} derive(FromJson, ToJson)

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
  world_size : @math.Vec2
}

///|
fn pixeladventure_empty_component_data() -> Json {
  @editor_bridge.default_custom_component_data()
}

///|
fn terrain_component_default_data() -> Json {
  PixelAdventureTerrainComponent::{ solid: false, collider_group: "grass" }.to_json()
}

///|
fn[T : @json.FromJson] validate_pixeladventure_component(
  component : @editor_bridge.ComponentDocument,
  path : String,
  label : String,
) -> Result[T, Array[@editor_bridge.ValidationError]] {
  @editor_bridge.validate_custom_component_payload(
    component,
    path,
    label + " payload is invalid",
  )
}

///|
fn validate_pixeladventure_terrain_component(
  component : @editor_bridge.ComponentDocument,
  path : String,
) -> Array[@editor_bridge.ValidationError] {
  let decoded : Result[
    PixelAdventureTerrainComponent,
    Array[@editor_bridge.ValidationError],
  ] = validate_pixeladventure_component(
    component, path, "PixelAdventureTerrain",
  )
  match decoded {
    Ok(data) =>
      if data.collider_group.trim() == "" {
        [
          @editor_bridge.validation_error(
            path + ".collider_group",
            "PixelAdventureTerrain collider_group must not be empty",
          ),
        ]
      } else {
        []
      }
    Err(errors) => errors
  }
}

///|
fn pixeladventure_runtime_document_source() -> @editor_bridge.DocumentSource {
  fn(path : String) {
    let normalized = path.replace(old="\\", new="/")
    @asset.read_bytes(normalized)
  }
}

///|
fn load_pixeladventure_project_bundle_with_source(
  source : @editor_bridge.DocumentSource,
  manifest_path? : String = @editor_bridge.project_manifest_file_name(""),
) -> @editor_bridge.ProjectBundle {
  @editor_bridge.load_project_bundle(source, manifest_path~) catch {
    @editor_bridge.MissingDocument(path) =>
      abort("Missing pixeladventure document: " + path)
    @editor_bridge.InvalidProjectManifest(message) =>
      abort("Invalid pixeladventure project manifest: " + message)
    @editor_bridge.InvalidSceneDocument(message) =>
      abort("Invalid pixeladventure startup scene: " + message)
    @editor_bridge.InvalidAtlasAssetDocument(message) =>
      abort("Invalid pixeladventure atlas asset: " + message)
    @editor_bridge.InvalidAnimationClipAssetDocument(message) =>
      abort("Invalid pixeladventure animation clip asset: " + message)
    @editor_bridge.InvalidAnimationGraphAssetDocument(message) =>
      abort("Invalid pixeladventure animation graph asset: " + message)
    err =>
      abort("Failed to load pixeladventure scene bundle: " + err.to_string())
  }
}

///|
pub fn pixeladventure_startup_scene_document_with_source(
  source : @editor_bridge.DocumentSource,
  manifest_path? : String = @editor_bridge.project_manifest_file_name(""),
) -> @editor_bridge.SceneDocument {
  load_pixeladventure_project_bundle_with_source(source, manifest_path~).scene
}

///|
pub fn pixeladventure_startup_scene_document() -> @editor_bridge.SceneDocument {
  pixeladventure_startup_scene_document_with_source(
    pixeladventure_runtime_document_source(),
  )
}

///|
fn set_entity_z(entity : @entity.Entity, z : Double) -> Unit {
  let transform = @transform.transforms()
    .get(entity)
    .unwrap_or(@transform.Transform::identity())
  @transform.transforms().set(
    entity,
    transform.with_translation(
      @math.Vec3::new(transform.translation.x, transform.translation.y, z),
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
  guard parsed is Some(_) else { return }
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
  guard parsed is Some(_) else { return }
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
  guard parsed is Some(_) else { return }
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
  guard parsed is Some(_) else { return }
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
  guard parsed is Some(_) else { return }
  set_entity_z(entity, PLAYER_Z)
}

///|
fn pixeladventure_custom_component_handlers() -> Map[
  String,
  @editor_bridge.CustomComponentHandler,
] {
  let handlers : Map[String, @editor_bridge.CustomComponentHandler] = {}
  handlers.set(
    pixeladventure_player_component_kind,
    @editor_bridge.custom_component_handler(
      default_data=pixeladventure_empty_component_data,
      validate=fn(component, path) {
        let decoded : Result[
          PixelAdventurePlayerComponent,
          Array[@editor_bridge.ValidationError],
        ] = validate_pixeladventure_component(
          component, path, "PixelAdventurePlayer",
        )
        match decoded {
          Ok(_) => []
          Err(errors) => errors
        }
      },
      apply=apply_pixeladventure_player_component,
    ),
  )
  handlers.set(
    pixeladventure_bird_component_kind,
    @editor_bridge.custom_component_handler(
      default_data=pixeladventure_empty_component_data,
      validate=fn(component, path) {
        let decoded : Result[
          PixelAdventureBirdComponent,
          Array[@editor_bridge.ValidationError],
        ] = validate_pixeladventure_component(
          component, path, "PixelAdventureBird",
        )
        match decoded {
          Ok(_) => []
          Err(errors) => errors
        }
      },
      apply=apply_pixeladventure_bird_component,
    ),
  )
  handlers.set(
    pixeladventure_apple_component_kind,
    @editor_bridge.custom_component_handler(
      default_data=pixeladventure_empty_component_data,
      validate=fn(component, path) {
        let decoded : Result[
          PixelAdventureAppleComponent,
          Array[@editor_bridge.ValidationError],
        ] = validate_pixeladventure_component(
          component, path, "PixelAdventureApple",
        )
        match decoded {
          Ok(_) => []
          Err(errors) => errors
        }
      },
      apply=apply_pixeladventure_apple_component,
    ),
  )
  handlers.set(
    pixeladventure_flag_component_kind,
    @editor_bridge.custom_component_handler(
      default_data=pixeladventure_empty_component_data,
      validate=fn(component, path) {
        let decoded : Result[
          PixelAdventureFlagComponent,
          Array[@editor_bridge.ValidationError],
        ] = validate_pixeladventure_component(
          component, path, "PixelAdventureFlag",
        )
        match decoded {
          Ok(_) => []
          Err(errors) => errors
        }
      },
      apply=apply_pixeladventure_flag_component,
    ),
  )
  handlers.set(
    pixeladventure_terrain_component_kind,
    @editor_bridge.custom_component_handler(
      default_data=terrain_component_default_data,
      validate=validate_pixeladventure_terrain_component,
      apply=apply_pixeladventure_terrain_component,
    ),
  )
  handlers
}

///|
fn register_pixeladventure_custom_components() -> Unit {
  for kind, handler in pixeladventure_custom_component_handlers() {
    @editor_bridge.register_custom_component(kind, handler)
  }
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
    guard entity.component(pixeladventure_terrain_component_kind)
      is Some(terrain_component) else {
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
fn scene_world_size(scene : @editor_bridge.SceneDocument) -> @math.Vec2 {
  let placements = terrain_placements_from_scene(scene)
  guard !placements.is_empty() else {
    return @math.Vec2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
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
  @math.Vec2(
    (max_x + 1).to_double() * terrain_tile_size.to_double(),
    (max_y + 1).to_double() * terrain_tile_size.to_double(),
  )
}

///|
fn build_terrain_colliders_from_scene(
  scene : @editor_bridge.SceneDocument,
) -> Unit {
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
        @math.Vec2(
          start_x.to_double() * tile_size_d,
          y.to_double() * tile_size_d,
        ),
        @math.Vec2((end_x - start_x + 1).to_double() * tile_size_d, tile_size_d),
      )
    }
  }
}

///|
fn load_level_scene_with_source(
  source : @editor_bridge.DocumentSource,
  manifest_path? : String = @editor_bridge.project_manifest_file_name(""),
) -> LoadedLevelScene {
  register_pixeladventure_custom_components()
  let bundle = load_pixeladventure_project_bundle_with_source(
    source,
    manifest_path~,
  )
  let scene = bundle.scene
  let context = @editor_bridge.asset_instantiation_context(
    atlas_assets=bundle.atlas_assets,
    animation_clip_assets=bundle.animation_clip_assets,
    animation_graph_assets=bundle.animation_graph_assets,
    custom_component_handlers=pixeladventure_custom_component_handlers(),
  )
  let runtime = @editor_bridge.instantiate_scene_document_with_context(
    scene, context,
  )
  let player_entity = runtime
    .entity(
      require_single_scene_entity_id(
        scene, pixeladventure_player_component_kind, "PixelAdventurePlayer",
      ),
    )
    .unwrap_or_else(fn() { panic() })
  let camera_entity = runtime
    .entity(require_single_scene_entity_id(scene, "Camera2d", "Camera2d"))
    .unwrap_or_else(fn() { panic() })
  let world_size = scene_world_size(scene)
  build_terrain_colliders_from_scene(scene)
  { player_entity, camera_entity, world_size }
}

///|
fn load_level_scene() -> LoadedLevelScene {
  load_level_scene_with_source(pixeladventure_runtime_document_source())
}
