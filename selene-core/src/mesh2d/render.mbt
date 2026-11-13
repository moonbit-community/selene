///|
fn centered_quad_transform(size : @math.Vec2) -> @math.Affine2 {
  @math.Affine2::from_translation(Vec2(-size.x / 2.0, -size.y / 2.0))
}

///|
pub fn render_mesh2d_system(
  frame : @render2d.Frame2D,
  meshes : @ecs.Query[(Mesh2d, @material2d.MeshMaterial2d, @transform.Spatial)],
  view : @render2d.RenderView2D,
) -> Unit {
  let camera_views = view.camera_views()
  for entity, (mesh, material_node, spatial) in meshes {
    guard view.is_alive(entity) else { continue }
    guard view.is_visible(entity) else { continue }
    let global_transform = spatial.global()
    guard mesh2d_asset(mesh.mesh) is Some(mesh_asset) else { continue }
    let material = match material_node.material {
      Color(handle) => @material2d.color_material(handle)
    }
    guard material is Some(material) else { continue }
    let sorting = view.sorting_for(entity)
    let depth = @render2d.sort_depth_for_transform(global_transform, sorting)
    let translation = global_transform.translation()
    let base_pos = @math.Vec2(translation.x, translation.y)
    let parallax = view.parallax_for(entity)
    if camera_views.is_empty() {
      let screen_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        None,
      )
      push_mesh2d_draw_command(
        frame,
        entity,
        mesh_asset,
        material,
        depth,
        @camera.pixel_snapped_position(view.scale_position(screen_pos)),
        view.screen_transform(global_transform, None),
        None,
        sorting,
      )
      continue
    }
    let world_pos = @parallax2d.parallax_world_position(
      base_pos,
      parallax,
      None,
    )
    let world_bounds = mesh2d_bounds(
      mesh_asset,
      world_pos,
      @camera.world_transform_2d(global_transform),
    )
    let camera_views_for_entity = view.camera_views_for_bounds(
      world_bounds,
      view.layers_for(entity),
      @parallax2d.parallax_depends_on_camera(parallax),
    )
    if camera_views_for_entity.is_empty() {
      continue
    }
    for camera_view in camera_views_for_entity {
      let raw_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        Some(camera_view),
      )
      let screen_position = @camera.pixel_snapped_position(
        camera_view.world_to_viewport(raw_pos),
      )
      let screen_transform = view.screen_transform(
        global_transform,
        Some(camera_view),
      )
      let bounds = mesh2d_bounds(mesh_asset, screen_position, screen_transform)
      guard camera_view.intersects_screen_rect(bounds) else { continue }
      push_mesh2d_draw_command(
        frame,
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
  frame : @render2d.Frame2D,
  entity : @ecs.Entity,
  mesh_asset : Mesh2dAsset,
  material : @material2d.ColorMaterial,
  depth : Double,
  snapped_pos : @math.Vec2,
  screen_transform : @math.Affine2,
  camera_entity_id : UInt32?,
  sorting : @render2d.Sorting2d,
) -> Unit {
  match mesh_asset.primitive {
    Rectangle(size) => {
      let external_transform = screen_transform * centered_quad_transform(size)
      match material.texture {
        Some(image) => {
          let command : @render2d_types.ImageDrawCommand2D = {
            image,
            destination: { position: snapped_pos, size, },
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
              frame.push_world_command(
                depth,
                Some(entity.id()),
                Image(command),
                sorting~,
                camera_entity_id=Some(camera_entity_id),
              )
            None =>
              frame.push_world_command(
                depth,
                Some(entity.id()),
                Image(command),
                sorting~,
              )
          }
        }
        None => {
          let command : @render2d_types.RectDrawCommand2D = {
            rect: { position: snapped_pos, size, },
            transform: external_transform,
            alpha_mode: material.alpha_mode,
            blend_mode: material.blend_mode,
            fill_color: material.color,
            stroke_color: None,
          }
          match camera_entity_id {
            Some(camera_entity_id) =>
              frame.push_world_command(
                depth,
                Some(entity.id()),
                Rect(command),
                sorting~,
                camera_entity_id=Some(camera_entity_id),
              )
            None =>
              frame.push_world_command(
                depth,
                Some(entity.id()),
                Rect(command),
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
          frame.push_world_command(
            depth,
            Some(entity.id()),
            Circle(command),
            sorting~,
            camera_entity_id=Some(camera_entity_id),
          )
        None =>
          frame.push_world_command(
            depth,
            Some(entity.id()),
            Circle(command),
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
  screen_transform : @math.Affine2,
) -> @math.Rect {
  match mesh_asset.primitive {
    Rectangle(size) =>
      @camera.transformed_rect_bounds(
        snapped_pos,
        { position: @math.Vec2::zero(), size, },
        screen_transform * centered_quad_transform(size),
      )
    Circle(radius) =>
      @camera.transformed_rect_bounds(
        snapped_pos,
        {
          position: Vec2(-radius, -radius),
          size: Vec2(radius * 2.0, radius * 2.0),
        },
        screen_transform,
      )
  }
}
