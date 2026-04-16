///|
fn update(
  dispatch : @rabbita.Dispatch[@app.Msg],
  msg : @app.Msg,
  model : @app.Model,
) -> (@rabbita.Cmd, @app.Model) {
  let (effects, next) = @app.update(msg, model)
  let effects_cmd = effects_to_cmd(dispatch, effects)
  let selection_sync_cmd = if next.selected_resource != model.selected_resource &&
    next.selected_resource is Some(_) {
    ensure_selected_asset_visible_cmd()
  } else {
    @cmd.none
  }
  let component_search_focus_cmd = if next.add_component_panel_open &&
    !model.add_component_panel_open {
    focus_component_search_cmd()
  } else {
    @cmd.none
  }
  let sticky_overlay_sync_cmd = sync_asset_tree_sticky_overlay_cmd()
  let resource_preview_sync_cmd = sync_resource_previews_cmd()
  (
    @cmd.batch([
      effects_cmd, selection_sync_cmd, component_search_focus_cmd, sticky_overlay_sync_cmd,
      resource_preview_sync_cmd,
    ]),
    next,
  )
}

///|
fn sidebar_tree_ratio(model : @app.ViewState) -> Double {
  let ratio = 1.0 - model.sidebar_scene_ratio - model.sidebar_assets_ratio
  if ratio < 0.0 {
    0.0
  } else {
    ratio
  }
}

///|
fn sidebar_row_weight(ratio : Double) -> String {
  let safe_ratio = if ratio < 0.01 { 0.01 } else { ratio }
  "\{(safe_ratio * 100.0).to_string()}fr"
}

///|
fn sidebar_column_style(model : @app.ViewState) -> Array[String] {
  [
    "--scene-pane: " + sidebar_row_weight(model.sidebar_scene_ratio),
    "--assets-pane: " + sidebar_row_weight(model.sidebar_assets_ratio),
    "--tree-pane: " + sidebar_row_weight(sidebar_tree_ratio(model)),
  ]
}

///|
fn sidebar_column_attrs(model : @app.ViewState) -> @html.Attrs {
  @html.Attrs::build()
  .data_set("scene-ratio", model.sidebar_scene_ratio.to_string())
  .data_set("assets-ratio", model.sidebar_assets_ratio.to_string())
}

///|
fn sidebar_splitter(kind : String) -> @rabbita.Html {
  @html.div(
    class="sidebar-splitter",
    attrs=@html.Attrs::build().data_set("sidebar-splitter", kind),
    @html.nothing,
  )
}

///|
fn tree_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  scene : @editor_bridge.SceneDocument,
  parent : String?,
  selected_ids : Array[String],
  depth : Int,
) -> Array[@rabbita.Html] {
  let nodes : Array[@rabbita.Html] = []
  for entity in scene.entities {
    if entity.parent != parent {
      continue
    }
    let is_selected = selected_ids.contains(entity.id)
    nodes.push(
      @html.div(
        class=if is_selected {
          "scene-tree-row tree-item selected"
        } else {
          "scene-tree-row tree-item"
        },
        style=["padding-left: \{depth * 14 + 8}px"],
        attrs=scene_tree_item_attrs(dispatch, entity),
        @html.span(class="scene-tree-row-label", @app.entity_label(entity)),
      ),
    )
    nodes.push_iter(
      tree_view(dispatch, scene, Some(entity.id), selected_ids, depth + 1).iter(),
    )
  }
  nodes
}

///|
fn scene_tree_item_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  entity : @editor_bridge.EntityDocument,
) -> @html.Attrs {
  let hover_hint = "Entity: " +
    @app.entity_label(entity) +
    " (double-click to frame)"
  @html.Attrs::build()
  .handler("click", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_select_entity(Some(entity.id))))
  })
  .handler("dblclick", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_select_entity(Some(entity.id))))
    schedule_cmd(scheduler, dispatch(@app.msg_frame_selection()))
  })
  .handler("mouseenter", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(Some(hover_hint))))
  })
  .handler("mouseleave", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
  })
}

///|
fn hint_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  label : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("mouseenter", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(Some(label))))
  })
  .handler("mouseleave", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
  })
}

///|
fn asset_display_name(asset : @editor_bridge.AssetDocument) -> String {
  asset_display_name_from_path(asset.path)
}

///|
fn asset_display_name_from_path(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn image_preview_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  path : String,
) -> @html.Attrs {
  @html.Attrs::build()
  .handler("load", fn(event, scheduler) {
    let size = image_event_natural_size(event)
    if size.length() >= 2 {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_asset_size_resolved(path, size[0], size[1])),
      )
    }
  })
  .handler("error", fn(_event, scheduler) {
    schedule_cmd(scheduler, dispatch(@app.msg_asset_image_load_failed(path)))
  })
}
///|
fn tree_row_indents(depth : Int) -> Array[@rabbita.Html] {
  let indents : Array[@rabbita.Html] = []
  for _index = 0; _index < depth; _index = _index + 1 {
    indents.push(@html.span(class="asset-tree-indent", @html.nothing))
  }
  indents
}

///|
fn asset_tree_section_title(section_key : String) -> String {
  match section_key {
    "images" => "IMAGES"
    "atlases" => "ATLASES"
    "animations" => "ANIMATIONS"
    "prefabs" => "PREFABS"
    _ => section_key
  }
}

///|
fn folder_chain_key(
  section_key : String,
  folders : Array[String],
  depth : Int,
) -> String {
  section_key + ":" + folders[:depth + 1].join("/")
}

///|
fn folder_ancestors_expanded(
  model : @app.ViewState,
  section_key : String,
  folders : Array[String],
  force_expand : Bool,
  depth_exclusive : Int,
) -> Bool {
  if force_expand {
    return true
  }
  for index = 0; index < depth_exclusive; index = index + 1 {
    let key = folder_chain_key(section_key, folders, index)
    if !model.asset_tree_folder_expanded(key) {
      return false
    }
  }
  true
}

///|
fn tree_folder_row(
  dispatch : @rabbita.Dispatch[@app.Msg],
  depth : Int,
  label : String,
  hover_label : String,
  expanded : Bool,
  toggle_enabled : Bool,
  folder_key : String,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @rabbita.Html {
  let children = tree_row_indents(depth)
  children.push(
    @html.span(class="asset-tree-node", if expanded { "▾" } else { "▸" }),
  )
  children.push(@html.span(class="asset-tree-label folder", label))
  let class = if toggle_enabled {
    if expanded {
      "asset-tree-row folder expanded"
    } else {
      "asset-tree-row folder collapsed"
    }
  } else if expanded {
    "asset-tree-row folder expanded locked"
  } else {
    "asset-tree-row folder collapsed locked"
  }
  let attrs = hint_attrs(dispatch, hover_label)
    .data_set("sticky-chain", sticky_chain.join("/"))
    .data_set("sticky-section", sticky_section)
    .data_set("sticky-kind", "folder")
  @html.button(
    class=if expanded { class } else { class },
    on_click=if toggle_enabled {
      dispatch(@app.msg_toggle_asset_tree_folder(folder_key))
    } else {
      @cmd.none
    },
    attrs~,
    children,
  )
}

///|
fn tree_file_row(
  dispatch : @rabbita.Dispatch[@app.Msg],
  selected : Bool,
  selection : @app.ResourceSelection,
  full_path : String,
  depth : Int,
  label : String,
  badge : String,
  draggable_asset_path : String?,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @rabbita.Html {
  let children = tree_row_indents(depth)
  children.push(
    @html.span(
      class="asset-tree-node file",
      match selection {
        @app.Image(_) => "I"
        @app.Atlas(_) => "A"
        @app.AnimationClip(_) => "C"
        @app.AnimationGraph(_) => "G"
        @app.Prefab(_) => "P"
      },
    ),
  )
  children.push(@html.span(class="asset-tree-label", label))
  children.push(@html.span(class="asset-tree-badge", badge))
  @html.div(
    class=if selected {
      "asset-tree-row file selected"
    } else {
      "asset-tree-row file"
    },
    on_click=dispatch(@app.msg_select_resource(Some(selection))),
    attrs=asset_tree_file_attrs(
      dispatch, selection, full_path, draggable_asset_path, sticky_chain, sticky_section,
    ),
    children,
  )
}

///|
fn asset_tree_file_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  selection : @app.ResourceSelection,
  full_path : String,
  draggable_asset_path : String?,
  sticky_chain : Array[String],
  sticky_section : String,
) -> @html.Attrs {
  let attrs = @html.Attrs::build()
    .data_set("sticky-chain", sticky_chain.join("/"))
    .data_set("sticky-section", sticky_section)
    .data_set("sticky-kind", "file")
    .handler("mouseenter", fn(_event, scheduler) {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_set_hover_hint(Some(full_path))),
      )
    })
    .handler("mouseleave", fn(_event, scheduler) {
      schedule_cmd(scheduler, dispatch(@app.msg_set_hover_hint(None)))
    })
    .handler("dblclick", fn(_event, scheduler) {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_select_resource(Some(selection))),
      )
      schedule_cmd(scheduler, dispatch(@app.msg_insert_selected_resource()))
    })
  match draggable_asset_path {
    Some(asset_path) =>
      attrs
      .draggable("true")
      .handler("dragstart", fn(event, _scheduler) {
        begin_dragged_asset(asset_path)
        match event.to_drag_event() {
          Some(drag_event) =>
            drag_event_set_asset_payload(drag_event, asset_path)
          None => ()
        }
      })
      .handler("dragend", fn(event, _scheduler) {
        ignore(event)
        clear_dragged_asset()
      })
    None => attrs
  }
}

///|
fn build_asset_tree_rows(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  paths : Array[String],
  section_key : String,
  force_expand : Bool,
  drop_root : String?,
  selection_of : (String) -> @app.ResourceSelection,
  badge_of : (String) -> String,
  draggable_path_of : (String) -> String?,
) -> Array[@rabbita.Html] {
  let rows : Array[@rabbita.Html] = []
  let section_title = asset_tree_section_title(section_key)
  let sorted_paths : Array[String] = []
  sorted_paths.push_iter(paths.iter())
  sorted_paths.sort_by(fn(left, right) { left.compare(right) })
  let mut previous_folders : Array[String] = []
  for path in sorted_paths {
    let segments = tree_path_segments(path, drop_root)
    if segments.is_empty() {
      continue
    }
    let file_index = segments.length() - 1
    let folders = if file_index > 0 {
      segments[:file_index].to_array()
    } else {
      []
    }
    let shared = common_prefix_len(previous_folders, folders)
    for index = shared; index < folders.length(); index = index + 1 {
      if !folder_ancestors_expanded(
          model, section_key, folders, force_expand, index,
        ) {
        break
      }
      let key = folder_chain_key(section_key, folders, index)
      let expanded = if force_expand {
        true
      } else {
        model.asset_tree_folder_expanded(key)
      }
      let folder_path = match drop_root {
        Some(root) => root + "/" + folders[:index + 1].join("/")
        None => folders[:index + 1].join("/")
      }
      rows.push(
        tree_folder_row(
          dispatch,
          index,
          folders[index],
          folder_path,
          expanded,
          !force_expand,
          key,
          folders[:index + 1].to_array(),
          section_title,
        ),
      )
    }
    if !folder_ancestors_expanded(
        model,
        section_key,
        folders,
        force_expand,
        folders.length(),
      ) {
      previous_folders = folders
      continue
    }
    let selection = selection_of(path)
    rows.push(
      tree_file_row(
        dispatch,
        model.selected_resource == Some(selection),
        selection,
        path,
        file_index,
        segments[file_index],
        badge_of(path),
        draggable_path_of(path),
        folders,
        section_title,
      ),
    )
    previous_folders = folders
  }
  rows
}

///|
fn asset_section(
  dispatch : @rabbita.Dispatch[@app.Msg],
  title : String,
  count : Int,
  expanded : Bool,
  toggle_msg : @app.Msg,
  items : Array[@rabbita.Html],
) -> @rabbita.Html {
  @html.div(class="asset-section", [
    @html.button(class="asset-section-toggle", on_click=dispatch(toggle_msg), [
      @html.span(
        class="asset-section-caret",
        if expanded {
          "▾"
        } else {
          "▸"
        },
      ),
      @html.span(class="asset-section-title", title),
      @html.span(class="asset-section-count", count.to_string()),
    ]),
    if expanded && !items.is_empty() {
      @html.div(class="asset-list", items)
    } else {
      @html.nothing
    },
  ])
}

///|
fn asset_panel_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  let has_asset_filter = model.asset_query_normalized() != ""
  let force_expand_tree = model.asset_query_normalized() != ""
  let force_expand_sections = force_expand_tree
  let image_paths : Array[String] = []
  let image_badges : Map[String, String] = {}
  for asset in model.image_assets() {
    let title = asset_display_name(asset)
    if !model.asset_matches_query(title, asset.path) {
      continue
    }
    let size_label = match model.asset_size(asset.path) {
      Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
      None => "image"
    }
    image_paths.push(asset.path)
    image_badges.set(asset.path, size_label)
  }
  let image_rows = build_asset_tree_rows(
    dispatch,
    model,
    image_paths,
    "images",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_image(path) },
    fn(path) { image_badges.get(path).unwrap_or("image") },
    fn(path) { Some(path) },
  )

  let atlas_paths : Array[String] = []
  for atlas_ref in model.atlas_refs {
    let atlas_name = match model.atlas_documents.get(atlas_ref.path) {
      Some(atlas) => atlas.name
      None => asset_display_name_from_path(atlas_ref.path)
    }
    if !model.asset_matches_query(atlas_name, atlas_ref.path) {
      continue
    }
    atlas_paths.push(atlas_ref.path)
  }
  let atlas_rows = build_asset_tree_rows(
    dispatch,
    model,
    atlas_paths,
    "atlases",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_atlas(path) },
    fn(_path) { "atlas" },
    fn(_path) { None },
  )

  let animation_clip_paths : Array[String] = []
  for animation_ref in model.animation_clip_refs {
    let animation_name = match
      model.animation_clip_documents.get(animation_ref.path) {
      Some(animation) => animation.name
      None => asset_display_name_from_path(animation_ref.path)
    }
    if !model.asset_matches_query(animation_name, animation_ref.path) {
      continue
    }
    animation_clip_paths.push(animation_ref.path)
  }
  let animation_clip_rows = build_asset_tree_rows(
    dispatch,
    model,
    animation_clip_paths,
    "animation-clips",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_animation_clip(path) },
    fn(_path) { "clip" },
    fn(_path) { None },
  )

  let animation_graph_paths : Array[String] = []
  for animation_ref in model.animation_graph_refs {
    let animation_name = match
      model.animation_graph_documents.get(animation_ref.path) {
      Some(animation) => animation.name
      None => asset_display_name_from_path(animation_ref.path)
    }
    if !model.asset_matches_query(animation_name, animation_ref.path) {
      continue
    }
    animation_graph_paths.push(animation_ref.path)
  }
  let animation_graph_rows = build_asset_tree_rows(
    dispatch,
    model,
    animation_graph_paths,
    "animation-graphs",
    force_expand_tree,
    Some("assets"),
    fn(path) { @app.resource_selection_animation_graph(path) },
    fn(_path) { "graph" },
    fn(_path) { None },
  )

  let prefab_paths : Array[String] = []
  for prefab_ref in model.prefab_refs {
    let prefab_name = match model.prefab_documents.get(prefab_ref.path) {
      Some(prefab) => prefab.name
      None => asset_display_name_from_path(prefab_ref.path)
    }
    if !model.asset_matches_query(prefab_name, prefab_ref.path) {
      continue
    }
    prefab_paths.push(prefab_ref.path)
  }
  let prefab_rows = build_asset_tree_rows(
    dispatch,
    model,
    prefab_paths,
    "prefabs",
    force_expand_tree,
    Some("prefabs"),
    fn(path) { @app.resource_selection_prefab(path) },
    fn(_path) { "prefab" },
    fn(_path) { None },
  )
  let selected_is_image = match model.selected_resource {
    Some(@app.Image(_)) => true
    _ => false
  }
  let selected_is_atlas = match model.selected_resource {
    Some(@app.Atlas(_)) => true
    _ => false
  }
  let selected_is_clip = match model.selected_resource {
    Some(@app.AnimationClip(_)) => true
    _ => false
  }
  let toolbar = @html.div(class="asset-toolbar", [
    @html.input(
      class="field-input asset-search-input",
      value=model.asset_query,
      placeholder="Filter assets",
      on_input=fn(value) { dispatch(@app.msg_set_asset_query(value)) },
      @html.nothing,
    ),
    @html.div(class="asset-toolbar-actions", [
      @html.button(
        class=if selected_is_image {
          "small-button"
        } else {
          "small-button disabled"
        },
        on_click=if selected_is_image {
          dispatch(@app.msg_create_atlas_from_selected_image())
        } else {
          @cmd.none
        },
        attrs=hint_attrs(dispatch, "Create atlas from selected image"),
        "Atlas",
      ),
      @html.button(
        class=if selected_is_atlas {
          "small-button"
        } else {
          "small-button disabled"
        },
        on_click=if selected_is_atlas {
          dispatch(@app.msg_create_animation_from_selected_atlas())
        } else {
          @cmd.none
        },
        attrs=hint_attrs(dispatch, "Create animation clip from selected atlas"),
        "Clip",
      ),
      @html.button(
        class=if selected_is_clip {
          "small-button"
        } else {
          "small-button disabled"
        },
        on_click=if selected_is_clip {
          dispatch(@app.msg_create_animation_graph_from_selected_clip())
        } else {
          @cmd.none
        },
        attrs=hint_attrs(dispatch, "Create animation graph from selected clip"),
        "Graph",
      ),
    ]),
  ])
  let content : Array[@rabbita.Html] = []
  if !image_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Images",
        image_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.images_section_expanded
        },
        @app.msg_toggle_images_section(),
        image_rows,
      ),
    )
  }
  if !atlas_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Atlases",
        atlas_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.atlases_section_expanded
        },
        @app.msg_toggle_atlases_section(),
        atlas_rows,
      ),
    )
  }
  if !animation_clip_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Animation Clips",
        animation_clip_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.animation_clips_section_expanded
        },
        @app.msg_toggle_animation_clips_section(),
        animation_clip_rows,
      ),
    )
  }
  if !animation_graph_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Animation Graphs",
        animation_graph_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.animation_graphs_section_expanded
        },
        @app.msg_toggle_animation_graphs_section(),
        animation_graph_rows,
      ),
    )
  }
  if !prefab_rows.is_empty() {
    content.push(
      asset_section(
        dispatch,
        "Prefabs",
        prefab_paths.length(),
        if force_expand_sections {
          true
        } else {
          model.prefabs_section_expanded
        },
        @app.msg_toggle_prefabs_section(),
        prefab_rows,
      ),
    )
  }
  if image_rows.is_empty() &&
    atlas_rows.is_empty() &&
    animation_clip_rows.is_empty() &&
    animation_graph_rows.is_empty() &&
    prefab_rows.is_empty() {
    content.push(
      @html.div(
        class="empty",
        if has_asset_filter {
          [
            @html.span("No assets match this filter"),
            @html.button(
              class="small-button",
              attrs=hint_attrs(dispatch, "Clear asset search filter"),
              on_click=dispatch(@app.msg_set_asset_query("")),
              "Reset Filter",
            ),
          ]
        } else {
          [@html.span("No assets found")]
        },
      ),
    )
  }
  @html.div(class="panel-body asset-panel-body", [
    toolbar,
    @html.div(class="asset-tree-scroll", [
      @html.div(class="asset-tree-sticky-overlay empty", @html.nothing),
      @html.div(class="asset-grid", content),
    ]),
  ])
}
