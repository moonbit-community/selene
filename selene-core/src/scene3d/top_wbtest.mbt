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
  inspect(
    read_accessor_vec3(0, buffers, buffer_views, accessors),
    content=(
      #|Some([{x: 1, y: 1, z: 1}, {x: 9, y: 8, z: 7}])
    ),
  )
}
