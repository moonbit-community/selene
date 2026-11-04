///|
priv struct CommandQueue {
  mut pending : Array[(World) -> Unit]
  mut spare : Array[(World) -> Unit]
}

///|
let queues : ResourceKey[CommandQueue] = ResourceKey(_ => {
  pending: [],
  spare: [],
})

///|
fn enqueue(world : World, command : (World) -> Unit) -> Unit {
  queues.get_in(world).pending.push(command)
}

///|
fn flush_commands(world : World) -> Unit {
  let queue = queues.get_in(world)
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
