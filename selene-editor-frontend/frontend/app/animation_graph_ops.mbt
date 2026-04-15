///|
fn animation_graph_document_for_clip(
  clip_path : String,
  clip : @editor_bridge.AnimationClipAssetDocument,
) -> @editor_bridge.AnimationGraphAssetDocument {
  @editor_bridge.AnimationGraphAssetDocument::default(
    clip.name + " Graph",
    clip_path,
  )
}

///|
fn animation_graph_default_clip_path(
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> String? {
  for node in graph.nodes {
    if graph.default_node == Some(node.id) {
      match node.kind {
        @editor_bridge.Clip(clip_asset_path~) => return Some(clip_asset_path)
        _ => ()
      }
    }
  }
  for node in graph.nodes {
    match node.kind {
      @editor_bridge.Clip(clip_asset_path~) => return Some(clip_asset_path)
      _ => ()
    }
  }
  None
}

///|
fn animation_graph_has_node_id(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node_id : String,
) -> Bool {
  for node in graph.nodes {
    if node.id == node_id {
      return true
    }
  }
  false
}

///|
fn next_animation_graph_node_id(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  prefix : String,
) -> String {
  let mut index = graph.nodes.length() + 1
  for ;; {
    let candidate = prefix + "-" + index.to_string()
    if !animation_graph_has_node_id(graph, candidate) {
      return candidate
    }
    index += 1
  }
  prefix + "-1"
}

///|
fn animation_graph_axis_bounds(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  axis : (@editor_bridge.AnimationGraphNodeDocument) -> Double,
) -> (Double, Double) {
  if graph.nodes.is_empty() {
    return (-1.0, 1.0)
  }
  let mut min_value = axis(graph.nodes[0])
  let mut max_value = min_value
  for node in graph.nodes[1:] {
    let value = axis(node)
    if value < min_value {
      min_value = value
    }
    if value > max_value {
      max_value = value
    }
  }
  if max_value - min_value < 0.001 {
    (min_value - 1.0, max_value + 1.0)
  } else {
    (min_value, max_value)
  }
}

///|
fn animation_graph_axis_unproject(
  normalized : Double,
  min_value : Double,
  max_value : Double,
) -> Double {
  min_value + clamp01(normalized) * (max_value - min_value)
}

///|
fn first_animation_clip_path(model : Model) -> String? {
  for clip_ref in model.animation_clip_refs {
    return Some(clip_ref.path)
  }
  for path, _ in model.animation_clip_documents {
    return Some(path)
  }
  None
}

///|
fn with_selected_animation_graph_node_added(
  model : Model,
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let node_id = next_animation_graph_node_id(graph, "node")
    let node = @editor_bridge.animation_graph_node_document(
      node_id,
      kind,
      position=@editor_bridge.vec2_doc(
        160.0 + graph.nodes.length().to_double() * 80.0,
        120.0,
      ),
    )
    let next_default = if graph.default_node is Some(_) {
      graph.default_node
    } else {
      Some(node_id)
    }
    graph.with_nodes(graph.nodes + [node]).with_default_node(next_default)
  })
}

///|
fn with_selected_animation_graph_node_removed(
  model : Model,
  node_id : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    let mut removed = false
    for node in graph.nodes {
      if node.id == node_id {
        removed = true
      } else {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for edge in node.edges {
          if edge.to != node_id {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      }
    }
    let next_default = if graph.default_node == Some(node_id) {
      if nodes.is_empty() {
        None
      } else {
        Some(nodes[0].id)
      }
    } else {
      graph.default_node
    }
    if removed {
      graph.with_nodes(nodes).with_default_node(next_default)
    } else {
      graph
    }
  })
}

///|
fn with_selected_animation_graph_clip_path_updated(
  model : Model,
  node_id : String,
  clip_path : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        match node.kind {
          @editor_bridge.Clip(..) =>
            nodes.push(
              node.with_kind(
                @editor_bridge.animation_graph_node_kind_clip(clip_path),
              ),
            )
          _ => nodes.push(node)
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn next_animation_graph_edge_target(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node_id : String,
) -> String? {
  for node in graph.nodes {
    if node.id != node_id {
      return Some(node.id)
    }
  }
  None
}

///|
fn with_selected_animation_graph_edge_added(
  model : Model,
  node_id : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    let target = next_animation_graph_edge_target(graph, node_id)
    for node in graph.nodes {
      if node.id == node_id {
        match target {
          Some(target) => {
            let mut exists = false
            for edge in node.edges {
              if edge.to == target {
                exists = true
                break
              }
            }
            if exists {
              nodes.push(node)
            } else {
              nodes.push(
                node.with_edges(
                  node.edges +
                  [@editor_bridge.animation_graph_edge_document(target)],
                ),
              )
            }
          }
          None => nodes.push(node)
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_added_to_target(
  model : Model,
  source_node_id : String,
  target_node_id : String,
) -> (Model, Bool) {
  if source_node_id == target_node_id {
    return (model, false)
  }
  let mut changed = false
  let next = update_selected_animation_graph_document(model, fn(graph) {
    let mut target_exists = false
    for node in graph.nodes {
      if node.id == target_node_id {
        target_exists = true
        break
      }
    }
    if !target_exists {
      return graph
    }
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == source_node_id {
        let mut exists = false
        for edge in node.edges {
          if edge.to == target_node_id {
            exists = true
            break
          }
        }
        if exists {
          nodes.push(node)
        } else {
          changed = true
          nodes.push(
            node.with_edges(
              node.edges +
              [@editor_bridge.animation_graph_edge_document(target_node_id)],
            ),
          )
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
  (next, changed)
}

///|
fn with_selected_animation_graph_edge_removed(
  model : Model,
  node_id : String,
  edge_index : Int,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          if index != edge_index {
            edges.push(node.edges[index])
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_target_updated(
  model : Model,
  node_id : String,
  edge_index : Int,
  target : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let next_target = target.trim().to_string()
    if next_target == "" {
      return graph
    }
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          let edge = node.edges[index]
          if index == edge_index {
            edges.push(
              @editor_bridge.animation_graph_edge_document(
                next_target,
                weight=edge.weight,
              ),
            )
          } else {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_weight_updated(
  model : Model,
  node_id : String,
  edge_index : Int,
  value : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          let edge = node.edges[index]
          if index == edge_index {
            edges.push(
              @editor_bridge.animation_graph_edge_document(
                edge.to,
                weight=parse_positive_double_or(edge.weight, value),
              ),
            )
          } else {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn update_selected_animation_graph_document(
  model : Model,
  updater : (@editor_bridge.AnimationGraphAssetDocument) -> @editor_bridge.AnimationGraphAssetDocument,
) -> Model {
  match model.selected_animation_graph_document() {
    Some((path, animation)) => {
      let animation_graph_documents = model.animation_graph_documents
      animation_graph_documents.set(path, updater(animation))
      { ..model, animation_graph_documents, }
    }
    None => model
  }
}
