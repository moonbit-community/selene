///|
pub(all) enum Mesh2dPrimitive {
  Rectangle(@math.Vec2D)
  Circle(Double)
} derive(Eq, Debug)

///|
pub(all) struct Mesh2dAsset {
  primitive : Mesh2dPrimitive
} derive(Eq, Debug)

///|
pub(all) struct Mesh2dHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct Mesh2d {
  mesh : Mesh2dHandle

  fn new(mesh : Mesh2dHandle) -> Mesh2d
} derive(Eq, Debug)

///|
pub(all) struct Mesh2dStorage {
  meshes : Map[Mesh2dHandle, Mesh2dAsset]
  dirty_meshes : Map[Mesh2dHandle, Mesh2dAsset]
  released_meshes : Array[Mesh2dHandle]
}

///|
priv struct Mesh2dWorldStore {
  mesh2ds : Map[@entity.Entity, Mesh2d]
}

///|
let mesh2d_world_stores : Map[UInt, Mesh2dWorldStore] = Map::new()

///|
fn mesh2d_world_store() -> Mesh2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  mesh2d_world_stores.get_or_init(world_id, fn() { { mesh2ds: Map::new() } })
}

///|
pub fn mesh2ds() -> Map[@entity.Entity, Mesh2d] {
  mesh2d_world_store().mesh2ds
}

///|
let mesh_storage : Mesh2dStorage = {
  meshes: Map::new(),
  dirty_meshes: Map::new(),
  released_meshes: [],
}

///|
let next_mesh2d_id : Ref[UInt] = Ref::new(0U)

///|
pub fn mesh2d_storage() -> Mesh2dStorage {
  mesh_storage
}

///|
pub fn Mesh2dAsset::rectangle(size : @math.Vec2D) -> Mesh2dAsset {
  { primitive: Rectangle(size) }
}

///|
pub fn Mesh2dAsset::circle(radius : Double) -> Mesh2dAsset {
  { primitive: Circle(radius) }
}

///|
pub fn Mesh2d::new(mesh : Mesh2dHandle) -> Mesh2d {
  { mesh, }
}

///|
pub fn register_mesh2d_asset(mesh : Mesh2dAsset) -> Mesh2dHandle {
  let handle = Mesh2dHandle(next_mesh2d_id.val)
  next_mesh2d_id.val += 1U
  mesh_storage.meshes.set(handle, mesh)
  mesh_storage.dirty_meshes.set(handle, mesh)
  handle
}

///|
pub fn update_mesh2d_asset(handle : Mesh2dHandle, mesh : Mesh2dAsset) -> Unit {
  mesh_storage.meshes.set(handle, mesh)
  mesh_storage.dirty_meshes.set(handle, mesh)
}

///|
pub fn release_mesh2d_asset(handle : Mesh2dHandle) -> Unit {
  mesh_storage.meshes.remove(handle)
  mesh_storage.dirty_meshes.remove(handle)
  mesh_storage.released_meshes.push(handle)
}

///|
pub fn mesh2d_asset(handle : Mesh2dHandle) -> Mesh2dAsset? {
  mesh_storage.meshes.get(handle)
}

///|
pub fn rectangle(size : @math.Vec2D) -> Mesh2dHandle {
  register_mesh2d_asset(Mesh2dAsset::rectangle(size))
}

///|
pub fn circle(radius : Double) -> Mesh2dHandle {
  register_mesh2d_asset(Mesh2dAsset::circle(radius))
}

///|
pub fn take_dirty_mesh2d_assets() -> Array[(Mesh2dHandle, Mesh2dAsset)] {
  let dirty = mesh_storage.dirty_meshes.to_array()
  mesh_storage.dirty_meshes.clear()
  dirty
}

///|
pub fn take_released_mesh2d_assets() -> Array[Mesh2dHandle] {
  let released = mesh_storage.released_meshes.copy()
  mesh_storage.released_meshes.clear()
  released
}

///|
fn active_camera2d_view() -> (
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
    guard @transform.global_transforms().get(entity) is Some(global) else {
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
fn pixel_snapped_position(position : @math.Vec2D) -> @math.Vec2D {
  @math.Vec2D(position[X].round(), position[Y].round())
}

///|
fn screen_space_transform(
  transform : @transform.Transform,
) -> @transform.Transform {
  transform.with_scale(
    @math.Vec3::new(
      transform.scale.x * @system.get_zoom(),
      transform.scale.y * @system.get_zoom(),
      transform.scale.z,
    ),
  )
}

///|
fn camera_relative_transform(
  global_transform : @transform.GlobalTransform,
  camera_transform : @transform.GlobalTransform,
  projection : @camera.OrthographicProjection,
) -> @transform.Transform {
  let relative_global = match camera_transform.affine.inverse() {
    Some(inverse_camera) =>
      @transform.GlobalTransform::{
        affine: inverse_camera * global_transform.affine,
      }
    None => global_transform
  }
  let relative = relative_global.compute_transform()
  let projection_scale = if projection.scale <= 0.0 {
    1.0
  } else {
    projection.scale
  }
  let pixels_per_world_unit = @system.get_zoom() / projection_scale
  relative.with_scale(
    @math.Vec3::new(
      relative.scale.x * pixels_per_world_unit,
      relative.scale.y * pixels_per_world_unit,
      relative.scale.z,
    ),
  )
}

///|
fn mesh_screen_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
  )?,
) -> @math.Transform {
  let transform = match camera_view {
    Some((_, camera_transform, projection)) =>
      camera_relative_transform(global_transform, camera_transform, projection)
    None => screen_space_transform(global_transform.compute_transform())
  }
  let x_axis = transform.rotation.rotate_vec3(
    @math.Vec3::x_axis().scalar_mul(transform.scale.x),
  )
  let y_axis = transform.rotation.rotate_vec3(
    @math.Vec3::y_axis().scalar_mul(transform.scale.y),
  )
  @math.Transform::new(a=x_axis.x, b=x_axis.y, c=y_axis.x, d=y_axis.y)
}

///|
fn centered_quad_transform(size : @math.Vec2D) -> @math.Transform {
  @math.Transform::from_translation(-size[X] / 2.0, -size[Y] / 2.0)
}

///|
pub fn render_mesh2d_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_view = active_camera2d_view()
  for entity, mesh in mesh2ds() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    guard mesh2d_asset(mesh.mesh) is Some(mesh_asset) else { continue }
    guard @material2d.mesh_material2ds().get(entity) is Some(material_node) else {
      continue
    }
    let material = match material_node.material {
      Color(handle) => @material2d.color_material(handle)
    }
    guard material is Some(material) else { continue }
    let depth = global_transform.translation().z
    let transform = global_transform.compute_transform()
    let raw_pos = @math.Vec2D(transform.translation.x, transform.translation.y)
    let screen_pos = match camera_view {
      Some((camera, camera_global, projection)) =>
        camera.world_to_viewport(camera_global, projection, raw_pos)
      None => @system.scale_vec2(raw_pos)
    }
    let snapped_pos = pixel_snapped_position(screen_pos)
    let screen_transform = mesh_screen_transform(global_transform, camera_view)
    match mesh_asset.primitive {
      Rectangle(size) => {
        let external_transform = screen_transform *
          centered_quad_transform(size)
        match material.texture {
          Some(image) =>
            @render2d.push_image_with_depth(depth, {
              image,
              destination: { position: snapped_pos, size },
              source: None,
              transform: external_transform,
              repeat: NoRepeat,
              color: material.color,
            })
          None =>
            @render2d.push_rect_with_depth(depth, {
              rect: { position: snapped_pos, size },
              transform: external_transform,
              fill_color: material.color,
              stroke_color: None,
            })
        }
      }
      Circle(radius) =>
        @render2d.push_circle_with_depth(depth, {
          center: snapped_pos,
          radius,
          transform: screen_transform,
          fill_color: material.color,
          stroke_color: None,
        })
    }
  }
}
