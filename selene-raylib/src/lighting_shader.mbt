///|
fn read_float(bytes : Bytes, off : Int) -> Float {
  let bits = bytes[off].to_int() |
    (bytes[off + 1].to_int() << 8) |
    (bytes[off + 2].to_int() << 16) |
    (bytes[off + 3].to_int() << 24)
  Float::reinterpret_from_int(bits)
}

///|
fn clamp_u8(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 255 {
    255
  } else {
    value
  }
}

///|
fn to_float(value : Double) -> Float {
  Float::from_double(value)
}

///|
fn clamp_playback_speed(speed : Double) -> Double {
  if speed <= 0.0 {
    0.01
  } else {
    speed
  }
}

///|
fn to_ray_vector2(x : Double, y : Double) -> @raylib.Vector2 {
  @raylib.Vector2::new(to_float(x), to_float(y))
}

///|
fn to_ray_vector3_smath(value : @smath.Vec3) -> @raylib.Vector3 {
  @raylib.Vector3::new(to_float(value.x), to_float(value.y), to_float(value.z))
}

///|
fn to_ray_rect(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> @raylib.Rectangle {
  @raylib.Rectangle::new(
    to_float(x),
    to_float(y),
    to_float(width),
    to_float(height),
  )
}

///|
fn clip_rect_intersection(lhs : @smath.Rect, rhs : @smath.Rect) -> @smath.Rect? {
  let left = @cmp.maximum(lhs.position[X], rhs.position[X])
  let top = @cmp.maximum(lhs.position[Y], rhs.position[Y])
  let right = @cmp.minimum(
    lhs.position[X] + lhs.size[X],
    rhs.position[X] + rhs.size[X],
  )
  let bottom = @cmp.minimum(
    lhs.position[Y] + lhs.size[Y],
    rhs.position[Y] + rhs.size[Y],
  )
  if right <= left || bottom <= top {
    None
  } else {
    Some({
      position: @smath.Vec2(left, top),
      size: @smath.Vec2(right - left, bottom - top),
    })
  }
}

///|
fn activate_clip_rect(rect : @smath.Rect) -> Unit {
  @raylib.begin_scissor_mode(
    rect.position[X].to_int(),
    rect.position[Y].to_int(),
    rect.size[X].to_int(),
    rect.size[Y].to_int(),
  )
}

///|
fn refresh_clip_stack() -> Unit {
  @raylib.end_scissor_mode()
  match clip_stack.last() {
    Some(rect) => activate_clip_rect(rect)
    None => ()
  }
}

///|
fn vector2_x(value : @raylib.Vector2) -> Double {
  read_float(value.to_bytes(), 0).to_double()
}

///|
fn vector2_y(value : @raylib.Vector2) -> Double {
  read_float(value.to_bytes(), 4).to_double()
}

///|
fn to_selene_vec2(value : @raylib.Vector2) -> @smath.Vec2 {
  @smath.Vec2(vector2_x(value), vector2_y(value))
}

///|
fn to_ray_color(color : @render.Color) -> @raylib.Color {
  @raylib.Color::new(
    color.r.reinterpret_as_int(),
    color.g.reinterpret_as_int(),
    color.b.reinterpret_as_int(),
    clamp_u8((color.a * 255.0).to_int()),
  )
}

///|
fn to_ray_color_bytes(color : @render.Color) -> (Byte, Byte, Byte, Byte) {
  (
    color.r.reinterpret_as_int().to_byte(),
    color.g.reinterpret_as_int().to_byte(),
    color.b.reinterpret_as_int().to_byte(),
    clamp_u8((color.a * 255.0).to_int()).to_byte(),
  )
}

///|
fn color_to_vec3(color : @render.Color) -> @smath.Vec3 {
  @smath.Vec3(
    color.r.to_double() / 255.0,
    color.g.to_double() / 255.0,
    color.b.to_double() / 255.0,
  )
}

///|
fn normalize_or(value : @smath.Vec3, fallback : @smath.Vec3) -> @smath.Vec3 {
  if value.length_squared() <= 0.0000001 {
    fallback
  } else {
    value.normalize()
  }
}

///|
fn light_rgb(color : @render.Color, intensity : Double) -> @smath.Vec3 {
  color_to_vec3(color).scalar_mul(@cmp.maximum(0.0, intensity))
}

///|
fn uniform_int(value : Int) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Int(value)
}

///|
fn uniform_texture_unit(value : Int) -> @raylib.ShaderUniformData {
  // NOTE: Keep texture samplers on Int uniforms for raylib 0.3.1 compatibility.
  // Some drivers/backend paths interpret SHADER_UNIFORM_SAMPLER2D inconsistently.
  @raylib.ShaderUniformData::Int(value)
}

///|
fn uniform_float(value : Double) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Float(to_float(value))
}

///|
fn uniform_vec2(value : @smath.Vec2) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Vec2(
    @raylib.Vector2::new(to_float(value[X]), to_float(value[Y])),
  )
}

///|
fn uniform_vec3(value : @smath.Vec3) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Vec3(
    @raylib.Vector3::new(
      to_float(value.x),
      to_float(value.y),
      to_float(value.z),
    ),
  )
}
