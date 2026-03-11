///|
pub enum TiledNameFilter {
  All
  None
  Names(Array[String])
}

///|
pub fn TiledNameFilter::none() -> TiledNameFilter {
  None
}

///|
pub fn TiledNameFilter::names(names : Array[String]) -> TiledNameFilter {
  Names(names)
}

///|
pub fn TiledNameFilter::matches(self : TiledNameFilter, name : String) -> Bool {
  match self {
    All => true
    None => false
    Names(names) => names.contains(name)
  }
}

///|
pub enum TiledColliderSourceKind {
  TilesLayer
  Object
} derive(Eq)

///|
pub struct TiledPhysicsSettings {
  objects_filter : TiledNameFilter
  tiles_layer_filter : TiledNameFilter
  collision_filter : @physics2d.CollisionFilter
  sensor_filter : @physics2d.CollisionFilter
  point_radius : Double
  ellipse_segments : Int
  merge_tile_rects : Bool
  collider_hook : ((TiledColliderSpawnedEvent) -> Unit)?
}

///|
pub struct TiledColliders {
  entities : Array[@entity.Entity]
}

///|
pub fn TiledColliders::alive_entities(
  self : TiledColliders,
) -> Array[@entity.Entity] {
  self.entities.filter(fn(entity) { entity.is_alive() })
}

///|
pub struct TiledColliderOrigin {
  map_entity : @entity.Entity
  source_entity : @entity.Entity
  layer_entity : @entity.Entity
  source_kind : TiledColliderSourceKind
  layer : TiledLayer
}

///|
pub struct TiledColliderSpawnedEvent {
  collider_entity : @entity.Entity
  origin : TiledColliderOrigin
  shape : @physics2d.CollisionShape
  sensor : Bool
  properties : Array[TiledProperty]
}

///|
priv struct TiledPhysicsWorldStore {
  tiled_colliders : Map[@entity.Entity, TiledColliders]
  tiled_collider_origins : Map[@entity.Entity, TiledColliderOrigin]
}

///|
let tiled_physics_world_stores : Map[UInt, TiledPhysicsWorldStore] = Map::new()

///|
fn tiled_physics_world_store() -> TiledPhysicsWorldStore {
  let world_id = @ecs.require_current_world().id()
  tiled_physics_world_stores.get_or_init(world_id, () => {
    tiled_colliders: Map::new(),
    tiled_collider_origins: Map::new(),
  })
}

///|
pub fn tiled_colliders() -> Map[@entity.Entity, TiledColliders] {
  tiled_physics_world_store().tiled_colliders
}

///|
pub fn tiled_collider_origins() -> Map[@entity.Entity, TiledColliderOrigin] {
  tiled_physics_world_store().tiled_collider_origins
}

///|
pub let tiled_collider_spawned_event_bus : @event.Events[
  TiledColliderSpawnedEvent,
] = @event.Events::new()

///|
let tiled_default_physics_group : @physics2d.CollisionGroup = @physics2d.CollisionGroup::new()

///|
pub fn default_tiled_physics_settings() -> TiledPhysicsSettings {
  let filter = @physics2d.all_collision_layers(tiled_default_physics_group)
  {
    objects_filter: All,
    tiles_layer_filter: All,
    collision_filter: filter,
    sensor_filter: filter,
    point_radius: 1.0,
    ellipse_segments: 16,
    merge_tile_rects: true,
    collider_hook: None,
  }
}

///|
fn init {
  tiled_collider_spawned_event_bus.register()
}

///|
priv struct TiledPhysicsSpawnSpec {
  source_entity : @entity.Entity
  layer_entity : @entity.Entity
  layer : TiledLayer
  source_kind : TiledColliderSourceKind
  shape : @physics2d.CollisionShape
  sensor : Bool
  properties : Array[TiledProperty]
}

///|
fn spawn_tiled_map_physics(
  map_entity : @entity.Entity,
  map : TiledMap,
  settings : TiledPhysicsSettings,
) -> Unit {
  spawn_tiled_physics_layers(map_entity, map, map.layers, settings)
}

///|
fn spawn_tiled_physics_layers(
  map_entity : @entity.Entity,
  map : TiledMap,
  layers : Array[TiledLayer],
  settings : TiledPhysicsSettings,
) -> Unit {
  guard tiled_map_storages().get(map_entity) is Some(storage) else { return }
  for layer in layers {
    match layer.kind {
      TileLayer(tile_layer) => {
        if !settings.tiles_layer_filter.matches(layer.name) {
          continue
        }
        guard storage.layer_entity(layer.id) is Some(layer_entity) else {
          continue
        }
        spawn_tiled_tile_layer_physics(
          map_entity, layer_entity, map, layer, tile_layer, settings,
        )
      }
      ObjectLayer(object_layer) =>
        for object in object_layer.objects {
          if !settings.objects_filter.matches(object.name) {
            continue
          }
          guard storage.object_entity(object.id) is Some(object_entity) else {
            continue
          }
          spawn_tiled_object_physics(
            map_entity, object_entity, map, layer, object, settings,
          )
        }
      GroupLayer(children) =>
        spawn_tiled_physics_layers(map_entity, map, children, settings)
      _ => ()
    }
  }
}

///|
fn spawn_tiled_tile_layer_physics(
  map_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  tile_layer : TiledTileLayer,
  settings : TiledPhysicsSettings,
) -> Unit {
  let specs : Array[TiledPhysicsSpawnSpec] = []
  for cell in tile_layer.tile_cells() {
    if cell.gid.is_empty() {
      continue
    }
    guard map.tileset_for_gid(cell.gid.tile_id) is Some(tileset) else {
      continue
    }
    let local_id = cell.gid.tile_id - tileset.first_gid
    guard tileset.tile_definition(local_id) is Some(tile_definition) else {
      continue
    }
    guard tile_definition.object_layer is Some(object_layer) else { continue }
    let tile_size = tiled_tileset_tile_size(map, tileset)
    let base_transform = @math.Transform::from_translation(
        tiled_cell_position(map, tileset, cell)[X],
        tiled_cell_position(map, tileset, cell)[Y],
      ) *
      tiled_gid_transform(cell.gid, tile_size)
    let inherited_properties = tile_definition.properties
    for object in object_layer.objects {
      if !settings.objects_filter.matches(object.name) {
        continue
      }
      let object_transform = base_transform *
        tiled_collision_object_transform(object)
      let object_specs = tiled_physics_specs_from_shape_object(
        layer_entity,
        layer_entity,
        layer,
        TilesLayer,
        object,
        object_transform,
        inherited_properties,
        settings,
      )
      for spec in object_specs {
        specs.push(spec)
      }
    }
  }
  let spawned_specs = if settings.merge_tile_rects {
    tiled_merge_tile_rect_specs(specs)
  } else {
    specs
  }
  for spec in spawned_specs {
    spawn_tiled_physics_spec(map_entity, spec, settings)
  }
}

///|
fn spawn_tiled_object_physics(
  map_entity : @entity.Entity,
  object_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  object : TiledObject,
  settings : TiledPhysicsSettings,
) -> Unit {
  let specs = tiled_object_physics_specs(
    object_entity, object_entity, map, layer, object, settings,
  )
  for spec in specs {
    spawn_tiled_physics_spec(map_entity, spec, settings)
  }
}

///|
fn tiled_object_physics_specs(
  source_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  map : TiledMap,
  layer : TiledLayer,
  object : TiledObject,
  settings : TiledPhysicsSettings,
) -> Array[TiledPhysicsSpawnSpec] {
  if tiled_physics_is_disabled(object.properties) {
    return []
  }
  match object.gid {
    Some(gid) =>
      match map.tileset_for_gid(gid.tile_id) {
        Some(tileset) => {
          let object_size = tiled_object_size(map, tileset, object)
          let inherited_properties = tiled_merge_properties(
            tileset
            .tile_definition(gid.tile_id - tileset.first_gid)
            .map_or([], fn(definition) { definition.properties }),
            object.properties,
          )
          let tile_transform = tiled_object_rotation_transform(
              object, object_size,
            ) *
            tiled_gid_transform(gid, object_size)
          let embedded_specs = tileset
            .tile_definition(gid.tile_id - tileset.first_gid)
            .map_or([], fn(definition) {
              definition.object_layer.map_or([], fn(object_layer) {
                let specs : Array[TiledPhysicsSpawnSpec] = []
                for embedded_object in object_layer.objects {
                  if !settings.objects_filter.matches(embedded_object.name) {
                    continue
                  }
                  let object_specs = tiled_physics_specs_from_shape_object(
                    source_entity,
                    layer_entity,
                    layer,
                    Object,
                    embedded_object,
                    tile_transform *
                    tiled_collision_object_transform(embedded_object),
                    inherited_properties,
                    settings,
                  )
                  for spec in object_specs {
                    specs.push(spec)
                  }
                }
                specs
              })
            })
          if embedded_specs.length() > 0 {
            embedded_specs
          } else {
            tiled_physics_specs_from_shape_object(
              source_entity,
              layer_entity,
              layer,
              Object,
              object,
              tile_transform,
              object.properties,
              settings,
              size_override=Some(object_size),
            )
          }
        }
        None =>
          tiled_physics_specs_from_shape_object(
            source_entity,
            layer_entity,
            layer,
            Object,
            object,
            @math.Transform::from_rotation_deg(object.rotation),
            object.properties,
            settings,
          )
      }
    None =>
      tiled_physics_specs_from_shape_object(
        source_entity,
        layer_entity,
        layer,
        Object,
        object,
        @math.Transform::from_rotation_deg(object.rotation),
        object.properties,
        settings,
      )
  }
}

///|
fn tiled_physics_specs_from_shape_object(
  source_entity : @entity.Entity,
  layer_entity : @entity.Entity,
  layer : TiledLayer,
  source_kind : TiledColliderSourceKind,
  object : TiledObject,
  transform : @math.Transform,
  inherited_properties : Array[TiledProperty],
  settings : TiledPhysicsSettings,
  size_override? : @math.Vec2D? = None,
) -> Array[TiledPhysicsSpawnSpec] {
  let properties = tiled_merge_properties(
    inherited_properties,
    object.properties,
  )
  if tiled_physics_is_disabled(properties) {
    return []
  }
  let sensor = tiled_physics_is_sensor(properties)
  let shape = if object.point {
    Some(
      @physics2d.CollisionShape::Ball(
        radius=settings.point_radius,
        offset=transform.apply_to_vec2d(@math.Vec2D::zero()),
      ),
    )
  } else if object.polyline.length() > 0 {
    Some(
      @physics2d.CollisionShape::Polyline(
        points=tiled_transform_points(
          object.polyline.map(point => @math.Vec2D(point.x, point.y)),
          transform,
        ),
        offset=@math.Vec2D::zero(),
        closed=false,
      ),
    )
  } else if object.polygon.length() > 0 {
    Some(
      @physics2d.CollisionShape::Polygon(
        points=tiled_transform_points(
          object.polygon.map(point => @math.Vec2D(point.x, point.y)),
          transform,
        ),
        offset=@math.Vec2D::zero(),
      ),
    )
  } else if object.ellipse {
    let size = size_override.unwrap_or(@math.Vec2D(object.width, object.height))
    if size[X] <= 0.0 || size[Y] <= 0.0 {
      None
    } else {
      Some(
        @physics2d.CollisionShape::Polygon(
          points=tiled_transform_points(
            tiled_ellipse_points(size, settings.ellipse_segments),
            transform,
          ),
          offset=@math.Vec2D::zero(),
        ),
      )
    }
  } else if object.text is Some(_) {
    None
  } else {
    let size = size_override.unwrap_or(@math.Vec2D(object.width, object.height))
    if size[X] <= 0.0 || size[Y] <= 0.0 {
      None
    } else {
      Some(tiled_shape_from_rect(size, transform))
    }
  }
  match shape {
    Some(shape) =>
      [
        {
          source_entity,
          layer_entity,
          layer,
          source_kind,
          shape,
          sensor,
          properties,
        },
      ]
    None => []
  }
}

///|
fn spawn_tiled_physics_spec(
  map_entity : @entity.Entity,
  spec : TiledPhysicsSpawnSpec,
  settings : TiledPhysicsSettings,
) -> Unit {
  let collider_entity = spec.source_entity.spawn_child(
    offset=@math.Vec2D::zero(),
  )
  let filter = if spec.sensor {
    settings.sensor_filter
  } else {
    settings.collision_filter
  }
  if spec.sensor {
    @physics2d.areas().set(collider_entity, @physics2d.new_sensor(filter))
  } else {
    @physics2d.colliders().set(
      collider_entity,
      @physics2d.Collider::new(filter),
    )
  }
  tiled_apply_physics_properties(collider_entity, spec.sensor, spec.properties)
  @physics2d.shapes().set(collider_entity, spec.shape)
  tiled_set_properties(collider_entity, spec.properties)
  let origin : TiledColliderOrigin = {
    map_entity,
    source_entity: spec.source_entity,
    layer_entity: spec.layer_entity,
    source_kind: spec.source_kind,
    layer: spec.layer,
  }
  tiled_collider_origins().set(collider_entity, origin)
  let colliders = tiled_colliders().get_or_init(spec.source_entity, () => {
    entities: [],
  })
  colliders.entities.push(collider_entity)
  let event = {
    collider_entity,
    origin,
    shape: spec.shape,
    sensor: spec.sensor,
    properties: spec.properties,
  }
  tiled_collider_spawned_event_bus.trigger(event, Some(collider_entity))
  if settings.collider_hook is Some(collider_hook) {
    collider_hook(event)
  }
}

///|
fn tiled_apply_physics_properties(
  collider_entity : @entity.Entity,
  sensor : Bool,
  properties : Array[TiledProperty],
) -> Unit {
  let active = tiled_property_bool(properties, "physics_active").unwrap_or(
    tiled_property_bool(properties, "active").unwrap_or(true),
  )
  if sensor {
    if @physics2d.areas().get(collider_entity) is Some(area) {
      area.active = active
    }
  } else if @physics2d.colliders().get(collider_entity) is Some(collider) {
    collider.active = active
    if tiled_property_number(properties, "physics_friction") is Some(friction) {
      collider.friction = friction
    } else if tiled_property_number(properties, "friction") is Some(friction) {
      collider.friction = friction
    }
    if tiled_property_number(properties, "physics_restitution")
      is Some(restitution) {
      collider.restitution = restitution
    } else if tiled_property_number(properties, "restitution")
      is Some(restitution) {
      collider.restitution = restitution
    }
  }
  if tiled_physics_body(properties) is Some(body) {
    @physics2d.rigid_bodies().set(collider_entity, body)
  }
}

///|
fn tiled_collision_object_transform(object : TiledObject) -> @math.Transform {
  @math.Transform::from_translation(object.x, object.y) *
  @math.Transform::from_rotation_deg(object.rotation)
}

///|
fn tiled_transform_points(
  points : Array[@math.Vec2D],
  transform : @math.Transform,
) -> Array[@math.Vec2D] {
  points.map(point => transform.apply_to_vec2d(point))
}

///|
fn tiled_shape_from_rect(
  size : @math.Vec2D,
  transform : @math.Transform,
) -> @physics2d.CollisionShape {
  let corners = tiled_transform_points(
    [
      @math.Vec2D::zero(),
      @math.Vec2D(size[X], 0.0),
      @math.Vec2D(size[X], size[Y]),
      @math.Vec2D(0.0, size[Y]),
    ],
    transform,
  )
  match tiled_axis_aligned_rect(corners) {
    Some((offset, rect_size)) =>
      @physics2d.CollisionShape::Rect(size=rect_size, offset~)
    None =>
      @physics2d.CollisionShape::Polygon(
        points=corners,
        offset=@math.Vec2D::zero(),
      )
  }
}

///|
fn tiled_axis_aligned_rect(
  corners : Array[@math.Vec2D],
) -> (@math.Vec2D, @math.Vec2D)? {
  if corners.length() != 4 {
    return None
  }
  let mut min_x = corners[0][X]
  let mut max_x = corners[0][X]
  let mut min_y = corners[0][Y]
  let mut max_y = corners[0][Y]
  for point in corners {
    min_x = if point[X] < min_x { point[X] } else { min_x }
    max_x = if point[X] > max_x { point[X] } else { max_x }
    min_y = if point[Y] < min_y { point[Y] } else { min_y }
    max_y = if point[Y] > max_y { point[Y] } else { max_y }
  }
  let rect_size = @math.Vec2D(max_x - min_x, max_y - min_y)
  if rect_size[X] <= 0.0 || rect_size[Y] <= 0.0 {
    return None
  }
  let expected = [
    @math.Vec2D(min_x, min_y),
    @math.Vec2D(max_x, min_y),
    @math.Vec2D(max_x, max_y),
    @math.Vec2D(min_x, max_y),
  ]
  for expected_point in expected {
    let mut matched = false
    for point in corners {
      if tiled_points_close(point, expected_point) {
        matched = true
        break
      }
    }
    if !matched {
      return None
    }
  }
  Some((@math.Vec2D(min_x, min_y), rect_size))
}

///|
fn tiled_ellipse_points(
  size : @math.Vec2D,
  segments : Int,
) -> Array[@math.Vec2D] {
  let count = if segments < 8 { 8 } else { segments }
  let center = size.scalar_mul(0.5)
  let points : Array[@math.Vec2D] = []
  for index in 0..<count {
    let angle = index.to_double() * @cmath.PI * 2.0 / count.to_double()
    points.push(
      center +
      @math.Vec2D(center[X] * @cmath.cos(angle), center[Y] * @cmath.sin(angle)),
    )
  }
  points
}

///|
fn tiled_merge_tile_rect_specs(
  specs : Array[TiledPhysicsSpawnSpec],
) -> Array[TiledPhysicsSpawnSpec] {
  let merged : Array[TiledPhysicsSpawnSpec] = []
  let pending : Array[TiledPhysicsSpawnSpec] = []
  for spec in specs {
    match spec.shape {
      Rect(..) if spec.properties.length() == 0 => pending.push(spec)
      _ => merged.push(spec)
    }
  }
  while pending.length() > 0 {
    let mut current = pending.pop().unwrap()
    let mut changed = true
    while changed {
      changed = false
      let next_pending : Array[TiledPhysicsSpawnSpec] = []
      for candidate in pending {
        match tiled_merge_rect_spec(current, candidate) {
          Some(merged_spec) => {
            current = merged_spec
            changed = true
          }
          None => next_pending.push(candidate)
        }
      }
      pending.clear()
      for candidate in next_pending {
        pending.push(candidate)
      }
    }
    merged.push(current)
  }
  merged
}

///|
fn tiled_merge_rect_spec(
  left : TiledPhysicsSpawnSpec,
  right : TiledPhysicsSpawnSpec,
) -> TiledPhysicsSpawnSpec? {
  if left.source_entity != right.source_entity ||
    left.layer_entity != right.layer_entity ||
    left.source_kind != right.source_kind ||
    left.sensor != right.sensor {
    return None
  }
  match (left.shape, right.shape) {
    (
      Rect(size=left_size, offset=left_offset),
      Rect(size=right_size, offset=right_offset),
    ) =>
      match
        tiled_merge_rects(left_offset, left_size, right_offset, right_size) {
        Some((offset, size)) => Some({ ..left, shape: Rect(size~, offset~) })
        None => None
      }
    _ => None
  }
}

///|
fn tiled_merge_rects(
  left_offset : @math.Vec2D,
  left_size : @math.Vec2D,
  right_offset : @math.Vec2D,
  right_size : @math.Vec2D,
) -> (@math.Vec2D, @math.Vec2D)? {
  if tiled_scalars_close(left_offset[Y], right_offset[Y]) &&
    tiled_scalars_close(left_size[Y], right_size[Y]) {
    if tiled_scalars_close(left_offset[X] + left_size[X], right_offset[X]) {
      return Some(
        (left_offset, @math.Vec2D(left_size[X] + right_size[X], left_size[Y])),
      )
    }
    if tiled_scalars_close(right_offset[X] + right_size[X], left_offset[X]) {
      return Some(
        (right_offset, @math.Vec2D(left_size[X] + right_size[X], left_size[Y])),
      )
    }
  }
  if tiled_scalars_close(left_offset[X], right_offset[X]) &&
    tiled_scalars_close(left_size[X], right_size[X]) {
    if tiled_scalars_close(left_offset[Y] + left_size[Y], right_offset[Y]) {
      return Some(
        (left_offset, @math.Vec2D(left_size[X], left_size[Y] + right_size[Y])),
      )
    }
    if tiled_scalars_close(right_offset[Y] + right_size[Y], left_offset[Y]) {
      return Some(
        (right_offset, @math.Vec2D(left_size[X], left_size[Y] + right_size[Y])),
      )
    }
  }
  None
}

///|
fn tiled_physics_is_sensor(properties : Array[TiledProperty]) -> Bool {
  tiled_property_bool(properties, "physics_sensor").unwrap_or(
    tiled_property_bool(properties, "sensor").unwrap_or(false),
  )
}

///|
fn tiled_physics_is_disabled(properties : Array[TiledProperty]) -> Bool {
  tiled_property_bool(properties, "physics_disabled").unwrap_or(
    tiled_property_bool(properties, "disabled").unwrap_or(false),
  )
}

///|
fn tiled_physics_body(
  properties : Array[TiledProperty],
) -> @physics2d.RigidBody? {
  let body_name = tiled_property_string_prefer(
    properties, "physics_body", "body",
  )
  let body_type = match body_name {
    Some(body_name) => tiled_physics_body_type(body_name)
    None => None
  }
  let gravity_scale = tiled_property_number_prefer(
    properties, "physics_gravity_scale", "gravity_scale",
  )
  let linear_damping = tiled_property_number_prefer(
    properties, "physics_linear_damping", "linear_damping",
  )
  let angular_damping = tiled_property_number_prefer(
    properties, "physics_angular_damping", "angular_damping",
  )
  let ccd_enabled = tiled_property_bool(properties, "physics_ccd").unwrap_or(
    tiled_property_bool(properties, "ccd_enabled").unwrap_or(false),
  )
  let lock_rotation = tiled_property_bool(properties, "physics_lock_rotation").unwrap_or(
    tiled_property_bool(properties, "lock_rotation").unwrap_or(true),
  )
  let has_body_overrides = body_type is Some(_) ||
    gravity_scale is Some(_) ||
    linear_damping is Some(_) ||
    angular_damping is Some(_) ||
    tiled_property_bool(properties, "physics_ccd") is Some(_) ||
    tiled_property_bool(properties, "ccd_enabled") is Some(_) ||
    tiled_property_bool(properties, "physics_lock_rotation") is Some(_) ||
    tiled_property_bool(properties, "lock_rotation") is Some(_)
  if !has_body_overrides {
    return None
  }
  let mut body = match body_type {
    Some(@physics2d.RigidBodyType::Dynamic) => @physics2d.RigidBody::dynamic()
    Some(@physics2d.RigidBodyType::Fixed) => @physics2d.RigidBody::fixed()
    Some(@physics2d.RigidBodyType::KinematicPositionBased) =>
      @physics2d.RigidBody::kinematic_position_based()
    Some(@physics2d.RigidBodyType::KinematicVelocityBased) =>
      @physics2d.RigidBody::kinematic_velocity_based()
    None => @physics2d.RigidBody::fixed()
  }
  if gravity_scale is Some(gravity_scale) {
    body = { ..body, gravity_scale, }
  }
  if linear_damping is Some(linear_damping) {
    body = { ..body, linear_damping, }
  }
  if angular_damping is Some(angular_damping) {
    body = { ..body, angular_damping, }
  }
  body = { ..body, ccd_enabled, lock_rotation }
  Some(body)
}

///|
fn tiled_physics_body_type(value : String) -> @physics2d.RigidBodyType? {
  match value.trim().to_string().to_lower() {
    "dynamic" => Some(@physics2d.RigidBodyType::Dynamic)
    "fixed" => Some(@physics2d.RigidBodyType::Fixed)
    "kinematicpositionbased" =>
      Some(@physics2d.RigidBodyType::KinematicPositionBased)
    "kinematic_position_based" =>
      Some(@physics2d.RigidBodyType::KinematicPositionBased)
    "kinematic-position-based" =>
      Some(@physics2d.RigidBodyType::KinematicPositionBased)
    "kinematicvelocitybased" =>
      Some(@physics2d.RigidBodyType::KinematicVelocityBased)
    "kinematic_velocity_based" =>
      Some(@physics2d.RigidBodyType::KinematicVelocityBased)
    "kinematic-velocity-based" =>
      Some(@physics2d.RigidBodyType::KinematicVelocityBased)
    _ => None
  }
}

///|
fn tiled_property_bool(
  properties : Array[TiledProperty],
  name : String,
) -> Bool? {
  match find_property_value(properties, name) {
    Some(Bool(value)) => Some(value)
    _ => None
  }
}

///|
fn tiled_property_number(
  properties : Array[TiledProperty],
  name : String,
) -> Double? {
  match find_property_value(properties, name) {
    Some(Float(value)) => Some(value)
    Some(Int(value)) => Some(value.to_double())
    _ => None
  }
}

///|
fn tiled_property_string(
  properties : Array[TiledProperty],
  name : String,
) -> String? {
  match find_property_value(properties, name) {
    Some(String(value)) => Some(value)
    _ => None
  }
}

///|
fn tiled_property_number_prefer(
  properties : Array[TiledProperty],
  primary : String,
  fallback : String,
) -> Double? {
  match tiled_property_number(properties, primary) {
    Some(value) => Some(value)
    None => tiled_property_number(properties, fallback)
  }
}

///|
fn tiled_property_string_prefer(
  properties : Array[TiledProperty],
  primary : String,
  fallback : String,
) -> String? {
  match tiled_property_string(properties, primary) {
    Some(value) => Some(value)
    None => tiled_property_string(properties, fallback)
  }
}

///|
fn tiled_merge_properties(
  base : Array[TiledProperty],
  override_ : Array[TiledProperty],
) -> Array[TiledProperty] {
  let merged : Array[TiledProperty] = []
  let names : Set[String] = Set::new()
  for property in override_ {
    if names.contains(property.name) {
      continue
    }
    merged.push(property)
    names.add(property.name)
  }
  for property in base {
    if names.contains(property.name) {
      continue
    }
    merged.push(property)
    names.add(property.name)
  }
  merged
}

///|
fn tiled_points_close(left : @math.Vec2D, right : @math.Vec2D) -> Bool {
  tiled_scalars_close(left[X], right[X]) &&
  tiled_scalars_close(left[Y], right[Y])
}

///|
fn tiled_scalars_close(left : Double, right : Double) -> Bool {
  (left - right).abs() <= 0.001
}
