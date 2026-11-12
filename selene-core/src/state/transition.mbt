///|
/// Used by application lifecycle registration during an active transition.
pub fn[T : StateType] is_entering(world : @ecs.World, value : T) -> Bool {
  let data : StateData[T] = state_data(world)
  match data.transition {
    Some((_, next)) => next == value
    None => false
  }
}

///|
/// Used by application lifecycle registration during an active transition.
pub fn[T : StateType] is_exiting(world : @ecs.World, value : T) -> Bool {
  let data : StateData[T] = state_data(world)
  match data.transition {
    Some((Some(previous), _)) => previous == value
    _ => false
  }
}
