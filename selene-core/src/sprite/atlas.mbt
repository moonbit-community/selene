///|
pub(all) struct TextureAtlasLayout {
  size : @math.Vec2D
  rects : Array[@math.Rect]

  fn new(size : @math.Vec2D, rects : Array[@math.Rect]) -> TextureAtlasLayout
}

///|
pub(all) struct TextureAtlasLayoutHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct TextureAtlas {
  layout : TextureAtlasLayoutHandle
  mut index : Int

  fn new(layout : TextureAtlasLayoutHandle, index? : Int) -> TextureAtlas
} derive(Eq, Show)

///|
let texture_atlas_layouts_by_handle : Map[
  TextureAtlasLayoutHandle,
  TextureAtlasLayout,
] = Map::new()

///|
let next_texture_atlas_layout_id : Ref[UInt] = Ref::new(0U)

///|
let dirty_texture_atlas_layouts : Map[
  TextureAtlasLayoutHandle,
  TextureAtlasLayout,
] = Map::new()

///|
let released_texture_atlas_layouts : Array[TextureAtlasLayoutHandle] = []

///|
pub fn TextureAtlasLayout::new(
  size : @math.Vec2D,
  rects : Array[@math.Rect],
) -> TextureAtlasLayout {
  { size, rects }
}

///|
pub fn TextureAtlasLayout::from_grid(
  tile_size : @math.Vec2D,
  columns : Int,
  rows : Int,
  padding? : @math.Vec2D? = None,
  offset? : @math.Vec2D? = None,
) -> TextureAtlasLayout {
  let rects : Array[@math.Rect] = []
  let padding = padding.unwrap_or(@math.Vec2D::zero())
  let offset = offset.unwrap_or(@math.Vec2D::zero())
  for row in 0..<rows {
    for column in 0..<columns {
      let position = @math.Vec2D(
        offset[X] + column.to_double() * (tile_size[X] + padding[X]),
        offset[Y] + row.to_double() * (tile_size[Y] + padding[Y]),
      )
      rects.push({ position, size: tile_size })
    }
  }
  let size = @math.Vec2D(
    offset[X] +
    columns.to_double() * tile_size[X] +
    @cmp.maximum(0.0, (columns - 1).to_double()) * padding[X],
    offset[Y] +
    rows.to_double() * tile_size[Y] +
    @cmp.maximum(0.0, (rows - 1).to_double()) * padding[Y],
  )
  { size, rects }
}

///|
pub fn TextureAtlas::new(
  layout : TextureAtlasLayoutHandle,
  index? : Int = 0,
) -> TextureAtlas {
  { layout, index }
}

///|
pub fn texture_atlas_layout(
  handle : TextureAtlasLayoutHandle,
) -> TextureAtlasLayout? {
  texture_atlas_layouts_by_handle.get(handle)
}

///|
pub fn texture_atlas_rect(texture_atlas : TextureAtlas) -> @math.Rect? {
  guard texture_atlas_layout(texture_atlas.layout) is Some(layout) else {
    return None
  }
  if texture_atlas.index < 0 || texture_atlas.index >= layout.rects.length() {
    return None
  }
  Some(layout.rects[texture_atlas.index])
}

///|
pub fn register_texture_atlas_layout(
  layout : TextureAtlasLayout,
) -> TextureAtlasLayoutHandle {
  let handle = TextureAtlasLayoutHandle(next_texture_atlas_layout_id.val)
  next_texture_atlas_layout_id.val += 1U
  texture_atlas_layouts_by_handle.set(handle, layout)
  dirty_texture_atlas_layouts.set(handle, layout)
  handle
}

///|
pub fn update_texture_atlas_layout(
  handle : TextureAtlasLayoutHandle,
  layout : TextureAtlasLayout,
) -> Unit {
  texture_atlas_layouts_by_handle.set(handle, layout)
  dirty_texture_atlas_layouts.set(handle, layout)
}

///|
pub fn release_texture_atlas_layout(handle : TextureAtlasLayoutHandle) -> Unit {
  texture_atlas_layouts_by_handle.remove(handle)
  dirty_texture_atlas_layouts.remove(handle)
  released_texture_atlas_layouts.push(handle)
}

///|
pub fn take_dirty_texture_atlas_layouts() -> Array[
  (TextureAtlasLayoutHandle, TextureAtlasLayout),
] {
  let dirty = dirty_texture_atlas_layouts.to_array()
  dirty_texture_atlas_layouts.clear()
  dirty
}

///|
pub fn take_released_texture_atlas_layouts() -> Array[TextureAtlasLayoutHandle] {
  let released = released_texture_atlas_layouts.copy()
  released_texture_atlas_layouts.clear()
  released
}
