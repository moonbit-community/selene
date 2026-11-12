///|
fn sparse_test_bytes(values : Array[Byte]) -> Bytes {
  Bytes::from_array(values)
}

///|
fn sparse_test_buffer_view(
  buffer : Int32,
  byte_length : Int32,
) -> BufferViewTemplate {
  { buffer, byte_offset: 0, byte_length, byte_stride: None, }
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
fn scene3d_test_append_u32_le(out : Array[Byte], value : Int32) -> Unit {
  let bits = value.reinterpret_as_uint()
  out.push(bits.to_byte())
  out.push((bits >> 8).to_byte())
  out.push((bits >> 16).to_byte())
  out.push((bits >> 24).to_byte())
}

///|
fn scene3d_test_glb_bytes(json_text : String) -> Bytes {
  let json_bytes = @utf8.encode(json_text)
  let padded_json_length = (json_bytes.length() + 3) / 4 * 4
  let total_length = 12 + 8 + padded_json_length
  let out : Array[Byte] = []
  out.push((103).to_byte())
  out.push((108).to_byte())
  out.push((84).to_byte())
  out.push((70).to_byte())
  scene3d_test_append_u32_le(out, 2)
  scene3d_test_append_u32_le(out, total_length)
  scene3d_test_append_u32_le(out, padded_json_length)
  scene3d_test_append_u32_le(out, GLB_CHUNK_TYPE_JSON)
  for byte in json_bytes {
    out.push(byte)
  }
  for _ in json_bytes.length()..<padded_json_length {
    out.push((32).to_byte())
  }
  Bytes::from_array(out[:])
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
  let sampler = @render3d.TextureSampler3D()
  let handles = [
    @render3d.register_image_asset({ path: "wbtest://image0", }),
    @render3d.register_image_asset({ path: "wbtest://image1", }),
    @render3d.register_image_asset({ path: "wbtest://image2", }),
    @render3d.register_image_asset({ path: "wbtest://image3", }),
    @render3d.register_image_asset({ path: "wbtest://image4", }),
  ]
  (
    [
      Some({ image: Some(handles[0]), sampler, }),
      Some({ image: Some(handles[1]), sampler, }),
      Some({ image: Some(handles[2]), sampler, }),
      Some({ image: Some(handles[3]), sampler, }),
      Some({ image: Some(handles[4]), sampler, }),
    ],
    handles,
  )
}

///|
test "parse_gltf_source decodes GLB JSON as UTF-8" {
  let json_text = "{\"asset\":{\"version\":\"2.0\"},\"scene\":0,\"scenes\":[{\"nodes\":[0]}],\"nodes\":[{\"name\":\"root\"}]}"
  let glb_bytes = scene3d_test_glb_bytes(json_text)
  let source = parse_gltf_source(glb_bytes)
  guard source is Some(gltf_source) else {
    inspect(false, content="true")
    return
  }
  let template = parse_scene_template("wbtest://scene.glb", gltf_source)
  inspect(template.roots.length(), content="1")
  inspect(template.nodes.length(), content="1")
  debug_inspect(template.nodes[0].name, content="Some(\"root\")")
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
        indices: { buffer_view: 0, byte_offset: 0, component_type: 5121, },
        values: { buffer_view: 1, byte_offset: 0, },
      }),
    }),
  ]
  debug_inspect(
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
        indices: { buffer_view: 1, byte_offset: 0, component_type: 5121, },
        values: { buffer_view: 2, byte_offset: 0, },
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
    material.base_color == { r: 25, g: 51, b: 76, a: 0.5, },
    content="true",
  )
  inspect(
    material.emissive_color == { r: 51, g: 102, b: 153, a: 1.0, },
    content="true",
  )
  inspect(
    material.base_color_texture.unwrap().image == texture_handles[3],
    content="true",
  )
  inspect(material.base_color_texture.unwrap().texcoord_set, content="6")
  inspect(
    material.base_color_texture.unwrap().transform.offset.x,
    content="0.25",
  )
  inspect(
    material.base_color_texture.unwrap().transform.offset.y,
    content="0.5",
  )
  inspect(
    material.base_color_texture.unwrap().transform.scale.x,
    content="0.75",
  )
  inspect(
    material.base_color_texture.unwrap().transform.scale.y,
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
  inspect(material.emissive_texture.unwrap().transform.offset.x, content="0.9")
  inspect(material.emissive_texture.unwrap().transform.scale.x, content="0.7")
  inspect(material.emissive_texture.unwrap().transform.rotation, content="0.4")
  inspect(
    material.normal_texture.unwrap().image == texture_handles[1],
    content="true",
  )
  inspect(material.normal_texture.unwrap().texcoord_set, content="8")
  inspect(material.normal_texture.unwrap().transform.offset.x, content="0.2")
  inspect(material.normal_texture.unwrap().transform.scale.x, content="0.4")
  inspect(material.normal_texture.unwrap().transform.rotation, content="0.6")
  inspect(material.normal_scale, content="0.25")
  inspect(
    material.occlusion_texture.unwrap().image == texture_handles[2],
    content="true",
  )
  inspect(material.occlusion_texture.unwrap().texcoord_set, content="9")
  inspect(
    material.occlusion_texture.unwrap().transform.offset.x,
    content="0.11",
  )
  inspect(material.occlusion_texture.unwrap().transform.scale.x, content="0.33")
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
    material.metallic_roughness_texture.unwrap().transform.offset.x,
    content="0.15",
  )
  inspect(
    material.metallic_roughness_texture.unwrap().transform.scale.x,
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
  let world = @ecs.require_current_world()
  let scene = @render3d.register_scene_path("wbtest://animation-scene")
  let clip = @animation.AnimationClip("idle")
  let clip_handle = @animation.register_animation_clip_asset(clip)
  let template = SceneTemplate()
  template.animations.set("idle", clip_handle)
  scene_templates.set(scene, template)
  scene_paths.set(scene, "wbtest://animation-scene")

  let instance = instantiate_scene_instance(
    scene,
    @transform.Transform::default(),
  )
  try! @ecs.run_schedule(@ecs.require_current_world(), _ => ())
  inspect(instance.animations.contains("idle"), content="true")
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@animation.AnimationPlayer]]).contains(
      instance.root,
    ),
    content="true",
  )
  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@animation.AnimationPlayer]])
    .get(instance.root)
    .map(value => value.0)
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
      offset: Vec2(0.25, 0.5),
      scale: Vec2(2.0, 3.0),
      rotation: 1.5707963267948966,
    },
    Vec2(1.0, 2.0),
  )
  inspect(uv.x, content="-5.75")
  inspect(uv.y, content="2.5000000000000004")
}

///|
test "glTF cubic rotation keys keep raw derivatives" {
  let incoming = @math.Quat(0.0, 0.0, 2.0, 0.0)
  let outgoing = @math.Quat(0.0, 0.0, 3.0, 0.0)
  let zero = @math.Quat(0.0, 0.0, 0.0, 0.0)
  let start = @math.Quat::identity()
  let end = @math.Quat(0.0, 0.0, 1.0, 0.0)
  let bytes : Array[Byte] = []
  for q in [zero, start, outgoing, incoming, end, zero] {
    sparse_test_append_vec3_le(bytes, q.x, q.y, q.z)
    sparse_test_append_f32_le(bytes, q.w)
  }
  let source = sparse_test_bytes(bytes)
  let values = read_accessor_quat(
    0,
    [Some(source)],
    [Some(sparse_test_buffer_view(0, source.length()))],
    [
      Some({
        buffer_view: Some(0),
        byte_offset: 0,
        component_type: 5126,
        count: 6,
        type_name: "VEC4",
        normalized: false,
        sparse: None,
      }),
    ],
  ).unwrap()
  let keys = parse_quat_keyframes([0.0, 1.0], values, CubicSpline)
  assert_eq(keys[0].value, start)
  assert_eq(keys[1].value, end)
  assert_eq(keys[0].in_tangent, Some(zero))
  assert_eq(keys[0].out_tangent, Some(outgoing))
  assert_eq(keys[1].in_tangent, Some(incoming))
  assert_eq(keys[1].out_tangent, Some(zero))
}

///|
test "glTF node matrices preserve zero scale and reject shear" {
  let collapsed = @json.parse("[0,0,0,0, 0,0,0,0, 0,-2,0,0, 4,5,6,1]")
  guard json_array(collapsed) is Some(values) else {
    fail("matrix fixture must be an array")
  }
  let pose = parse_matrix_transform(values).unwrap().compute_affine()
  assert_true(pose.x_axis.length() == 0.0 && pose.y_axis.length() == 0.0)
  assert_true(
    pose.transform_point(Vec3(1.0, 1.0, 1.0)).distance(Vec3(4.0, 3.0, 6.0)) <
    1.0e-12,
  )

  let sheared = @json.parse("[1,0,0,0, 1,1,0,0, 0,0,1,0, 0,0,0,1]")
  guard json_array(sheared) is Some(values) else {
    fail("matrix fixture must be an array")
  }
  assert_true(parse_matrix_transform(values) is None)
}

///|
test "glTF accepts Float32 rounded rotations while rejecting actual shear" {
  let rotation = @math.Rotation3::from_axis_angle(Vec3(1.0, 2.0, 3.0), 0.7)
  let affine = @math.Affine3::from_scale_rotation_translation(
    Vec3(2.0, 3.0, -4.0),
    rotation,
    Vec3(5.0, 6.0, 7.0),
  )
  let values = @math.Mat4::from_affine(affine)
    .to_column_major()
    .map(value => Float::from_double(value).to_double())
  let matrix = @json.parse(
    "[" + values.map(value => value.to_string()).join(",") + "]",
  )
  guard json_array(matrix) is Some(values) else {
    fail("matrix fixture must be an array")
  }
  let actual = parse_matrix_transform(values).unwrap().compute_affine()
  assert_true(actual.x_axis.distance(affine.x_axis) < 1.0e-6)
  assert_true(actual.y_axis.distance(affine.y_axis) < 1.0e-6)
  assert_true(actual.z_axis.distance(affine.z_axis) < 1.0e-6)
  let sheared = @json.parse("[1,0,0,0, 0.001,1,0,0, 0,0,1,0, 0,0,0,1]")
  guard json_array(sheared) is Some(values) else {
    fail("matrix fixture must be an array")
  }
  assert_true(parse_matrix_transform(values) is None)
}

///|
test "canceled scene subtrees release their cloned meshes" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for renderer_count in [1, 2] {
    let world = @ecs.World()
    @ecs.set_current_world(world)
    let mesh = @render3d.register_mesh_asset(
      @render3d.triangle_mesh([@math.Vec3::zero()]),
    )
    let material = @render3d.register_material_asset(StandardMaterial3D())
    let scene = @render3d.register_scene_path("wbtest://canceled-scene")
    let skinned : SkinnedPrimitiveTemplate = {
      base_positions: [@math.Vec3::zero()],
      indices: None,
      topology: TriangleList,
      base_normals: [],
      uv_sets: [],
      colors: None,
      tangents: None,
      morph_targets: [],
      morph_weights: [],
      influences: [],
    }
    scene_templates.set(scene, {
      ..SceneTemplate(),
      roots: [0],
      nodes: [
        {
          ..SceneNodeTemplate(),
          renderers: Array::make(renderer_count, {
            renderer: {
              mesh,
              material,
              visible: true,
              cast_shadows: true,
              receive_shadows: true,
            },
            skinned: Some(skinned),
          }),
        },
      ],
    })
    ignore(@render3d.take_dirty_mesh_assets())
    ignore(@render3d.take_released_mesh_assets())
    let parent = @ecs.commands(world).spawn(())
    @ecs.commands(world).delete(parent)
    let instance = instantiate_scene_instance(
      scene,
      @transform.Transform::identity(),
      parent~,
    )
    let cloned = @render3d.take_dirty_mesh_assets().map(pair => pair.0)
    assert_eq(cloned.length(), renderer_count)
    @ecs.run_schedule(world, _ => ())
    assert_false(instance.root.is_valid_in(world))
    let released = @render3d.take_released_mesh_assets()
    for handle in cloned {
      assert_true(released.contains(handle))
      assert_true(@render3d.mesh_asset(handle) is None)
    }
    assert_true(@render3d.mesh_asset(mesh) is Some(_))
    @render3d.release_mesh_asset(mesh)
    @render3d.release_material_asset(material)
    scene_templates.remove(scene)
  }
}
