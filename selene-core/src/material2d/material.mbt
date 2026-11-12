///|
pub(all) struct ColorMaterial {
  color : @render.Color
  texture : @asset.ImageHandle?
  uv_transform : @math.Affine2
  alpha_mode : @render.AlphaMode2D
  blend_mode : @render.BlendMode2D
}

///|
#derive(Eq, Debug, Hash)
pub(all) struct ColorMaterialHandle(UInt32)

///|
pub extend ColorMaterialHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ColorMaterialHandle with Eq::{not_equal, equal}

///|
pub extend ColorMaterialHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
pub(all) enum Material2dHandle {
  Color(ColorMaterialHandle)
}

///|
pub extend Material2dHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Material2dHandle with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct MeshMaterial2d {
  material : Material2dHandle
}

///|
pub extend MeshMaterial2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MeshMaterial2d with Eq::{not_equal, equal}

///|
let color_materials : Map[ColorMaterialHandle, ColorMaterial] = Map([])

///|
let next_color_material_id : Ref[UInt32] = Ref(0U)

///|
fn default_material_color() -> @render.Color {
  { r: 255U, g: 255U, b: 255U, a: 1.0, }
}

///|
pub fn ColorMaterial::ColorMaterial(
  color~ : @render.Color = default_material_color(),
  texture~ : @asset.ImageHandle? = None,
  uv_transform~ : @math.Affine2 = @math.Affine2::identity(),
  alpha_mode~ : @render.AlphaMode2D = Blend,
  blend_mode~ : @render.BlendMode2D = Alpha,
) -> ColorMaterial {
  { color, texture, uv_transform, alpha_mode, blend_mode, }
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
