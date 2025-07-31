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
const GAME_WIDTH = 2048.0

///|
const GAME_HEIGHT = 2048.0

///|
pub let quadtree : Ref[QuadTree] = {
  val: QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(GAME_WIDTH, GAME_HEIGHT),
    0,
  ),
}

///|
pub struct QuadTree {
  position : @math.Vec2D
  size : @math.Vec2D
  children : Array[QuadTree]
  priv depth : Int
  priv bounding_box : @math.Rect
  priv entities : @set.Set[@system.Entity]
}

///|
fn QuadTree::new(
  position : @math.Vec2D,
  size : @math.Vec2D,
  depth : Int,
) -> QuadTree {
  {
    position,
    size,
    depth,
    entities: @set.Set::new(),
    children: [],
    bounding_box: { position, size },
  }
}

///|
const MAX_DEPTH = 5

///|
fn QuadTree::insert(self : Self, entity : @system.Entity) -> Unit {
  guard collides.get(entity) is Some(collide) else { return }
  guard @position.positions.get(entity) is Some(position) else { return }
  // Now we only support rectangulars
  guard collide.shape is Rect(width~, height~) else { return }
  let box = @math.Rect::{
    position: position.inner(),
    size: @math.Vec2D::new(width, height),
  }
  if !self.bounding_box.intersects(box) {
    return
  }
  if self.depth >= MAX_DEPTH {
    self.entities.add(entity)
    return
  }
  if self.children.is_empty() {
    let half_size = @math.Vec2D::new(self.size.x * 0.5, self.size.y * 0.5)
    self.children
    ..push(QuadTree::new(self.position, half_size, self.depth + 1))
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D::new(half_size.x, 0),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D::new(0, half_size.y),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(QuadTree::new(self.position + half_size, half_size, self.depth + 1))
  }
  for child in self.children {
    child.insert(entity)
  }
}

///| 
fn QuadTree::query(self : Self, area : @math.Rect) -> @set.Set[@system.Entity] {
  let mut trees = @list.of([self])
  let mut results = @set.Set::new()
  while trees is More(hd, tail=rest) {
    trees = rest
    if !hd.bounding_box.intersects(area) {
      continue
    }
    if hd.children is [] {
      results = results.union(hd.entities)
    } else {
      hd.children.each(t => trees = trees.add(t))
    }
  }
  results
}
