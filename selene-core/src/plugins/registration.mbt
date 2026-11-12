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
fn add_system(
  app : @app.App,
  system : @ecs.System,
  schedule : @app.Schedule,
  name : String,
  in_set? : @app.SystemSet,
  before~ : Array[@app.SystemSet] = [],
  after~ : Array[@app.SystemSet] = [],
) -> @app.App {
  match in_set {
    Some(set) =>
      app.add_system(
        schedule,
        system,
        system_name=name,
        in_set=set,
        before~,
        after~,
      )
    None => app.add_system(schedule, system, system_name=name, before~, after~)
  }
}

///|
fn register_builtin_messages(app : @app.App) -> @app.App {
  app
  .add_message(@inputs.key_input_event_bus)
  .add_message(@inputs.mouse_button_event_bus)
  .add_message(@inputs.mouse_motion_event_bus)
  .add_message(@inputs.mouse_wheel_event_bus)
  .add_message(@inputs.touch_event_bus)
  .add_message(@inputs.touch_gesture_event_bus)
  .add_message(@inputs.virtual_button_event_bus)
  .add_message(@inputs.virtual_axis_event_bus)
  .add_message(@inputs.gamepad_connection_event_bus)
  .add_message(@inputs.gamepad_button_event_bus)
  .add_message(@inputs.gamepad_axis_event_bus)
  .add_message(@input_action.input_action_event_bus)
  .add_message(@audio.audio_event_bus)
  .add_message(@animation.animation_clip_asset_events)
  .add_message(@animation.animation_graph_asset_events)
  .add_message(@scene.scene_instance_ready_events)
  .add_message(@collision.contact_event_bus)
  .add_message(@collision.trigger_event_bus)
  .add_message(@collision.pointer_event_bus)
  .add_message(@physics3d.collision_event_bus)
  .add_message(@physics3d.contact_force_event_bus)
  .add_message(@physics3d.sensor_event_bus)
  .add_message(@ui.pointer_enter_event_bus)
  .add_message(@ui.pointer_leave_event_bus)
  .add_message(@ui.pointer_down_event_bus)
  .add_message(@ui.pointer_up_event_bus)
  .add_message(@ui.click_event_bus)
  .add_message(@ui.navigation_event_bus)
  .add_message(@ui.focus_in_event_bus)
  .add_message(@ui.focus_out_event_bus)
  .add_message(@ldtk.ldtk_world_spawned_event_bus)
  .add_message(@ldtk.ldtk_level_spawned_event_bus)
  .add_message(@ldtk.ldtk_layer_spawned_event_bus)
  .add_message(@ldtk.ldtk_tile_spawned_event_bus)
  .add_message(@ldtk.ldtk_entity_spawned_event_bus)
  .add_message(@ldtk.ldtk_int_grid_cell_spawned_event_bus)
  .add_message(@ldtk.ldtk_int_grid_collider_spawned_event_bus)
  .add_message(@ldtk.ldtk_level_event_bus)
  .add_message(@tiled.tiled_world_spawned_event_bus)
  .add_message(@tiled.tiled_world_map_spawned_event_bus)
  .add_message(@tiled.tiled_map_spawned_event_bus)
  .add_message(@tiled.tiled_layer_spawned_event_bus)
  .add_message(@tiled.tiled_tile_spawned_event_bus)
  .add_message(@tiled.tiled_object_spawned_event_bus)
  .add_message(@tiled.tiled_image_layer_spawned_event_bus)
  .add_message(@tiled.tiled_collider_spawned_event_bus)
  .add_message(@asset.image_asset_events)
  .add_message(@asset.audio_asset_events)
  .add_message(@asset.font_asset_events)
}
