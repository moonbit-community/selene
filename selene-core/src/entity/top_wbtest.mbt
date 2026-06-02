///|
test "alive entity count follows lifecycle-visible entities" {
  let baseline = alive_entity_count()
  let entity = Entity()
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  inspect(alive_entity_count(), content="\{baseline}")
  entity.respawn()
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  entity_flush_system(0.0)
  inspect(alive_entity_count(), content="\{baseline}")
}

///|
test "reserved spawn increments alive count on flush" {
  let baseline = alive_entity_count()
  let entity = Entity::reserve_spawn()
  inspect(alive_entity_count(), content="\{baseline}")
  entity_flush_system(0.0)
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  inspect(alive_entity_count(), content="\{baseline}")
  entity_flush_system(0.0)
}
