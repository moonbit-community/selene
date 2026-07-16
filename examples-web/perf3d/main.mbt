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
const DEFAULT_COUNT : Int = 1000

///|
const DEFAULT_DURATION : Double = 10.0

///|
priv struct PerfConfig {
  case_name : String
  mode : String
  count : Int
  duration : Double
}

///|
priv struct PerfState {
  config : PerfConfig
  entities : Array[@entity.Entity]
  frame_samples : Array[Double]
  work_samples : Array[Double]
  game_samples : Array[Double]
  render_samples : Array[Double]
  render3d_submit_samples : Array[Double]
  render3d_items_samples : Array[Double]
  render3d_flush_samples : Array[Double]
  start_ms : Double
  mut last_ms : Double
  mut last_live_ms : Double
  mut frames : Int
  mut max_frame_ms : Double
  mut max_work_ms : Double
  mut finished : Bool
  hud : @entity.Entity
}

///|
let perf_state : Ref[PerfState?] = Ref(None)

///|
fn color(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  { r, g, b, a }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @math.Vec3 {
  Vec3(x, y, z)
}

///|
fn look_at_rotation(position : @math.Vec3, target : @math.Vec3) -> @math.Quat {
  let forward = (target - position).normalize()
  if forward.length_squared() <= 0.0000001 {
    return @math.Quat::identity()
  }
  let world_up = @math.Vec3::y_axis()
  let right = forward.cross(world_up).normalize()
  let camera_z = -forward
  let camera_y = camera_z.cross(right).normalize()
  @math.Quat::from_basis(right, camera_y, camera_z)
}

///|
fn read_perf_config() -> PerfConfig {
  {
    case_name: perf_query_case("static-cubes"),
    mode: perf_query_mode("cheap"),
    count: perf_query_count(DEFAULT_COUNT),
    duration: perf_query_duration(DEFAULT_DURATION),
  }
}

///|
fn configure_lighting_mode(mode : String) -> Unit {
  let lighting_mode = match mode {
    "full" => @webgpu.Render3DLightingMode::Full
    "unlit" => Unlit
    _ => Cheap
  }
  @webgpu.set_render3d_lighting_mode(lighting_mode)
}

///|
pub fn run() -> Unit {
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .with_fps(60)
  .add_plugin(@plugins.default_3d_plugin)
  .add_system(Startup, setup_perf3d)
  .add_system(Update, animate_perf3d)
  .add_system(PostUpdate, update_perf3d_stats)
  .run()
}

///|
fn setup_perf3d(_world : @ecs.World) -> Unit {
  let config = read_perf_config()
  configure_lighting_mode(config.mode)
  setup_camera(config)
  setup_lights(config)

  let meshes = meshes_for_case(config.case_name)
  let material = material_for_case(config.case_name)
  let entities = spawn_grid(config, meshes, material)
  let hud = setup_hud(config)
  let now = perf_now_ms()
  perf_state.val = Some({
    config,
    entities,
    frame_samples: [],
    work_samples: [],
    game_samples: [],
    render_samples: [],
    render3d_submit_samples: [],
    render3d_items_samples: [],
    render3d_flush_samples: [],
    start_ms: now,
    last_ms: now,
    last_live_ms: now,
    frames: 0,
    max_frame_ms: 0.0,
    max_work_ms: 0.0,
    finished: false,
    hud,
  })
}

///|
fn setup_camera(config : PerfConfig) -> Unit {
  let camera = @entity.Entity()
  let side = ceil_sqrt(config.count).to_double()
  let distance = (side * 1.65).max(34.0)
  let position = vec3(0.0, distance * 0.55, distance)
  @transform.transforms().set(camera, {
    translation: position,
    rotation: look_at_rotation(position, @math.Vec3::zero()),
    scale: @math.Vec3::one(),
  })
  @camera3d.cameras3d().set(camera, {
    ..@camera3d.Camera3DComponent::default(),
    clear_color: color(18U, 20U, 26U, 1.0),
    fov_y: 75.0,
    far: 500.0,
  })
}

///|
fn setup_lights(config : PerfConfig) -> Unit {
  @render3d.set_ambient_light3d(
    Some({ color: color(255U, 255U, 255U, 1.0), intensity: 0.08 }),
  )
  let dir_light = @entity.Entity()
  @render3d.directional_lights3d().set(dir_light, {
    ..@render3d.default_directional_light3d(),
    direction: vec3(-0.35, -0.8, -0.45).normalize(),
    color: color(255U, 245U, 220U, 1.0),
    intensity: 1.8,
    shadows: config.case_name == "shadow-casters",
  })
}

///|
fn setup_hud(config : PerfConfig) -> @entity.Entity {
  let hud = @entity.Entity()
  @ui.nodes().set(
    hud,
    @ui.Node::absolute(Vec2(16.0, 16.0), size=Vec2(900.0, 92.0)),
  )
  @ui.texts().set(
    hud,
    Text(
      "perf3d: case=\{config.case_name} count=\{config.count} mode=\{config.mode}",
    ),
  )
  @ui.text_fonts().set(hud, TextFont(family="monospace", size=18.0))
  @ui.text_colors().set(hud, TextColor(color(236U, 244U, 255U, 1.0)))
  @ui.z_indexes().set(hud, ZIndex(100))
  hud
}

///|
fn meshes_for_case(case_name : String) -> Array[@render3d.MeshHandle] {
  let meshes : Array[@render3d.MeshAsset] = match case_name {
    "mixed-primitives" =>
      [
        @render3d.cube_mesh(vec3(0.8, 0.8, 0.8)),
        @render3d.sphere_mesh(0.45),
        @render3d.cylinder_mesh(0.42, 0.42, 0.9, slices=24),
        @render3d.plane_mesh(vec3(0.9, 0.9, 0.9)),
      ]
    "shadow-casters" => [@render3d.cube_mesh(vec3(0.8, 1.4, 0.8))]
    _ => [@render3d.cube_mesh(vec3(0.8, 0.8, 0.8))]
  }
  meshes.map(@render3d.register_mesh_asset)
}

///|
fn material_for_case(case_name : String) -> @render3d.MaterialHandle {
  let base = match case_name {
    "shadow-casters" => color(230U, 175U, 90U, 1.0)
    "mixed-primitives" => color(106U, 190U, 255U, 1.0)
    _ => color(130U, 210U, 145U, 1.0)
  }
  @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: base,
    roughness: 0.75,
  })
}

///|
fn spawn_grid(
  config : PerfConfig,
  meshes : Array[@render3d.MeshHandle],
  material : @render3d.MaterialHandle,
) -> Array[@entity.Entity] {
  let entities : Array[@entity.Entity] = []
  let side = ceil_sqrt(config.count)
  let spacing = if config.case_name == "shadow-casters" { 1.35 } else { 1.15 }
  let half = (side - 1).to_double() * spacing * 0.5
  for index in 0..<config.count {
    let row = index / side
    let col = index % side
    let entity = @entity.Entity()
    @transform.transforms().set(entity, {
      translation: vec3(
        col.to_double() * spacing - half,
        0.0,
        row.to_double() * spacing - half,
      ),
      rotation: @math.Quat::identity(),
      scale: @math.Vec3::one(),
    })
    @render3d.mesh3d_renderers().set(entity, {
      mesh: meshes[index % meshes.length()],
      material,
      visible: true,
      cast_shadows: config.case_name == "shadow-casters",
      receive_shadows: false,
    })
    entities.push(entity)
  }
  entities
}

///|
fn ceil_sqrt(value : Int) -> Int {
  let mut side = 1
  while side * side < value {
    side += 1
  }
  side
}

///|
fn animate_perf3d(_world : @ecs.World) -> Unit {
  guard perf_state.val is Some(state) else { return }
  if state.config.case_name != "dynamic-cubes" {
    return
  }
  let elapsed = @time.elapsed()
  for index in 0..<state.entities.length() {
    let entity = state.entities[index]
    guard @transform.transforms().get(entity) is Some(transform) else {
      continue
    }
    @transform.transforms().set(entity, {
      ..transform,
      rotation: @math.Quat::from_axis_angle(
        vec3(0.0, 1.0, 0.0),
        elapsed + index.to_double() * 0.01,
      ),
    })
  }
}

///|
fn update_perf3d_stats(_world : @ecs.World) -> Unit {
  guard perf_state.val is Some(state) else { return }
  if state.finished {
    return
  }
  let now = perf_now_ms()
  let frame_ms = now - state.last_ms
  state.last_ms = now
  if state.frames > 0 {
    state.frame_samples.push(frame_ms)
    state.max_frame_ms = state.max_frame_ms.max(frame_ms)
  }
  state.frames += 1

  let elapsed_s = (now - state.start_ms) / 1000.0
  let stats = @webgpu.render3d_last_submission_stats()
  let timing = @webgpu.webgpu_last_frame_timing()
  let render3d_timing = @webgpu.webgpu_last_render3d_timing()
  if state.frames > 1 {
    state.work_samples.push(timing.total_work_ms)
    state.game_samples.push(timing.game_ms)
    state.render_samples.push(timing.render_ms)
    state.render3d_submit_samples.push(render3d_timing.submit_total_ms)
    state.render3d_items_samples.push(render3d_timing.items_ms)
    state.render3d_flush_samples.push(render3d_timing.flush_ms)
    state.max_work_ms = state.max_work_ms.max(timing.total_work_ms)
  }
  let avg_fps = if elapsed_s > 0.0 {
    state.frames.to_double() / elapsed_s
  } else {
    0.0
  }
  if now - state.last_live_ms >= 250.0 {
    state.last_live_ms = now
    let p95 = percentile_frame_ms(state.frame_samples, 0.95)
    let work_p95 = percentile_frame_ms(state.work_samples, 0.95)
    perf_publish_live(
      state.config.case_name,
      state.config.count,
      state.config.duration,
      state.frames,
      avg_fps,
      p95,
      work_p95,
      stats.draw_commands,
      stats.uploaded_vertex_bytes,
    )
    let hud_text = StringBuilder::new()
    hud_text.write_string(
      "perf3d case=\{state.config.case_name} count=\{state.config.count} mode=\{state.config.mode}",
    )
    hud_text.write_char('\n')
    hud_text.write_string(
      "fps=\{avg_fps} p95=\{p95}ms work_p95=\{work_p95}ms draw=\{stats.draw_commands} submitted=\{stats.submitted_items} upload=\{stats.uploaded_vertex_bytes}B",
    )
    @ui.texts().set(state.hud, Text(hud_text.to_string()))
  }
  if elapsed_s >= state.config.duration {
    state.finished = true
    publish_final_result(state, stats, elapsed_s)
  }
}

///|
fn publish_final_result(
  state : PerfState,
  stats : @webgpu.Render3DSubmissionStatsSnapshot,
  elapsed_s : Double,
) -> Unit {
  let avg_fps = if elapsed_s > 0.0 {
    state.frames.to_double() / elapsed_s
  } else {
    0.0
  }
  perf_publish_result(
    state.config.case_name,
    state.config.mode,
    state.config.count,
    elapsed_s,
    state.frames,
    avg_fps,
    percentile_frame_ms(state.frame_samples, 0.50),
    percentile_frame_ms(state.frame_samples, 0.95),
    state.max_frame_ms,
    percentile_frame_ms(state.work_samples, 0.50),
    percentile_frame_ms(state.work_samples, 0.95),
    state.max_work_ms,
    percentile_frame_ms(state.game_samples, 0.95),
    percentile_frame_ms(state.render_samples, 0.95),
    percentile_frame_ms(state.render3d_submit_samples, 0.95),
    percentile_frame_ms(state.render3d_items_samples, 0.95),
    percentile_frame_ms(state.render3d_flush_samples, 0.95),
    stats.submitted_items,
    stats.draw_commands,
    stats.command_groups,
    stats.uploaded_vertex_bytes,
    stats.render_bind_group_creations,
  )
}

///|
fn percentile_frame_ms(samples : Array[Double], ratio : Double) -> Double {
  if samples.length() == 0 {
    return 0.0
  }
  let sorted = samples.copy()
  sorted.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
  let index = ((sorted.length() - 1).to_double() * ratio).to_int()
  sorted[index]
}
