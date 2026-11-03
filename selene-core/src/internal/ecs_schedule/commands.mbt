///|
priv struct CommandQueue {
  mut pending : Array[(@ecs.World) -> Unit]
  mut spare : Array[(@ecs.World) -> Unit]
}

///|
let queues : @ecs.WorldKey[CommandQueue] = @ecs.WorldKey(() => {
  pending: [],
  spare: [],
})

///|
let flushing : Ref[Bool] = Ref(false)

///|
// Query traversal and command application both run synchronously.
let query_depth : Ref[Int32] = Ref(0)

///|
pub fn enter_query() -> Unit {
  query_depth.val += 1
}

///|
pub fn leave_query() -> Unit {
  query_depth.val -= 1
}

///|
pub fn enqueue(world : @ecs.World, command : (@ecs.World) -> Unit) -> Unit {
  world.get_or_init(queues).pending.push(command)
}

///|
pub fn has_pending(world : @ecs.World) -> Bool {
  !world.get_or_init(queues).pending.is_empty()
}

///|
pub(all) suberror FlushError {
  ReentrantFlush
  ActiveQuery
}

///|
pub fn flush(world : @ecs.World) -> Unit raise FlushError {
  guard !flushing.val else { raise ReentrantFlush }
  guard query_depth.val == 0 else { raise ActiveQuery }
  let queue = world.get_or_init(queues)
  guard !queue.pending.is_empty() else { return }
  let batch = queue.pending
  queue.pending = queue.spare
  queue.spare = batch
  let previous_world = @ecs.current_world()
  flushing.val = true
  defer {
    batch.clear()
    flushing.val = false
    match previous_world {
      Some(previous) => @ecs.set_current_world(previous)
      None => @ecs.clear_current_world()
    }
  }
  for command in batch {
    @ecs.set_current_world(world)
    command(world)
  }
}
