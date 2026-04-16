///|
fn atlas_region_preview_names(
  regions : Array[@editor_bridge.AtlasRegionDocument],
) -> String {
  if regions.is_empty() {
    return "No regions generated"
  }
  let names : Array[String] = []
  let limit = if regions.length() < 8 { regions.length() } else { 8 }
  for index = 0; index < limit; index = index + 1 {
    names.push(regions[index].name)
  }
  names.join(", ")
}

///|
fn preview_rect_spec(rect : @editor_bridge.RectDoc) -> String {
  "\{rect.x.to_string()},\{rect.y.to_string()},\{rect.width.to_string()},\{rect.height.to_string()}"
}

///|
fn preview_region_specs(
  regions : Array[@editor_bridge.AtlasRegionDocument],
) -> String {
  let specs : Array[String] = []
  for region in regions {
    specs.push(preview_rect_spec(region.rect))
  }
  specs.join(";")
}

///|
fn atlas_region_by_name(
  atlas : @editor_bridge.AtlasAssetDocument,
  name : String,
) -> @editor_bridge.AtlasRegionDocument? {
  for region in atlas.regions {
    if region.name == name {
      return Some(region)
    }
  }
  None
}

///|
fn clip_preview_regions(
  clip : @editor_bridge.AnimationClipAssetDocument,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> (Array[@editor_bridge.AtlasRegionDocument], Array[String]) {
  let regions : Array[@editor_bridge.AtlasRegionDocument] = []
  let missing : Array[String] = []
  for frame_name in clip.frames {
    match atlas_region_by_name(atlas, frame_name) {
      Some(region) => regions.push(region)
      None => missing.push(frame_name)
    }
  }
  (regions, missing)
}

///|
fn graph_preview_clip_binding(
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> (String, String, Bool)? {
  match graph.default_node {
    Some(default_node_id) =>
      for node in graph.nodes {
        if node.id != default_node_id {
          continue
        }
        match node.kind {
          @editor_bridge.Clip(clip_asset_path~) =>
            return Some((node.id, clip_asset_path, true))
          _ => ()
        }
      }
    None => ()
  }
  for node in graph.nodes {
    match node.kind {
      @editor_bridge.Clip(clip_asset_path~) =>
        return Some((node.id, clip_asset_path, false))
      _ => ()
    }
  }
  None
}

///|
fn atlas_preview_canvas(
  source_image : String,
  regions : Array[@editor_bridge.AtlasRegionDocument],
) -> @rabbita.Html {
  @html.div(class="resource-preview-frame resource-preview-canvas-frame", [
    @html.canvas(
      class="resource-preview-canvas atlas-preview-canvas",
      attrs=@html.Attrs::build()
        .data_set("preview-src", project_asset_src(source_image))
        .data_set("preview-rects", preview_region_specs(regions)),
      @html.nothing,
    ),
  ])
}

///|
fn animation_preview_canvas(
  source_image : String,
  regions : Array[@editor_bridge.AtlasRegionDocument],
  fps : Double,
  looping : Bool,
  model : @app.ViewState,
) -> @rabbita.Html {
  @html.div(
    class="resource-preview-frame resource-preview-canvas-frame animation-preview-frame",
    [
      @html.canvas(
        class="resource-preview-canvas animation-preview-canvas",
        attrs=@html.Attrs::build()
          .data_set("preview-src", project_asset_src(source_image))
          .data_set("preview-rects", preview_region_specs(regions))
          .data_set(
            "preview-paused",
            if model.animation_preview_paused {
              "true"
            } else {
              "false"
            },
          )
          .data_set("preview-speed", model.animation_preview_speed.to_string())
          .data_set(
            "preview-seek-seconds",
            model.animation_preview_seek_seconds.to_string(),
          )
          .data_set(
            "preview-seek-serial",
            model.animation_preview_seek_serial.to_string(),
          )
          .data_set("preview-fps", fps.to_string())
          .data_set("preview-looping", if looping { "true" } else { "false" }),
        @html.nothing,
      ),
    ],
  )
}

///|
fn animation_preview_controls(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  @html.div(class="resource-preview-controls", [
    @html.div(class="inspector-actions", [
      @html.button(
        class=if model.animation_preview_paused {
          "small-button"
        } else {
          "small-button active"
        },
        on_click=dispatch(@app.msg_toggle_animation_preview_paused()),
        if model.animation_preview_paused {
          "Play"
        } else {
          "Pause"
        },
      ),
    ]),
    labeled_input("Speed", model.animation_preview_speed.to_string(), fn(
      value,
    ) {
      dispatch(@app.msg_update_animation_preview_speed(value))
    }),
    labeled_input("Seek (seconds)", model.animation_preview_seek_input, fn(
      value,
    ) {
      dispatch(@app.msg_update_animation_preview_seek_input(value))
    }),
    @html.div(class="inspector-actions", [
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_apply_animation_preview_seek()),
        "Seek",
      ),
    ]),
  ])
}

///|
fn preview_missing_frames_message(missing : Array[String]) -> String {
  if missing.is_empty() {
    ""
  } else {
    "Missing frames: " + missing.join(", ")
  }
}

///|
fn tree_path_segments(path : String, drop_root : String?) -> Array[String] {
  let raw = path.split("/")
  let segments : Array[String] = []
  for segment in raw {
    if segment != "" {
      segments.push(segment.to_string())
    }
  }
  let mut start = 0
  match drop_root {
    Some(root) if !segments.is_empty() && segments[0] == root => start = 1
    _ => ()
  }
  let trimmed : Array[String] = []
  for index = start; index < segments.length(); index = index + 1 {
    trimmed.push(segments[index])
  }
  if trimmed.is_empty() {
    [path]
  } else {
    trimmed
  }
}

///|
fn common_prefix_len(left : Array[String], right : Array[String]) -> Int {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  for index = 0; index < limit; index = index + 1 {
    if left[index] != right[index] {
      return index
    }
  }
  limit
}
