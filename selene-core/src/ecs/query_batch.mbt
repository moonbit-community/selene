///|
/// A view valid only during its query batch callback.
struct QueryBatch[T] {
  scope : Ref[Bool]
  entities : Array[Entity]
  table : Int32
  column : QueryColumn[T]
  components : Array[QueryComponent]
}

///|
/// Reads column elements. Mutable component objects are not made immutable.
struct ReadColumn[T] {
  scope : Ref[Bool]
  values : Array[T]
}

///|
/// Reads and replaces elements in one declared component column.
struct WriteColumn[T] {
  scope : Ref[Bool]
  values : Array[T]
}

///|
#inline
fn require_batch(scope : Ref[Bool]) -> Unit {
  guard scope.val else { abort("query batch view used outside its callback") }
}

///|
/// Visits each matching archetype with a callback-scoped batch view.
pub fn[T] Query::batches(
  self : Query[T],
  visit : (QueryBatch[T]) -> Unit,
) -> Unit {
  self.for_each_table((entities, table, column) => {
    let scope = Ref(true)
    defer {
      scope.val = false
    }
    visit({ scope, entities, table, column, components: self.components, })
  })
}

///|
#inline
pub fn[T] QueryBatch::length(self : QueryBatch[T]) -> Int32 {
  require_batch(self.scope)
  self.entities.length()
}

///|
#inline
pub fn[T] QueryBatch::entity(self : QueryBatch[T], row : Int32) -> Entity {
  require_batch(self.scope)
  self.entities[row]
}

///|
#inline
pub fn[T] QueryBatch::get(self : QueryBatch[T], row : Int32) -> T {
  require_batch(self.scope)
  (self.column.read)(row)
}

///|
#inline
pub fn[T] QueryBatch::set(self : QueryBatch[T], row : Int32, value : T) -> Unit {
  require_batch(self.scope)
  (self.column.write)(row, value)
}

///|
fn[T, C : Component] QueryBatch::component_column(
  self : QueryBatch[T],
) -> Array[C] {
  require_batch(self.scope)
  let key : ComponentKey[C] = Component::component_key()
  let mut selected = None
  for component in self.components {
    if component.key_id == key.key.id {
      selected = Some(component)
      break
    }
  }
  guard selected is Some(component) else {
    abort("component is not declared in this query")
  }
  // Use the same synchronous, typed lookup slot as WorldKey. No World or
  // untyped component array escapes through the query's public interface.
  (component.load)()
  let store = key.key.read_slot.val.unwrap()
  key.key.read_slot.val = None
  store.column(self.table).unwrap()
}

///|
pub fn[T, C : Component] QueryBatch::read_column(
  self : QueryBatch[T],
) -> ReadColumn[C] {
  { scope: self.scope, values: self.component_column(), }
}

///|
pub fn[T, C : Component] QueryBatch::write_column(
  self : QueryBatch[T],
) -> WriteColumn[C] {
  { scope: self.scope, values: self.component_column(), }
}

///|
#inline
pub fn[T] ReadColumn::length(self : ReadColumn[T]) -> Int32 {
  require_batch(self.scope)
  self.values.length()
}

///|
#inline
#alias(op_get)
pub fn[T] ReadColumn::get(self : ReadColumn[T], row : Int32) -> T {
  require_batch(self.scope)
  self.values[row]
}

///|
#inline
pub fn[T] WriteColumn::length(self : WriteColumn[T]) -> Int32 {
  require_batch(self.scope)
  self.values.length()
}

///|
#inline
#alias(op_get)
pub fn[T] WriteColumn::get(self : WriteColumn[T], row : Int32) -> T {
  require_batch(self.scope)
  self.values[row]
}

///|
#inline
#alias(op_set)
pub fn[T] WriteColumn::set(
  self : WriteColumn[T],
  row : Int32,
  value : T,
) -> Unit {
  require_batch(self.scope)
  self.values[row] = value
}
