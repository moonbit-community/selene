///|
pub struct SceneRuntime {
  entity_ids : Map[String, @entity.Entity]
  tracked_entities : Array[@entity.Entity]
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle]
  material_handles : Array[@material2d.ColorMaterialHandle]
  mesh_handles : Array[@mesh2d.Mesh2dHandle]
}

///|
pub fn identity_asset_path_resolver(path : String?) -> String? {
  path
}

///|
fn vec2_of(doc : Vec2Doc) -> @math.Vec2D {
  @math.Vec2D(doc.x, doc.y)
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
    position: @math.Vec2D(doc.x, doc.y),
    size: @math.Vec2D(doc.width, doc.height),
  }
}

///|
fn anchor_of(doc : Vec2Doc) -> @sprite.Anchor {
  @sprite.Anchor(@math.Vec2D(doc.x, doc.y))
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
fn apply_document_components(
  entity : @entity.Entity,
  document : EntityDocument,
  atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle],
  material_handles : Array[@material2d.ColorMaterialHandle],
  mesh_handles : Array[@mesh2d.Mesh2dHandle],
  asset_path_resolver : (String?) -> String?,
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

  for component in document.components {
    match component.kind {
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
        let atlas = atlas_doc.map(fn(atlas_data) {
          let layout = @sprite.register_texture_atlas_layout(
            @sprite.TextureAtlasLayout::from_grid(
              vec2_of(atlas_data.layout.tile_size),
              atlas_data.layout.columns,
              atlas_data.layout.rows,
              padding=Some(vec2_of(atlas_data.layout.padding)),
              offset=Some(vec2_of(atlas_data.layout.offset)),
            ),
          )
          atlas_layouts.push(layout)
          @sprite.TextureAtlas::new(layout, index=atlas_data.index)
        })
        let image = asset_path_resolver(data.image_path).map(fn(path) {
          @asset.load_image(path)
        })
        @sprite.sprites().set(
          entity,
          @sprite.Sprite::new(
            image~,
            texture_atlas=atlas,
            rect=data.rect.map(rect_of),
            color=color_of(data.color),
            custom_size=data.custom_size.map(vec2_of),
            anchor=anchor_of(data.anchor),
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
        let font = match asset_path_resolver(data.font_path) {
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
                @mesh2d.Mesh2dAsset::rectangle(@math.Vec2D(32.0, 32.0)),
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
          @camera.Camera::new(is_active=data.is_active, order=data.order),
        )
        @camera.camera2ds().set(entity, @camera.Camera2d::new())
        @camera.orthographic_projections().set(
          entity,
          @camera.OrthographicProjection::new(scale=data.scale),
        )
      }
      _ => ()
    }
  }
  if !@transform.transforms().contains(entity) {
    @transform.transforms().set(entity, @transform.Transform::identity())
  }
  if !@visibility.visibilities().contains(entity) {
    @visibility.visibilities().set(entity, @visibility.Visible)
  }
}

///|
pub fn instantiate_scene_document(
  scene : SceneDocument,
  asset_path_resolver : (String?) -> String?,
) -> SceneRuntime {
  let entity_ids : Map[String, @entity.Entity] = {}
  let tracked_entities : Array[@entity.Entity] = []
  let atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle] = []
  let material_handles : Array[@material2d.ColorMaterialHandle] = []
  let mesh_handles : Array[@mesh2d.Mesh2dHandle] = []

  for document in scene.entities {
    let entity = @entity.Entity::new()
    entity_ids.set(document.id, entity)
    tracked_entities.push(entity)
  }
  for document in scene.entities {
    match document.parent {
      Some(parent_id) =>
        if entity_ids.contains(parent_id) {
          entity_ids[document.id].set_parent(entity_ids[parent_id])
        }
      None => ()
    }
  }
  for document in scene.entities {
    let entity = entity_ids[document.id]
    apply_document_components(
      entity, document, atlas_layouts, material_handles, mesh_handles, asset_path_resolver,
    )
  }
  {
    entity_ids,
    tracked_entities,
    atlas_layouts,
    material_handles,
    mesh_handles,
  }
}
