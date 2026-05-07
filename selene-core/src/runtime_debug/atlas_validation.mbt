///|
fn rect_equals(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  lhs.position == rhs.position && lhs.size == rhs.size
}

///|
fn rect_overlap(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  let l_min_x = lhs.position[@math.X]
  let l_min_y = lhs.position[@math.Y]
  let l_max_x = lhs.position[@math.X] + lhs.size[@math.X]
  let l_max_y = lhs.position[@math.Y] + lhs.size[@math.Y]

  let r_min_x = rhs.position[@math.X]
  let r_min_y = rhs.position[@math.Y]
  let r_max_x = rhs.position[@math.X] + rhs.size[@math.X]
  let r_max_y = rhs.position[@math.Y] + rhs.size[@math.Y]

  l_min_x < r_max_x &&
  l_max_x > r_min_x &&
  l_min_y < r_max_y &&
  l_max_y > r_min_y
}

///|
fn validate_atlas_transparency(
  image_path : String?,
  rects : Array[@math.Rect],
  issues : Array[AtlasValidationIssue],
) -> Unit {
  guard image_path is Some(path) else {
    issues.push({
      kind: TransparencyCheckUnavailable,
      rect_index: None,
      other_rect_index: None,
      message: "Transparency checks require an atlas image path",
    })
    return
  }
  let mut backend_supported = false
  for index, rect in rects {
    match @platform_render.image_region_is_fully_transparent(path, rect) {
      Some(true) => {
        backend_supported = true
        issues.push({
          kind: FullyTransparentRect,
          rect_index: Some(index),
          other_rect_index: None,
          message: "Frame rect appears fully transparent",
        })
      }
      Some(false) => backend_supported = true
      None => ()
    }
  }
  if !backend_supported {
    issues.push({
      kind: TransparencyCheckUnavailable,
      rect_index: None,
      other_rect_index: None,
      message: "Current platform cannot inspect atlas transparency",
    })
  }
}

///|
pub fn validate_texture_atlas_layout(
  layout : @sprite.TextureAtlasLayout,
) -> AtlasValidationReport {
  validate_texture_atlas_layout_for_image(layout, None)
}

///|
pub fn validate_texture_atlas_layout_for_image(
  layout : @sprite.TextureAtlasLayout,
  image_path : String?,
) -> AtlasValidationReport {
  let atlas_size = @sprite.texture_atlas_layout_size(layout)
  let rects = @sprite.texture_atlas_layout_rects(layout)
  let issues : Array[AtlasValidationIssue] = []
  if atlas_size[@math.X] <= 0.0 || atlas_size[@math.Y] <= 0.0 {
    issues.push({
      kind: InvalidAtlasSize,
      rect_index: None,
      other_rect_index: None,
      message: "Atlas size must be positive",
    })
  }
  for index, rect in rects {
    if rect.size[@math.X] <= 0.0 || rect.size[@math.Y] <= 0.0 {
      issues.push({
        kind: InvalidRectSize,
        rect_index: Some(index),
        other_rect_index: None,
        message: "Frame rect size must be positive",
      })
    }
    let max_x = rect.position[@math.X] + rect.size[@math.X]
    let max_y = rect.position[@math.Y] + rect.size[@math.Y]
    if rect.position[@math.X] < 0.0 ||
      rect.position[@math.Y] < 0.0 ||
      max_x > atlas_size[@math.X] ||
      max_y > atlas_size[@math.Y] {
      issues.push({
        kind: OutOfBounds,
        rect_index: Some(index),
        other_rect_index: None,
        message: "Frame rect is outside atlas bounds",
      })
    }
  }
  for left_index in 0..<rects.length() {
    for right_index in (left_index + 1)..<rects.length() {
      let lhs = rects[left_index]
      let rhs = rects[right_index]
      if rect_equals(lhs, rhs) {
        issues.push({
          kind: DuplicateRect,
          rect_index: Some(left_index),
          other_rect_index: Some(right_index),
          message: "Duplicate frame rect detected",
        })
      } else if rect_overlap(lhs, rhs) {
        issues.push({
          kind: Overlap,
          rect_index: Some(left_index),
          other_rect_index: Some(right_index),
          message: "Overlapping frame rect detected",
        })
      }
    }
  }
  validate_atlas_transparency(image_path, rects, issues)
  { total_rects: rects.length(), issues }
}

///|
pub fn validate_registered_texture_atlases() -> Array[
  (@sprite.TextureAtlasLayoutHandle, AtlasValidationReport),
] {
  let atlas_image_paths : Map[@sprite.TextureAtlasLayoutHandle, String] = Map::of([])
  for _entity, sprite in @sprite.sprites() {
    guard sprite.texture_atlas is Some(atlas) else { continue }
    guard sprite.image is Some(image_handle) else { continue }
    guard @asset.image_path(image_handle) is Some(path) else { continue }
    if !atlas_image_paths.contains(atlas.layout) {
      atlas_image_paths.set(atlas.layout, path)
    }
  }
  let reports : Array[(@sprite.TextureAtlasLayoutHandle, AtlasValidationReport)] = []
  for pair in @sprite.texture_atlas_layout_entries() {
    reports.push(
      (
        pair.0,
        validate_texture_atlas_layout_for_image(
          pair.1,
          atlas_image_paths.get(pair.0),
        ),
      ),
    )
  }
  reports
}
