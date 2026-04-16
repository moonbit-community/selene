///|
fn ldtk_emit_pending_transformed_events() -> Unit {
  for pair in ldtk_pending_transformed_level_iids().to_array() {
    let iid = pair.0
    ldtk_level_event_bus.trigger(Transformed(iid), None)
    ldtk_pending_transformed_level_iids().remove(iid)
  }
}

///|
fn ldtk_cleanup_dead_spawned_levels(instance : LdtkWorldInstance) -> Unit {
  for pair in instance.spawned_levels.to_array() {
    if !pair.1.is_alive() {
      instance.spawned_levels.remove(pair.0)
      ldtk_pending_transformed_level_iids().remove(pair.0)
    }
  }
}

///|
fn ldtk_cleanup_dead_runtime_entries() -> Unit {
  for pair in ldtk_respawns().to_array() {
    if !pair.0.is_alive() {
      ldtk_respawns().remove(pair.0)
    }
  }
  for pair in ldtk_worldly_entities().to_array() {
    if !pair.0.is_alive() {
      ldtk_worldly_entities().remove(pair.0)
    }
  }
  for pair in ldtk_layer_metadata().to_array() {
    if !pair.0.is_alive() {
      ldtk_layer_metadata().remove(pair.0)
    }
  }
  for pair in ldtk_level_backgrounds().to_array() {
    if !pair.0.is_alive() {
      ldtk_level_backgrounds().remove(pair.0)
    }
  }
  for pair in ldtk_level_iids().to_array() {
    if !pair.0.is_alive() {
      ldtk_level_iids().remove(pair.0)
    }
  }
  for pair in ldtk_entity_iids().to_array() {
    if !pair.0.is_alive() {
      ldtk_entity_iids().remove(pair.0)
    }
  }
  for pair in ldtk_grid_coords().to_array() {
    if !pair.0.is_alive() {
      ldtk_grid_coords().remove(pair.0)
    }
  }
  for pair in ldtk_int_grid_cells().to_array() {
    if !pair.0.is_alive() {
      ldtk_int_grid_cells().remove(pair.0)
    }
  }
  for pair in ldtk_tile_metadata().to_array() {
    if !pair.0.is_alive() {
      ldtk_tile_metadata().remove(pair.0)
    }
  }
  for pair in ldtk_int_grid_colliders().to_array() {
    if !pair.0.is_alive() {
      @physics2d.areas().remove(pair.0)
      @physics2d.colliders().remove(pair.0)
      @physics2d.shapes().remove(pair.0)
      @physics2d.rigid_bodies().remove(pair.0)
      ldtk_int_grid_colliders().remove(pair.0)
    }
  }
  for pair in ldtk_spawned_layer_instances().to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_layer_instances().remove(pair.0)
    }
  }
  for pair in ldtk_spawned_tile_instances().to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_tile_instances().remove(pair.0)
    }
  }
  for pair in ldtk_spawned_entity_instances().to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_entity_instances().remove(pair.0)
    }
  }
  for pair in ldtk_spawned_int_grid_cells().to_array() {
    if !pair.0.is_alive() {
      ldtk_spawned_int_grid_cells().remove(pair.0)
    }
  }
}

///|
fn ldtk_apply_registered_entity(event : LdtkEntitySpawnedEvent) -> Unit {
  if ldtk_find_registered_entity_hook(
      event.layer.identifier,
      event.instance.identifier,
    )
    is Some(hook) {
    hook(event)
  }
}

///|
fn ldtk_apply_registered_int_cell(event : LdtkIntGridCellSpawnedEvent) -> Unit {
  if ldtk_find_registered_int_cell_hook(event.layer.identifier, event.value)
    is Some(hook) {
    hook(event)
  }
}

///|
fn ldtk_find_registered_entity_hook(
  layer_identifier : String,
  entity_identifier : String,
) -> ((LdtkEntitySpawnedEvent) -> Unit)? {
  if ldtk_entity_typed_registrations().get(
      ldtk_entity_typed_registration_key(
        Some(layer_identifier),
        Some(entity_identifier),
      ),
    )
    is Some(hook) {
    return Some(hook)
  }
  if ldtk_entity_typed_registrations().get(
      ldtk_entity_typed_registration_key(None, Some(entity_identifier)),
    )
    is Some(hook) {
    return Some(hook)
  }
  if ldtk_entity_typed_registrations().get(
      ldtk_entity_typed_registration_key(Some(layer_identifier), None),
    )
    is Some(hook) {
    return Some(hook)
  }
  ldtk_entity_typed_registrations().get(
    ldtk_entity_typed_registration_key(None, None),
  )
}

///|
fn ldtk_find_registered_int_cell_hook(
  layer_identifier : String,
  value : Int,
) -> ((LdtkIntGridCellSpawnedEvent) -> Unit)? {
  if ldtk_int_cell_typed_registrations().get(
      ldtk_int_cell_typed_registration_key(Some(layer_identifier), Some(value)),
    )
    is Some(hook) {
    return Some(hook)
  }
  if ldtk_int_cell_typed_registrations().get(
      ldtk_int_cell_typed_registration_key(None, Some(value)),
    )
    is Some(hook) {
    return Some(hook)
  }
  if ldtk_int_cell_typed_registrations().get(
      ldtk_int_cell_typed_registration_key(Some(layer_identifier), None),
    )
    is Some(hook) {
    return Some(hook)
  }
  ldtk_int_cell_typed_registrations().get(
    ldtk_int_cell_typed_registration_key(None, None),
  )
}

///|
fn ldtk_append_entity_typed_registration(
  layer_identifier : String?,
  entity_identifier : String?,
  hook : (LdtkEntitySpawnedEvent) -> Unit,
) -> Unit {
  let key = ldtk_entity_typed_registration_key(
    layer_identifier, entity_identifier,
  )
  if ldtk_entity_typed_registrations().get(key) is Some(existing_hook) {
    ldtk_entity_typed_registrations().set(key, fn(event) {
      existing_hook(event)
      hook(event)
    })
  } else {
    ldtk_entity_typed_registrations().set(key, hook)
  }
}

///|
fn ldtk_append_int_cell_typed_registration(
  layer_identifier : String?,
  value : Int?,
  hook : (LdtkIntGridCellSpawnedEvent) -> Unit,
) -> Unit {
  let key = ldtk_int_cell_typed_registration_key(layer_identifier, value)
  if ldtk_int_cell_typed_registrations().get(key) is Some(existing_hook) {
    ldtk_int_cell_typed_registrations().set(key, fn(event) {
      existing_hook(event)
      hook(event)
    })
  } else {
    ldtk_int_cell_typed_registrations().set(key, hook)
  }
}

///|
fn ldtk_int_grid_cell_spawn_hook_key(
  layer_identifier : String,
  value : Int,
) -> String {
  "\{layer_identifier}#\{value}"
}

///|
fn ldtk_int_grid_value_spawn_hook_key(value : Int) -> String {
  value.to_string()
}

///|
fn ldtk_entity_layer_identifier_spawn_hook_key(
  layer_identifier : String,
  identifier : String,
) -> String {
  "\{layer_identifier}#\{identifier}"
}

///|
fn ldtk_entity_typed_registration_key(
  layer_identifier : String?,
  entity_identifier : String?,
) -> String {
  "L(\{ldtk_optional_string_registration_key(layer_identifier)})|E(\{ldtk_optional_string_registration_key(entity_identifier)})"
}

///|
fn ldtk_int_cell_typed_registration_key(
  layer_identifier : String?,
  value : Int?,
) -> String {
  "L(\{ldtk_optional_string_registration_key(layer_identifier)})|V(\{ldtk_optional_int_registration_key(value)})"
}

///|
fn ldtk_optional_string_registration_key(value : String?) -> String {
  match value {
    Some(content) => "S\{content.length()}:\{content}"
    None => "N"
  }
}

///|
fn ldtk_optional_int_registration_key(value : Int?) -> String {
  match value {
    Some(number) => "I\{number}"
    None => "N"
  }
}

///|
fn ldtk_clamp_alpha(alpha : Double) -> Double {
  if alpha < 0.0 {
    0.0
  } else if alpha > 1.0 {
    1.0
  } else {
    alpha
  }
}

///|
fn ldtk_color_with_alpha(color : String, alpha : Double) -> String {
  let clamped_alpha = ldtk_clamp_alpha(alpha)
  if clamped_alpha >= 0.999999 {
    return color
  }
  let normalized = color.trim().to_string()
  if normalized.has_prefix("#") {
    return ldtk_hex_color_with_alpha(normalized, clamped_alpha).unwrap_or(color)
  }
  if normalized.has_prefix("rgba(") && normalized.has_suffix(")") {
    return ldtk_rgba_color_with_alpha(normalized, clamped_alpha).unwrap_or(
      color,
    )
  }
  if normalized.has_prefix("rgb(") && normalized.has_suffix(")") {
    return ldtk_rgb_color_with_alpha(normalized, clamped_alpha).unwrap_or(color)
  }
  color
}

///|
fn ldtk_hex_color_with_alpha(color : String, alpha : Double) -> String? {
  let hex = color.unsafe_substring(start=1, end=color.length())
  if hex.length() != 6 && hex.length() != 8 {
    return None
  }
  guard ldtk_hex_pair_to_int(hex, 0) is Some(red) else { return None }
  guard ldtk_hex_pair_to_int(hex, 2) is Some(green) else { return None }
  guard ldtk_hex_pair_to_int(hex, 4) is Some(blue) else { return None }
  let base_alpha = if hex.length() == 8 {
    ldtk_hex_pair_to_int(hex, 6)
    .map(value => value.to_double() / 255.0)
    .unwrap_or(1.0)
  } else {
    1.0
  }
  let final_alpha = ldtk_clamp_alpha(alpha * base_alpha)
  Some("rgba(\{red},\{green},\{blue},\{final_alpha})")
}

///|
fn ldtk_rgb_color_with_alpha(color : String, alpha : Double) -> String? {
  let body = color.unsafe_substring(start=4, end=color.length() - 1)
  let values = body.split(",").to_array()
  if values.length() != 3 {
    return None
  }
  guard ldtk_parse_color_channel(values[0]) is Some(red) else { return None }
  guard ldtk_parse_color_channel(values[1]) is Some(green) else { return None }
  guard ldtk_parse_color_channel(values[2]) is Some(blue) else { return None }
  Some("rgba(\{red},\{green},\{blue},\{ldtk_clamp_alpha(alpha)})")
}

///|
fn ldtk_rgba_color_with_alpha(color : String, alpha : Double) -> String? {
  let body = color.unsafe_substring(start=5, end=color.length() - 1)
  let values = body.split(",").to_array()
  if values.length() != 4 {
    return None
  }
  guard ldtk_parse_color_channel(values[0]) is Some(red) else { return None }
  guard ldtk_parse_color_channel(values[1]) is Some(green) else { return None }
  guard ldtk_parse_color_channel(values[2]) is Some(blue) else { return None }
  guard ldtk_parse_alpha_channel(values[3]) is Some(base_alpha) else {
    return None
  }
  Some("rgba(\{red},\{green},\{blue},\{ldtk_clamp_alpha(alpha * base_alpha)})")
}

///|
fn ldtk_parse_color_channel(source : StringView) -> Int? {
  let trimmed = source.trim()
  let parsed : Result[Int, Error] = try? @string.parse_int(trimmed, base=10)
  match parsed {
    Ok(value) =>
      Some(if value < 0 { 0 } else if value > 255 { 255 } else { value })
    Err(_) => None
  }
}

///|
fn ldtk_parse_alpha_channel(source : StringView) -> Double? {
  let trimmed = source.trim()
  let parsed : Result[Double, Error] = try? @string.parse_double(trimmed)
  match parsed {
    Ok(value) => Some(ldtk_clamp_alpha(value))
    Err(_) => None
  }
}

///|
fn ldtk_hex_pair_to_int(hex : String, index : Int) -> Int? {
  if index < 0 || index + 2 > hex.length() {
    return None
  }
  let pair = hex.unsafe_substring(start=index, end=index + 2)
  let parsed : Result[Int, Error] = try? @string.parse_int(pair, base=16)
  match parsed {
    Ok(value) => Some(value)
    Err(_) => None
  }
}
