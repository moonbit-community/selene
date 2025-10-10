# Changelog

## [0.18.0] - 2025-10-01

### Added

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
