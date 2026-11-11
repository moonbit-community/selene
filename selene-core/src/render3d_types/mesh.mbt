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
#derive(Eq, Debug)
pub(all) struct Tangent3D {
  x : Double
  y : Double
  z : Double
  w : Double
}

///|
pub extend Tangent3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Tangent3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum TriangleTopology3D {
  TriangleList
  TriangleStrip
  TriangleFan
}

///|
pub extend TriangleTopology3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TriangleTopology3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct TriangleMesh3D {
  positions : Array[@math.Vec3]
  indices : Array[Int32]?
  topology : TriangleTopology3D
  uv_sets : Array[Array[@math.Vec2]]
  normals : Array[@math.Vec3]?
  tangents : Array[Tangent3D]?
  colors : Array[@render.Color]?
}

///|
pub extend TriangleMesh3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TriangleMesh3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum MeshPrimitive3D {
  Cube(@math.Vec3)
  Sphere(Double)
  Cylinder(Double, Double, Double, Int32)
  Plane(@math.Vec3)
  Triangles(TriangleMesh3D)
}

///|
pub extend MeshPrimitive3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MeshPrimitive3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct MeshAsset {
  primitive : MeshPrimitive3D
}

///|
pub extend MeshAsset with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MeshAsset with Eq::{not_equal, equal}
