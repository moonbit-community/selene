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
            size: @smath.Vec2(width.to_double(), height.to_double()),
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
  mouse_movement : @inputs.MouseMovement,
  mouse_wheel : @inputs.MouseWheel,
) -> Unit {
  backend.mouse_state = Some(mouse)
  backend.mouse_movement = Some(mouse_movement)
  backend.mouse_wheel = Some(mouse_wheel)
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
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  backend.lock_state = Some(locked)
  backend.lock_requested = locked.val
  sync_mouse_lock()
  backend.cursor_locked = @raylib.is_cursor_hidden()
  locked.val = backend.cursor_locked
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
  @rl.set_texture(0U)
  @rl.begin(@rl.Quads)
  @rl.normal3f(0.0, 0.0, 1.0)
  let (r0, g0, b0, a0) = to_ray_color_bytes(c0)
  @rl.color4ub(r0, g0, b0, a0)
  @rl.vertex2f(p0.0, p0.1)
  let (r1, g1, b1, a1) = to_ray_color_bytes(c1)
  @rl.color4ub(r1, g1, b1, a1)
  @rl.vertex2f(p1.0, p1.1)
  let (r2, g2, b2, a2) = to_ray_color_bytes(c2)
  @rl.color4ub(r2, g2, b2, a2)
  @rl.vertex2f(p2.0, p2.1)
  let (r3, g3, b3, a3) = to_ray_color_bytes(c3)
  @rl.color4ub(r3, g3, b3, a3)
  @rl.vertex2f(p3.0, p3.1)
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
  let (r, g, b, a) = to_ray_color_bytes(color)
  ignore(@rl.check_render_batch_limit(points.length() * 2))
  @rl.set_texture(0U)
  @rl.begin(@rl.Lines)
  @rl.color4ub(r, g, b, a)
  for index in 0..<points.length() {
    let current = points[index]
    let next = points[(index + 1) % points.length()]
    @rl.vertex2f(current.0, current.1)
    @rl.vertex2f(next.0, next.1)
  }
  @rl.end_()
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
    @smath.Vec2(
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
    return @smath.Vec2(0.0, cosmic_font_size(style.size))
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
  @smath.Vec2(vector2_x(measured), vector2_y(measured))
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
      draw_colored_quad(
        p0,
        p1,
        p2,
        p3,
        command.fill_color,
        command.fill_color,
        command.fill_color,
        command.fill_color,
      )
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
      let segments = 40
      ignore(@rl.check_render_batch_limit(segments * 3))
      @rl.set_texture(0U)
      @rl.begin(@rl.Triangles)
      let (fr, fg, fb, fa) = to_ray_color_bytes(fill)
      @rl.color4ub(fr, fg, fb, fa)
      @rl.normal3f(0.0, 0.0, 1.0)
      for index in 0..<segments {
        let angle0 = index.to_double() * 2.0 * @cmath.PI / segments.to_double()
        let angle1 = (index + 1).to_double() *
          2.0 *
          @cmath.PI /
          segments.to_double()
        let point0 = transform_image_point(
          command.center[X],
          command.center[Y],
          command.transform,
          @cmath.cos(angle0) * command.radius,
          @cmath.sin(angle0) * command.radius,
        )
        let point1 = transform_image_point(
          command.center[X],
          command.center[Y],
          command.transform,
          @cmath.cos(angle1) * command.radius,
          @cmath.sin(angle1) * command.radius,
        )
        outline.push(point0)
        @rl.vertex2f(center.0, center.1)
        @rl.vertex2f(point0.0, point0.1)
        @rl.vertex2f(point1.0, point1.1)
      }
      @rl.end_()
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
