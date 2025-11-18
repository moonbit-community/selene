# Changelog

## [0.19.0] - 2025-10-27

### Added 

- `@sprite.ColorCircle::new` and corresponding variant `SpriteType::ColorCircle`
- `@backend.draw_color_circle`

### Changed 

- `@sprite.ColorRect::new` add optional argument `stroke_color`
- `@backend.draw_color_rect` add labeled argument `stroke_color`

### Removed 

- `@backend.draw_stroke_rect` now combined in `@backend.draw_color_rect`

## [0.18.3] - 2025-10-27

### Changed 

- `@entity.Entity::get_roots` now only returns live entities 

## [0.18.2] - 2025-10-13

### Added 

- `@backend.get_time_scale`

## [0.18.1] - 2025-10-13

### Added 

- Widget APIs: `@style.add_widget` and `@style.screen_root`

### Changed 

- Add a variant: `@style.SizePlan::FromShape`

## [0.18.0] - 2025-10-11

### Added

- Entity inheritance, including APIs:
  - `fn get_children(Entity) -> Array[Entity]`
  - `fn get_offset(Entity) -> @math.Vec2D`
  - `fn get_parent(Entity) -> Entity?`
  - `fn get_roots() -> Array[Entity]`
  - `fn iter_entities() -> Iter[Entity]`
  - `fn live_entities() -> Iter[Entity]`
  - `fn set_offset(Entity, @math.Vec2D) -> Unit`
  - `fn spawn_child(Entity, offset? : @math.Vec2D) -> Entity`
- Positions and liveness of child entities will be affected by parent entities 
- New experimental subpackage `@style`, including APIs to make UI elements and styles

### Changed 

- New subpackage `@entity`, including APIs about Entities which were placed in `@system`

### Removed

- `@entity.live_entities`

## [0.17.2] - 2025-10-10

### Added 

- `@backend.get_realtime_delta`
- `@math.HAlign` and `@math.VAlign`

### Fixed 

- `@system.realtime_timer_system` bug fixed 

### Changed 

- `@backend.draw_text`: add argument `baseline` and `align`
- `@sprite.Text`: add fields `baseline` and `align`; so as `Text::new`

## [0.17.1] - 2025-09-30

### Added 

- `@backend.load_font`: dynmaically loading fonts

## [0.17.0] - 2025-09-26

### Added

- Update documentations for `@system` and `@input`. 

### Changed

- Function `@system.timeout` argument `pausible` is now optional and `true` by default.
