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
const VIEWPORT_WIDTH : Double = 960.0

///|
const VIEWPORT_HEIGHT : Double = 640.0

///|
fn color(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @render.Vec3 {
  @render.Vec3::{ x, y, z }
}

///|
pub fn run() -> Unit {
  @system.App::new()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .with_fps(60)
  .add_system(draw_scene_system, schedule=Render)
  .add_system(draw_overlay_system, schedule=Render)
  .run()
}

///|
fn draw_scene_system(_delta : Double) -> Unit {
  @backend.begin_3d(@render.Camera3D::{
    position: vec3(-2.5, 4.5, 9.0),
    target: vec3(0.0, 0.0, 0.0),
    up: vec3(0.0, 1.0, 0.0),
    fovy: 45.0,
  })

  // Bevy sample uses Circle(radius=4.0); a thin cylinder reproduces the same base.
  @backend.draw_cylinder_3d(@render.CylinderDrawCommand3D::{
    center: vec3(0.0, -0.05, 0.0),
    radius_top: 4.0,
    radius_bottom: 4.0,
    height: 0.1,
    slices: 64,
    color: color(255U, 255U, 255U, 1.0),
  })

  @backend.draw_cube_3d(@render.CubeDrawCommand3D::{
    center: vec3(0.0, 0.5, 0.0),
    size: vec3(1.0, 1.0, 1.0),
    color: color(124U, 144U, 255U, 1.0),
  })
  @backend.draw_cube_wires_3d(@render.CubeDrawCommand3D::{
    center: vec3(0.0, 0.5, 0.0),
    size: vec3(1.0, 1.0, 1.0),
    color: color(0U, 0U, 0U, 1.0),
  })

  // Point-light marker at (4, 8, 4).
  @backend.draw_sphere_3d(@render.SphereDrawCommand3D::{
    center: vec3(4.0, 8.0, 4.0),
    radius: 0.2,
    color: color(253U, 249U, 0U, 1.0),
  })

  @backend.end_3d()
}

///|
fn draw_overlay_system(_delta : Double) -> Unit {
  @backend.draw_text(@render.TextDrawCommand::{
    text: "3d_scene: bevy 3d_scene.rs replicated",
    position: @math.Vec2D(16.0, 16.0),
    style: @render.TextStyle::{
      family: "sans-serif",
      size: 20.0,
      color: color(245U, 245U, 245U, 1.0),
      align: Left,
      baseline: Top,
    },
  })
}
