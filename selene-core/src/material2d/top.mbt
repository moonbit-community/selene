///|
pub(all) enum AlphaMode2D {
  Opaque
  Blend
} derive(Eq, Debug)

///|
pub(all) struct ColorMaterial {
  color : @render.Color
  texture : @asset.ImageHandle?
  uv_transform : @math.Transform
  alpha_mode : AlphaMode2D

  fn new(
    color? : @render.Color,
    texture? : @asset.ImageHandle?,
    uv_transform? : @math.Transform,
    alpha_mode? : AlphaMode2D,
  ) -> ColorMaterial
}

///|
pub(all) struct ColorMaterialHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) enum Material2dHandle {
  Color(ColorMaterialHandle)
} derive(Eq, Debug)

///|
pub(all) struct MeshMaterial2d {
  material : Material2dHandle

  fn new(material : Material2dHandle) -> MeshMaterial2d
} derive(Eq, Debug)

///|
priv struct Material2dWorldStore {
  mesh_material2ds : Map[@entity.Entity, MeshMaterial2d]
}

///|
let material2d_world_stores : Map[UInt, Material2dWorldStore] = Map::new()

///|
fn material2d_world_store() -> Material2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  material2d_world_stores.get_or_init(world_id, fn() {
    { mesh_material2ds: Map::new() }
  })
}

///|
pub fn mesh_material2ds() -> Map[@entity.Entity, MeshMaterial2d] {
  material2d_world_store().mesh_material2ds
}

///|
let color_materials : Map[ColorMaterialHandle, ColorMaterial] = Map::new()

///|
let next_color_material_id : Ref[UInt] = Ref::new(0U)

///|
let dirty_color_materials : Map[ColorMaterialHandle, ColorMaterial] = Map::new()

///|
let released_color_materials : Array[ColorMaterialHandle] = []

///|
fn default_material_color() -> @render.Color {
  @render.Color::{ r: 255U, g: 255U, b: 255U, a: 1.0 }
}

///|
pub fn ColorMaterial::new(
  color? : @render.Color = default_material_color(),
  texture? : @asset.ImageHandle? = None,
  uv_transform? : @math.Transform = @math.Transform::identity(),
  alpha_mode? : AlphaMode2D = Blend,
) -> ColorMaterial {
  { color, texture, uv_transform, alpha_mode }
}

///|
pub fn ColorMaterial::from_color(color : @render.Color) -> ColorMaterial {
  ColorMaterial::new(color~)
}

///|
pub fn MeshMaterial2d::new(material : Material2dHandle) -> MeshMaterial2d {
  { material, }
}

///|
pub fn MeshMaterial2d::from_color_material(
  material : ColorMaterialHandle,
) -> MeshMaterial2d {
  MeshMaterial2d::new(Color(material))
}

///|
pub fn color_material(handle : ColorMaterialHandle) -> ColorMaterial? {
  color_materials.get(handle)
}

///|
pub fn register_color_material(material : ColorMaterial) -> ColorMaterialHandle {
  let handle = ColorMaterialHandle(next_color_material_id.val)
  next_color_material_id.val += 1U
  color_materials.set(handle, material)
  dirty_color_materials.set(handle, material)
  handle
}

///|
pub fn update_color_material(
  handle : ColorMaterialHandle,
  material : ColorMaterial,
) -> Unit {
  color_materials.set(handle, material)
  dirty_color_materials.set(handle, material)
}

///|
pub fn release_color_material(handle : ColorMaterialHandle) -> Unit {
  color_materials.remove(handle)
  dirty_color_materials.remove(handle)
  released_color_materials.push(handle)
}

///|
pub fn take_dirty_color_materials() -> Array[
  (ColorMaterialHandle, ColorMaterial),
] {
  let dirty = dirty_color_materials.to_array()
  dirty_color_materials.clear()
  dirty
}

///|
pub fn take_released_color_materials() -> Array[ColorMaterialHandle] {
  let released = released_color_materials.copy()
  released_color_materials.clear()
  released
}
