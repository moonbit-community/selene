# Selene ECS API Mapping (Bevy Alignment)

This document captures the first breaking migration pass from legacy Selene ECS entrypoints toward Bevy-style runtime APIs.

## Runtime Entry

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@system.App::new()` | `@app.App::new()` | Runtime entrypoint moved out of `selene/system`. |
| `System = (Double) -> Unit` | `System = (@ecs.World, Double) -> Unit` | Systems now receive world context. |
| `RunCondition = () -> Bool` | `RunCondition = (@ecs.World) -> Bool` | Conditions are world-aware. |

## Commands

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@commands.commands()` | `@commands.commands(world)` | Command queue is world-owned. |
| `Commands::add(() -> Unit)` | `Commands::add((@ecs.World) -> Unit)` | Deferred commands can read/write world state. |
| `has_pending_commands()` | `has_pending_commands(world)` | Queue inspection is world-scoped. |
| `commands_flush_system(delta)` | `commands_flush_system(world, delta)` | Flush step is world-scoped. |

## Query

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `query(storage)` | `query(world, storage)` | Query constructors now bind to world context. |
| `QueryReader::read(storage)` | `QueryReader::read(world, storage)` | Change detection API now requires world context. |
| `Snapshot/Added/Removed/Changed` APIs | Removed | Snapshot-style query delta public API removed. |

## Plugins

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `debug_plugin(@system.App)` | `debug_plugin(@app.App)` | Plugin surface follows new app module. |
| `default_plugin(@system.App)` | `default_plugin(@app.App)` | Plugin surface follows new app module. |
| `default_3d_plugin(@system.App)` | `default_3d_plugin(@app.App)` | Plugin surface follows new app module. |

## Runtime Resources

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@camera3d.active_camera3d : Ref[ActiveCamera3D?]` | `@camera3d.get_active_camera3d()` + `@camera3d.set_active_camera3d(...)` | Active 3D camera is world-scoped and no longer exposed as a single global ref. |
| `@ui.ui_scale_mode : Ref[UiScaleMode]` | `@ui.get_ui_scale_mode()` + `@ui.set_ui_scale_mode(...)` | UI scale mode is world-scoped and no longer exposed as a global ref. |

## Core Component Stores

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@position.positions` | `@position.positions()` | Position store is now resolved from the active world. |
| `@position.previous_positions` | `@position.previous_positions()` | Previous-position snapshot store is now resolved from the active world. |
| `@velocity.velocities` | `@velocity.velocities()` | Velocity store is now resolved from the active world. |
| `@transform.transforms` | `@transform.transforms()` | 2D transform alias store is now resolved from the active world. |
| `@transform.positions` | `@transform.positions()` | 2D transform alias store is now resolved from the active world. |
| `@transform.global_transforms` | `@transform.global_transforms()` | 2D global transform alias store is now resolved from the active world. |
| `@transform.previous_transforms` | `@transform.previous_transforms()` | 2D previous-transform alias store is now resolved from the active world. |
| `@transform.previous_positions` | `@transform.previous_positions()` | 2D previous-transform alias store is now resolved from the active world. |
| `@transform3d.transforms3d` | `@transform3d.transforms3d()` | 3D local transform store is now resolved from the active world. |
| `@transform3d.global_transforms3d` | `@transform3d.global_transforms3d()` | 3D global transform store is now resolved from the active world. |
| `@transform3d.previous_global_transforms3d` | `@transform3d.previous_global_transforms3d()` | 3D previous-global snapshot store is now resolved from the active world. |
| `@physics2d.linear_velocities` | `@physics2d.linear_velocities()` | Physics2D velocity alias now resolves through active world storage. |
| `@physics2d.velocities` | `@physics2d.velocities()` | Physics2D velocity alias now resolves through active world storage. |
| `@sprite.sprites` | `@sprite.sprites()` | Sprite component store is now resolved from the active world. |
| `@visibility.visibilities` | `@visibility.visibilities()` | Visibility component store is now resolved from the active world. |
| `@visibility.inherited_visibilities` | `@visibility.inherited_visibilities()` | Inherited visibility store is now resolved from the active world. |
| `@visibility.view_visibilities` | `@visibility.view_visibilities()` | View visibility store is now resolved from the active world. |
| `@visibility.render_layers` | `@visibility.render_layers()` | Render-layer store is now resolved from the active world. |
| `@collision.rigid_bodies` | `@collision.rigid_bodies()` | 2D rigid-body authored store is now resolved from the active world. |
| `@collision.colliders` | `@collision.colliders()` | 2D collider authored store is now resolved from the active world. |
| `@collision.resolved_velocities` | `@collision.resolved_velocities()` | Physics post-solve velocity cache is now resolved from the active world. |
| `@collision.grounded_entities` | `@collision.grounded_entities()` | Grounded entity set is now resolved from the active world. |
| `@collision.areas` | `@collision.areas()` | 2D trigger-area authored store is now resolved from the active world. |
| `@collision.shapes` | `@collision.shapes()` | 2D collision-shape authored store is now resolved from the active world. |
| `@collision.joints` | `@collision.joints()` | 2D impulse-joint authored store is now resolved from the active world. |
| `@collision.multibody_joints` | `@collision.multibody_joints()` | 2D multibody-joint authored store is now resolved from the active world. |
| `@collision.pickables` | `@collision.pickables()` | Pointer-pickable authored store is now resolved from the active world. |
| `@physics2d.colliders` | `@physics2d.colliders()` | Physics2D collider alias now resolves through active world storage. |
| `@physics2d.rigid_bodies` | `@physics2d.rigid_bodies()` | Physics2D rigid-body alias now resolves through active world storage. |
| `@physics2d.joints` | `@physics2d.joints()` | Physics2D joint alias now resolves through active world storage. |
| `@physics2d.multibody_joints` | `@physics2d.multibody_joints()` | Physics2D multibody-joint alias now resolves through active world storage. |
| `@physics2d.sensors` | `@physics2d.sensors()` | Physics2D sensor alias now resolves through active world storage. |
| `@physics2d.areas` | `@physics2d.areas()` | Physics2D area alias now resolves through active world storage. |
| `@physics2d.shapes` | `@physics2d.shapes()` | Physics2D shape alias now resolves through active world storage. |
| `@physics2d.resolved_velocities` | `@physics2d.resolved_velocities()` | Physics2D resolved-velocity alias now resolves through active world storage. |
| `@physics2d.grounded_entities` | `@physics2d.grounded_entities()` | Physics2D grounded-entity alias now resolves through active world storage. |
| `@physics2d.pickables` | `@physics2d.pickables()` | Physics2D pickable alias now resolves through active world storage. |
| `@camera3d.cameras3d` | `@camera3d.cameras3d()` | 3D camera component store is now resolved from the active world. |
| `@render3d.mesh3d_renderers` | `@render3d.mesh3d_renderers()` | 3D mesh renderer store is now resolved from the active world. |
| `@render3d.directional_lights3d` | `@render3d.directional_lights3d()` | 3D directional-light store is now resolved from the active world. |
| `@render3d.point_lights3d` | `@render3d.point_lights3d()` | 3D point-light store is now resolved from the active world. |
| `@render3d.spot_lights3d` | `@render3d.spot_lights3d()` | 3D spot-light store is now resolved from the active world. |
| `@physics3d.rigid_bodies3d` | `@physics3d.rigid_bodies3d()` | 3D rigid-body authored store is now resolved from the active world. |
| `@physics3d.colliders3d` | `@physics3d.colliders3d()` | 3D collider authored store is now resolved from the active world. |
| `@physics3d.sensors3d` | `@physics3d.sensors3d()` | 3D sensor authored store is now resolved from the active world. |
| `@physics3d.linear_velocities3d` | `@physics3d.linear_velocities3d()` | 3D linear-velocity authored store is now resolved from the active world. |
| `@physics3d.angular_velocities3d` | `@physics3d.angular_velocities3d()` | 3D angular-velocity authored store is now resolved from the active world. |
| `@animation3d.animation_players3d` | `@animation3d.animation_players3d()` | 3D animation player component store is now resolved from the active world. |
| `@audio.audio_players` | `@audio.audio_players()` | Audio player component store is now resolved from the active world. |
| `@audio.audio_playback_settings` | `@audio.audio_playback_settings()` | Audio playback-settings store is now resolved from the active world. |
| `@audio.audio_sinks` | `@audio.audio_sinks()` | Audio sink component store is now resolved from the active world. |
| `@a11y.a11ys` | `@a11y.a11ys()` | Accessibility component store is now resolved from the active world. |

## Input Runtime Stores

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@inputs.connected_gamepads` | `@inputs.connected_gamepads()` | Gamepad connected set is now resolved from the active world. |
| `@inputs.pressed_gamepad_buttons` | `@inputs.pressed_gamepad_buttons()` | Gamepad pressed-button set is now resolved from the active world. |
| `@inputs.gamepad_axis_values` | `@inputs.gamepad_axis_values()` | Gamepad axis-value map is now resolved from the active world. |
| `@inputs.just_connected_gamepads` | `@inputs.just_connected_gamepads()` | Per-frame gamepad connection diff set is now resolved from the active world. |
| `@inputs.just_disconnected_gamepads` | `@inputs.just_disconnected_gamepads()` | Per-frame gamepad disconnection diff set is now resolved from the active world. |
| `@inputs.just_pressed_gamepad_buttons` | `@inputs.just_pressed_gamepad_buttons()` | Per-frame button-pressed diff set is now resolved from the active world. |
| `@inputs.just_released_gamepad_buttons` | `@inputs.just_released_gamepad_buttons()` | Per-frame button-released diff set is now resolved from the active world. |

## UI Component Stores

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@ui.nodes` | `@ui.nodes()` | UI node authored store is now resolved from the active world. |
| `@ui.computed_ui_nodes` | `@ui.computed_ui_nodes()` | Computed UI layout store is now resolved from the active world. |
| `@ui.global_ui_nodes` | `@ui.global_ui_nodes()` | Global UI layout store is now resolved from the active world. |
| `@ui.calculated_clips` | `@ui.calculated_clips()` | Calculated clip store is now resolved from the active world. |
| `@ui.layout_configs` | `@ui.layout_configs()` | Layout config store is now resolved from the active world. |
| `@ui.z_indexes` | `@ui.z_indexes()` | Local z-index store is now resolved from the active world. |
| `@ui.global_zindexes` | `@ui.global_zindexes()` | Global z-index store is now resolved from the active world. |
| `@ui.scroll_positions` | `@ui.scroll_positions()` | UI scroll offset store is now resolved from the active world. |
| `@ui.tab_indexes` | `@ui.tab_indexes()` | UI tab-index store is now resolved from the active world. |
| `@ui.focus_policies` | `@ui.focus_policies()` | UI focus-policy store is now resolved from the active world. |
| `@ui.focusables` | `@ui.focusables()` | UI focus marker store is now resolved from the active world. |
| `@ui.focuseds` | `@ui.focuseds()` | UI focused marker store is now resolved from the active world. |
| `@ui.override_clips` | `@ui.override_clips()` | UI override-clip marker store is now resolved from the active world. |
| `@ui.relative_cursor_positions` | `@ui.relative_cursor_positions()` | UI relative cursor state store is now resolved from the active world. |
| `@ui.background_colors` | `@ui.background_colors()` | UI background-color authored store is now resolved from the active world. |
| `@ui.border_colors` | `@ui.border_colors()` | UI border-color authored store is now resolved from the active world. |
| `@ui.border_radii` | `@ui.border_radii()` | UI border-radius authored store is now resolved from the active world. |
| `@ui.box_shadows` | `@ui.box_shadows()` | UI box-shadow authored store is now resolved from the active world. |
| `@ui.outlines` | `@ui.outlines()` | UI outline authored store is now resolved from the active world. |
| `@ui.ui_images` | `@ui.ui_images()` | UI image authored store is now resolved from the active world. |
| `@ui.material_nodes` | `@ui.material_nodes()` | UI material-node authored store is now resolved from the active world. |
| `@ui.texts` | `@ui.texts()` | UI text authored store is now resolved from the active world. |
| `@ui.text_fonts` | `@ui.text_fonts()` | UI text-font authored store is now resolved from the active world. |
| `@ui.text_colors` | `@ui.text_colors()` | UI text-color authored store is now resolved from the active world. |
| `@ui.text_layouts` | `@ui.text_layouts()` | UI text-layout authored store is now resolved from the active world. |
| `@ui.buttons` | `@ui.buttons()` | UI button authored store is now resolved from the active world. |
| `@ui.interactions` | `@ui.interactions()` | UI interaction state store is now resolved from the active world. |

## Tiled Runtime Stores

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@tiled.tiled_map_instances` | `@tiled.tiled_map_instances()` | Tiled map instance store is now resolved from the active world. |
| `@tiled.tiled_layer_instances` | `@tiled.tiled_layer_instances()` | Tiled layer instance store is now resolved from the active world. |
| `@tiled.tiled_tile_instances` | `@tiled.tiled_tile_instances()` | Tiled tile instance store is now resolved from the active world. |
| `@tiled.tiled_object_instances` | `@tiled.tiled_object_instances()` | Tiled object instance store is now resolved from the active world. |
| `@tiled.tiled_image_layer_instances` | `@tiled.tiled_image_layer_instances()` | Tiled image-layer instance store is now resolved from the active world. |
| `@tiled.tiled_properties` | `@tiled.tiled_properties()` | Tiled property store is now resolved from the active world. |
| `@tiled.tiled_map_storages` | `@tiled.tiled_map_storages()` | Tiled map-storage store is now resolved from the active world. |
| `@tiled.tiled_parallax_layers` | `@tiled.tiled_parallax_layers()` | Tiled parallax metadata store is now resolved from the active world. |
| `@tiled.tiled_colliders` | `@tiled.tiled_colliders()` | Tiled collider-authored store is now resolved from the active world. |
| `@tiled.tiled_collider_origins` | `@tiled.tiled_collider_origins()` | Tiled collider-origin store is now resolved from the active world. |
| `@tiled.tiled_world_instances` | `@tiled.tiled_world_instances()` | Tiled world root instance store is now resolved from the active world. |
| `@tiled.tiled_world_map_instances` | `@tiled.tiled_world_map_instances()` | Tiled world-to-map instance relation store is now resolved from the active world. |

## LDtk Runtime Stores

| Legacy Selene | New Selene | Notes |
| --- | --- | --- |
| `@ldtk.ldtk_world_instances` | `@ldtk.ldtk_world_instances()` | LDtk world instance store is now resolved from the active world. |
| `@ldtk.ldtk_level_instances` | `@ldtk.ldtk_level_instances()` | LDtk level instance store is now resolved from the active world. |
| `@ldtk.ldtk_layer_metadata` | `@ldtk.ldtk_layer_metadata()` | LDtk layer metadata store is now resolved from the active world. |
| `@ldtk.ldtk_level_backgrounds` | `@ldtk.ldtk_level_backgrounds()` | LDtk level background store is now resolved from the active world. |
| `@ldtk.ldtk_level_iids` | `@ldtk.ldtk_level_iids()` | LDtk level-iid store is now resolved from the active world. |
| `@ldtk.ldtk_entity_iids` | `@ldtk.ldtk_entity_iids()` | LDtk entity-iid store is now resolved from the active world. |
| `@ldtk.ldtk_grid_coords` | `@ldtk.ldtk_grid_coords()` | LDtk grid-coordinate store is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_cells` | `@ldtk.ldtk_int_grid_cells()` | LDtk int-grid cell store is now resolved from the active world. |
| `@ldtk.ldtk_tile_metadata` | `@ldtk.ldtk_tile_metadata()` | LDtk tile metadata store is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_colliders` | `@ldtk.ldtk_int_grid_colliders()` | LDtk int-grid collider store is now resolved from the active world. |
| `@ldtk.ldtk_worldly_entities` | `@ldtk.ldtk_worldly_entities()` | LDtk worldly marker store is now resolved from the active world. |
| `@ldtk.ldtk_respawns` | `@ldtk.ldtk_respawns()` | LDtk respawn marker store is now resolved from the active world. |
| `@ldtk.ldtk_spawned_layer_instances` | `@ldtk.ldtk_spawned_layer_instances()` | LDtk spawned-layer store is now resolved from the active world. |
| `@ldtk.ldtk_spawned_tile_instances` | `@ldtk.ldtk_spawned_tile_instances()` | LDtk spawned-tile store is now resolved from the active world. |
| `@ldtk.ldtk_spawned_entity_instances` | `@ldtk.ldtk_spawned_entity_instances()` | LDtk spawned-entity store is now resolved from the active world. |
| `@ldtk.ldtk_spawned_int_grid_cells` | `@ldtk.ldtk_spawned_int_grid_cells()` | LDtk spawned-int-grid-cell store is now resolved from the active world. |
| `@ldtk.ldtk_entity_spawn_hooks` | `@ldtk.ldtk_entity_spawn_hooks()` | LDtk entity spawn-hook registry is now resolved from the active world. |
| `@ldtk.ldtk_entity_layer_spawn_hooks` | `@ldtk.ldtk_entity_layer_spawn_hooks()` | LDtk entity layer-default hook registry is now resolved from the active world. |
| `@ldtk.ldtk_entity_layer_identifier_spawn_hooks` | `@ldtk.ldtk_entity_layer_identifier_spawn_hooks()` | LDtk entity layer+identifier hook registry is now resolved from the active world. |
| `@ldtk.ldtk_entity_default_spawn_hook` | `@ldtk.ldtk_entity_default_spawn_hook()` | LDtk global entity default hook ref is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_layer_spawn_hooks` | `@ldtk.ldtk_int_grid_layer_spawn_hooks()` | LDtk int-grid layer hook registry is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_cell_spawn_hooks` | `@ldtk.ldtk_int_grid_cell_spawn_hooks()` | LDtk int-grid layer+value hook registry is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_value_spawn_hooks` | `@ldtk.ldtk_int_grid_value_spawn_hooks()` | LDtk int-grid value hook registry is now resolved from the active world. |
| `@ldtk.ldtk_int_grid_default_spawn_hook` | `@ldtk.ldtk_int_grid_default_spawn_hook()` | LDtk global int-grid default hook ref is now resolved from the active world. |
| `@ldtk.ldtk_entity_typed_registrations` | `@ldtk.ldtk_entity_typed_registrations()` | LDtk typed entity registration map is now resolved from the active world. |
| `@ldtk.ldtk_int_cell_typed_registrations` | `@ldtk.ldtk_int_cell_typed_registrations()` | LDtk typed int-cell registration map is now resolved from the active world. |
| `@ldtk.ldtk_pending_transformed_level_iids` | `@ldtk.ldtk_pending_transformed_level_iids()` | LDtk transformed-level pending cache is now resolved from the active world. |

## World-Scoped Internals

- `time` frame state (`delta/raw_delta/elapsed/scale`) is stored per `world.id`.
- `system/display` viewport/screen/zoom/render-alpha state is stored per `world.id`.
- `camera` 2D follow/limits/interpolation state is stored per `world.id`.
- `ui/interaction` hovered/pressed/focused runtime markers are stored per `world.id`.
- `render2d` frame command buffers are stored per `world.id`.
- `render3d` extraction frame and lighting resource state are stored per `world.id`.
- `render3d_pipeline` prepared frame state is stored per `world.id`.
- `physics3d` rapier world/handle maps are stored per `world.id`.
- `collision/rapier_2d` rapier world/config-key/pending-ops runtime stores are stored per `world.id`.
- `sprite` component store is stored per `world.id`.
- `visibility` component and render-layer stores are stored per `world.id`.
- `collision` authored body/collider/area/shape/joint/pickable stores plus grounded/resolved caches are stored per `world.id`.
- `physics2d` alias component stores are resolved per `world.id`.
- `camera3d` authored camera store is stored per `world.id`.
- `render3d` authored mesh/light component stores are stored per `world.id`.
- `physics3d` authored component stores are stored per `world.id`.
- `animation3d` player/target/skinning/morph runtime maps are stored per `world.id`.
- `audio` player/settings/sink component stores are stored per `world.id`.
- `a11y` authored component store is stored per `world.id`.
