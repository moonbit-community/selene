///|
#derive(Eq, Debug)
struct Position(Int32)

///|
let position_key : @ecs.ComponentKey[Position] = ComponentKey()

///|
impl @ecs.Component for Position with fn component_key() {
  position_key
}

///|
#derive(Eq, Debug)
struct Speed(Int32)

///|
let speed_key : @ecs.ComponentKey[Speed] = ComponentKey()

///|
impl @ecs.Component for Speed with fn component_key() {
  speed_key
}

///|
test "component identity and point access are scoped to their World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let entity = @ecs_runtime.spawn(first, (Position(42), Speed(7)))
  let other = @ecs_runtime.spawn1(second, Position(99))
  assert_eq(first.get_component(entity), Some(Position(42)))
  assert_eq(first.get_component(entity), Some(Speed(7)))
  assert_eq(second.get_component(entity), (None : Position?))
  assert_eq(first.get_component(other), (None : Position?))
  first.set_component(entity, Position(43))
  assert_eq(first.get_component(entity), Some(Position(43)))
  assert_eq(second.get_component(other), Some(Position(99)))
}
