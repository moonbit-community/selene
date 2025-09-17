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
pub let quadtree_root : Ref[QuadTree] = Ref::new(
  QuadTree::new(@math.Vec2D(0, 0), @math.Vec2D(0, 0), 0),
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
fn QuadTree::is_smallest_size(self : QuadTree) -> Bool {
  self.size[X] <= SMALLEST_SIZE || self.size[Y] <= SMALLEST_SIZE
}

///|
const SMALLEST_SIZE = 64.0

///|
fn QuadTree::insert(
  self : Self,
  entity : @system.Entity,
  box : @math.Rect,
) -> Unit {
  if !self.bounding_box.intersects(box) {
    return
  }
  if self.is_smallest_size() {
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
fn quadtree_query(area : @math.Rect) -> @set.Set[@system.Entity] {
  let mut trees = @list.of([quadtree_root.val])
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

pub fn quadtree_render_system(backend : &@system.Backend, _delta : Double) -> Unit {
  fn render_node(node : QuadTree) -> Unit {
    let position = node.position - @camera.get_position()
    let size = node.size
    backend.draw_stroke_rect(
      x=position[X],
      y=position[Y],
      width=size[X],
      height=size[Y],
      color="blue",
    )
    for child in node.children {
      render_node(child)
    }
  }

  render_node(quadtree_root.val)
}

///|
pub fn quadtree_clear_system(_ : &@system.Backend, _delta : Double) -> Unit {
  let mut left_limit = 0.0
  let mut right_limit = 0.0
  let mut top_limit = 0.0
  let mut bottom_limit = 0.0
  let boxes = []
  for e, shape in shapes {
    guard e.is_alive() else { continue }
    guard @ui.uis.get(e) is None else { continue }
    guard @position.positions.get(e) is Some(position) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~) else { continue }
    let box = @math.Rect::{
      position: position.0 + offset,
      size: @math.Vec2D(width, height),
    }
    boxes.push((e, box))
    left_limit = @cmp.minimum(left_limit, box.position[X])
    right_limit = @cmp.maximum(right_limit, box.position[X] + box.size[X])
    top_limit = @cmp.minimum(top_limit, box.position[Y])
    bottom_limit = @cmp.maximum(bottom_limit, box.position[Y] + box.size[Y])
  }
  quadtree_root.val = QuadTree::new(
    @math.Vec2D(left_limit, top_limit),
    @math.Vec2D(right_limit - left_limit, bottom_limit - top_limit),
    0,
  )
  for box in boxes {
    quadtree_root.val.insert(box.0, box.1)
  }
}
