///|
pub(all) struct ColorMaterial {
  color : @render.Color
  texture : @asset.ImageHandle?
  uv_transform : @math.Transform
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
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
} derive(Eq, Debug)

///|
priv struct Material2dWorldStore {
  mesh_material2ds : Map[@entity.Entity, MeshMaterial2d]
}

///|
let material2d_world_stores : Map[UInt, Material2dWorldStore] = Map([])

///|
fn material2d_world_store() -> Material2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  material2d_world_stores.get_or_init(world_id, fn() {
    { mesh_material2ds: Map([]) }
  })
}

///|
pub fn mesh_material2ds() -> Map[@entity.Entity, MeshMaterial2d] {
  material2d_world_store().mesh_material2ds
}

///|
let color_materials : Map[ColorMaterialHandle, ColorMaterial] = Map([])

///|
let next_color_material_id : Ref[UInt] = Ref(0U)

///|
fn default_material_color() -> @render.Color {
  @render.Color::{ r: 255U, g: 255U, b: 255U, a: 1.0 }
}

///|
pub fn ColorMaterial::ColorMaterial(
  color? : @render.Color = default_material_color(),
  texture? : @asset.ImageHandle? = None,
  uv_transform? : @math.Transform = @math.Transform::identity(),
  alpha_mode? : @render.AlphaMode2D = Blend,
  blend_mode? : @render.BlendMode2D = Alpha,
) -> ColorMaterial {
  { color, texture, uv_transform, alpha_mode, blend_mode }
}

///|
pub fn ColorMaterial::from_color(color : @render.Color) -> ColorMaterial {
  ColorMaterial(color~)
}

///|
pub fn MeshMaterial2d::MeshMaterial2d(
  material : Material2dHandle,
) -> MeshMaterial2d {
  { material, }
}

///|
pub fn MeshMaterial2d::from_color_material(
  material : ColorMaterialHandle,
) -> MeshMaterial2d {
  MeshMaterial2d(Color(material))
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
  handle
}

///|
pub fn update_color_material(
  handle : ColorMaterialHandle,
  material : ColorMaterial,
) -> Unit {
  color_materials.set(handle, material)
}

///|
pub fn release_color_material(handle : ColorMaterialHandle) -> Unit {
  color_materials.remove(handle)
}
