///|
/// Describes the component columns in a query row. Use Single[T] for one column.
pub(open) trait QueryData {
  fn make_query(World) -> Query[Self]
}

///|
pub fn[T : QueryData] World::query(
  self : World,
  filters~ : Array[EntityFilter] = [],
) -> Query[T] {
  let query = QueryData::make_query(self)
  if filters.is_empty() {
    query
  } else {
    query.with_filters(filters)
  }
}

///|
/// Constructs a single-component query without spelling Single at construction.
pub fn[T : Component] World::query1(
  self : World,
  filters~ : Array[EntityFilter] = [],
) -> Query[Single[T]] {
  self.query(filters~)
}

///|
fn[T : Component] query_component(store : ComponentStore[T]) -> QueryComponent {
  let key : ComponentKey[T] = Component::component_key()
  { key_id: key.key.id, load: () => key.key.read_slot.val = Some(store), }
}

///|
fn[T] make_query1(
  store : ComponentStore[T],
  components~ : Array[QueryComponent] = [],
) -> Query[Single[T]] {
  Query(
    store.world_id,
    store.storage,
    store.order,
    id => {
      guard store.column(id) is Some(values) else { return None }
      Some({
        read: row => Single(values[row]),
        write: (row, value) => values[row] = value.0,
      })
    },
    components,
  )
}

///|
pub impl[T : Component] QueryData for Single[T] with fn make_query(world) {
  let store : ComponentStore[T] = components_in(world)
  make_query1(store, components=[query_component(store)])
}

///|
#deprecated("Use World::query or World::query1.", skip_current_package=true)
#doc(hidden)
pub extend Single with QueryData::{make_query}

///|
fn[A, B] make_query2(
  a : ComponentStore[A],
  b : ComponentStore[B],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      Some({
        read: row => (column_a[row], column_b[row]),
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
        },
      })
    },
    components,
  )
}

///|
pub impl[A : Component, B : Component] QueryData for (A, B) with fn make_query(
  world,
) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  make_query2(a, b, components=[query_component(a), query_component(b)])
}

///|
fn[A, B, C] make_query3(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      Some({
        read: row => (column_a[row], column_b[row], column_c[row]),
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
        },
      })
    },
    components,
  )
}

///|
pub impl[A : Component, B : Component, C : Component] QueryData for (A, B, C) with fn make_query(
  world,
) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  make_query3(a, b, c, components=[
    query_component(a),
    query_component(b),
    query_component(c),
  ])
}

///|
fn[A, B, C, D] make_query4(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C, D)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard d.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      guard d.column(id) is Some(column_d) else { return None }
      Some({
        read: row => {
          (column_a[row], column_b[row], column_c[row], column_d[row])
        },
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
          column_d[row] = value.3
        },
      })
    },
    components,
  )
}

///|
pub impl[A : Component, B : Component, C : Component, D : Component] QueryData for (
  A,
  B,
  C,
  D,
) with fn make_query(world) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  let d : ComponentStore[D] = components_in(world)
  make_query4(a, b, c, d, components=[
    query_component(a),
    query_component(b),
    query_component(c),
    query_component(d),
  ])
}

///|
fn[A, B, C, D, E] make_query5(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  e : ComponentStore[E],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C, D, E)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard d.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard e.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      guard d.column(id) is Some(column_d) else { return None }
      guard e.column(id) is Some(column_e) else { return None }
      Some({
        read: row => {
          (
            column_a[row],
            column_b[row],
            column_c[row],
            column_d[row],
            column_e[row],
          )
        },
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
          column_d[row] = value.3
          column_e[row] = value.4
        },
      })
    },
    components,
  )
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
] QueryData for (A, B, C, D, E) with fn make_query(world) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  let d : ComponentStore[D] = components_in(world)
  let e : ComponentStore[E] = components_in(world)
  make_query5(a, b, c, d, e, components=[
    query_component(a),
    query_component(b),
    query_component(c),
    query_component(d),
    query_component(e),
  ])
}

///|
fn[A, B, C, D, E, F] make_query6(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  e : ComponentStore[E],
  f : ComponentStore[F],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C, D, E, F)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard d.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard e.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard f.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      guard d.column(id) is Some(column_d) else { return None }
      guard e.column(id) is Some(column_e) else { return None }
      guard f.column(id) is Some(column_f) else { return None }
      Some({
        read: row => {
          (
            column_a[row],
            column_b[row],
            column_c[row],
            column_d[row],
            column_e[row],
            column_f[row],
          )
        },
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
          column_d[row] = value.3
          column_e[row] = value.4
          column_f[row] = value.5
        },
      })
    },
    components,
  )
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
] QueryData for (A, B, C, D, E, F) with fn make_query(world) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  let d : ComponentStore[D] = components_in(world)
  let e : ComponentStore[E] = components_in(world)
  let f : ComponentStore[F] = components_in(world)
  make_query6(a, b, c, d, e, f, components=[
    query_component(a),
    query_component(b),
    query_component(c),
    query_component(d),
    query_component(e),
    query_component(f),
  ])
}

///|
fn[A, B, C, D, E, F, G] make_query7(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  e : ComponentStore[E],
  f : ComponentStore[F],
  g : ComponentStore[G],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C, D, E, F, G)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard d.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard e.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard f.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard g.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      guard d.column(id) is Some(column_d) else { return None }
      guard e.column(id) is Some(column_e) else { return None }
      guard f.column(id) is Some(column_f) else { return None }
      guard g.column(id) is Some(column_g) else { return None }
      Some({
        read: row => {
          (
            column_a[row],
            column_b[row],
            column_c[row],
            column_d[row],
            column_e[row],
            column_f[row],
            column_g[row],
          )
        },
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
          column_d[row] = value.3
          column_e[row] = value.4
          column_f[row] = value.5
          column_g[row] = value.6
        },
      })
    },
    components,
  )
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
  G : Component,
] QueryData for (A, B, C, D, E, F, G) with fn make_query(world) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  let d : ComponentStore[D] = components_in(world)
  let e : ComponentStore[E] = components_in(world)
  let f : ComponentStore[F] = components_in(world)
  let g : ComponentStore[G] = components_in(world)
  make_query7(a, b, c, d, e, f, g, components=[
    query_component(a),
    query_component(b),
    query_component(c),
    query_component(d),
    query_component(e),
    query_component(f),
    query_component(g),
  ])
}

///|
fn[A, B, C, D, E, F, G, H] make_query8(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  e : ComponentStore[E],
  f : ComponentStore[F],
  g : ComponentStore[G],
  h : ComponentStore[H],
  components~ : Array[QueryComponent] = [],
) -> Query[(A, B, C, D, E, F, G, H)] {
  guard b.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard c.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard d.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard e.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard f.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard g.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  guard h.world_id == a.world_id else {
    abort("component stores belong to different worlds")
  }
  Query(
    a.world_id,
    a.storage,
    a.order,
    id => {
      guard a.column(id) is Some(column_a) else { return None }
      guard b.column(id) is Some(column_b) else { return None }
      guard c.column(id) is Some(column_c) else { return None }
      guard d.column(id) is Some(column_d) else { return None }
      guard e.column(id) is Some(column_e) else { return None }
      guard f.column(id) is Some(column_f) else { return None }
      guard g.column(id) is Some(column_g) else { return None }
      guard h.column(id) is Some(column_h) else { return None }
      Some({
        read: row => {
          (
            column_a[row],
            column_b[row],
            column_c[row],
            column_d[row],
            column_e[row],
            column_f[row],
            column_g[row],
            column_h[row],
          )
        },
        write: (row, value) => {
          column_a[row] = value.0
          column_b[row] = value.1
          column_c[row] = value.2
          column_d[row] = value.3
          column_e[row] = value.4
          column_f[row] = value.5
          column_g[row] = value.6
          column_h[row] = value.7
        },
      })
    },
    components,
  )
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
  G : Component,
  H : Component,
] QueryData for (A, B, C, D, E, F, G, H) with fn make_query(world) {
  let a : ComponentStore[A] = components_in(world)
  let b : ComponentStore[B] = components_in(world)
  let c : ComponentStore[C] = components_in(world)
  let d : ComponentStore[D] = components_in(world)
  let e : ComponentStore[E] = components_in(world)
  let f : ComponentStore[F] = components_in(world)
  let g : ComponentStore[G] = components_in(world)
  let h : ComponentStore[H] = components_in(world)
  make_query8(a, b, c, d, e, f, g, h, components=[
    query_component(a),
    query_component(b),
    query_component(c),
    query_component(d),
    query_component(e),
    query_component(f),
    query_component(g),
    query_component(h),
  ])
}
