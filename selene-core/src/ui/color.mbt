///|
pub fn rgba(r : Int, g : Int, b : Int, a : Double) -> @render.Color {
  let clamp_channel = fn(value : Int) -> UInt {
    if value < 0 {
      0U
    } else if value > 255 {
      255U
    } else {
      value.reinterpret_as_uint()
    }
  }
  let clamp_alpha = fn(value : Double) -> Double {
    if value < 0.0 {
      0.0
    } else if value > 1.0 {
      1.0
    } else {
      value
    }
  }
  @render.Color::{
    r: clamp_channel(r),
    g: clamp_channel(g),
    b: clamp_channel(b),
    a: clamp_alpha(a),
  }
}

///|
pub fn transparent() -> @render.Color {
  rgba(0, 0, 0, 0.0)
}

///|
fn parse_uint(text : StringView, base : Int) -> UInt? {
  let parsed = try? @string.parse_uint(text, base~)
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn parse_int(text : StringView) -> Int? {
  let parsed = try? @string.parse_int(text)
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn parse_double(text : StringView) -> Double? {
  let parsed = try? @string.parse_double(text)
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}

///|
fn parse_hex_byte(text : String) -> UInt? {
  parse_uint(text.to_string_view(), 16)
}

///|
fn named_color(name : String) -> @render.Color? {
  match name {
    "black" => Some(rgba(0, 0, 0, 1.0))
    "white" => Some(rgba(255, 255, 255, 1.0))
    "red" => Some(rgba(255, 0, 0, 1.0))
    "green" => Some(rgba(0, 128, 0, 1.0))
    "blue" => Some(rgba(0, 0, 255, 1.0))
    "yellow" => Some(rgba(255, 255, 0, 1.0))
    "cyan" => Some(rgba(0, 255, 255, 1.0))
    "magenta" => Some(rgba(255, 0, 255, 1.0))
    "orange" => Some(rgba(255, 165, 0, 1.0))
    "purple" => Some(rgba(128, 0, 128, 1.0))
    "gray" => Some(rgba(128, 128, 128, 1.0))
    "grey" => Some(rgba(128, 128, 128, 1.0))
    "brown" => Some(rgba(165, 42, 42, 1.0))
    "pink" => Some(rgba(255, 192, 203, 1.0))
    "gold" => Some(rgba(255, 215, 0, 1.0))
    "transparent" => Some(transparent())
    "none" => Some(transparent())
    _ => None
  }
}

///|
fn parse_hex_color(color : String) -> @render.Color? {
  let hex = color.unsafe_substring(start=1, end=color.length())
  match hex.length() {
    3 => {
      let r = hex.unsafe_substring(start=0, end=1)
      let g = hex.unsafe_substring(start=1, end=2)
      let b = hex.unsafe_substring(start=2, end=3)
      guard parse_hex_byte(r + r) is Some(r) else { return None }
      guard parse_hex_byte(g + g) is Some(g) else { return None }
      guard parse_hex_byte(b + b) is Some(b) else { return None }
      Some(
        rgba(
          r.reinterpret_as_int(),
          g.reinterpret_as_int(),
          b.reinterpret_as_int(),
          1.0,
        ),
      )
    }
    4 => {
      let r = hex.unsafe_substring(start=0, end=1)
      let g = hex.unsafe_substring(start=1, end=2)
      let b = hex.unsafe_substring(start=2, end=3)
      let a = hex.unsafe_substring(start=3, end=4)
      guard parse_hex_byte(r + r) is Some(r) else { return None }
      guard parse_hex_byte(g + g) is Some(g) else { return None }
      guard parse_hex_byte(b + b) is Some(b) else { return None }
      guard parse_hex_byte(a + a) is Some(a) else { return None }
      Some(
        rgba(
          r.reinterpret_as_int(),
          g.reinterpret_as_int(),
          b.reinterpret_as_int(),
          a.to_double() / 255.0,
        ),
      )
    }
    6 => {
      guard parse_hex_byte(hex.unsafe_substring(start=0, end=2)) is Some(r) else {
        return None
      }
      guard parse_hex_byte(hex.unsafe_substring(start=2, end=4)) is Some(g) else {
        return None
      }
      guard parse_hex_byte(hex.unsafe_substring(start=4, end=6)) is Some(b) else {
        return None
      }
      Some(
        rgba(
          r.reinterpret_as_int(),
          g.reinterpret_as_int(),
          b.reinterpret_as_int(),
          1.0,
        ),
      )
    }
    8 => {
      guard parse_hex_byte(hex.unsafe_substring(start=0, end=2)) is Some(r) else {
        return None
      }
      guard parse_hex_byte(hex.unsafe_substring(start=2, end=4)) is Some(g) else {
        return None
      }
      guard parse_hex_byte(hex.unsafe_substring(start=4, end=6)) is Some(b) else {
        return None
      }
      guard parse_hex_byte(hex.unsafe_substring(start=6, end=8)) is Some(a) else {
        return None
      }
      Some(
        rgba(
          r.reinterpret_as_int(),
          g.reinterpret_as_int(),
          b.reinterpret_as_int(),
          a.to_double() / 255.0,
        ),
      )
    }
    _ => None
  }
}

///|
fn parse_rgb_body(body : String, with_alpha : Bool) -> @render.Color? {
  let values : Array[String] = []
  for part in body.split(",") {
    values.push(part.trim().to_owned())
  }
  if with_alpha && values.length() != 4 {
    return None
  }
  if !with_alpha && values.length() != 3 {
    return None
  }
  guard parse_int(values[0].trim()) is Some(r) else { return None }
  guard parse_int(values[1].trim()) is Some(g) else { return None }
  guard parse_int(values[2].trim()) is Some(b) else { return None }
  if with_alpha {
    guard parse_double(values[3].trim()) is Some(a) else { return None }
    return Some(rgba(r, g, b, a))
  }
  Some(rgba(r, g, b, 1.0))
}

///|
fn parse_rgb_color(color : String) -> @render.Color? {
  if color.has_prefix("rgba(") && color.has_suffix(")") {
    let body = color.unsafe_substring(start=5, end=color.length() - 1)
    return parse_rgb_body(body, true)
  }
  if color.has_prefix("rgb(") && color.has_suffix(")") {
    let body = color.unsafe_substring(start=4, end=color.length() - 1)
    return parse_rgb_body(body, false)
  }
  None
}

///|
pub fn parse_color(color : String) -> @render.Color {
  let normalized = color.trim().to_owned().to_lower()
  if normalized.has_prefix("#") {
    if parse_hex_color(normalized) is Some(parsed) {
      return parsed
    }
  }
  if normalized.has_prefix("rgb(") || normalized.has_prefix("rgba(") {
    if parse_rgb_color(normalized) is Some(parsed) {
      return parsed
    }
  }
  if named_color(normalized) is Some(parsed) {
    return parsed
  }
  rgba(255, 255, 255, 1.0)
}
