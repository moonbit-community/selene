# `selene/ldtk` Registration Template

Selene uses explicit runtime registration APIs instead of derive macros.

- `register_*`: set or replace one handler for a scope
- `add_*`: append handlers for a scope

For both entity and int-cell typed registration, scope resolution priority is:

1. `(layer + identifier/value)`
2. `(identifier/value only)`
3. `(layer only)`
4. `(default)`

Only the highest-priority scope is selected. Within the same selected scope, `add_*` handlers run in registration order.

## Minimal Bundle-Like Template

Declare each custom component with `#selene.component` and generate its
companion. Registration callbacks return initial component values; the importer
adds them to the spawn draft in its owning World. The registration context also
provides `event.project`; parent entities are still pending during construction,
so use this initial data instead of querying their components.

```moonbit
///|
#selene.component
pub struct EnemyTag {}

///|
#selene.component
pub struct Health {
  value : Int
}

///|
#selene.component
pub struct SolidCell {}

///|
pub fn setup_ldtk_bindings() -> Unit {
  // Optional: clear old bindings before re-registering.
  @ldtk.clear_ldtk_entity_registrations()
  @ldtk.clear_ldtk_int_cell_registrations()

  // "Enemy" entity -> compose multiple component insertions.
  @ldtk.add_ldtk_entity_component("Enemy", fn(_event) { EnemyTag::{} })
  @ldtk.add_ldtk_entity_component("Enemy", fn(event) {
    Health::{
      value: event.instance.field_int("HP").unwrap_or(1),
    }
  })

  // Layer-scoped int-grid value -> component insertion.
  @ldtk.add_ldtk_int_cell_component_for_layer(
    "Collision",
    1,
    fn(_event) { SolidCell::{} },
  )
}
```

## Entity Tile Helper (`__tile`)

To mirror bevy's `#[sprite_sheet]` flow without derive macros, Selene provides explicit helpers that read `entity.instance.tile` (`__tile`) and insert a sprite automatically:

- One-shot insertion in your own hook:
  - `insert_ldtk_entity_tile_sprite(world~, event, zindex=...)`
  - `ldtk_entity_tile_sprite(world~, event, zindex=...)`
- Registration helpers with the same scope model:
  - `register_ldtk_entity_tile_sprite_for_layer_optional(...)`
  - `add_ldtk_entity_tile_sprite_for_layer_optional(...)`
  - plus layer/default convenience wrappers.

These helpers:

- Resolve the tileset image from `__tile.tilesetUid` (or layer tileset fallback)
- Use the `__tile` source rectangle as the sprite source
- Scale to `entity.width/height`
- Apply the LDtk pivot offset so the sprite occupies the expected entity area
