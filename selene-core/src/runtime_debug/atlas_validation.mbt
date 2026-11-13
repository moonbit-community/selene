///|
pub(all) enum AtlasValidationIssueKind {
  InvalidAtlasSize
  InvalidRectSize
  OutOfBounds
  DuplicateRect
  Overlap
  FullyTransparentRect
  TransparencyCheckUnavailable
}

///|
pub(all) struct AtlasValidationIssue {
  kind : AtlasValidationIssueKind
  rect_index : Int32?
  other_rect_index : Int32?
  message : String
}

///|
pub(all) struct AtlasValidationReport {
  total_rects : Int32
  issues : Array[AtlasValidationIssue]
}

///|
fn rect_equals(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  lhs.position == rhs.position && lhs.size == rhs.size
}

///|
fn rect_overlap(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  let l_min_x = lhs.position.x
  let l_min_y = lhs.position.y
  let l_max_x = lhs.position.x + lhs.size.x
  let l_max_y = lhs.position.y + lhs.size.y

  let r_min_x = rhs.position.x
  let r_min_y = rhs.position.y
  let r_max_x = rhs.position.x + rhs.size.x
  let r_max_y = rhs.position.y + rhs.size.y

  l_min_x < r_max_x &&
  l_max_x > r_min_x &&
  l_min_y < r_max_y &&
  l_max_y > r_min_y
}

///|
fn validate_atlas_transparency(
  image : @asset.ImageHandle?,
  rects : Array[@math.Rect],
  issues : Array[AtlasValidationIssue],
) -> Unit {
  guard image is Some(handle) else {
    issues.push({
      kind: TransparencyCheckUnavailable,
      rect_index: None,
      other_rect_index: None,
      message: "Transparency checks require an atlas image",
    })
    return
  }
  let mut backend_supported = false
  for index, rect in rects {
    match @platform_render.image_region_is_fully_transparent(handle, rect) {
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
  image : @asset.ImageHandle?,
) -> AtlasValidationReport {
  let atlas_size = @sprite.texture_atlas_layout_size(layout)
  let rects = @sprite.texture_atlas_layout_rects(layout)
  let issues : Array[AtlasValidationIssue] = []
  if atlas_size.x <= 0.0 || atlas_size.y <= 0.0 {
    issues.push({
      kind: InvalidAtlasSize,
      rect_index: None,
      other_rect_index: None,
      message: "Atlas size must be positive",
    })
  }
  for index, rect in rects {
    if rect.size.x <= 0.0 || rect.size.y <= 0.0 {
      issues.push({
        kind: InvalidRectSize,
        rect_index: Some(index),
        other_rect_index: None,
        message: "Frame rect size must be positive",
      })
    }
    let max_x = rect.position.x + rect.size.x
    let max_y = rect.position.y + rect.size.y
    if rect.position.x < 0.0 ||
      rect.position.y < 0.0 ||
      max_x > atlas_size.x ||
      max_y > atlas_size.y {
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
  validate_atlas_transparency(image, rects, issues)
  { total_rects: rects.length(), issues, }
}

///|
pub fn validate_registered_texture_atlases(
  world~ : @ecs.World,
) -> Array[(@sprite.TextureAtlasLayoutHandle, AtlasValidationReport)] {
  let query_sprite : @ecs.Query[@ecs.Single[@sprite.Sprite]] = world.query()
  let atlas_images : Map[@sprite.TextureAtlasLayoutHandle, @asset.ImageHandle] = Map([],
  )
  for _entity, Single(sprite) in query_sprite {
    guard sprite.texture_atlas is Some(atlas) else { continue }
    guard sprite.image is Some(image_handle) else { continue }
    if !atlas_images.contains(atlas.layout) {
      atlas_images.set(atlas.layout, image_handle)
    }
  }
  let reports : Array[(@sprite.TextureAtlasLayoutHandle, AtlasValidationReport)] = []
  for (handle, layout) in @sprite.texture_atlas_layout_entries() {
    reports.push(
      (
        handle,
        validate_texture_atlas_layout_for_image(
          layout,
          atlas_images.get(handle),
        ),
      ),
    )
  }
  reports
}
