///|
pub fn clear_ldtk_int_cell_registrations() -> Unit {
  ldtk_int_cell_typed_registrations().clear()
}

///|
pub fn add_ldtk_entity_registration_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
  hook : (LdtkEntitySpawn) -> Unit,
) -> Unit {
  ldtk_append_entity_typed_registration(
    layer_identifier, entity_identifier, hook,
  )
}

///|
pub fn add_ldtk_entity_registration_for_layer(
  layer_identifier : String,
  entity_identifier : String,
  hook : (LdtkEntitySpawn) -> Unit,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
    hook,
  )
}

///|
pub fn add_ldtk_entity_registration(
  entity_identifier : String,
  hook : (LdtkEntitySpawn) -> Unit,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(
    None,
    Some(entity_identifier),
    hook,
  )
}

///|
pub fn add_default_ldtk_entity_registration_for_layer(
  layer_identifier : String,
  hook : (LdtkEntitySpawn) -> Unit,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(
    Some(layer_identifier),
    None,
    hook,
  )
}

///|
pub fn add_default_ldtk_entity_registration(
  hook : (LdtkEntitySpawn) -> Unit,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(None, None, hook)
}

///|
pub fn[T] add_ldtk_entity_component_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
  storage : @ecs.ComponentStore[T],
  make : (LdtkEntitySpawn) -> T,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(
    layer_identifier,
    entity_identifier,
    fn(event) { event.draft.add_to(storage, make(event)) },
  )
}

///|
pub fn[T] add_ldtk_entity_component_for_layer(
  layer_identifier : String,
  entity_identifier : String,
  storage : @ecs.ComponentStore[T],
  make : (LdtkEntitySpawn) -> T,
) -> Unit {
  add_ldtk_entity_component_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
    storage,
    make,
  )
}

///|
pub fn[T] add_ldtk_entity_component(
  entity_identifier : String,
  storage : @ecs.ComponentStore[T],
  make : (LdtkEntitySpawn) -> T,
) -> Unit {
  add_ldtk_entity_component_for_layer_optional(
    None,
    Some(entity_identifier),
    storage,
    make,
  )
}

///|
pub fn[T] add_default_ldtk_entity_component_for_layer(
  layer_identifier : String,
  storage : @ecs.ComponentStore[T],
  make : (LdtkEntitySpawn) -> T,
) -> Unit {
  add_ldtk_entity_component_for_layer_optional(
    Some(layer_identifier),
    None,
    storage,
    make,
  )
}

///|
pub fn[T] add_default_ldtk_entity_component(
  storage : @ecs.ComponentStore[T],
  make : (LdtkEntitySpawn) -> T,
) -> Unit {
  add_ldtk_entity_component_for_layer_optional(None, None, storage, make)
}

///|
pub fn ldtk_entity_tile_sprite(
  event : LdtkEntitySpawn,
  zindex~ : Int32 = event.zindex,
) -> @sprite.Sprite? {
  guard event.instance.tile is Some(tile) else { return None }
  guard ldtk_entity_tile_image(event, tile) is Some(image) else { return None }
  let source_width = if tile.w > 0 {
    tile.w.to_double()
  } else {
    event.instance.width.to_double()
  }
  let source_height = if tile.h > 0 {
    tile.h.to_double()
  } else {
    event.instance.height.to_double()
  }
  if source_width <= 0.0 || source_height <= 0.0 {
    return None
  }
  let target_width = if event.instance.width > 0 {
    event.instance.width.to_double()
  } else {
    source_width
  }
  let target_height = if event.instance.height > 0 {
    event.instance.height.to_double()
  } else {
    source_height
  }
  let scale_x = target_width / source_width
  let scale_y = target_height / source_height
  let pivot_offset = @math.Vec2(
    target_width * (event.instance.pivot.x - 0.5),
    target_height * (event.instance.pivot.y - 0.5),
  )
  ignore(zindex)
  let target_size = @math.Vec2(source_width * scale_x, source_height * scale_y)
  Some(
    Sprite(
      image=Some(image),
      rect=Some({
        position: Vec2(tile.x.to_double(), tile.y.to_double()),
        size: Vec2(source_width, source_height),
      }),
      color={ r: 255U, g: 255U, b: 255U, a: 1.0, },
      custom_size=Some(target_size),
      anchor=ldtk_sprite_anchor_for_pixel_offset(pivot_offset, target_size),
    ),
  )
}

///|
pub fn add_ldtk_entity_tile_sprite_to_draft(
  event : LdtkEntitySpawn,
  zindex~ : Int32 = event.zindex,
) -> Bool {
  guard ldtk_entity_tile_sprite(event, zindex~) is Some(sprite) else {
    return false
  }
  let pose = event.spatial.pose()
  event.spatial.set_local(
    pose.with_translation(
      Vec3(pose.translation.x, pose.translation.y, zindex.to_double()),
    ),
  )
  event.draft.add(sprite)
  true
}

///|
pub fn register_ldtk_entity_tile_sprite_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  register_ldtk_entity_for_layer_optional(layer_identifier, entity_identifier, fn(
    event,
  ) {
    ignore(
      add_ldtk_entity_tile_sprite_to_draft(
        event,
        zindex=event.zindex + zindex_offset,
      ),
    )
  })
}

///|
pub fn register_ldtk_entity_tile_sprite_for_layer(
  layer_identifier : String,
  entity_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  register_ldtk_entity_tile_sprite_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
    zindex_offset~,
  )
}

///|
pub fn register_ldtk_entity_tile_sprite(
  entity_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  register_ldtk_entity_tile_sprite_for_layer_optional(
    None,
    Some(entity_identifier),
    zindex_offset~,
  )
}

///|
pub fn register_default_ldtk_entity_tile_sprite_for_layer(
  layer_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  register_ldtk_entity_tile_sprite_for_layer_optional(
    Some(layer_identifier),
    None,
    zindex_offset~,
  )
}

///|
pub fn register_default_ldtk_entity_tile_sprite(
  zindex_offset~ : Int32 = 0,
) -> Unit {
  register_ldtk_entity_tile_sprite_for_layer_optional(
    None,
    None,
    zindex_offset~,
  )
}

///|
pub fn add_ldtk_entity_tile_sprite_for_layer_optional(
  layer_identifier : String?,
  entity_identifier : String?,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  add_ldtk_entity_registration_for_layer_optional(
    layer_identifier,
    entity_identifier,
    fn(event) {
      ignore(
        add_ldtk_entity_tile_sprite_to_draft(
          event,
          zindex=event.zindex + zindex_offset,
        ),
      )
    },
  )
}

///|
pub fn add_ldtk_entity_tile_sprite_for_layer(
  layer_identifier : String,
  entity_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  add_ldtk_entity_tile_sprite_for_layer_optional(
    Some(layer_identifier),
    Some(entity_identifier),
    zindex_offset~,
  )
}

///|
pub fn add_ldtk_entity_tile_sprite(
  entity_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  add_ldtk_entity_tile_sprite_for_layer_optional(
    None,
    Some(entity_identifier),
    zindex_offset~,
  )
}

///|
pub fn add_default_ldtk_entity_tile_sprite_for_layer(
  layer_identifier : String,
  zindex_offset~ : Int32 = 0,
) -> Unit {
  add_ldtk_entity_tile_sprite_for_layer_optional(
    Some(layer_identifier),
    None,
    zindex_offset~,
  )
}

///|
pub fn add_default_ldtk_entity_tile_sprite(zindex_offset~ : Int32 = 0) -> Unit {
  add_ldtk_entity_tile_sprite_for_layer_optional(None, None, zindex_offset~)
}

///|
pub fn add_ldtk_int_cell_registration_for_layer_optional(
  layer_identifier : String?,
  value : Int32?,
  hook : (LdtkIntGridCellSpawn) -> Unit,
) -> Unit {
  ldtk_append_int_cell_typed_registration(layer_identifier, value, hook)
}

///|
pub fn add_ldtk_int_cell_registration_for_layer(
  layer_identifier : String,
  value : Int32,
  hook : (LdtkIntGridCellSpawn) -> Unit,
) -> Unit {
  add_ldtk_int_cell_registration_for_layer_optional(
    Some(layer_identifier),
    Some(value),
    hook,
  )
}
