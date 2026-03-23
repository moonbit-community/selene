///|
pub fn despawn_ldtk_tree(root : @entity.Entity) -> Unit {
  let entities : Array[@entity.Entity] = []
  collect_ldtk_entity_tree(root, entities)
  for entity in entities {
    clear_ldtk_root_components(entity)
    @sprite.sprites().remove(entity)
    @transform.transforms().remove(entity)
    entity.destroy()
  }
}

///|
pub fn clear_ldtk_children(root : @entity.Entity) -> Unit {
  for child in root.get_children() {
    if child.is_alive() {
      despawn_ldtk_tree(child)
    }
  }
}

///|
fn collect_ldtk_entity_tree(
  entity : @entity.Entity,
  into : Array[@entity.Entity],
) -> Unit {
  into.push(entity)
  for child in entity.get_children() {
    collect_ldtk_entity_tree(child, into)
  }
}

///|
fn clear_ldtk_root_components(entity : @entity.Entity) -> Unit {
  if ldtk_level_instances().get(entity) is Some(level_instance) {
    ldtk_pending_transformed_level_iids().remove(level_instance.level.iid)
  }
  if ldtk_int_grid_cells().contains(entity) {
    @physics2d.areas().remove(entity)
    @physics2d.colliders().remove(entity)
    @physics2d.shapes().remove(entity)
    @physics2d.rigid_bodies().remove(entity)
  }
  if ldtk_int_grid_colliders().contains(entity) {
    @physics2d.areas().remove(entity)
    @physics2d.colliders().remove(entity)
    @physics2d.shapes().remove(entity)
    @physics2d.rigid_bodies().remove(entity)
    ldtk_int_grid_colliders().remove(entity)
  }
  ldtk_respawns().remove(entity)
  ldtk_worldly_entities().remove(entity)
  ldtk_tile_metadata().remove(entity)
  ldtk_int_grid_cells().remove(entity)
  ldtk_grid_coords().remove(entity)
  ldtk_entity_iids().remove(entity)
  ldtk_level_iids().remove(entity)
  ldtk_level_backgrounds().remove(entity)
  ldtk_layer_metadata().remove(entity)
  ldtk_spawned_int_grid_cells().remove(entity)
  ldtk_spawned_entity_instances().remove(entity)
  ldtk_spawned_tile_instances().remove(entity)
  ldtk_spawned_layer_instances().remove(entity)
  ldtk_level_instances().remove(entity)
  ldtk_world_instances().remove(entity)
}
