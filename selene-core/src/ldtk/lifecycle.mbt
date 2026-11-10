///|
pub fn despawn_ldtk_tree(root : @ecs.Entity) -> Unit {
  if ldtk_world_instances().get(root) is Some(instance) {
    for iid in instance.spawned_levels.keys() {
      ldtk_pending_transformed_level_iids().remove(iid)
    }
  }
  if ldtk_level_iids().get(root) is Some(level) {
    ldtk_pending_transformed_level_iids().remove(level.iid)
  }
  ignore(root.delete())
}
