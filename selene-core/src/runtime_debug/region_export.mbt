///|
fn debug_rect_to_math_rect(rect : DebugRect) -> @math.Rect {
  @math.Rect::{
    position: @math.Vec2(rect.x, rect.y),
    size: @math.Vec2(rect.width, rect.height),
  }
}

///|
fn default_sprite_region_file_name(
  entry : SpriteInspectorEntry,
  index : Int,
) -> String {
  let entity_id = entry.entity_id.to_string()
  "sprite_\{index.to_string()}_entity_\{entity_id}.png"
}

///|
fn join_output_path(output_dir : String, file_name : String) -> String {
  if output_dir == "" {
    return file_name
  }
  if output_dir.has_suffix("/") || output_dir.has_suffix("\\") {
    output_dir + file_name
  } else {
    output_dir + "/" + file_name
  }
}

///|
pub fn export_texture_region_png(
  image_path : String,
  rect : @math.Rect,
  out_path : String,
) -> Bool {
  @platform_render.export_texture_region_png(image_path, rect, out_path)
}

///|
pub fn export_sprite_inspector_regions(
  entries : Array[SpriteInspectorEntry],
  output_dir : String,
  file_naming? : (SpriteInspectorEntry, Int) -> String = default_sprite_region_file_name,
) -> Int {
  let mut exported = 0
  for index, entry in entries {
    guard entry.image_path is Some(image_path) else { continue }
    guard entry.source_rect is Some(source_rect) else { continue }
    let out_path = join_output_path(output_dir, file_naming(entry, index))
    if export_texture_region_png(
        image_path,
        debug_rect_to_math_rect(source_rect),
        out_path,
      ) {
      exported += 1
    }
  }
  exported
}
