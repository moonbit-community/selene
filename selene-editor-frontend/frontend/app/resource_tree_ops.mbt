///|
fn scene_path_exists(
  scene_refs : Array[@editor_bridge.SceneRef],
  path : String,
) -> Bool {
  for scene_ref in scene_refs {
    if scene_ref.path == path {
      return true
    }
  }
  false
}

///|
fn asset_ref_exists(
  refs : Array[@editor_bridge.AssetRef],
  path : String,
) -> Bool {
  for asset_ref in refs {
    if asset_ref.path == path {
      return true
    }
  }
  false
}

///|
fn prefab_ref_exists(
  refs : Array[@editor_bridge.PrefabRef],
  path : String,
) -> Bool {
  for prefab_ref in refs {
    if prefab_ref.path == path {
      return true
    }
  }
  false
}

///|
fn resource_exists(model : Model, selection : ResourceSelection) -> Bool {
  match selection {
    Image(path) => {
      for asset in model.assets {
        if asset.kind is @editor_bridge.Image && asset.path == path {
          return true
        }
      }
      false
    }
    Atlas(path) => asset_ref_exists(model.atlas_refs, path)
    AnimationClip(path) => asset_ref_exists(model.animation_clip_refs, path)
    AnimationGraph(path) => asset_ref_exists(model.animation_graph_refs, path)
    Prefab(path) => prefab_ref_exists(model.prefab_refs, path)
  }
}

///|
fn visible_resources_in_order(model : Model) -> Array[ResourceSelection] {
  let resources : Array[ResourceSelection] = []
  let force_expand_sections = model.asset_query_normalized() != ""

  if model.images_section_expanded || force_expand_sections {
    let image_paths : Array[String] = []
    for asset in model.image_assets() {
      if model.asset_matches_query(asset_basename(asset.path), asset.path) {
        image_paths.push(asset.path)
      }
    }
    for path in sorted_strings(image_paths) {
      resources.push(Image(path))
    }
  }

  if model.atlases_section_expanded || force_expand_sections {
    let atlas_paths : Array[String] = []
    for atlas_ref in model.atlas_refs {
      let atlas_name = match model.atlas_documents.get(atlas_ref.path) {
        Some(atlas) => atlas.name
        None => asset_basename(atlas_ref.path)
      }
      if model.asset_matches_query(atlas_name, atlas_ref.path) {
        atlas_paths.push(atlas_ref.path)
      }
    }
    for path in sorted_strings(atlas_paths) {
      resources.push(Atlas(path))
    }
  }

  if model.animation_clips_section_expanded || force_expand_sections {
    let animation_paths : Array[String] = []
    for animation_ref in model.animation_clip_refs {
      let animation_name = match
        model.animation_clip_documents.get(animation_ref.path) {
        Some(animation) => animation.name
        None => asset_basename(animation_ref.path)
      }
      if model.asset_matches_query(animation_name, animation_ref.path) {
        animation_paths.push(animation_ref.path)
      }
    }
    for path in sorted_strings(animation_paths) {
      resources.push(AnimationClip(path))
    }
  }

  if model.animation_graphs_section_expanded || force_expand_sections {
    let animation_paths : Array[String] = []
    for animation_ref in model.animation_graph_refs {
      let animation_name = match
        model.animation_graph_documents.get(animation_ref.path) {
        Some(animation) => animation.name
        None => asset_basename(animation_ref.path)
      }
      if model.asset_matches_query(animation_name, animation_ref.path) {
        animation_paths.push(animation_ref.path)
      }
    }
    for path in sorted_strings(animation_paths) {
      resources.push(AnimationGraph(path))
    }
  }

  if model.prefabs_section_expanded || force_expand_sections {
    let prefab_paths : Array[String] = []
    for prefab_ref in model.prefab_refs {
      let prefab_name = match model.prefab_documents.get(prefab_ref.path) {
        Some(prefab) => prefab.name
        None => asset_basename(prefab_ref.path)
      }
      if model.asset_matches_query(prefab_name, prefab_ref.path) {
        prefab_paths.push(prefab_ref.path)
      }
    }
    for path in sorted_strings(prefab_paths) {
      resources.push(Prefab(path))
    }
  }

  resources
}

///|
fn resource_index(
  resources : Array[ResourceSelection],
  target : ResourceSelection,
) -> Int? {
  for index = 0; index < resources.length(); index = index + 1 {
    if resources[index] == target {
      return Some(index)
    }
  }
  None
}

///|
fn with_expanded_section_for_selection(
  model : Model,
  selection : ResourceSelection?,
) -> Model {
  match selection {
    Some(Image(_)) => { ..model, images_section_expanded: true }
    Some(Atlas(_)) => { ..model, atlases_section_expanded: true }
    Some(AnimationClip(_)) =>
      { ..model, animation_clips_section_expanded: true }
    Some(AnimationGraph(_)) =>
      { ..model, animation_graphs_section_expanded: true }
    Some(Prefab(_)) => { ..model, prefabs_section_expanded: true }
    None => model
  }
}

///|
fn resource_selection_section_key(selection : ResourceSelection) -> String {
  match selection {
    Image(_) => "images"
    Atlas(_) => "atlases"
    AnimationClip(_) => "animation-clips"
    AnimationGraph(_) => "animation-graphs"
    Prefab(_) => "prefabs"
  }
}

///|
fn resource_selection_root_folder(selection : ResourceSelection) -> String {
  match selection {
    Image(_) => "assets"
    Atlas(_) => "assets"
    AnimationClip(_) => "assets"
    AnimationGraph(_) => "assets"
    Prefab(_) => "prefabs"
  }
}

///|
fn resource_selection_path(selection : ResourceSelection) -> String {
  match selection {
    Image(path) => path
    Atlas(path) => path
    AnimationClip(path) => path
    AnimationGraph(path) => path
    Prefab(path) => path
  }
}

///|
fn resource_selection_name(selection : ResourceSelection) -> String {
  asset_basename(resource_selection_path(selection))
}

///|
fn resource_tree_segments(path : String, root : String) -> Array[String] {
  let raw = path.split("/")
  let segments : Array[String] = []
  for segment in raw {
    if segment != "" {
      segments.push(segment.to_string())
    }
  }
  let mut start = 0
  if !segments.is_empty() && segments[0] == root {
    start = 1
  }
  let trimmed : Array[String] = []
  for index = start; index < segments.length(); index = index + 1 {
    trimmed.push(segments[index])
  }
  trimmed
}

///|
fn with_asset_tree_expanded_for_selection(
  expanded : Map[String, Bool],
  selection : ResourceSelection?,
) -> Map[String, Bool] {
  let next = expanded
  match selection {
    Some(selection) => {
      let section = resource_selection_section_key(selection)
      let root = resource_selection_root_folder(selection)
      let path = resource_selection_path(selection)
      let segments = resource_tree_segments(path, root)
      if segments.length() <= 1 {
        return next
      }
      for index = 0; index < segments.length() - 1; index = index + 1 {
        let key = section + ":" + segments[:index + 1].join("/")
        next.set(key, true)
      }
      next
    }
    None => next
  }
}

///|
fn collect_folder_keys_for_path(
  path : String,
  section : String,
  root : String,
  seen : Map[String, Bool],
  keys : Array[String],
) -> Unit {
  let segments = resource_tree_segments(path, root)
  if segments.length() <= 1 {
    return
  }
  for index = 0; index < segments.length() - 1; index = index + 1 {
    let key = section + ":" + segments[:index + 1].join("/")
    if seen.contains(key) {
      continue
    }
    seen.set(key, true)
    keys.push(key)
  }
}

///|
fn all_asset_tree_folder_keys(model : Model) -> Array[String] {
  let seen : Map[String, Bool] = {}
  let keys : Array[String] = []
  for asset in model.image_assets() {
    collect_folder_keys_for_path(asset.path, "images", "assets", seen, keys)
  }
  for atlas in model.atlas_refs {
    collect_folder_keys_for_path(atlas.path, "atlases", "assets", seen, keys)
  }
  for animation in model.animation_clip_refs {
    collect_folder_keys_for_path(
      animation.path,
      "animation-clips",
      "assets",
      seen,
      keys,
    )
  }
  for animation in model.animation_graph_refs {
    collect_folder_keys_for_path(
      animation.path,
      "animation-graphs",
      "assets",
      seen,
      keys,
    )
  }
  for prefab in model.prefab_refs {
    collect_folder_keys_for_path(prefab.path, "prefabs", "prefabs", seen, keys)
  }
  keys
}
