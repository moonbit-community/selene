///|
/// Collects initial component values before an entity has a handle.
struct SpawnDraft {
  world : World
  columns : Array[(Int32, (Int32, Entity) -> Unit)]
  mut spawned : Bool
}

///|
pub fn World::spawn_draft(self : World) -> SpawnDraft {
  { world: self, columns: [], spawned: false, }
}

///|
pub fn[T : Component] SpawnDraft::add(self : SpawnDraft, value : T) -> Unit {
  let store : ComponentStore[T] = components_in(self.world)
  self.add_to(store, value)
}

///|
pub fn[T] SpawnDraft::add_to(
  self : SpawnDraft,
  store : ComponentStore[T],
  value : T,
) -> Unit {
  guard !self.spawned else { abort("spawn draft already used") }
  guard store.belongs_to(self.world) else {
    abort("spawn draft component belongs to another World")
  }
  guard !self.columns.any(column => column.0 == store.component) else {
    abort("duplicate component in spawn draft")
  }
  self.columns.push(
    (store.component, (table, entity) => store.append_new(table, entity, value)),
  )
}

///|
pub fn SpawnDraft::spawn(self : SpawnDraft, parent? : Entity) -> Entity {
  guard !self.spawned else { abort("spawn draft already used") }
  let signature = self.columns.map(column => column.0)
  signature.sort()
  let plan : SpawnPlan[Unit] = {
    world_id: self.world.id(),
    entities: entity_store(world=self.world),
    signature,
    table: None,
    append: (table, entity, _) => {
      for (_, append) in self.columns {
        append(table, entity)
      }
    },
  }
  let entity = plan.spawn((), parent?)
  self.spawned = true
  self.columns.clear()
  entity
}
