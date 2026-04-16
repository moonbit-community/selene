///|
fn read_accessor_color(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render.Color]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.count <= 0 ||
    (accessor.type_name != "VEC3" && accessor.type_name != "VEC4") {
    return None
  }
  let lane_count = if accessor.type_name == "VEC4" { 4 } else { 3 }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@render.Color] = []
  for _ in 0..<accessor.count {
    output.push({ r: 0U, g: 0U, b: 0U, a: 0.0 })
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * lane_count
    }
    if step < component_size * lane_count {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * lane_count
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let r = read_component_color_factor(bytes, pos, accessor.component_type)
      let g = read_component_color_factor(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let b = read_component_color_factor(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let a = if lane_count == 4 {
        read_component_color_factor(
          bytes,
          pos + component_size * 3,
          accessor.component_type,
        )
      } else {
        Some(1.0)
      }
      guard (r, g, b, a) is (Some(pr), Some(pg), Some(pb), Some(pa)) else {
        return None
      }
      output[idx] = {
        r: factor_to_u8(pr),
        g: factor_to_u8(pg),
        b: factor_to_u8(pb),
        a: clamp01(pa),
      }
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
      step = component_size * lane_count
    }
    if step < component_size * lane_count {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * lane_count
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
      let r = read_component_color_factor(bytes, pos, accessor.component_type)
      let g = read_component_color_factor(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let b = read_component_color_factor(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let a = if lane_count == 4 {
        read_component_color_factor(
          bytes,
          pos + component_size * 3,
          accessor.component_type,
        )
      } else {
        Some(1.0)
      }
      guard (r, g, b, a) is (Some(pr), Some(pg), Some(pb), Some(pa)) else {
        return None
      }
      output[target_index] = {
        r: factor_to_u8(pr),
        g: factor_to_u8(pg),
        b: factor_to_u8(pb),
        a: clamp01(pa),
      }
    }
  }
  Some(output)
}

///|
fn read_accessor_mat4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Mat4]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "MAT4" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  let output : Array[@math.Mat4] = []
  for _ in 0..<accessor.count {
    output.push(@math.Mat4::identity())
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = 64
    }
    if step < 64 {
      return None
    }
    let required_end = base_offset + (accessor.count - 1) * step + 64
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      guard read_mat4_value(bytes, pos) is Some(value) else { return None }
      output[idx] = value
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
      step = 64
    }
    if step < 64 {
      return None
    }
    let required_end = base_offset + (sparse.count - 1) * step + 64
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
      guard read_mat4_value(bytes, pos) is Some(value) else { return None }
      output[target_index] = value
    }
  }
  Some(output)
}

///|
fn read_accessor_joint4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[(Int, Int, Int, Int)]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = match accessor.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => 0
  }
  if component_size == 0 {
    return None
  }
  let output : Array[(Int, Int, Int, Int)] = []
  for _ in 0..<accessor.count {
    output.push((0, 0, 0, 0))
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
      let c0 = read_component_int(bytes, pos, accessor.component_type)
      let c1 = read_component_int(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let c2 = read_component_int(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let c3 = read_component_int(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
      )
      guard (c0, c1, c2, c3) is (Some(j0), Some(j1), Some(j2), Some(j3)) else {
        return None
      }
      output[idx] = (j0, j1, j2, j3)
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
      let c0 = read_component_int(bytes, pos, accessor.component_type)
      let c1 = read_component_int(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let c2 = read_component_int(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let c3 = read_component_int(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
      )
      guard (c0, c1, c2, c3) is (Some(j0), Some(j1), Some(j2), Some(j3)) else {
        return None
      }
      output[target_index] = (j0, j1, j2, j3)
    }
  }
  Some(output)
}
