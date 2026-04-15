///|
pub(all) enum Mesh2dPrimitive {
  Rectangle(@math.Vec2)
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
pub fn Mesh2dAsset::rectangle(size : @math.Vec2) -> Mesh2dAsset {
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
pub fn rectangle(size : @math.Vec2) -> Mesh2dHandle {
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
fn centered_quad_transform(size : @math.Vec2) -> @math.Transform {
  @math.Transform::from_translation(-size[X] / 2.0, -size[Y] / 2.0)
}

///|
pub fn render_mesh2d_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_views = @camera.active_camera2d_views()
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
    let sorting = @render2d.entity_sorting2d(entity)
    let depth = @render2d.sort_depth_for_transform(global_transform, sorting)
    let transform = global_transform.compute_transform()
    let base_pos = @math.Vec2(transform.translation.x, transform.translation.y)
    let parallax = @parallax2d.inherited_parallax2d(entity)
    if camera_views.is_empty() {
      let screen_pos = @parallax2d.parallax_world_position(base_pos, parallax, None)
      push_mesh2d_draw_command(
        entity,
        mesh_asset,
        material,
        depth,
        @camera.pixel_snapped_position(@system.scale_vec2(screen_pos)),
        @camera.camera_screen_transform(global_transform, None),
        None,
        sorting,
      )
      continue
    }
    let entity_layers = @visibility.entity_render_layers(entity)
    for camera_view in camera_views {
      guard @visibility.matches(
        @visibility.entity_render_layers(camera_view.entity),
        entity_layers,
      ) else {
        continue
      }
      let raw_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        Some(camera_view),
      )
      let screen_position = @camera.pixel_snapped_position(
        camera_view.world_to_viewport(raw_pos),
      )
      let screen_transform = @camera.camera_screen_transform(
        global_transform,
        Some(camera_view),
      )
      let bounds = mesh2d_bounds(mesh_asset, screen_position, screen_transform)
      guard camera_view.intersects_screen_rect(bounds) else { continue }
      @visibility.mark_visible_to_camera(entity, camera_view.entity.id())
      push_mesh2d_draw_command(
        entity,
        mesh_asset,
        material,
        depth,
        screen_position,
        screen_transform,
        Some(camera_view.entity.id()),
        sorting,
      )
    }
  }
}

///|
fn push_mesh2d_draw_command(
  entity : @entity.Entity,
  mesh_asset : Mesh2dAsset,
  material : @material2d.ColorMaterial,
  depth : Double,
  snapped_pos : @math.Vec2,
  screen_transform : @math.Transform,
  camera_entity_id : UInt?,
  sorting : @render2d.Sorting2d,
) -> Unit {
  match mesh_asset.primitive {
    Rectangle(size) => {
      let external_transform = screen_transform * centered_quad_transform(size)
      match material.texture {
        Some(image) => {
          let command : @render2d_types.ImageDrawCommand2D = {
            image,
            destination: { position: snapped_pos, size },
            source: None,
            transform: external_transform,
            uv_transform: material.uv_transform,
            repeat: NoRepeat,
            alpha_mode: material.alpha_mode,
            blend_mode: material.blend_mode,
            color: material.color,
          }
          match camera_entity_id {
            Some(camera_entity_id) =>
              @render2d.push_image_with_depth_to_camera(
                camera_entity_id,
                depth,
                command,
                entity_id=Some(entity.id()),
                sorting~,
              )
            None =>
              @render2d.push_image_with_depth_for_entity(
                depth,
                Some(entity.id()),
                command,
                sorting~,
              )
          }
        }
        None => {
          let command : @render2d_types.RectDrawCommand2D = {
            rect: { position: snapped_pos, size },
            transform: external_transform,
            alpha_mode: material.alpha_mode,
            blend_mode: material.blend_mode,
            fill_color: material.color,
            stroke_color: None,
          }
          match camera_entity_id {
            Some(camera_entity_id) =>
              @render2d.push_rect_with_depth_to_camera(
                camera_entity_id,
                depth,
                command,
                entity_id=Some(entity.id()),
                sorting~,
              )
            None =>
              @render2d.push_rect_with_depth_for_entity(
                depth,
                Some(entity.id()),
                command,
                sorting~,
              )
          }
        }
      }
    }
    Circle(radius) => {
      let command : @render2d_types.CircleDrawCommand2D = {
        center: snapped_pos,
        radius,
        transform: screen_transform,
        alpha_mode: material.alpha_mode,
        blend_mode: material.blend_mode,
        fill_color: material.color,
        stroke_color: None,
      }
      match camera_entity_id {
        Some(camera_entity_id) =>
          @render2d.push_circle_with_depth_to_camera(
            camera_entity_id,
            depth,
            command,
            entity_id=Some(entity.id()),
            sorting~,
          )
        None =>
          @render2d.push_circle_with_depth_for_entity(
            depth,
            Some(entity.id()),
            command,
            sorting~,
          )
      }
    }
  }
}

///|
fn mesh2d_bounds(
  mesh_asset : Mesh2dAsset,
  snapped_pos : @math.Vec2,
  screen_transform : @math.Transform,
) -> @math.Rect {
  match mesh_asset.primitive {
    Rectangle(size) =>
      @camera.transformed_rect_bounds(
        snapped_pos,
        { position: @math.Vec2::zero(), size },
        screen_transform * centered_quad_transform(size),
      )
    Circle(radius) =>
      @camera.transformed_rect_bounds(
        snapped_pos,
        {
          position: @math.Vec2(-radius, -radius),
          size: @math.Vec2(radius * 2.0, radius * 2.0),
        },
        screen_transform,
      )
  }
}
