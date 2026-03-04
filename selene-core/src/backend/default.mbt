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
pub fn initialize(config : @render.BackendConfig) -> () -> Unit {
  ignore(config.startup)
  ignore(config.render_loop)
  ignore(config.game_loop)
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  ignore(config.screen_width)
  ignore(config.screen_height)
  ignore(config.fps)
  ignore(config.image_smooth)
  fn() {  }
}

///|
pub fn draw_image(command : @render.ImageDrawCommand) -> Unit {
  ignore(command)
}

///|
pub fn register_key_events(pressed_keys : Set[@inputs.Code]) -> Unit {
  ignore(pressed_keys)
}

///|
pub fn register_mouse_events(
  mouse : @inputs.Mouse,
  mouse_movement : @inputs.MouseMovement,
) -> Unit {
  ignore(mouse)
  ignore(mouse_movement)
}

///|
pub fn register_gamepad_events(
  gamepads : Set[@inputs.Gamepad],
  buttons : Set[@inputs.GamepadButtonInput],
  axes : Map[@inputs.GamepadAxisInput, Double],
) -> Unit {
  ignore(gamepads)
  ignore(buttons)
  ignore(axes)
}

///|
pub fn lock_mouse(locked : Ref[Bool]) -> Unit {
  ignore(locked)
}

///|
pub fn draw_text(command : @render.TextDrawCommand) -> Unit {
  ignore(command)
}

///|
pub fn measure_text(style : @render.TextStyle, text : String) -> @math.Vec2D {
  let width = text.length().to_double() * style.size * 0.6
  let height = style.size
  @math.Vec2D(width, height)
}

///|
pub fn draw_rect(command : @render.RectDrawCommand) -> Unit {
  ignore(command)
}

///|
pub fn draw_circle(command : @render.CircleDrawCommand) -> Unit {
  ignore(command)
}

///|
pub fn draw_gradient_rect(command : @render.GradientRectDrawCommand) -> Unit {
  ignore(command)
}

///|
pub fn begin_3d(camera : @render.Camera3D) -> Unit {
  ignore(camera)
}

///|
pub fn end_3d() -> Unit {

}

///|
pub fn draw_cube_3d(command : @render.CubeDrawCommand3D) -> Unit {
  ignore(command)
}

///|
pub fn draw_cube_wires_3d(command : @render.CubeDrawCommand3D) -> Unit {
  ignore(command)
}

///|
pub fn draw_sphere_3d(command : @render.SphereDrawCommand3D) -> Unit {
  ignore(command)
}

///|
pub fn draw_cylinder_3d(command : @render.CylinderDrawCommand3D) -> Unit {
  ignore(command)
}

///|
pub fn sync_mesh_asset(
  handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.MeshAsset,
) -> Unit {
  ignore(handle)
  ignore(mesh)
}

///|
pub fn sync_material_asset(
  handle : @render3d_types.MaterialHandle,
  material : @render3d_types.StandardMaterial3D,
) -> Unit {
  ignore(handle)
  ignore(material)
}

///|
pub fn sync_image_asset(
  handle : @render3d_types.ImageHandle,
  image : @render3d_types.ImageAsset,
) -> Unit {
  ignore(handle)
  ignore(image)
}

///|
pub fn release_mesh_asset(handle : @render3d_types.MeshHandle) -> Unit {
  ignore(handle)
}

///|
pub fn release_material_asset(handle : @render3d_types.MaterialHandle) -> Unit {
  ignore(handle)
}

///|
pub fn release_image_asset(handle : @render3d_types.ImageHandle) -> Unit {
  ignore(handle)
}

///|
pub fn render_3d_frame(frame : @render3d_types.RenderFrame3D) -> Unit {
  ignore(frame)
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  loop_~ : Bool,
) -> Unit {
  ignore(audio_path)
  ignore(volume)
  ignore(loop_)
}

///|
pub fn preload_img(path : String) -> Unit {
  ignore(path)
}

///|
pub fn preload_audio(path : String) -> Unit {
  ignore(path)
}

///|
pub fn set_embedded_assets(lookup : (String) -> Bytes?) -> Unit {
  ignore(lookup)
}

///|
pub fn get_asset_bytes(path : String) -> Bytes? {
  ignore(path)
  None
}

///|
pub fn request_close() -> Unit {

}

///|
pub fn set_time_scale(scale : Double) -> Unit {
  ignore(scale)
}

///|
pub fn load_font(font : String, path : String) -> Unit {
  ignore(font)
  ignore(path)
}

///|
pub fn get_realtime_delta() -> Double {
  0.016
}

///|
pub fn get_time_scale() -> Double {
  1.0
}
