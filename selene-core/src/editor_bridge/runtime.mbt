///|
pub type AssetPathResolver = (String?) -> String?

///|
pub type CustomComponentApplier = (
  @entity.Entity,
  ComponentDocument,
  AssetInstantiationContext,
) -> Unit

///|
pub struct AssetInstantiationContext {
  asset_path_resolver : AssetPathResolver
  atlas_assets : Map[String, AtlasAssetDocument]
  animation_clip_assets : Map[String, AnimationClipAssetDocument]
  animation_graph_assets : Map[String, AnimationGraphAssetDocument]
  custom_component_handlers : Map[String, CustomComponentHandler]
}

///|
pub struct SceneRuntime {
  entity_ids : Map[String, @entity.Entity]
  tracked_entities : Array[@entity.Entity]
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle]
  material_handles : Array[@material2d.ColorMaterialHandle]
  mesh_handles : Array[@mesh2d.Mesh2dHandle]
  animation_clip_handles : Array[@animation.AnimationClipHandle]
  animation_graph_handles : Array[@animation.AnimationGraphHandle]
}

///|
priv struct PreparedAtlas {
  image_path : String?
  texture_atlas : @sprite.TextureAtlas?
  default_size : Vec2Doc?
  default_anchor : Vec2Doc?
}

///|
pub fn identity_asset_path_resolver(path : String?) -> String? {
  path
}

///|
pub fn asset_instantiation_context(
  asset_path_resolver? : AssetPathResolver = identity_asset_path_resolver,
  atlas_assets? : Map[String, AtlasAssetDocument] = {},
  animation_clip_assets? : Map[String, AnimationClipAssetDocument] = {},
  animation_graph_assets? : Map[String, AnimationGraphAssetDocument] = {},
  custom_component_handlers? : Map[String, CustomComponentHandler] = registered_custom_component_handlers,
) -> AssetInstantiationContext {
  {
    asset_path_resolver,
    atlas_assets,
    animation_clip_assets,
    animation_graph_assets,
    custom_component_handlers: normalize_custom_component_handlers(
      custom_component_handlers,
    ),
  }
}

///|
fn vec2_of(doc : Vec2Doc) -> @math.Vec2 {
  @math.Vec2(doc.x, doc.y)
}

///|
fn color_of(doc : ColorDoc) -> @render.Color {
  @render.Color::{
    r: doc.r.reinterpret_as_uint(),
    g: doc.g.reinterpret_as_uint(),
    b: doc.b.reinterpret_as_uint(),
    a: doc.a.to_double() / 255.0,
  }
}

///|
fn rect_of(doc : RectDoc) -> @math.Rect {
  @math.Rect::{
    position: @math.Vec2(doc.x, doc.y),
    size: @math.Vec2(doc.width, doc.height),
  }
}

///|
fn anchor_of(doc : Vec2Doc) -> @sprite.Anchor {
  @sprite.Anchor(@math.Vec2(doc.x, doc.y))
}

///|
fn basename_of(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn texture_atlas_layout_doc_from_asset(
  atlas : AtlasAssetDocument,
) -> TextureAtlasLayoutDoc {
  {
    tile_size: atlas.tile_size,
    columns: atlas.columns,
    rows: atlas.rows,
    padding: atlas.spacing,
    offset: atlas.margin,
  }
}

///|
fn register_layout_handle(
  layout_doc : TextureAtlasLayoutDoc,
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle],
) -> @sprite.TextureAtlasLayoutHandle {
  let handle = @sprite.register_texture_atlas_layout(
    @sprite.TextureAtlasLayout::from_grid(
      vec2_of(layout_doc.tile_size),
      layout_doc.columns,
      layout_doc.rows,
      padding=Some(vec2_of(layout_doc.padding)),
      offset=Some(vec2_of(layout_doc.offset)),
    ),
  )
  atlas_layouts.push(handle)
  handle
}

///|
fn region_by_name_or_index(
  atlas : AtlasAssetDocument,
  region_name : String?,
  index : Int,
) -> AtlasRegionDocument? {
  if region_name is Some(name) {
    for region in atlas.regions {
      if region.name == name {
        return Some(region)
      }
    }
  }
  for region in atlas.regions {
    if region.index == index {
      return Some(region)
    }
  }
  None
}

///|
fn autotile_rule_set_kind_of(
  rule_set : AutoTileRuleSetDocument,
) -> @autotile2d.AutoTileRuleSetKind {
  match rule_set {
    Bitmask4 => @autotile2d.autotile_rule_set_bitmask4()
    Bitmask8 => @autotile2d.autotile_rule_set_bitmask8()
    Wang => @autotile2d.autotile_rule_set_wang()
  }
}

///|
fn autotile_source_of(
  data : AutoTileLayer2dComponent,
) -> @autotile2d.AutoTileLayerSource {
  let palette : Array[@autotile2d.AutoTilePaletteEntry] = []
  for entry in data.palette {
    let bitmask4_rules : Array[@autotile2d.AutoTileMaskRule] = []
    let bitmask8_rules : Array[@autotile2d.AutoTileMaskRule] = []
    let wang_rules : Array[@autotile2d.AutoTileWangRule] = []
    for rule in entry.bitmask4_rules {
      bitmask4_rules.push(
        @autotile2d.autotile_mask_rule(
          rule.mask,
          rule.region_name,
          atlas_index=rule.atlas_index,
        ),
      )
    }
    for rule in entry.bitmask8_rules {
      bitmask8_rules.push(
        @autotile2d.autotile_mask_rule(
          rule.mask,
          rule.region_name,
          atlas_index=rule.atlas_index,
        ),
      )
    }
    for rule in entry.wang_rules {
      wang_rules.push(
        @autotile2d.autotile_wang_rule(
          rule.north,
          rule.east,
          rule.south,
          rule.west,
          rule.region_name,
          atlas_index=rule.atlas_index,
        ),
      )
    }
    palette.push(
      @autotile2d.autotile_palette_entry(
        entry.terrain,
        entry.fallback_region_name,
        fallback_atlas_index=entry.fallback_atlas_index,
        bitmask4_rules~,
        bitmask8_rules~,
        wang_rules~,
      ),
    )
  }
  let cells : Array[@autotile2d.AutoTileCell] = []
  for cell in data.cells {
    cells.push(@autotile2d.autotile_cell(cell.x, cell.y, cell.terrain))
  }
  @autotile2d.autotile_layer_source(
    tile_width=data.tile_size.x,
    tile_height=data.tile_size.y,
    origin_x=data.origin.x,
    origin_y=data.origin.y,
    atlas_asset_path=data.atlas_asset_path,
    rule_set=autotile_rule_set_kind_of(data.rule_set),
    palette~,
    cells~,
  )
}

///|
fn autotile_visual_resolver(
  context : AssetInstantiationContext,
) -> @autotile2d.AutoTileVisualResolver {
  fn(source, tile) {
    guard source.atlas_asset_path.trim() != "" else { return None }
    match context.atlas_assets.get(source.atlas_asset_path) {
      Some(atlas) => {
        let region = region_by_name_or_index(
          atlas,
          Some(tile.region_name),
          tile.atlas_index,
        )
        let rect = region.map(fn(item) { rect_of(item.rect) })
        let size = match region {
          Some(item) => @math.Vec2(item.rect.width, item.rect.height)
          None => @math.Vec2(source.tile_width, source.tile_height)
        }
        Some(
          @autotile2d.autotile_visual(
            image_path=(context.asset_path_resolver)(Some(atlas.source_image)),
            rect~,
            custom_size=Some(size),
            anchor=anchor_of(atlas.default_anchor),
          ),
        )
      }
      None => None
    }
  }
}

///|
fn apply_autotile_layer_component(
  entity : @entity.Entity,
  data : AutoTileLayer2dComponent,
  context : AssetInstantiationContext,
) -> Unit {
  let source = autotile_source_of(data)
  @autotile2d.register_runtime_layer(
    entity,
    source,
    context=@autotile2d.autotile_runtime_context(
      visual_resolver=Some(autotile_visual_resolver(context)),
      z=0.1,
    ),
  )
}

///|
fn prepared_atlas(
  atlas_doc : TextureAtlasComponent?,
  context : AssetInstantiationContext,
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle],
) -> PreparedAtlas? {
  match atlas_doc {
    Some(atlas_data) =>
      match atlas_data.atlas_asset_path {
        Some(path) =>
          match context.atlas_assets.get(path) {
            Some(atlas_asset) => {
              let layout = register_layout_handle(
                texture_atlas_layout_doc_from_asset(atlas_asset),
                atlas_layouts,
              )
              let region = region_by_name_or_index(
                atlas_asset,
                atlas_data.region_name,
                atlas_data.index,
              )
              Some({
                image_path: (context.asset_path_resolver)(
                  Some(atlas_asset.source_image),
                ),
                texture_atlas: Some(
                  @sprite.TextureAtlas::new(
                    layout,
                    index=region.map_or(atlas_data.index, fn(it) { it.index }),
                  ),
                ),
                default_size: match region {
                  Some(it) => Some(vec2_doc(it.rect.width, it.rect.height))
                  None => Some(atlas_asset.tile_size)
                },
                default_anchor: Some(atlas_asset.default_anchor),
              })
            }
            None => None
          }
        None =>
          match atlas_data.layout {
            Some(layout_doc) => {
              let layout = register_layout_handle(layout_doc, atlas_layouts)
              Some({
                image_path: None,
                texture_atlas: Some(
                  @sprite.TextureAtlas::new(layout, index=atlas_data.index),
                ),
                default_size: Some(layout_doc.tile_size),
                default_anchor: None,
              })
            }
            None => None
          }
      }
    None => None
  }
}

///|
fn repeat_animation_of(
  repeat_mode : AnimationRepeatModeDoc,
) -> @animation.RepeatAnimation {
  match repeat_mode {
    Never => @animation.Never
    Forever => @animation.Forever
    Count(count) =>
      if count <= 0 {
        @animation.Forever
      } else {
        @animation.Count(count.reinterpret_as_uint())
      }
  }
}

///|
pub fn[T : FromJson] decode_component(component : ComponentDocument?) -> T? {
  match component {
    Some(value) => Some(@json.from_json(value.data)) catch { _ => None }
    None => None
  }
}

///|
pub fn decoded_transform(document : EntityDocument) -> Transform2dComponent {
  decode_component(document.component("Transform2d")).unwrap_or(
    transform2d_value(),
  )
}

///|
pub fn sprite_doc_size(
  sprite_data : SpriteComponent,
  atlas_size : Vec2Doc?,
) -> Vec2Doc {
  match sprite_data.custom_size {
    Some(size) => size
    None =>
      match atlas_size {
        Some(size) => size
        None =>
          match sprite_data.rect {
            Some(rect) => vec2_doc(rect.width, rect.height)
            None => vec2_doc(32.0, 32.0)
          }
      }
  }
}

///|
fn clear_entity_components(entity : @entity.Entity) -> Unit {
  @name.names().remove(entity) |> ignore
  @transform.transforms().remove(entity) |> ignore
  @transform.global_transforms().remove(entity) |> ignore
  @visibility.visibilities().remove(entity) |> ignore
  @sprite.sprites().remove(entity) |> ignore
  @mesh2d.mesh2ds().remove(entity) |> ignore
  @material2d.mesh_material2ds().remove(entity) |> ignore
  @text2d.text2ds().remove(entity) |> ignore
  @text2d.text_bounds().remove(entity) |> ignore
  @text2d.text_anchors().remove(entity) |> ignore
  @ui.texts().remove(entity) |> ignore
  @ui.text_fonts().remove(entity) |> ignore
  @ui.text_colors().remove(entity) |> ignore
  @ui.text_layouts().remove(entity) |> ignore
  @camera.cameras().remove(entity) |> ignore
  @camera.camera2ds().remove(entity) |> ignore
  @camera.orthographic_projections().remove(entity) |> ignore
  @physics2d.rigid_bodies().remove(entity) |> ignore
  @physics2d.colliders().remove(entity) |> ignore
  @physics2d.sensors().remove(entity) |> ignore
  @physics2d.shapes().remove(entity) |> ignore
  @physics2d.velocities().remove(entity) |> ignore
  @animation.animation_players().remove(entity) |> ignore
  @animation.animation_transitions().remove(entity) |> ignore
  @animation.animation_graph_handles().remove(entity) |> ignore
  @animation.animation_target_ids().remove(entity) |> ignore
  @animation.animated_bys().remove(entity) |> ignore
  entity.remove_parent()
  entity.destroy()
}

///|
pub fn SceneRuntime::destroy(self : SceneRuntime) -> Unit {
  for entity in self.tracked_entities {
    clear_entity_components(entity)
  }
  for handle in self.atlas_layouts {
    @sprite.release_texture_atlas_layout(handle)
  }
  for handle in self.material_handles {
    @material2d.release_color_material(handle)
  }
  for handle in self.mesh_handles {
    @mesh2d.release_mesh2d_asset(handle)
  }
  for handle in self.animation_clip_handles {
    @animation.release_animation_clip_asset(handle)
  }
  for handle in self.animation_graph_handles {
    @animation.release_animation_graph_asset(handle)
  }
}

///|
pub fn SceneRuntime::entity(
  self : SceneRuntime,
  id : String,
) -> @entity.Entity? {
  if self.entity_ids.contains(id) {
    Some(self.entity_ids[id])
  } else {
    None
  }
}

///|
fn apply_animation_components(
  entity : @entity.Entity,
  document : EntityDocument,
  animation_doc : AnimationPlayerComponent,
  transitions_doc : AnimationTransitionsComponent?,
  context : AssetInstantiationContext,
  animation_clip_handles : Array[@animation.AnimationClipHandle],
  animation_graph_handles : Array[@animation.AnimationGraphHandle],
) -> Unit {
  guard animation_doc.graph_asset_path is Some(graph_path) else { return }
  guard context.animation_graph_assets.get(graph_path) is Some(graph_doc) else {
    return
  }
  let target_id = @animation.AnimationTargetId::new(document.id)
  @animation.animation_target_ids().set(entity, target_id)

  let clip_handles_by_path : Map[String, @animation.AnimationClipHandle] = {}
  for node in graph_doc.nodes {
    match node.kind {
      Clip(clip_asset_path~) => {
        if clip_asset_path == "" ||
          clip_handles_by_path.contains(clip_asset_path) {
          continue
        }
        guard context.animation_clip_assets.get(clip_asset_path)
          is Some(clip_doc) else {
          continue
        }
        guard context.atlas_assets.get(clip_doc.atlas_asset_path)
          is Some(atlas_asset) else {
          continue
        }
        let clip = @animation.AnimationClip::new(clip_doc.name)
        let keyframes : Array[@animation.ScalarKeyframe] = []
        for index, frame_name in clip_doc.frames {
          if region_by_name_or_index(atlas_asset, Some(frame_name), index)
            is Some(region) {
            keyframes.push({
              time: index.to_double() / clip_doc.fps,
              value: region.index.to_double(),
              in_tangent: None,
              out_tangent: None,
            })
          }
        }
        if keyframes.is_empty() {
          continue
        }
        clip.add_curve_to_target(
          target_id,
          @animation.VariableCurve::scalar(
            @animation.texture_atlas_index_field(),
            keyframes,
            interpolation=@animation.Step,
          ),
        )
        let handle = @animation.register_animation_clip_asset(clip)
        animation_clip_handles.push(handle)
        clip_handles_by_path.set(clip_asset_path, handle)
      }
      _ => ()
    }
  }
  guard !clip_handles_by_path.is_empty() else { return }

  let graph = @animation.AnimationGraph::new()
  let graph_nodes : Map[String, @animation.AnimationNodeIndex] = {}
  let runtime_node_order : Array[@animation.AnimationNodeIndex] = []
  for node in graph_doc.nodes {
    let runtime_node : @animation.AnimationNodeIndex? = match node.kind {
      Clip(clip_asset_path~) =>
        match clip_handles_by_path.get(clip_asset_path) {
          Some(handle) =>
            if node.mask_groups.is_empty() {
              Some(graph.add_clip(handle))
            } else {
              Some(graph.add_clip_with_mask(handle, node.mask_groups))
            }
          None => None
        }
      Blend =>
        if node.mask_groups.is_empty() {
          Some(graph.add_blend())
        } else {
          Some(graph.add_blend_with_mask(node.mask_groups))
        }
      AdditiveBlend =>
        if node.mask_groups.is_empty() {
          Some(graph.add_additive_blend())
        } else {
          Some(graph.add_additive_blend_with_mask(node.mask_groups))
        }
    }
    if runtime_node is Some(index) {
      graph_nodes.set(node.id, index)
      runtime_node_order.push(index)
    }
  }
  guard !runtime_node_order.is_empty() else { return }

  for node in graph_doc.nodes {
    guard graph_nodes.get(node.id) is Some(parent) else { continue }
    for edge in node.edges {
      guard graph_nodes.get(edge.to) is Some(child) else { continue }
      graph.add_edge(parent, child, weight=edge.weight)
    }
  }

  let graph_handle = @animation.register_animation_graph_asset(graph)
  animation_graph_handles.push(graph_handle)
  @animation.animation_graph_handles().set(entity, graph_handle)
  let player = @animation.AnimationPlayer::new()
  let default_node : @animation.AnimationNodeIndex? = match
    animation_doc.start_node {
    Some(node_name) =>
      match graph_nodes.get(node_name) {
        Some(node) => Some(node)
        None =>
          match graph_doc.default_node {
            Some(default_name) => graph_nodes.get(default_name)
            None => Some(runtime_node_order[0])
          }
      }
    None =>
      match graph_doc.default_node {
        Some(default_name) =>
          match graph_nodes.get(default_name) {
            Some(node) => Some(node)
            None => Some(runtime_node_order[0])
          }
        None => Some(runtime_node_order[0])
      }
  }
  if transitions_doc is Some(transitions_data) {
    let transitions = @animation.AnimationTransitions::new()
    if animation_doc.autoplay && default_node is Some(node) {
      let active = transitions.play(
        player,
        node,
        transitions_data.duration,
        repeat=repeat_animation_of(animation_doc.repeat_mode_doc()),
      )
      ignore(active.set_speed(animation_doc.speed))
    }
    @animation.animation_transitions().set(entity, transitions)
  } else if animation_doc.autoplay && default_node is Some(node) {
    let active = player.play(
      node,
      repeat=repeat_animation_of(animation_doc.repeat_mode_doc()),
    )
    ignore(active.set_speed(animation_doc.speed))
  }
  @animation.animation_players().set(entity, player)
}

///|
fn apply_document_components(
  entity : @entity.Entity,
  document : EntityDocument,
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle],
  material_handles : Array[@material2d.ColorMaterialHandle],
  mesh_handles : Array[@mesh2d.Mesh2dHandle],
  animation_clip_handles : Array[@animation.AnimationClipHandle],
  animation_graph_handles : Array[@animation.AnimationGraphHandle],
  context : AssetInstantiationContext,
) -> Unit {
  let atlas_doc : TextureAtlasComponent? = decode_component(
    document.component("TextureAtlas"),
  )
  let mesh_doc : Mesh2dComponent? = decode_component(
    document.component("Mesh2d"),
  )
  let material_doc : ColorMaterialComponent? = decode_component(
    document.component("ColorMaterial"),
  )
  let animation_doc : AnimationPlayerComponent? = decode_component(
    document.component("AnimationPlayer"),
  )
  let transitions_doc : AnimationTransitionsComponent? = decode_component(
    document.component("AnimationTransitions"),
  )
  let autotile_doc : AutoTileLayer2dComponent? = decode_component(
    document.component("AutoTileLayer2d"),
  )

  for component in document.components {
    match component.kind {
      "Name" => {
        let data : NameComponent = match decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @name.names().set(entity, @name.Name::new(data.value))
      }
      "Transform2d" => {
        let data : Transform2dComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @transform.transforms().set(
          entity,
          @transform.Transform::from_xyz(
            data.translation.x,
            data.translation.y,
            0.0,
          )
          .with_rotation(
            @math.Quat::from_axis_angle(@math.Vec3::z_axis(), data.rotation),
          )
          .with_scale(@math.Vec3::new(data.scale.x, data.scale.y, 1.0)),
        )
      }
      "Visibility" => {
        let data : VisibilityComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @visibility.visibilities().set(
          entity,
          if data.visible {
            @visibility.Visible
          } else {
            @visibility.Hidden
          },
        )
      }
      "Sprite" => {
        let data : SpriteComponent = match decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        let prepared = prepared_atlas(atlas_doc, context, atlas_layouts)
        let resolved_sprite_image = match prepared {
          Some(value) =>
            match value.image_path {
              Some(path) => Some(path)
              None => (context.asset_path_resolver)(data.image_path)
            }
          None => (context.asset_path_resolver)(data.image_path)
        }
        let image = resolved_sprite_image.map(fn(path) {
          @asset.load_image(path)
        })
        @sprite.sprites().set(
          entity,
          @sprite.Sprite::new(
            image~,
            texture_atlas=prepared.bind(fn(value) { value.texture_atlas }),
            rect=match prepared {
              Some(_) => None
              None => data.rect.map(rect_of)
            },
            color=color_of(data.color),
            custom_size=Some(
              vec2_of(
                sprite_doc_size(
                  data,
                  prepared.bind(fn(value) { value.default_size }),
                ),
              ),
            ),
            anchor=anchor_of(
              prepared.map_or(data.anchor, fn(value) {
                value.default_anchor.unwrap_or(data.anchor)
              }),
            ),
            flip_x=data.flip_x,
            flip_y=data.flip_y,
          ),
        )
      }
      "Text2d" => {
        let data : Text2dComponent = match decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @text2d.text2ds().set(entity, @text2d.Text2d::new())
        @text2d.text_anchors().set(entity, anchor_of(data.anchor))
        match data.bounds {
          Some(bounds) =>
            @text2d.text_bounds().set(
              entity,
              @text2d.TextBounds::new(bounds.x, bounds.y),
            )
          None => ()
        }
        @ui.texts().set(entity, @ui.Text::new(data.content))
        @ui.text_colors().set(entity, @ui.TextColor::new(color_of(data.color)))
        let font = match (context.asset_path_resolver)(data.font_path) {
          Some(path) =>
            @ui.TextFont::from_font(
              @asset.load_font(path, family=basename_of(path)),
              size=data.font_size,
            )
          None => @ui.TextFont::new(size=data.font_size)
        }
        @ui.text_fonts().set(entity, font)
      }
      "Mesh2d" =>
        if mesh_doc is Some(mesh_data) && material_doc is Some(material_data) {
          let handle = match mesh_data.primitive {
            "rectangle" =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::rectangle(
                  mesh_data.size.unwrap_or(vec2_doc(32.0, 32.0)) |> vec2_of,
                ),
              )
            "circle" =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::circle(mesh_data.radius.unwrap_or(16.0)),
              )
            _ =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::rectangle(@math.Vec2(32.0, 32.0)),
              )
          }
          mesh_handles.push(handle)
          let material = @material2d.register_color_material(
            @material2d.ColorMaterial::from_color(color_of(material_data.color)),
          )
          material_handles.push(material)
          @mesh2d.mesh2ds().set(entity, @mesh2d.Mesh2d::new(handle))
          @material2d.mesh_material2ds().set(
            entity,
            @material2d.MeshMaterial2d::from_color_material(material),
          )
        }
      "Camera2d" => {
        let data : Camera2dComponent = match decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @camera.cameras().set(
          entity,
          @camera.Camera::new(
            is_active=data.is_active,
            order=data.order,
            viewport=data.viewport.map(fn(viewport) {
              @camera.CameraViewport::from_rect(rect_of(viewport))
            }),
          ),
        )
        @camera.camera2ds().set(entity, @camera.Camera2d::new())
        @camera.orthographic_projections().set(
          entity,
          @camera.OrthographicProjection::new(scale=data.scale),
        )
      }
      "PhysicsBody2d" => {
        let data : PhysicsBody2dComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        let body = match data.body_type.to_lower() {
          "fixed" =>
            {
              ..@physics2d.RigidBody::fixed(),
              gravity_scale: data.gravity_scale,
              linear_damping: data.linear_damping,
              angular_damping: data.angular_damping,
              ccd_enabled: data.ccd_enabled,
              lock_rotation: data.lock_rotation,
            }
          "kinematic_position_based" =>
            {
              ..@physics2d.RigidBody::kinematic_position_based(),
              gravity_scale: data.gravity_scale,
              linear_damping: data.linear_damping,
              angular_damping: data.angular_damping,
              ccd_enabled: data.ccd_enabled,
              lock_rotation: data.lock_rotation,
            }
          "kinematic_velocity_based" =>
            {
              ..@physics2d.RigidBody::kinematic_velocity_based(),
              gravity_scale: data.gravity_scale,
              linear_damping: data.linear_damping,
              angular_damping: data.angular_damping,
              ccd_enabled: data.ccd_enabled,
              lock_rotation: data.lock_rotation,
            }
          _ =>
            {
              ..@physics2d.RigidBody::dynamic(),
              gravity_scale: data.gravity_scale,
              linear_damping: data.linear_damping,
              angular_damping: data.angular_damping,
              ccd_enabled: data.ccd_enabled,
              lock_rotation: data.lock_rotation,
            }
        }
        @physics2d.rigid_bodies().set(entity, body)
        @physics2d.set_rigid_body_linear_velocity(
          entity,
          vec2_of(data.linear_velocity),
        )
        @physics2d.set_rigid_body_angular_velocity(
          entity,
          data.angular_velocity,
        )
      }
      "PhysicsCollider2d" => {
        let data : PhysicsCollider2dComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        let filter = @physics2d.all_collision_layers(
          @physics2d.CollisionGroup::new(),
        )
        let size = data.size.unwrap_or(vec2_doc(32.0, 32.0))
        let shape = match data.shape.to_lower() {
          "circle" =>
            @physics2d.ColliderShape::Ball(
              radius=data.radius.unwrap_or(size.x / 2.0),
              offset=@math.Vec2::zero(),
            )
          _ =>
            @physics2d.ColliderShape::Rect(
              size=vec2_of(size),
              offset=@math.Vec2::zero(),
            )
        }
        @physics2d.shapes().set(entity, shape)
        if data.sensor {
          @physics2d.sensors().set(entity, @physics2d.Area::new(filter))
        } else {
          @physics2d.colliders().set(
            entity,
            @physics2d.Collider::with_material(
              filter,
              friction=data.friction,
              restitution=data.restitution,
              active=true,
            ),
          )
        }
      }
      "AnimationPlayer" => ()
      "AnimationTransitions" => ()
      "AutoTileLayer2d" => ()
      _ =>
        if context.custom_component_handlers.get(component.kind)
          is Some(handler) {
          (handler.apply)(entity, component, context)
        }
    }
  }
  if animation_doc is Some(player_doc) {
    apply_animation_components(
      entity, document, player_doc, transitions_doc, context, animation_clip_handles,
      animation_graph_handles,
    )
  }
  if autotile_doc is Some(layer_doc) {
    apply_autotile_layer_component(entity, layer_doc, context)
  }
  if !@name.names().contains(entity) {
    @name.names().set(entity, @name.Name::new(document.name))
  }
  if !@transform.transforms().contains(entity) {
    @transform.transforms().set(entity, @transform.Transform::identity())
  }
  if !@visibility.visibilities().contains(entity) {
    @visibility.visibilities().set(entity, @visibility.Visible)
  }
}

///|
fn instantiate_entity_documents(
  documents : Array[EntityDocument],
  context : AssetInstantiationContext,
  parent_entity : @entity.Entity?,
) -> SceneRuntime {
  let entity_ids : Map[String, @entity.Entity] = {}
  let tracked_entities : Array[@entity.Entity] = []
  let atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle] = []
  let material_handles : Array[@material2d.ColorMaterialHandle] = []
  let mesh_handles : Array[@mesh2d.Mesh2dHandle] = []
  let animation_clip_handles : Array[@animation.AnimationClipHandle] = []
  let animation_graph_handles : Array[@animation.AnimationGraphHandle] = []

  for document in documents {
    let entity = @entity.Entity::new()
    entity_ids.set(document.id, entity)
    tracked_entities.push(entity)
  }
  for document in documents {
    match document.parent {
      Some(parent_id) =>
        if entity_ids.contains(parent_id) {
          entity_ids[document.id].set_parent(entity_ids[parent_id])
        }
      None =>
        if parent_entity is Some(parent) {
          entity_ids[document.id].set_parent(parent)
        }
    }
  }
  for document in documents {
    let entity = entity_ids[document.id]
    apply_document_components(
      entity, document, atlas_layouts, material_handles, mesh_handles, animation_clip_handles,
      animation_graph_handles, context,
    )
  }
  {
    entity_ids,
    tracked_entities,
    atlas_layouts,
    material_handles,
    mesh_handles,
    animation_clip_handles,
    animation_graph_handles,
  }
}

///|
pub fn instantiate_scene_document_with_context(
  scene : SceneDocument,
  context : AssetInstantiationContext,
) -> SceneRuntime {
  instantiate_entity_documents(scene.entities, context, None)
}

///|
pub fn instantiate_scene_document(
  scene : SceneDocument,
  asset_path_resolver : AssetPathResolver,
) -> SceneRuntime {
  instantiate_scene_document_with_context(
    scene,
    asset_instantiation_context(asset_path_resolver~),
  )
}

///|
pub fn instantiate_prefab_document(
  prefab : PrefabDocument,
  parent? : @entity.Entity? = None,
  context? : AssetInstantiationContext = asset_instantiation_context(),
) -> SceneRuntime {
  instantiate_entity_documents(prefab.entities, context, parent)
}
