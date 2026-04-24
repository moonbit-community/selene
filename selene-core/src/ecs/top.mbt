///|
pub(all) struct World {
  id : UInt
  pending_commands : Array[(World) -> Unit]
  mut frame_index : UInt
  mut fixed_step_index : UInt
}

///|
fn make_world(id : UInt) -> World {
  { id, pending_commands: [], frame_index: 0, fixed_step_index: 0 }
}

///|
let next_world_id : Ref[UInt] = Ref::new(1U)

///|
let bootstrap_world_value : World = make_world(0U)

///|
let current_world_ref : Ref[World?] = Ref::new(Some(bootstrap_world_value))

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
pub fn World::id(self : World) -> UInt {
  self.id
}

///|
pub fn World::queue_command(self : World, command : (World) -> Unit) -> Unit {
  self.pending_commands.push(command)
}

///|
pub fn World::has_pending_commands(self : World) -> Bool {
  self.pending_commands.length() > 0
}

///|
pub fn World::flush_commands(self : World) -> Unit {
  if self.pending_commands.length() == 0 {
    return
  }
  let queued = self.pending_commands.copy()
  self.pending_commands.clear()
  for command in queued {
    command(self)
  }
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
pub fn World::frame_index(self : World) -> UInt {
  self.frame_index
}

///|
pub fn World::fixed_step_index(self : World) -> UInt {
  self.fixed_step_index
}
