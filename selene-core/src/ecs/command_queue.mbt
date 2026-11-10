///|
priv struct CommandQueue {
  mut pending : Array[(World) -> Unit]
  mut spare : Array[(World) -> Unit]
}

///|
let queues : ResourceKey[CommandQueue] = ResourceKey()

///|
fn CommandQueue::CommandQueue() -> CommandQueue {
  { pending: [], spare: [], }
}

///|
fn enqueue(world : World, command : (World) -> Unit) -> Unit {
  queues.get_or_insert_with(world, _ => CommandQueue()).pending.push(command)
}

///|
fn flush_commands(world : World) -> Unit {
  let queue = queues.get_or_insert_with(world, _ => CommandQueue())
  guard !queue.pending.is_empty() else { return }
  let batch = queue.pending
  queue.pending = queue.spare
  queue.spare = batch
  defer batch.clear()
  for command in batch {
    set_current_world(world)
    command(world)
  }
}
