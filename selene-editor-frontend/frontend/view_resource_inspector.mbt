///|
fn selected_asset_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  match model.selected_resource {
    Some(@app.Image(path)) =>
      match model.selected_image_asset() {
        Some(asset) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Image"),
              if model.failed_image_assets.get(path).unwrap_or(false) {
                @html.div(
                  class="resource-preview-empty",
                  "Image preview unavailable",
                )
              } else {
                @html.div(class="resource-preview-frame", [
                  @html.img(
                    class="resource-preview-image",
                    src=project_asset_src(path),
                    alt=asset_display_name(asset),
                    attrs=image_preview_attrs(dispatch, path),
                    @html.nothing,
                  ),
                ])
              },
              @html.div(class="kv", [
                @html.span(class="kv-key", "Name"),
                @html.span(class="kv-value", asset_display_name(asset)),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", asset.path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Size"),
                @html.span(
                  class="kv-value",
                  match model.asset_size(path) {
                    Some(size) => "\{size.x.to_int()}×\{size.y.to_int()}"
                    None => "Unknown"
                  },
                ),
              ]),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Sprite To Scene",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_create_atlas_from_selected_image()),
                  "Create Atlas",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "No resource selected")
      }
    Some(@app.Atlas(_)) =>
      match model.selected_atlas_document() {
        Some((path, atlas)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Atlas"),
              atlas_preview_canvas(atlas.source_image, atlas.regions),
              @html.div(
                class="resource-preview-note",
                "Source image with generated atlas regions",
              ),
              labeled_input("Name", atlas.name, fn(value) {
                dispatch(@app.msg_update_selected_atlas_name(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Source"),
                @html.span(class="kv-value", atlas.source_image),
              ]),
              labeled_input("Tile Width", atlas.tile_size.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_tile_width(value))
              }),
              labeled_input("Tile Height", atlas.tile_size.y.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_tile_height(value))
              }),
              labeled_input("Columns", atlas.columns.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_columns(value))
              }),
              labeled_input("Rows", atlas.rows.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_rows(value))
              }),
              labeled_input("Spacing X", atlas.spacing.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_spacing_x(value))
              }),
              labeled_input("Spacing Y", atlas.spacing.y.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_spacing_y(value))
              }),
              labeled_input("Margin X", atlas.margin.x.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_x(value))
              }),
              labeled_input("Margin Y", atlas.margin.y.to_string(), fn(value) {
                dispatch(@app.msg_update_selected_atlas_margin_y(value))
              }),
              labeled_input("Anchor X", atlas.default_anchor.x.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_anchor_x(value))
              }),
              labeled_input("Anchor Y", atlas.default_anchor.y.to_string(), fn(
                value,
              ) {
                dispatch(@app.msg_update_selected_atlas_anchor_y(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Regions"),
                @html.span(class="kv-value", atlas.regions.length().to_string()),
              ]),
              @html.div(
                class="kv-value",
                atlas_region_preview_names(atlas.regions),
              ),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_atlas()),
                  "Save Atlas",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Atlas Sprite",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_create_animation_from_selected_atlas(),
                  ),
                  "Create Clip",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Atlas is still loading")
      }
    Some(@app.AnimationClip(_)) =>
      match model.selected_animation_clip_document() {
        Some((path, clip)) =>
          match model.atlas_documents.get(clip.atlas_asset_path) {
            Some(atlas) => {
              let (preview_regions, missing_frames) = clip_preview_regions(
                clip, atlas,
              )
              @html.div(class="panel-body", [
                @html.div(class="inspector-block", [
                  @html.h3("Animation Clip"),
                  if preview_regions.is_empty() {
                    @html.div(
                      class="resource-preview-empty",
                      if missing_frames.is_empty() {
                        "No frames available in the referenced atlas"
                      } else {
                        preview_missing_frames_message(missing_frames)
                      },
                    )
                  } else {
                    animation_preview_canvas(
                      atlas.source_image,
                      preview_regions,
                      clip.fps,
                      clip.looping,
                      model,
                    )
                  },
                  @html.div(
                    class="resource-preview-note",
                    "Previewing \{preview_regions.length().to_string()}/\{clip.frames.length().to_string()} resolved clip frames",
                  ),
                  if missing_frames.is_empty() {
                    @html.nothing
                  } else {
                    @html.div(
                      class="resource-preview-empty compact",
                      preview_missing_frames_message(missing_frames),
                    )
                  },
                  animation_preview_controls(dispatch, model),
                  labeled_input("Name", clip.name, fn(value) {
                    dispatch(
                      @app.msg_update_selected_animation_clip_asset_name(value),
                    )
                  }),
                  @html.div(class="kv", [
                    @html.span(class="kv-key", "Path"),
                    @html.span(class="kv-value", path),
                  ]),
                  @html.div(class="kv", [
                    @html.span(class="kv-key", "Atlas"),
                    @html.span(class="kv-value", clip.atlas_asset_path),
                  ]),
                  labeled_input("FPS", clip.fps.to_string(), fn(value) {
                    dispatch(@app.msg_update_selected_animation_clip_fps(value))
                  }),
                  @html.label(class="field", [
                    @html.span(class="field-label", "Looping"),
                    @html.button(
                      class="small-button",
                      on_click=dispatch(
                        @app.msg_toggle_selected_animation_clip_looping(),
                      ),
                      if clip.looping {
                        "Enabled"
                      } else {
                        "Disabled"
                      },
                    ),
                  ]),
                  labeled_input("Frames", clip.frames.join(", "), fn(value) {
                    dispatch(
                      @app.msg_update_selected_animation_clip_frames(value),
                    )
                  }),
                  @html.div(class="inspector-actions", [
                    @html.button(
                      class="small-button",
                      on_click=dispatch(@app.msg_save_selected_animation_clip()),
                      "Save Clip",
                    ),
                    @html.button(
                      class="small-button",
                      on_click=dispatch(@app.msg_insert_selected_resource()),
                      "Add Clip Sprite",
                    ),
                    @html.button(
                      class="small-button",
                      on_click=dispatch(
                        @app.msg_create_animation_graph_from_selected_clip(),
                      ),
                      "Create Graph",
                    ),
                  ]),
                ]),
              ])
            }
            None =>
              @html.div(
                class="empty",
                "Referenced atlas is still loading: \{clip.atlas_asset_path}",
              )
          }
        None => @html.div(class="empty", "Animation clip is still loading")
      }
    Some(@app.AnimationGraph(_)) =>
      match model.selected_animation_graph_document() {
        Some((path, graph)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Animation Graph"),
              labeled_input("Name", graph.name, fn(value) {
                dispatch(
                  @app.msg_update_selected_animation_graph_asset_name(value),
                )
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              labeled_input("Default Node", graph.default_node.unwrap_or(""), fn(
                value,
              ) {
                dispatch(
                  @app.msg_update_selected_animation_graph_default_node(value),
                )
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Node Count"),
                @html.span(class="kv-value", graph.nodes.length().to_string()),
              ]),
              animation_graph_canvas_view(
                dispatch,
                graph,
                model.graph_edge_connect_source_node,
              ),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_clip_node(),
                  ),
                  "Add Clip Node",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_blend_node(),
                  ),
                  "Add Blend Node",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(
                    @app.msg_add_selected_animation_graph_additive_blend_node(),
                  ),
                  "Add Additive Node",
                ),
              ]),
              if graph.nodes.is_empty() {
                @html.div(class="empty", "No nodes yet")
              } else {
                @html.div(
                  class="component-card-list",
                  graph.nodes.map(fn(node) {
                    animation_graph_node_card(dispatch, graph, node)
                  }),
                )
              },
              @html.h3("Preview"),
              match graph_preview_clip_binding(graph) {
                Some((node_id, clip_path, uses_default_node)) =>
                  match model.animation_clip_documents.get(clip_path) {
                    Some(clip) =>
                      match model.atlas_documents.get(clip.atlas_asset_path) {
                        Some(atlas) => {
                          let (preview_regions, missing_frames) = clip_preview_regions(
                            clip, atlas,
                          )
                          @html.div(class="resource-preview-section", [
                            if preview_regions.is_empty() {
                              @html.div(
                                class="resource-preview-empty",
                                if missing_frames.is_empty() {
                                  "Selected preview clip has no resolved frames"
                                } else {
                                  preview_missing_frames_message(missing_frames)
                                },
                              )
                            } else {
                              animation_preview_canvas(
                                atlas.source_image,
                                preview_regions,
                                clip.fps,
                                clip.looping,
                                model,
                              )
                            },
                            @html.div(
                              class="resource-preview-note",
                              if uses_default_node {
                                "Previewing default clip node \{node_id}"
                              } else {
                                "Default node is not a clip; previewing first clip node \{node_id}"
                              },
                            ),
                            @html.div(class="kv", [
                              @html.span(class="kv-key", "Clip"),
                              @html.span(class="kv-value", clip_path),
                            ]),
                            if missing_frames.is_empty() {
                              @html.nothing
                            } else {
                              @html.div(
                                class="resource-preview-empty compact",
                                preview_missing_frames_message(missing_frames),
                              )
                            },
                            animation_preview_controls(dispatch, model),
                          ])
                        }
                        None =>
                          @html.div(
                            class="resource-preview-empty",
                            "Preview atlas is still loading: \{clip.atlas_asset_path}",
                          )
                      }
                    None =>
                      @html.div(
                        class="resource-preview-empty",
                        "Preview clip is still loading: \{clip_path}",
                      )
                  }
                None =>
                  @html.div(
                    class="resource-preview-empty",
                    "No clip-backed node available for preview",
                  )
              },
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_animation_graph()),
                  "Save Graph",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Add Animated Sprite",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Animation graph is still loading")
      }
    Some(@app.Prefab(_)) =>
      match model.selected_prefab_document() {
        Some((path, prefab)) =>
          @html.div(class="panel-body", [
            @html.div(class="inspector-block", [
              @html.h3("Prefab"),
              labeled_input("Name", prefab.name, fn(value) {
                dispatch(@app.msg_update_selected_prefab_name(value))
              }),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Path"),
                @html.span(class="kv-value", path),
              ]),
              @html.div(class="kv", [
                @html.span(class="kv-key", "Entities"),
                @html.span(
                  class="kv-value",
                  prefab.entities.length().to_string(),
                ),
              ]),
              @html.div(
                class="kv-value",
                prefab.entities
                .map(fn(entity) { entity.name + " (" + entity.id + ")" })
                .join(", "),
              ),
              @html.div(class="inspector-actions", [
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_save_selected_prefab()),
                  "Save Prefab",
                ),
                @html.button(
                  class="small-button",
                  on_click=dispatch(@app.msg_insert_selected_resource()),
                  "Instantiate Prefab",
                ),
              ]),
            ]),
          ])
        None => @html.div(class="empty", "Prefab is still loading")
      }
    None => @html.div(class="empty", "No entity or resource selected")
  }
}
