///|
fn read_accessor_weight4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[(Double, Double, Double, Double)]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[(Double, Double, Double, Double)] = []
  for _ in 0..<accessor.count {
    output.push((0.0, 0.0, 0.0, 0.0))
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 4
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let c0 = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let c1 = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let c2 = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let c3 = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (c0, c1, c2, c3) is (Some(w0), Some(w1), Some(w2), Some(w3)) else {
        return None
      }
      output[idx] = (w0, w1, w2, w3)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 4
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let c0 = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let c1 = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let c2 = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let c3 = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (c0, c1, c2, c3) is (Some(w0), Some(w1), Some(w2), Some(w3)) else {
        return None
      }
      output[target_index] = (w0, w1, w2, w3)
    }
  }
  Some(output)
}

///|
fn read_accessor_indices(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Int]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "SCALAR" || accessor.count <= 0 {
    return None
  }
  let component_size = match accessor.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => return None
  }
  let indices : Array[Int] = []
  for _ in 0..<accessor.count {
    indices.push(0)
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let value = match accessor.component_type {
        5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
        5123 => read_u16_le(bytes, pos)
        5125 => read_u32_le(bytes, pos)
        _ => None
      }
      guard value is Some(index_value) else { return None }
      indices[idx] = index_value
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views)
      is Some(override_indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset + (sparse.count - 1) * step + component_size
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = override_indices[idx]
      if target_index < 0 || target_index >= indices.length() {
        return None
      }
      let pos = base_offset + idx * step
      let value = match accessor.component_type {
        5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
        5123 => read_u16_le(bytes, pos)
        5125 => read_u32_le(bytes, pos)
        _ => None
      }
      guard value is Some(index_value) else { return None }
      indices[target_index] = index_value
    }
  }
  Some(indices)
}

///|
fn resolve_accessor_bytes(
  accessor : AccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  match accessor.buffer_view {
    Some(buffer_view_index) =>
      resolve_buffer_region(
        buffer_view_index,
        accessor.byte_offset,
        buffers,
        buffer_views,
      )
    None => None
  }
}

///|
fn resolve_sparse_values_bytes(
  sparse : SparseAccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  resolve_buffer_region(
    sparse.values.buffer_view,
    sparse.values.byte_offset,
    buffers,
    buffer_views,
  )
}

///|
fn resolve_buffer_region(
  buffer_view_index : Int,
  extra_offset : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  guard buffer_view_index >= 0 else { return None }
  guard buffer_views.get(buffer_view_index) is Some(Some(view)) else {
    return None
  }
  if view.buffer < 0 || view.byte_offset < 0 || extra_offset < 0 {
    return None
  }
  guard buffers.get(view.buffer) is Some(Some(bytes)) else { return None }
  let total_offset = view.byte_offset + extra_offset
  let view_end = view.byte_offset + view.byte_length
  if total_offset < view.byte_offset || total_offset > view_end {
    return None
  }
  if total_offset < 0 || total_offset > bytes.length() {
    return None
  }
  let stride = view.byte_stride.unwrap_or(0)
  Some((bytes, total_offset, stride, view_end))
}

///|
fn read_sparse_indices(
  sparse : SparseAccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> Array[Int]? {
  let component_size = match sparse.indices.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => return None
  }
  guard resolve_buffer_region(
      sparse.indices.buffer_view,
      sparse.indices.byte_offset,
      buffers,
      buffer_views,
    )
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = component_size
  }
  if step < component_size {
    return None
  }
  let required_end = base_offset + (sparse.count - 1) * step + component_size
  if sparse.count > 0 &&
    (required_end > view_end || required_end > bytes.length()) {
    return None
  }
  let output : Array[Int] = []
  for idx in 0..<sparse.count {
    let pos = base_offset + idx * step
    let value = match sparse.indices.component_type {
      5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
      5123 => read_u16_le(bytes, pos)
      5125 => read_u32_le(bytes, pos)
      _ => None
    }
    guard value is Some(index_value) else { return None }
    output.push(index_value)
  }
  Some(output)
}

///|
fn accessor_component_size(component_type : Int) -> Int {
  match component_type {
    5120 => 1
    5121 => 1
    5122 => 2
    5123 => 2
    5125 => 4
    5126 => 4
    _ => 0
  }
}

///|
fn read_f32_le(bytes : Bytes, offset : Int) -> Double? {
  if offset < 0 || offset + 3 >= bytes.length() {
    return None
  }
  Some(
    Float::reinterpret_from_uint(bytes.unsafe_read_uint32_le(offset)).to_double(),
  )
}

///|
fn quat_from_components(
  x : Double,
  y : Double,
  z : Double,
  w : Double,
) -> @math.Quat {
  let length_squared = x * x + y * y + z * z + w * w
  if length_squared <= 0.0000000001 {
    @math.Quat::identity()
  } else {
    @math.Quat::new(x, y, z, w).normalize()
  }
}

///|
fn read_mat4_value(bytes : Bytes, offset : Int) -> @math.Mat4? {
  let values : Array[Double] = []
  for index in 0..<16 {
    guard read_f32_le(bytes, offset + index * 4) is Some(value) else {
      return None
    }
    values.push(value)
  }
  Some({
    m00: values[0],
    m01: values[4],
    m02: values[8],
    m03: values[12],
    m10: values[1],
    m11: values[5],
    m12: values[9],
    m13: values[13],
    m20: values[2],
    m21: values[6],
    m22: values[10],
    m23: values[14],
    m30: values[3],
    m31: values[7],
    m32: values[11],
    m33: values[15],
  })
}

///|
fn read_u16_le(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 1 >= bytes.length() {
    return None
  }
  Some(bytes.unsafe_read_uint16_le(offset).to_int())
}

///|
fn read_i8(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset >= bytes.length() {
    return None
  }
  let value = bytes.unsafe_get(offset).to_int()
  if value >= 128 {
    Some(value - 256)
  } else {
    Some(value)
  }
}

///|
fn read_i16_le(bytes : Bytes, offset : Int) -> Int? {
  match read_u16_le(bytes, offset) {
    Some(value) =>
      if value >= 32768 {
        Some(value - 65536)
      } else {
        Some(value)
      }
    None => None
  }
}

///|
fn read_u32_le(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 3 >= bytes.length() {
    return None
  }
  let value = bytes.unsafe_read_uint32_le(offset).reinterpret_as_int()
  if value < 0 {
    None
  } else {
    Some(value)
  }
}
