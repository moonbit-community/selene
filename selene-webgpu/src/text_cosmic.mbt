// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
priv struct CosmicRasterImage {
  width : Int
  height : Int
  pixels : Array[Int]
}

///|
let cosmic_font_system : Ref[@cosmic.FontSystem] = Ref::new(
  @cosmic.FontSystem::new(),
)

///|
let cosmic_swash_cache : Ref[@cosmic.SwashCache] = Ref::new(
  @cosmic.SwashCache::new(),
)

///|
let cosmic_loaded_families : Map[String, Bool] = Map::new()

///|
let cosmic_text_cache : Map[String, Bool] = Map::new()

///|
fn saturating_byte(value : Int) -> Byte {
  if value < 0 {
    Int::to_byte(0)
  } else if value > 255 {
    Int::to_byte(255)
  } else {
    value.to_byte()
  }
}

///|
fn alpha_to_byte(alpha : Double) -> Byte {
  saturating_byte((alpha * 255.0).round().to_int())
}

///|
fn to_cosmic_color(color : @render.Color) -> @cosmic.Color {
  @cosmic.Color::rgba(
    color.r.to_byte(),
    color.g.to_byte(),
    color.b.to_byte(),
    alpha_to_byte(color.a),
  )
}

///|
fn text_cache_key(command : @render2d_types.TextDrawCommand2D) -> String {
  let color = command.style.color
  let a = alpha_to_byte(color.a).to_int()
  "t:" +
  command.text.length().to_string() +
  ":" +
  command.text +
  "|f:" +
  command.style.family.length().to_string() +
  ":" +
  command.style.family +
  "|s:" +
  command.style.size.to_string() +
  "|r:" +
  color.r.to_string() +
  "|g:" +
  color.g.to_string() +
  "|b:" +
  color.b.to_string() +
  "|a:" +
  a.to_string()
}

///|
fn ensure_font_loaded(family : String) -> Bool {
  if cosmic_loaded_families.contains(family) {
    return true
  }
  if webgpu_font_bytes_status(family) != 1 {
    return false
  }
  let raw_bytes = webgpu_take_font_bytes(family)
  if raw_bytes.is_empty() {
    return false
  }
  let bytes = Bytes::from_iter(
    raw_bytes.iter().map(fn(value) { saturating_byte(value) }),
  )
  cosmic_font_system.val = cosmic_font_system.val.load_font_data(bytes)
  cosmic_loaded_families.set(family, true)
  cosmic_text_cache.clear()
  true
}

///|
fn rasterize_with_cosmic(
  command : @render2d_types.TextDrawCommand2D,
) -> CosmicRasterImage? {
  let family = command.style.family
  if !cosmic_loaded_families.contains(family) {
    return None
  }
  let font_size = if command.style.size < 1.0 {
    1.0
  } else {
    command.style.size
  }
  let metrics = @cosmic.Metrics::new(
    Float::from_double(font_size),
    Float::from_double(font_size * 1.25),
  )
  let attrs = @cosmic.Attrs::new().family(@cosmic.Family::Name(family))
  let attrs_list = @cosmic.AttrsList::new(attrs)
  let buffer = @cosmic.Buffer::new(metrics)
    .set_wrap(@cosmic.Wrap::None)
    .set_text(command.text, attrs_list, @cosmic.Shaping::Advanced)
    .set_size(None, None)
  let mut min_x = 0
  let mut min_y = 0
  let mut max_x = -1
  let mut max_y = -1
  let points : Array[(Int, Int, Int, Int, Int, Int)] = []
  let (drawn_buffer, swash_cache) = buffer.draw(
    cosmic_font_system.val,
    cosmic_swash_cache.val,
    to_cosmic_color(command.style.color),
    fn(x, y, _w, _h, color) {
      let (r, g, b, a) = color.as_rgba()
      points.push((x, y, r.to_int(), g.to_int(), b.to_int(), a.to_int()))
      if max_x < min_x {
        min_x = x
        max_x = x
        min_y = y
        max_y = y
      } else {
        if x < min_x {
          min_x = x
        }
        if x > max_x {
          max_x = x
        }
        if y < min_y {
          min_y = y
        }
        if y > max_y {
          max_y = y
        }
      }
    },
  )
  ignore(drawn_buffer)
  cosmic_swash_cache.val = swash_cache
  if points.is_empty() {
    return None
  }
  let width = max_x - min_x + 1
  let height = max_y - min_y + 1
  let pixels = Array::make(width * height * 4, 0)
  for point in points {
    let x = point.0
    let y = point.1
    let r = point.2
    let g = point.3
    let b = point.4
    let a = point.5
    let local_x = x - min_x
    let local_y = y - min_y
    let idx = (local_y * width + local_x) * 4
    pixels[idx] = r
    pixels[idx + 1] = g
    pixels[idx + 2] = b
    pixels[idx + 3] = a
  }
  Some({ width, height, pixels })
}

///|
fn draw_text_with_cosmic(command : @render2d_types.TextDrawCommand2D) -> Bool {
  if command.text == "" {
    return true
  }
  if !ensure_font_loaded(command.style.family) &&
    !cosmic_loaded_families.contains(command.style.family) {
    return false
  }
  let key = text_cache_key(command)
  if !cosmic_text_cache.contains(key) {
    match rasterize_with_cosmic(command) {
      Some(image) => {
        if !webgpu_upload_text_texture(
            key,
            image.width,
            image.height,
            image.pixels,
          ) {
          return false
        }
        cosmic_text_cache.set(key, true)
      }
      None => return false
    }
  }
  if cosmic_text_cache.contains(key) {
    webgpu_draw_cached_text(
      key,
      command.position[X],
      command.position[Y],
      h_align_to_code(command.style.align),
      v_align_to_code(command.style.baseline),
    )
    true
  } else {
    false
  }
}
