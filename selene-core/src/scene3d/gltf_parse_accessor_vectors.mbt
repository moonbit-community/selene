///|
fn read_accessor_vec3(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Vec3]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC3" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@math.Vec3] = []
  for _ in 0..<accessor.count {
    output.push(@math.Vec3::zero())
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 3
    }
    if step < component_size * 3 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 3
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z) is (Some(px), Some(py), Some(pz)) else { return None }
      output[idx] = @math.Vec3(px, py, pz)
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
      step = component_size * 3
    }
    if step < component_size * 3 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 3
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z) is (Some(px), Some(py), Some(pz)) else { return None }
      output[target_index] = @math.Vec3(px, py, pz)
    }
  }
  Some(output)
}

///|
fn read_accessor_vec2(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Vec2]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC2" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@math.Vec2] = []
  for _ in 0..<accessor.count {
    output.push(@math.Vec2(0.0, 0.0))
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 2
    }
    if step < component_size * 2 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 2
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y) is (Some(px), Some(py)) else { return None }
      output[idx] = @math.Vec2(px, py)
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
      step = component_size * 2
    }
    if step < component_size * 2 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 2
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y) is (Some(px), Some(py)) else { return None }
      output[target_index] = @math.Vec2(px, py)
    }
  }
  Some(output)
}

///|
fn read_accessor_quat(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Quat]? {
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
  let output : Array[@math.Quat] = []
  for _ in 0..<accessor.count {
    output.push(@math.Quat::identity())
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[idx] = quat_from_components(px, py, pz, pw)
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[target_index] = quat_from_components(px, py, pz, pw)
    }
  }
  Some(output)
}

///|
fn read_accessor_scalar(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Double]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "SCALAR" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[Double] = []
  for _ in 0..<accessor.count {
    output.push(0.0)
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
      guard read_component_double(
          bytes,
          pos,
          accessor.component_type,
          accessor.normalized,
        )
        is Some(value) else {
        return None
      }
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
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      guard read_component_double(
          bytes,
          pos,
          accessor.component_type,
          accessor.normalized,
        )
        is Some(value) else {
        return None
      }
      output[target_index] = value
    }
  }
  Some(output)
}

///|
fn read_accessor_tangent(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render3d.Tangent3D]? {
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
  let output : Array[@render3d.Tangent3D] = []
  for _ in 0..<accessor.count {
    output.push({ x: 1.0, y: 0.0, z: 0.0, w: 1.0 })
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[idx] = { x: px, y: py, z: pz, w: pw }
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
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[target_index] = { x: px, y: py, z: pz, w: pw }
    }
  }
  Some(output)
}
