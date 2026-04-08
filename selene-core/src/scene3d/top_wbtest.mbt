///|
fn sparse_test_bytes(values : Array[Byte]) -> Bytes {
  Bytes::from_array(values)
}

///|
fn sparse_test_buffer_view(
  buffer : Int,
  byte_length : Int,
) -> BufferViewTemplate {
  { buffer, byte_offset: 0, byte_length, byte_stride: None }
}

///|
fn sparse_test_append_f32_le(out : Array[Byte], value : Double) -> Unit {
  let bits = Float::from_double(value)
    .reinterpret_as_int()
    .reinterpret_as_uint()
  out.push(bits.to_byte())
  out.push((bits >> 8).to_byte())
  out.push((bits >> 16).to_byte())
  out.push((bits >> 24).to_byte())
}

///|
fn sparse_test_append_vec3_le(
  out : Array[Byte],
  x : Double,
  y : Double,
  z : Double,
) -> Unit {
  sparse_test_append_f32_le(out, x)
  sparse_test_append_f32_le(out, y)
  sparse_test_append_f32_le(out, z)
}

///|
fn scene3d_test_object(input : String) -> Map[String, Json] raise {
  json_object(@json.parse(input)).unwrap()
}

///|
fn scene3d_test_texture_sources() -> (
  Array[TextureSourceTemplate?],
  Array[@render3d.ImageHandle],
) {
  let sampler = @render3d.default_texture_sampler3d()
  let handles = [
    @render3d.register_image_asset({ path: "wbtest://image0" }),
    @render3d.register_image_asset({ path: "wbtest://image1" }),
    @render3d.register_image_asset({ path: "wbtest://image2" }),
    @render3d.register_image_asset({ path: "wbtest://image3" }),
    @render3d.register_image_asset({ path: "wbtest://image4" }),
  ]
  (
    [
      Some({ image: Some(handles[0]), sampler }),
      Some({ image: Some(handles[1]), sampler }),
      Some({ image: Some(handles[2]), sampler }),
      Some({ image: Some(handles[3]), sampler }),
      Some({ image: Some(handles[4]), sampler }),
    ],
    handles,
  )
}

///|
test "read_accessor_scalar supports sparse-only accessors" {
  let index_bytes = sparse_test_bytes([(1).to_byte(), (3).to_byte()])
  let value_bytes = sparse_test_bytes([(7).to_byte(), (9).to_byte()])
  let buffers : Array[Bytes?] = [Some(index_bytes), Some(value_bytes)]
  let buffer_views : Array[BufferViewTemplate?] = [
    Some(sparse_test_buffer_view(0, index_bytes.length())),
    Some(sparse_test_buffer_view(1, value_bytes.length())),
  ]
  let accessors : Array[AccessorTemplate?] = [
    Some({
      buffer_view: None,
      byte_offset: 0,
      component_type: 5121,
      count: 4,
      type_name: "SCALAR",
      normalized: false,
      sparse: Some({
        count: 2,
        indices: { buffer_view: 0, byte_offset: 0, component_type: 5121 },
        values: { buffer_view: 1, byte_offset: 0 },
      }),
    }),
  ]
  inspect(
    read_accessor_scalar(0, buffers, buffer_views, accessors),
    content="Some([0, 7, 0, 9])",
  )
}

///|
test "read_accessor_vec3 applies sparse overrides over base data" {
  let base_bytes : Array[Byte] = []
  sparse_test_append_vec3_le(base_bytes, 1.0, 1.0, 1.0)
  sparse_test_append_vec3_le(base_bytes, 2.0, 2.0, 2.0)
  let sparse_index_bytes = sparse_test_bytes([(1).to_byte()])
  let sparse_value_bytes : Array[Byte] = []
  sparse_test_append_vec3_le(sparse_value_bytes, 9.0, 8.0, 7.0)
  let base_bytes_value = sparse_test_bytes(base_bytes)
  let sparse_value_bytes_value = sparse_test_bytes(sparse_value_bytes)
  let buffers : Array[Bytes?] = [
    Some(base_bytes_value),
    Some(sparse_index_bytes),
    Some(sparse_value_bytes_value),
  ]
  let buffer_views : Array[BufferViewTemplate?] = [
    Some(sparse_test_buffer_view(0, base_bytes_value.length())),
    Some(sparse_test_buffer_view(1, sparse_index_bytes.length())),
    Some(sparse_test_buffer_view(2, sparse_value_bytes_value.length())),
  ]
  let accessors : Array[AccessorTemplate?] = [
    Some({
      buffer_view: Some(0),
      byte_offset: 0,
      component_type: 5126,
      count: 2,
      type_name: "VEC3",
      normalized: false,
      sparse: Some({
        count: 1,
        indices: { buffer_view: 1, byte_offset: 0, component_type: 5121 },
        values: { buffer_view: 2, byte_offset: 0 },
      }),
    }),
  ]
  let points = read_accessor_vec3(0, buffers, buffer_views, accessors).unwrap()
  inspect(points.length(), content="2")
  inspect(
    points[0].x == 1.0 && points[0].y == 1.0 && points[0].z == 1.0,
    content="true",
  )
  inspect(
    points[1].x == 9.0 && points[1].y == 8.0 && points[1].z == 7.0,
    content="true",
  )
}

///|
test "parse_texture_samplers preserves glTF wrap and filter semantics" {
  let sampler_json =
    #|{
    #|  "samplers": [
    #|    {
    #|      "wrapS": 33071,
    #|      "wrapT": 33648,
    #|      "minFilter": 9984,
    #|      "magFilter": 9728
    #|    }
    #|  ]
    #|}
  let samplers = parse_texture_samplers(scene3d_test_object(sampler_json))
  inspect(samplers.length(), content="1")
  inspect(
    match samplers[0].wrap_u {
      ClampToEdge => true
      Repeat | MirroredRepeat => false
    },
    content="true",
  )
  inspect(
    match samplers[0].wrap_v {
      MirroredRepeat => true
      Repeat | ClampToEdge => false
    },
    content="true",
  )
  inspect(
    match samplers[0].min_filter {
      Nearest => true
      Linear => false
    },
    content="true",
  )
  inspect(
    match samplers[0].mag_filter {
      Nearest => true
      Linear => false
    },
    content="true",
  )
  inspect(
    match samplers[0].mipmap_filter {
      Some(Nearest) => true
      Some(Linear) | None => false
    },
    content="true",
  )
}

///|
test "parse_material_asset preserves glTF material factors, bindings, and texture transforms" {
  let (texture_sources, texture_handles) = scene3d_test_texture_sources()
  let material_json =
    #|{
    #|  "alphaMode": "MASK",
    #|  "alphaCutoff": 0.33,
    #|  "doubleSided": true,
    #|  "extensions": {
    #|    "KHR_materials_unlit": {}
    #|  },
    #|  "emissiveFactor": [0.2, 0.4, 0.6],
    #|  "emissiveTexture": {
    #|    "index": 0,
    #|    "texCoord": 1,
    #|    "extensions": {
    #|      "KHR_texture_transform": {
    #|        "offset": [0.9, 0.8],
    #|        "scale": [0.7, 0.6],
    #|        "rotation": 0.4,
    #|        "texCoord": 7
    #|      }
    #|    }
    #|  },
    #|  "normalTexture": {
    #|    "index": 1,
    #|    "texCoord": 2,
    #|    "scale": 0.25,
    #|    "extensions": {
    #|      "KHR_texture_transform": {
    #|        "offset": [0.2, 0.3],
    #|        "scale": [0.4, 0.5],
    #|        "rotation": 0.6,
    #|        "texCoord": 8
    #|      }
    #|    }
    #|  },
    #|  "occlusionTexture": {
    #|    "index": 2,
    #|    "texCoord": 3,
    #|    "strength": 0.75,
    #|    "extensions": {
    #|      "KHR_texture_transform": {
    #|        "offset": [0.11, 0.22],
    #|        "scale": [0.33, 0.44],
    #|        "rotation": 0.55,
    #|        "texCoord": 9
    #|      }
    #|    }
    #|  },
    #|  "pbrMetallicRoughness": {
    #|    "baseColorFactor": [0.1, 0.2, 0.3, 0.5],
    #|    "metallicFactor": 0.9,
    #|    "roughnessFactor": 0.4,
    #|    "baseColorTexture": {
    #|      "index": 3,
    #|      "texCoord": 4,
    #|      "extensions": {
    #|        "KHR_texture_transform": {
    #|          "offset": [0.25, 0.5],
    #|          "scale": [0.75, 0.125],
    #|          "rotation": 0.7853981633974483,
    #|          "texCoord": 6
    #|        }
    #|      }
    #|    },
    #|    "metallicRoughnessTexture": {
    #|      "index": 4,
    #|      "texCoord": 5,
    #|      "extensions": {
    #|        "KHR_texture_transform": {
    #|          "offset": [0.15, 0.35],
    #|          "scale": [0.45, 0.65],
    #|          "rotation": 0.85,
    #|          "texCoord": 10
    #|        }
    #|      }
    #|    }
    #|  }
    #|}
  let material = parse_material_asset(
    @json.parse(material_json),
    texture_sources,
  )
  inspect(
    match material.alpha_mode {
      Mask => true
      Opaque | Blend => false
    },
    content="true",
  )
  inspect(material.alpha_cutoff, content="0.33")
  inspect(material.double_sided, content="true")
  inspect(material.unlit, content="true")
  inspect(
    material.base_color == { r: 25, g: 51, b: 76, a: 0.5 },
    content="true",
  )
  inspect(
    material.emissive_color == { r: 51, g: 102, b: 153, a: 1.0 },
    content="true",
  )
  inspect(
    material.base_color_texture.unwrap().image == texture_handles[3],
    content="true",
  )
  inspect(material.base_color_texture.unwrap().texcoord_set, content="6")
  inspect(
    material.base_color_texture.unwrap().transform.offset[X],
    content="0.25",
  )
  inspect(
    material.base_color_texture.unwrap().transform.offset[Y],
    content="0.5",
  )
  inspect(
    material.base_color_texture.unwrap().transform.scale[X],
    content="0.75",
  )
  inspect(
    material.base_color_texture.unwrap().transform.scale[Y],
    content="0.125",
  )
  inspect(
    material.base_color_texture.unwrap().transform.rotation,
    content="0.7853981633974483",
  )
  inspect(
    material.emissive_texture.unwrap().image == texture_handles[0],
    content="true",
  )
  inspect(material.emissive_texture.unwrap().texcoord_set, content="7")
  inspect(material.emissive_texture.unwrap().transform.offset[X], content="0.9")
  inspect(material.emissive_texture.unwrap().transform.scale[X], content="0.7")
  inspect(material.emissive_texture.unwrap().transform.rotation, content="0.4")
  inspect(
    material.normal_texture.unwrap().image == texture_handles[1],
    content="true",
  )
  inspect(material.normal_texture.unwrap().texcoord_set, content="8")
  inspect(material.normal_texture.unwrap().transform.offset[X], content="0.2")
  inspect(material.normal_texture.unwrap().transform.scale[X], content="0.4")
  inspect(material.normal_texture.unwrap().transform.rotation, content="0.6")
  inspect(material.normal_scale, content="0.25")
  inspect(
    material.occlusion_texture.unwrap().image == texture_handles[2],
    content="true",
  )
  inspect(material.occlusion_texture.unwrap().texcoord_set, content="9")
  inspect(
    material.occlusion_texture.unwrap().transform.offset[X],
    content="0.11",
  )
  inspect(
    material.occlusion_texture.unwrap().transform.scale[X],
    content="0.33",
  )
  inspect(
    material.occlusion_texture.unwrap().transform.rotation,
    content="0.55",
  )
  inspect(material.occlusion_strength, content="0.75")
  inspect(
    material.metallic_roughness_texture.unwrap().image == texture_handles[4],
    content="true",
  )
  inspect(
    material.metallic_roughness_texture.unwrap().texcoord_set,
    content="10",
  )
  inspect(
    material.metallic_roughness_texture.unwrap().transform.offset[X],
    content="0.15",
  )
  inspect(
    material.metallic_roughness_texture.unwrap().transform.scale[X],
    content="0.45",
  )
  inspect(
    material.metallic_roughness_texture.unwrap().transform.rotation,
    content="0.85",
  )
  inspect(material.metallic, content="0.9")
  inspect(material.roughness, content="0.4")
}

///|
test "instantiate_scene_instance installs animation components without autoplay" {
  let scene = @render3d.register_scene_path("wbtest://animation-scene")
  let clip = @animation.AnimationClip::new("idle")
  let clip_handle = @animation.register_animation_clip_asset(clip)
  let template = empty_scene_template()
  template.animations.set("idle", clip_handle)
  scene_templates.set(scene, template)
  scene_paths.set(scene, "wbtest://animation-scene")

  let instance = instantiate_scene_instance(
    scene,
    @transform.Transform::default(),
  )
  inspect(instance.animations.contains("idle"), content="true")
  inspect(
    @animation.animation_players().contains(instance.root),
    content="true",
  )
  inspect(
    @animation.animation_players()
    .get(instance.root)
    .unwrap()
    .playing_animations()
    .length(),
    content="0",
  )
}

///|
test "apply_texture_transform3d matches glTF offset-rotate-scale order" {
  let uv = @render3d.apply_texture_transform3d(
    {
      offset: @math.Vec2D(0.25, 0.5),
      scale: @math.Vec2D(2.0, 3.0),
      rotation: 1.5707963267948966,
    },
    @math.Vec2D(1.0, 2.0),
  )
  inspect(uv[X], content="-5.75")
  inspect(uv[Y], content="2.5000000000000004")
}
