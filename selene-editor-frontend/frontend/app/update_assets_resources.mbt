///|
fn update_assets_resources(
  msg : AssetsResourcesMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
    CreateAtlasFromSelectedImage =>
      match model.selected_image_asset() {
        Some(asset) => {
          let atlas = atlas_document_from_image(
            asset.path,
            model.asset_size(asset.path),
          )
          let path = "assets/atlases/" +
            @editor_bridge.atlas_asset_file_name(atlas.name)
          let atlas_documents = model.atlas_documents
          atlas_documents.set(path, atlas)
          let atlas_refs = model.atlas_refs
          if !asset_ref_exists(atlas_refs, path) {
            atlas_refs.push(@editor_bridge.asset_ref(path))
          }
          let next = {
            ..model,
            atlas_documents,
            atlas_refs,
            selected_resource: Some(resource_selection_atlas(path)),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_atlas(path)),
            ),
            status: "Created atlas " + atlas.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_atlas_save(path, atlas),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    CreateAnimationFromSelectedAtlas =>
      match model.selected_atlas_document() {
        Some((path, atlas)) => {
          let clip = animation_clip_document_from_atlas(path, atlas)
          let clip_path = "assets/animation_clips/" +
            @editor_bridge.animation_clip_asset_file_name(clip.name)
          let animation_clip_documents = model.animation_clip_documents
          animation_clip_documents.set(clip_path, clip)
          let animation_clip_refs = model.animation_clip_refs
          if !asset_ref_exists(animation_clip_refs, clip_path) {
            animation_clip_refs.push(@editor_bridge.asset_ref(clip_path))
          }
          let next = {
            ..model,
            animation_clip_documents,
            animation_clip_refs,
            selected_resource: Some(
              resource_selection_animation_clip(clip_path),
            ),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_animation_clip(clip_path)),
            ),
            status: "Created animation clip " + clip.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_clip_save(clip_path, clip),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    CreateAnimationGraphFromSelectedClip =>
      match model.selected_animation_clip_document() {
        Some((clip_path, clip)) => {
          let graph = animation_graph_document_for_clip(clip_path, clip)
          let graph_path = "assets/animation_graphs/" +
            @editor_bridge.animation_graph_asset_file_name(graph.name)
          let animation_graph_documents = model.animation_graph_documents
          animation_graph_documents.set(graph_path, graph)
          let animation_graph_refs = model.animation_graph_refs
          if !asset_ref_exists(animation_graph_refs, graph_path) {
            animation_graph_refs.push(@editor_bridge.asset_ref(graph_path))
          }
          let next = {
            ..model,
            animation_graph_documents,
            animation_graph_refs,
            selected_resource: Some(
              resource_selection_animation_graph(graph_path),
            ),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_animation_graph(graph_path)),
            ),
            status: "Created animation graph " + graph.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_graph_save(graph_path, graph),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    SaveSelectedAsPrefab =>
      match (model.scene, model.selected_entity_id) {
        (Some(scene), Some(entity_id)) =>
          match prefab_from_scene_selection(scene, entity_id) {
            Some(prefab) => {
              let path = "prefabs/" +
                @editor_bridge.prefab_file_name(prefab.name)
              let prefab_documents = model.prefab_documents
              prefab_documents.set(path, prefab)
              let prefab_refs = model.prefab_refs
              if !prefab_ref_exists(prefab_refs, path) {
                prefab_refs.push(@editor_bridge.prefab_ref(path))
              }
              let next = {
                ..model,
                prefab_documents,
                prefab_refs,
                selected_resource: Some(resource_selection_prefab(path)),
                asset_tree_expanded: with_asset_tree_expanded_for_selection(
                  model.asset_tree_expanded,
                  Some(resource_selection_prefab(path)),
                ),
                status: "Saved prefab " + prefab.name,
              }
              let next = with_expanded_section_for_selection(
                next,
                next.selected_resource,
              )
              (
                [
                  rpc_effect(
                    SceneSaved,
                    @shared.rpc_request_prefab_save(path, prefab),
                  ),
                ],
                next,
              )
            }
            None => ([], model)
          }
        _ => ([], model)
      }
    InsertSelectedResource =>
      match (model.scene, model.selected_resource) {
        (Some(scene), Some(Image(path))) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            next_resource_entity_translation(),
          )
          let next = with_single_entity_selection(
            { ..model, scene: Some(next_scene) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        (Some(scene), Some(Atlas(path))) =>
          match model.atlas_documents.get(path) {
            Some(atlas) => {
              let (next_scene, id) = add_atlas_asset_to_scene(
                scene,
                path,
                atlas,
                next_resource_entity_translation(),
              )
              let next = with_single_entity_selection(
                { ..model, scene: Some(next_scene) },
                Some(id),
              )
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        (Some(scene), Some(AnimationClip(path))) =>
          match model.animation_clip_documents.get(path) {
            Some(clip) =>
              match model.atlas_documents.get(clip.atlas_asset_path) {
                Some(atlas) => {
                  let mut graph_pair : (
                    String,
                    @editor_bridge.AnimationGraphAssetDocument,
                  )? = None
                  for graph_path, graph in model.animation_graph_documents {
                    let selected_clip_path = animation_graph_default_clip_path(
                      graph,
                    ).unwrap_or("")
                    if selected_clip_path == path {
                      graph_pair = Some((graph_path, graph))
                      break
                    }
                  }
                  match graph_pair {
                    Some((graph_path, graph)) => {
                      let (next_scene, id) = add_animation_graph_asset_to_scene(
                        scene,
                        graph_path,
                        graph,
                        clip,
                        atlas,
                        next_resource_entity_translation(),
                      )
                      let next = with_single_entity_selection(
                        { ..model, scene: Some(next_scene) },
                        Some(id),
                      )
                      apply_scene_change(model, next)
                    }
                    None => {
                      let (next_scene, id) = add_atlas_asset_to_scene(
                        scene,
                        clip.atlas_asset_path,
                        atlas,
                        next_resource_entity_translation(),
                      )
                      let next = with_single_entity_selection(
                        { ..model, scene: Some(next_scene) },
                        Some(id),
                      )
                      apply_scene_change(model, next)
                    }
                  }
                }
                None => ([], model)
              }
            None => ([], model)
          }
        (Some(scene), Some(AnimationGraph(path))) =>
          match model.animation_graph_documents.get(path) {
            Some(graph) =>
              match animation_graph_default_clip_path(graph) {
                Some(clip_path) =>
                  match model.animation_clip_documents.get(clip_path) {
                    Some(clip) =>
                      match model.atlas_documents.get(clip.atlas_asset_path) {
                        Some(atlas) => {
                          let (next_scene, id) = add_animation_graph_asset_to_scene(
                            scene,
                            path,
                            graph,
                            clip,
                            atlas,
                            next_resource_entity_translation(),
                          )
                          let next = with_single_entity_selection(
                            { ..model, scene: Some(next_scene) },
                            Some(id),
                          )
                          apply_scene_change(model, next)
                        }
                        None => ([], model)
                      }
                    None => ([], model)
                  }
                None => ([], model)
              }
            None => ([], model)
          }
        (Some(scene), Some(Prefab(path))) =>
          match model.prefab_documents.get(path) {
            Some(prefab) => {
              let (next_scene, id) = instantiate_prefab_into_scene(
                scene,
                prefab,
                next_resource_entity_translation(),
              )
              let next = with_single_entity_selection(
                { ..model, scene: Some(next_scene) },
                id,
              )
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        _ => ([], model)
      }
  }
}
