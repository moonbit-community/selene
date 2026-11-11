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
pub fn apply_texture_transform3d(
  transform : TextureTransform3D,
  uv : @math.Vec2,
) -> @math.Vec2 {
  @render3d_types.apply_texture_transform3d(transform, uv)
}

///|
pub fn cubemap_asset_six_faces(faces : CubemapFaces3D) -> CubemapAsset3D {
  @render3d_types.cubemap_asset_six_faces(faces)
}

///|
pub fn cube_mesh(size : @math.Vec3) -> MeshAsset {
  { primitive: Cube(size), }
}

///|
pub fn sphere_mesh(radius : Double) -> MeshAsset {
  { primitive: Sphere(radius), }
}

///|
pub fn cylinder_mesh(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices~ : Int32 = 24,
) -> MeshAsset {
  { primitive: Cylinder(radius_top, radius_bottom, height, slices), }
}

///|
pub fn plane_mesh(size : @math.Vec3) -> MeshAsset {
  { primitive: Plane(size), }
}

///|
pub fn triangle_mesh(
  positions : Array[@math.Vec3],
  uvs~ : Array[@math.Vec2]? = None,
  normals~ : Array[@math.Vec3]? = None,
  tangents~ : Array[Tangent3D]? = None,
  colors~ : Array[@render.Color]? = None,
  uv_sets~ : Array[Array[@math.Vec2]] = [],
  indices~ : Array[Int32]? = None,
  topology~ : TriangleTopology3D = TriangleList,
) -> MeshAsset {
  let resolved_uv_sets = uv_sets.copy()
  if resolved_uv_sets.length() == 0 {
    if uvs is Some(primary_uvs) {
      resolved_uv_sets.push(primary_uvs)
    }
  } else if uvs is Some(primary_uvs) {
    if resolved_uv_sets.length() > 0 {
      resolved_uv_sets[0] = primary_uvs
    } else {
      resolved_uv_sets.push(primary_uvs)
    }
  }
  {
    primitive: Triangles({
      positions,
      indices,
      topology,
      uv_sets: resolved_uv_sets,
      normals,
      tangents,
      colors,
    }),
  }
}
