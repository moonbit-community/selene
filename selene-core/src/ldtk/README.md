# `selene/ldtk` Registration Template (No Derive)

MoonBit currently does not provide a derive macro flow like bevy's
`#[derive(LdtkEntity)]` / `#[derive(LdtkIntCell)]`.

Selene provides equivalent runtime registration APIs:

- `register_*`: set/replace one handler for a scope.
- `add_*`: append handlers for a scope (bundle-like composition).

For both entity and int-cell typed registration, scope resolution priority is:

1. `(layer + identifier/value)`
2. `(identifier/value only)`
3. `(layer only)`
4. `(default)`

Only the highest-priority scope is selected.  
Within the same selected scope, `add_*` handlers run in registration order.

## Minimal Bundle-Like Template

```moonbit
///|
pub struct EnemyTag {}

///|
pub struct Health {
  value : Int
}

///|
pub struct SolidCell {}

///|
pub let enemy_tags : Map[@entity.Entity, EnemyTag] = Map::new()

///|
pub let healths : Map[@entity.Entity, Health] = Map::new()

///|
pub let solid_cells : Map[@entity.Entity, SolidCell] = Map::new()

///|
pub fn setup_ldtk_bindings() -> Unit {
  // Optional: clear old bindings before re-registering.
  @ldtk.clear_ldtk_entity_registrations()
  @ldtk.clear_ldtk_int_cell_registrations()

  // "Enemy" entity -> compose multiple component insertions.
  @ldtk.add_ldtk_entity_component("Enemy", enemy_tags, fn(_event) { {} })
  @ldtk.add_ldtk_entity_component("Enemy", healths, fn(event) {
    {
      value: event.instance.field_int("HP").unwrap_or(1),
    }
  })

  // Layer-scoped int-grid value -> component insertion.
  @ldtk.add_ldtk_int_cell_component_for_layer(
    "Collision",
    1,
    solid_cells,
    fn(_event) { {} },
  )
}
```

## Common Variants

- Replace one scope handler (single registration):
  - `register_ldtk_entity_for_layer_optional(...)`
  - `register_ldtk_int_cell_for_layer_optional(...)`
- Append additional behavior to the same scope:
  - `add_ldtk_entity_registration_for_layer_optional(...)`
  - `add_ldtk_int_cell_registration_for_layer_optional(...)`
- Remove one scope:
  - `unregister_ldtk_entity_for_layer_optional(...)`
  - `unregister_ldtk_int_cell_for_layer_optional(...)`

## Entity Tile Placeholder Sprite (`__tile`)

To mirror bevy's `#[sprite_sheet]` flow without derive macros, Selene now
provides explicit helper APIs that read `entity.instance.tile` (`__tile`) and
insert a sprite automatically:

- One-shot insertion in your own hook:
  - `insert_ldtk_entity_tile_sprite(event, zindex=...)`
  - `ldtk_entity_tile_sprite(event, zindex=...)`
- Registration helpers with the same scope model:
  - `register_ldtk_entity_tile_sprite_for_layer_optional(...)`
  - `add_ldtk_entity_tile_sprite_for_layer_optional(...)`
  - plus layer/default convenience wrappers.

These helpers:

- Resolve the tileset image from `__tile.tilesetUid` (or layer tileset fallback).
- Use the `__tile` source rectangle as sprite atlas source.
- Scale to `entity.width/height`.
- Apply LDtk pivot offset so the rendered sprite occupies the expected entity
  area.
