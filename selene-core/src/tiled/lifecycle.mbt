///|
pub fn despawn_tiled_tree(root : @ecs.Entity) -> Unit {
  @ecs.commands(@ecs.require_current_world()).despawn(root)
}
