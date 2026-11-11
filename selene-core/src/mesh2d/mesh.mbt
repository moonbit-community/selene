///|
#derive(Eq, Debug)
pub(all) enum Mesh2dPrimitive {
  Rectangle(@math.Vec2)
  Circle(Double)
}

///|
pub extend Mesh2dPrimitive with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dPrimitive with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct Mesh2dAsset {
  primitive : Mesh2dPrimitive
}

///|
pub extend Mesh2dAsset with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dAsset with Eq::{not_equal, equal}

///|
#derive(Eq, Debug, Hash)
pub(all) struct Mesh2dHandle(UInt32)

///|
pub extend Mesh2dHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dHandle with Eq::{not_equal, equal}

///|
pub extend Mesh2dHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Mesh2d {
  mesh : Mesh2dHandle
}

///|
pub extend Mesh2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2d with Eq::{not_equal, equal}

///|
pub(all) struct Mesh2dStorage {
  meshes : Map[Mesh2dHandle, Mesh2dAsset]
}

///|
pub fn mesh2ds() -> @ecs.ComponentStore[Mesh2d] {
  @ecs.components()
}

///|
let mesh_storage : Mesh2dStorage = { meshes: Map([]), }

///|
let next_mesh2d_id : Ref[UInt32] = Ref(0U)

///|
pub fn mesh2d_storage() -> Mesh2dStorage {
  mesh_storage
}

///|
pub fn Mesh2dAsset::rectangle(size : @math.Vec2) -> Mesh2dAsset {
  { primitive: Rectangle(size), }
}

///|
pub fn Mesh2dAsset::circle(radius : Double) -> Mesh2dAsset {
  { primitive: Circle(radius), }
}

///|
pub fn Mesh2d::Mesh2d(mesh : Mesh2dHandle) -> Mesh2d {
  { mesh, }
}

///|
pub fn register_mesh2d_asset(mesh : Mesh2dAsset) -> Mesh2dHandle {
  let handle = Mesh2dHandle(next_mesh2d_id.val)
  next_mesh2d_id.val += 1U
  mesh_storage.meshes.set(handle, mesh)
  handle
}

///|
pub fn update_mesh2d_asset(handle : Mesh2dHandle, mesh : Mesh2dAsset) -> Unit {
  mesh_storage.meshes.set(handle, mesh)
}

///|
pub fn release_mesh2d_asset(handle : Mesh2dHandle) -> Unit {
  mesh_storage.meshes.remove(handle)
}

///|
pub fn mesh2d_asset(handle : Mesh2dHandle) -> Mesh2dAsset? {
  mesh_storage.meshes.get(handle)
}

///|
pub fn rectangle(size : @math.Vec2) -> Mesh2dHandle {
  register_mesh2d_asset(Mesh2dAsset::rectangle(size))
}

///|
pub fn circle(radius : Double) -> Mesh2dHandle {
  register_mesh2d_asset(Mesh2dAsset::circle(radius))
}
