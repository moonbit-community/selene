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

///| This should be the same as the WORLD_WIDTH
const GAME_WIDTH = 2048.0

///|
const GAME_HEIGHT = 2048.0

// FIXME: quadtree should be rebuilt each frame

///|
pub let quadtree_root : QuadTree = QuadTree::new(
  @math.Vec2D(0, 0),
  @math.Vec2D(GAME_WIDTH, GAME_HEIGHT),
  0,
)

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
fn QuadTree::insert(
  self : Self,
  entity : @system.Entity,
  box : @math.Rect,
) -> Unit {
  if !self.bounding_box.intersects(box) {
    return
  }
  if self.depth >= MAX_DEPTH {
    self.entities.add(entity)
    return
  }
  if self.children.is_empty() {
    let half_size = @math.Vec2D(self.size[X] * 0.5, self.size[Y] * 0.5)
    self.children
    ..push(QuadTree::new(self.position, half_size, self.depth + 1))
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D(half_size[X], 0),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D(0, half_size[Y]),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(QuadTree::new(self.position + half_size, half_size, self.depth + 1))
  }
  for child in self.children {
    child.insert(entity, box)
  }
}

///|
fn QuadTree::remove(
  self : Self,
  entity : @system.Entity,
  box : @math.Rect,
) -> Unit {
  if !self.bounding_box.intersects(box) {
    return
  }
  if self.depth >= MAX_DEPTH {
    self.entities.remove(entity)
    return
  }
  for child in self.children {
    child.remove(entity, box)
  }
  if self.children
    .iter()
    .all(c => c.entities.is_empty() && c.children.is_empty()) {
    self.children.clear()
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

///|
pub fn quadtree_render_system(backend : &@system.Backend) -> Unit {
  fn render_node(node : QuadTree) -> Unit {
    backend.draw_stroke_rect(
      x=node.position[X],
      y=node.position[Y],
      width=node.size[X],
      height=node.size[Y],
      color="blue",
    )
    for child in node.children {
      render_node(child)
    }
  }

  render_node(quadtree_root)
}
