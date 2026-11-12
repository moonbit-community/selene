///|
pub fn despawn_ldtk_tree(world~ : @ecs.World, root : @ecs.Entity) -> Unit {
  let query_ldtk_world_instance : @ecs.Query[LdtkWorldInstance] = world.query()
  let query_ldtk_level_iid : @ecs.Query[LdtkLevelIid] = world.query()
  if query_ldtk_world_instance.get(root) is Some(instance) {
    for iid in instance.spawned_levels.keys() {
      ldtk_pending_transformed_level_iids().remove(iid)
    }
  }
  if query_ldtk_level_iid.get(root) is Some(level) {
    ldtk_pending_transformed_level_iids().remove(level.iid)
  }
  ignore(root.delete())
}
