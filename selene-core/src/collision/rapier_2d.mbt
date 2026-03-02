// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
pub(all) struct RapierSpatialIndex {
  bodies : @rapier_full.RigidBodySet
  colliders : @rapier_full.ColliderSet
  query : @collision.QueryPipeline
  collider_entities : Map[Int, @entity.Entity]
}

///|
fn to_rapier_vec2(vec : @math.Vec2D) -> @rapier_full.Vec2 {
  @rapier_full.Vec2::new(Float::from_double(vec[X]), Float::from_double(vec[Y]))
}

///|
fn rect_center(rect : @math.Rect) -> @math.Vec2D {
  rect.position + rect.size.scalar_mul(0.5)
}

///|
fn to_rapier_isometry(rect : @math.Rect) -> @rapier_full.Isometry2 {
  @rapier_full.Isometry2::from_translation(to_rapier_vec2(rect_center(rect)))
}

///|
fn to_rapier_shape(rect : @math.Rect) -> @collision.Shape {
  @collision.Shape::Cuboid(
    Float::from_double(rect.size[X] * 0.5),
    Float::from_double(rect.size[Y] * 0.5),
  )
}

///|
fn collider_handle_id(handle : @collision.ColliderHandle) -> Int {
  let (id, _generation) = handle.into_raw_parts()
  id
}

///|
fn get_index_entity(
  index : RapierSpatialIndex,
  handle : @collision.ColliderHandle,
) -> @entity.Entity? {
  index.collider_entities.get(collider_handle_id(handle))
}

///|
fn build_rapier_index(
  include_entity : (@entity.Entity) -> Bool,
) -> RapierSpatialIndex {
  let bodies = @rapier_full.RigidBodySet::new()
  let colliders = @rapier_full.ColliderSet::new()
  let collider_entities : Map[Int, @entity.Entity] = Map::new()
  for entity, shape in shapes {
    guard entity.is_alive() else { continue }
    guard include_entity(entity) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~) else { continue }
    guard @position.positions.get(entity) is Some(position) else { continue }
    guard width > 0.0 && height > 0.0 else { continue }
    let rect = @math.Rect::{
      position: position.0 + offset,
      size: @math.Vec2D(width, height),
    }
    let builder = @rapier_full.ColliderBuilder::cuboid(
      Float::from_double(rect.size[X] * 0.5),
      Float::from_double(rect.size[Y] * 0.5),
    ).translation(to_rapier_vec2(rect_center(rect)))
    let handle = colliders.insert(builder.build())
    collider_entities.set(collider_handle_id(handle), entity)
  }
  {
    bodies,
    colliders,
    query: @collision.QueryPipeline::new(
      @collision.QueryFilter::new(),
      bodies,
      colliders,
    ),
    collider_entities,
  }
}

///|
fn ui_space_matches(entity : @entity.Entity, space : @ui.UiSpace) -> Bool {
  guard @ui.uis.get(entity) is Some(ui) else { return false }
  match (ui.space, space) {
    (Virtual, Virtual) => true
    (Screen, Screen) => true
    _ => false
  }
}

///|
fn build_world_rapier_index() -> RapierSpatialIndex {
  build_rapier_index(fn(entity) { @ui.uis.get(entity) is None })
}

///|
fn build_ui_rapier_index(space : @ui.UiSpace) -> RapierSpatialIndex {
  build_rapier_index(fn(entity) { ui_space_matches(entity, space) })
}

///|
fn rapier_query_point_entities(
  index : RapierSpatialIndex,
  point : @math.Vec2D,
  predicate : (@entity.Entity) -> Bool,
) -> Set[@entity.Entity] {
  let filter = @collision.QueryFilter::new().predicate(fn(handle, _collider) {
    guard get_index_entity(index, handle) is Some(entity) else { return false }
    predicate(entity)
  })
  let query = index.query.with_filter(filter)
  let handles = query.intersect_point(
    index.bodies,
    index.colliders,
    to_rapier_vec2(point),
  )
  let result = Set::new()
  for handle in handles {
    guard get_index_entity(index, handle) is Some(entity) else { continue }
    if predicate(entity) {
      result.add(entity)
    }
  }
  result
}

///|
fn rapier_query_rect_entities(
  index : RapierSpatialIndex,
  rect : @math.Rect,
  predicate : (@entity.Entity) -> Bool,
) -> Set[@entity.Entity] {
  let filter = @collision.QueryFilter::new().predicate(fn(handle, _collider) {
    guard get_index_entity(index, handle) is Some(entity) else { return false }
    predicate(entity)
  })
  let query = index.query.with_filter(filter)
  let handles = query.intersect_shape(
    index.bodies,
    index.colliders,
    to_rapier_isometry(rect),
    to_rapier_shape(rect),
  )
  let result = Set::new()
  for handle in handles {
    guard get_index_entity(index, handle) is Some(entity) else { continue }
    if predicate(entity) {
      result.add(entity)
    }
  }
  result
}

///|
fn rapier_cast_rect(
  index : RapierSpatialIndex,
  owner : @entity.Entity,
  rect : @math.Rect,
  motion : @math.Vec2D,
  predicate : (@entity.Entity) -> Bool,
) -> (@entity.Entity, Double)? {
  let filter = @collision.QueryFilter::new().predicate(fn(handle, _collider) {
    guard get_index_entity(index, handle) is Some(entity) else { return false }
    guard entity != owner else { return false }
    predicate(entity)
  })
  let query = index.query.with_filter(filter)
  let options = @collision.ShapeCastOptions::new(1.0F, true)
  let cast = query.cast_shape(
    index.bodies,
    index.colliders,
    to_rapier_isometry(rect),
    to_rapier_vec2(motion),
    to_rapier_shape(rect),
    options,
  )
  guard cast is Some((handle, hit))
  guard get_index_entity(index, handle) is Some(entity)
  Some((entity, hit.toi().to_double()))
}
