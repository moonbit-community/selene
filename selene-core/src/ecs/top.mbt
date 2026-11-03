///|
pub struct World {
  id : UInt32
  mut frame_index : UInt32
  mut fixed_step_index : UInt32
  priv storage : Map[Int32, () -> Unit]
}

///|
fn make_world(id : UInt32) -> World {
  { id, frame_index: 0, fixed_step_index: 0, storage: {}, }
}

///|
let next_world_id : Ref[UInt32] = Ref(1U)

///|
let bootstrap_world_value : World = make_world(0U)

///|
let current_world_ref : Ref[World?] = Ref(Some(bootstrap_world_value))

///|
pub fn World::World() -> World {
  let id = next_world_id.val
  next_world_id.val += 1U
  make_world(id)
}

///|
pub fn bootstrap_world() -> World {
  bootstrap_world_value
}

///|
pub fn current_world() -> World? {
  current_world_ref.val
}

///|
pub fn require_current_world() -> World {
  match current_world_ref.val {
    Some(world) => world
    None => abort("No active world. Set one via @ecs.set_current_world(world).")
  }
}

///|
pub fn set_current_world(world : World) -> Unit {
  current_world_ref.val = Some(world)
}

///|
pub fn clear_current_world() -> Unit {
  current_world_ref.val = None
}

///|
pub fn World::id(self : World) -> UInt32 {
  self.id
}

///|
pub fn World::advance_frame(self : World) -> Unit {
  self.frame_index += 1U
}

///|
pub fn World::advance_fixed_step(self : World) -> Unit {
  self.fixed_step_index += 1U
}

///|
pub fn World::frame_index(self : World) -> UInt32 {
  self.frame_index
}

///|
pub fn World::fixed_step_index(self : World) -> UInt32 {
  self.fixed_step_index
}
