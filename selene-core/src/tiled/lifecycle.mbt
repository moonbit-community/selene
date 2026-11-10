///|
pub fn despawn_tiled_tree(root : @ecs.Entity) -> Unit {
  ignore(root.delete())
}
