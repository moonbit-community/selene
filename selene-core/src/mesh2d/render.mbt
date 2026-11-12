///|
fn centered_quad_transform(size : @math.Vec2) -> @math.Affine2 {
  @math.Affine2::from_translation(Vec2(-size.x / 2.0, -size.y / 2.0))
}

///|
pub fn render_mesh2d_system(world~ : @ecs.World, delta : Double) -> Unit {
  let query_mesh_material2d : @ecs.Query[
    @ecs.Single[@material2d.MeshMaterial2d],
  ] = world.query()
  let query_mesh2d : @ecs.Query[@ecs.Single[Mesh2d]] = world.query()
  ignore(delta)
  let camera_views = @camera.active_camera2d_views(world~)
  let camera_extract = @culling2d.CameraExtract2dContext(camera_views)
  for entity, Single(mesh) in query_mesh2d {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transform(world~, entity) is Some(global_transform) else {
      continue
    }
    guard mesh2d_asset(mesh.mesh) is Some(mesh_asset) else { continue }
    guard query_mesh_material2d.get(entity).map(value => value.0)
      is Some(material_node) else {
      continue
    }
    let material = match material_node.material {
      Color(handle) => @material2d.color_material(handle)
    }
    guard material is Some(material) else { continue }
    let sorting = @render2d.entity_sorting2d(world~, entity)
    let depth = @render2d.sort_depth_for_transform(global_transform, sorting)
    let translation = global_transform.translation()
    let base_pos = @math.Vec2(translation.x, translation.y)
    let parallax = @parallax2d.inherited_parallax2d(world~, entity)
    if camera_views.is_empty() {
      let screen_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        None,
      )
      push_mesh2d_draw_command(
        entity,
        mesh_asset,
        material,
        depth,
        @camera.pixel_snapped_position(@window.scale_vec2(screen_pos)),
        @camera.camera_screen_transform(global_transform, None),
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
    let camera_views_for_entity = camera_extract.camera_views_for_bounds(
      world~,
      world_bounds,
      @visibility.entity_render_layers(world~, entity),
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
      let screen_transform = @camera.camera_screen_transform(
        global_transform,
        Some(camera_view),
      )
      let bounds = mesh2d_bounds(mesh_asset, screen_position, screen_transform)
      guard camera_view.intersects_screen_rect(bounds) else { continue }
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
            rect: { position: snapped_pos, size, },
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
