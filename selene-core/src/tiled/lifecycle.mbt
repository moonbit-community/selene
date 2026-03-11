///|
pub fn despawn_tiled_tree(root : @entity.Entity) -> Unit {
  let entities : Array[@entity.Entity] = []
  collect_tiled_entity_tree(root, entities)
  for entity in entities {
    clear_tiled_root_components(entity)
    @physics2d.colliders().remove(entity)
    @physics2d.areas().remove(entity)
    @physics2d.shapes().remove(entity)
    @physics2d.rigid_bodies().remove(entity)
    @physics2d.linear_velocities().remove(entity)
    @physics2d.resolved_velocities().remove(entity)
    @physics2d.grounded_entities().remove(entity)
    @sprite.sprites().remove(entity)
    @transform.positions().remove(entity)
    entity.destroy()
  }
}

///|
pub fn clear_tiled_children(root : @entity.Entity) -> Unit {
  for child in root.get_children() {
    if child.is_alive() {
      despawn_tiled_tree(child)
    }
  }
}

///|
fn collect_tiled_entity_tree(
  entity : @entity.Entity,
  into : Array[@entity.Entity],
) -> Unit {
  into.push(entity)
  for child in entity.get_children() {
    collect_tiled_entity_tree(child, into)
  }
}

///|
fn clear_tiled_root_components(entity : @entity.Entity) -> Unit {
  tiled_world_map_instances().remove(entity)
  tiled_world_instances().remove(entity)
  tiled_image_layer_instances().remove(entity)
  tiled_object_instances().remove(entity)
  tiled_tile_instances().remove(entity)
  tiled_layer_instances().remove(entity)
  tiled_map_instances().remove(entity)
  tiled_map_storages().remove(entity)
  tiled_properties().remove(entity)
  tiled_parallax_layers().remove(entity)
  tiled_colliders().remove(entity)
  tiled_collider_origins().remove(entity)
}
