///|
fn with_blend_mode(
  blend_mode : @render.BlendMode2D,
  action : () -> Unit,
) -> Unit {
  match blend_mode {
    Alpha => action()
    Additive => {
      @raylib.begin_blend_mode(@raylib.BlendAdditive)
      action()
      @raylib.end_blend_mode()
    }
    Multiply => {
      @raylib.begin_blend_mode(@raylib.BlendMultiplied)
      action()
      @raylib.end_blend_mode()
    }
  }
}

///|
pub fn render2d_begin_pass(
  viewport : @smath.Rect,
  load_op : @render2d_types.RenderPassLoadOp2D,
  clear_color : @render.Color,
  target : @render2d_types.RenderPassTarget2D,
) -> Unit {
  backend.active_2d_offscreen_target = None
  let mut pass_viewport = viewport
  match target {
    Screen => ()
    Offscreen(name) => {
      let width = @cmp.maximum(1, viewport.size[X].ceil().to_int())
      let height = @cmp.maximum(1, viewport.size[Y].ceil().to_int())
      match ensure_offscreen_target_2d(name, width, height) {
        Some(offscreen_target) => {
          offscreen_target.render_texture.begin_mode()
          backend.active_2d_offscreen_target = Some(name)
          pass_viewport = {
            position: @smath.Vec2::zero(),
            size: Vec2(width.to_double(), height.to_double()),
          }
        }
        None =>
          pass_viewport = {
            position: @smath.Vec2::zero(),
            size: @smath.Vec2::zero(),
          }
      }
    }
  }
  reset_clip_stack()
  push_clip_rect(pass_viewport)
  if load_op is Clear {
    mark_frame_drawn()
    @raylib.draw_rectangle_rec(
      to_ray_rect(
        pass_viewport.position[X],
        pass_viewport.position[Y],
        pass_viewport.size[X],
        pass_viewport.size[Y],
      ),
      to_ray_color(clear_color),
    )
  }
}

///|
pub fn render2d_end_pass() -> Unit {
  reset_clip_stack()
  if backend.active_2d_offscreen_target is Some(_) {
    @raylib.end_texture_mode()
  }
  backend.active_2d_offscreen_target = None
}

///|
pub fn push_clip_rect(rect : @smath.Rect) -> Unit {
  let next = match clip_stack.last() {
    Some(current) =>
      clip_rect_intersection(current, rect).unwrap_or({
        position: @smath.Vec2::zero(),
        size: @smath.Vec2::zero(),
      })
    None => rect
  }
  clip_stack.push(next)
  refresh_clip_stack()
}

///|
pub fn pop_clip_rect() -> Unit {
  if clip_stack.is_empty() {
    return
  }
  ignore(clip_stack.pop())
  refresh_clip_stack()
}

///|
pub fn reset_clip_stack() -> Unit {
  while !clip_stack.is_empty() {
    ignore(clip_stack.pop())
  }
  @raylib.end_scissor_mode()
}

///|
pub fn register_key_events(pressed_keys : Set[@inputs.Code]) -> Unit {
  backend.key_events = Some(pressed_keys)
}

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_relative_delta : Ref[@smath.Vec2?],
  mouse_wheel : @inputs.MouseWheel,
) -> Unit {
  backend.mouse_state = Some(mouse)
  backend.mouse_relative_delta = Some(mouse_relative_delta)
  backend.mouse_wheel = Some(mouse_wheel)
}

///|
pub fn register_touch_events(
  touches : Map[@inputs.TouchId, @inputs.TouchPoint],
  changes : Array[@inputs.TouchEvent],
) -> Unit {
  backend.touch_state = Some(touches)
  backend.touch_changes_state = Some(changes)
}

///|
pub fn register_gamepad_events(
  gamepads : Set[@inputs.Gamepad],
  buttons : Set[@inputs.GamepadButtonInput],
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  backend.gamepads_state = Some(gamepads)
  backend.gamepad_buttons_state = Some(buttons)
  backend.gamepad_axes_state = Some(axes)
  sync_gamepad_events()
}

///|
pub fn lock_mouse(lock_state_ref : Ref[Bool]) -> Unit {
  backend.lock_state = Some(lock_state_ref)
  backend.lock_requested = lock_state_ref.val
  sync_mouse_lock()
  backend.cursor_locked = @raylib.is_cursor_hidden()
  lock_state_ref.val = backend.cursor_locked
}

///|
fn transform_is_identity_2d(transform : @smath.Transform) -> Bool {
  (transform.a - 1.0).abs() < 0.000001 &&
  transform.b.abs() < 0.000001 &&
  transform.c.abs() < 0.000001 &&
  (transform.d - 1.0).abs() < 0.000001 &&
  transform.tx.abs() < 0.000001 &&
  transform.ty.abs() < 0.000001
}

///|
fn bind_solid_color_texture() -> Unit {
  @rl.set_texture(@raylib.get_texture_id(get_white_texture()))
}

///|
fn tuple_to_ray_vector2(point : (Float, Float)) -> @raylib.Vector2 {
  @raylib.Vector2::new(point.0, point.1)
}

///|
fn draw_solid_quad(
  p0 : (Float, Float),
  p1 : (Float, Float),
  p2 : (Float, Float),
  p3 : (Float, Float),
  color : @render.Color,
) -> Unit {
  let ray_color = to_ray_color(color)
  @raylib.draw_triangle(
    tuple_to_ray_vector2(p0),
    tuple_to_ray_vector2(p3),
    tuple_to_ray_vector2(p2),
    ray_color,
  )
  @raylib.draw_triangle(
    tuple_to_ray_vector2(p0),
    tuple_to_ray_vector2(p2),
    tuple_to_ray_vector2(p1),
    ray_color,
  )
}

///|
fn draw_colored_quad(
  p0 : (Float, Float),
  p1 : (Float, Float),
  p2 : (Float, Float),
  p3 : (Float, Float),
  c0 : @render.Color,
  c1 : @render.Color,
  c2 : @render.Color,
  c3 : @render.Color,
) -> Unit {
  ignore(@rl.check_render_batch_limit(4))
  bind_solid_color_texture()
  @rl.begin(@rl.Quads)
  @rl.normal3f(0.0, 0.0, 1.0)
  let (r0, g0, b0, a0) = to_ray_color_bytes(c0)
  @rl.color4ub(r0, g0, b0, a0)
  @rl.tex_coord2f(0.0, 0.0)
  @rl.vertex2f(p0.0, p0.1)
  let (r3, g3, b3, a3) = to_ray_color_bytes(c3)
  @rl.color4ub(r3, g3, b3, a3)
  @rl.tex_coord2f(0.0, 1.0)
  @rl.vertex2f(p3.0, p3.1)
  let (r2, g2, b2, a2) = to_ray_color_bytes(c2)
  @rl.color4ub(r2, g2, b2, a2)
  @rl.tex_coord2f(1.0, 1.0)
  @rl.vertex2f(p2.0, p2.1)
  let (r1, g1, b1, a1) = to_ray_color_bytes(c1)
  @rl.color4ub(r1, g1, b1, a1)
  @rl.tex_coord2f(1.0, 0.0)
  @rl.vertex2f(p1.0, p1.1)
  @rl.end_()
}

///|
fn draw_line_loop(
  points : Array[(Float, Float)],
  color : @render.Color,
) -> Unit {
  if points.length() < 2 {
    return
  }
  let ray_color = to_ray_color(color)
  for index in 0..<points.length() {
    let current = points[index]
    let next = points[(index + 1) % points.length()]
    @raylib.draw_line_v(
      tuple_to_ray_vector2(current),
      tuple_to_ray_vector2(next),
      ray_color,
    )
  }
}

///|
fn draw_text_with_cosmic_transform(
  command : @render2d_types.TextDrawCommand2D,
) -> Bool {
  guard command.text != "" else { return true }
  guard command.style.color.a > 0.0 else { return true }
  guard cosmic_texture_for_text(command.text, command.style)
    is Some(cached_texture) else {
    return false
  }
  let measured = measure_text_with_cosmic(command.style, command.text).unwrap_or(
    Vec2(
      cached_texture.width.to_double(),
      cached_texture.height.to_double(),
    ),
  )
  let mut x = command.position[X]
  let mut y = command.position[Y]
  match command.style.align {
    Left => ()
    Center => x -= measured[X] / 2.0
    Right => x -= measured[X]
  }
  match command.style.baseline {
    Top => ()
    Center => y -= measured[Y] / 2.0
    Bottom => y -= measured[Y]
  }
  draw_textured_quad(
    cached_texture.texture,
    cached_texture.width.to_double(),
    cached_texture.height.to_double(),
    0.0,
    0.0,
    cached_texture.width.to_double(),
    cached_texture.height.to_double(),
    0.0,
    0.0,
    cached_texture.width.to_double(),
    cached_texture.height.to_double(),
    x,
    y,
    command.transform,
    @smath.Transform::identity(),
    white_render_color(),
  )
  true
}

///|
pub fn draw_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  mark_frame_drawn()
  with_blend_mode(command.blend_mode, fn() {
    if !transform_is_identity_2d(command.transform) {
      if draw_text_with_cosmic_transform(command) {
        ()
      } else if draw_text_with_cosmic(command) {
        ()
      } else {
        let font = get_font_by_family(command.style.family)
        let measured = measure_text(command.style, command.text)
        let text_width = measured[X]
        let text_height = measured[Y]
        let mut x = command.position[X]
        let mut y = command.position[Y]
        match command.style.align {
          Left => ()
          Center => x -= text_width / 2.0
          Right => x -= text_width
        }
        match command.style.baseline {
          Top => ()
          Center => y -= text_height / 2.0
          Bottom => y -= text_height
        }
        @raylib.draw_text_ex(
          font,
          command.text,
          to_ray_vector2(x, y),
          to_float(command.style.size),
          RAYLIB_DEFAULT_TEXT_SPACING,
          to_ray_color(command.style.color),
        )
      }
    } else if draw_text_with_cosmic(command) {
      ()
    } else {
      let font = get_font_by_family(command.style.family)
      let measured = measure_text(command.style, command.text)
      let text_width = measured[X]
      let text_height = measured[Y]
      let mut x = command.position[X]
      let mut y = command.position[Y]
      match command.style.align {
        Left => ()
        Center => x -= text_width / 2.0
        Right => x -= text_width
      }
      match command.style.baseline {
        Top => ()
        Center => y -= text_height / 2.0
        Bottom => y -= text_height
      }
      @raylib.draw_text_ex(
        font,
        command.text,
        to_ray_vector2(x, y),
        to_float(command.style.size),
        RAYLIB_DEFAULT_TEXT_SPACING,
        to_ray_color(command.style.color),
      )
    }
  })
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @smath.Vec2 {
  if text == "" {
    return Vec2(0.0, cosmic_font_size(style.size))
  }
  if measure_text_with_cosmic(style, text) is Some(measured) {
    return measured
  }
  let font = get_font_by_family(style.family)
  let measured = @raylib.measure_text_ex(
    font,
    text,
    to_float(style.size),
    RAYLIB_DEFAULT_TEXT_SPACING,
  )
  Vec2(vector2_x(measured), vector2_y(measured))
}

///|
pub fn draw_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  mark_frame_drawn()
  with_blend_mode(command.blend_mode, fn() {
    if !transform_is_identity_2d(command.transform) {
      let p0 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        0.0,
        0.0,
      )
      let p1 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        command.rect.size[X],
        0.0,
      )
      let p2 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        command.rect.size[X],
        command.rect.size[Y],
      )
      let p3 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        0.0,
        command.rect.size[Y],
      )
      draw_solid_quad(p0, p1, p2, p3, command.fill_color)
      if command.stroke_color is Some(stroke_color) {
        draw_line_loop([p0, p1, p2, p3], stroke_color)
      }
    } else {
      let rect = to_ray_rect(
        command.rect.position[X],
        command.rect.position[Y],
        command.rect.size[X],
        command.rect.size[Y],
      )
      @raylib.draw_rectangle_rec(rect, to_ray_color(command.fill_color))
      if command.stroke_color is Some(stroke_color) {
        @raylib.draw_rectangle_lines_ex(rect, 1.0, to_ray_color(stroke_color))
      }
    }
  })
}

///|
pub fn draw_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  mark_frame_drawn()
  with_blend_mode(command.blend_mode, fn() {
    if !transform_is_identity_2d(command.transform) {
      let center = transform_image_point(
        command.center[X],
        command.center[Y],
        command.transform,
        0.0,
        0.0,
      )
      let fill = command.fill_color
      let outline : Array[(Float, Float)] = []
      let fan : Array[@raylib.Vector2] = [tuple_to_ray_vector2(center)]
      let segments = 40
      for index in 0..<segments {
        let angle0 = index.to_double() * 2.0 * @cmath.PI / segments.to_double()
        let point0 = transform_image_point(
          command.center[X],
          command.center[Y],
          command.transform,
          @cmath.cos(angle0) * command.radius,
          @cmath.sin(angle0) * command.radius,
        )
        outline.push(point0)
        fan.push(tuple_to_ray_vector2(point0))
      }
      @raylib.draw_triangle_fan(fan, to_ray_color(fill))
      if command.stroke_color is Some(stroke_color) {
        draw_line_loop(outline, stroke_color)
      }
    } else {
      let center = to_ray_vector2(command.center[X], command.center[Y])
      let radius = to_float(command.radius)
      @raylib.draw_circle_v(center, radius, to_ray_color(command.fill_color))
      if command.stroke_color is Some(stroke_color) {
        @raylib.draw_circle_lines_v(center, radius, to_ray_color(stroke_color))
      }
    }
  })
}

///|
pub fn draw_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  mark_frame_drawn()
  with_blend_mode(command.blend_mode, fn() {
    if !transform_is_identity_2d(command.transform) {
      let p0 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        0.0,
        0.0,
      )
      let p1 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        command.rect.size[X],
        0.0,
      )
      let p2 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        command.rect.size[X],
        command.rect.size[Y],
      )
      let p3 = transform_image_point(
        command.rect.position[X],
        command.rect.position[Y],
        command.transform,
        0.0,
        command.rect.size[Y],
      )
      draw_colored_quad(
        p0,
        p1,
        p2,
        p3,
        command.color_start,
        command.color_start,
        command.color_end,
        command.color_end,
      )
    } else {
      let rect = to_ray_rect(
        command.rect.position[X],
        command.rect.position[Y],
        command.rect.size[X],
        command.rect.size[Y],
      )
      @raylib.draw_rectangle_gradient_ex(
        rect,
        to_ray_color(command.color_start),
        to_ray_color(command.color_start),
        to_ray_color(command.color_end),
        to_ray_color(command.color_end),
      )
    }
  })
}

///|
fn begin_3d(camera : @render3d_types.FrameCamera3D) -> Unit {
  @raylib.begin_mode_3d(to_ray_camera3d(camera))
}

///|
fn end_3d() -> Unit {
  @raylib.end_mode_3d()
}

///|
pub fn sync_mesh_asset(
  handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.MeshAsset,
) -> Unit {
  if backend.meshes3d.get(handle) is Some(existing) && existing != mesh {
    clear_triangle_mesh_cache_for_handle(handle)
  }
  backend.meshes3d.set(handle, mesh)
}

///|
pub fn sync_material_asset(
  handle : @render3d_types.MaterialHandle,
  material : @render3d_types.StandardMaterial3D,
) -> Unit {
  backend.materials3d.set(handle, material)
  ensure_material_mipmaps(material)
}
