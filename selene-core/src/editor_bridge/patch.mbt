///|
pub enum ScenePatchOp {
  PutEntity(EntityDocument)
  DeleteEntity(String)
  ReparentEntity(id~ : String, parent~ : String?)
  RenameEntity(id~ : String, name~ : String)
  PutComponent(entity_id~ : String, component~ : ComponentDocument)
  RemoveComponent(entity_id~ : String, kind~ : String)
} derive(Eq, ToJson, FromJson)

///|
pub struct ScenePatch {
  ops : Array[ScenePatchOp]
} derive(Eq, ToJson, FromJson)

///|
pub fn ScenePatch::empty() -> ScenePatch {
  { ops: [] }
}

///|
pub fn SceneDocument::apply_patch(
  self : SceneDocument,
  patch : ScenePatch,
) -> SceneDocument {
  patch.ops.fold(init=self, fn(scene, op) {
    match op {
      PutEntity(entity) => scene.with_entity(entity)
      DeleteEntity(id) => scene.without_entity(id)
      ReparentEntity(id~, parent~) =>
        match scene.entity(id) {
          Some(entity) => scene.with_entity({ ..entity, parent, })
          None => scene
        }
      RenameEntity(id~, name~) =>
        match scene.entity(id) {
          Some(entity) => scene.with_entity({ ..entity, name, })
          None => scene
        }
      PutComponent(entity_id~, component~) =>
        match scene.entity(entity_id) {
          Some(entity) => scene.with_entity(entity.with_component(component))
          None => scene
        }
      RemoveComponent(entity_id~, kind~) =>
        match scene.entity(entity_id) {
          Some(entity) => scene.with_entity(entity.without_component(kind))
          None => scene
        }
    }
  })
}
