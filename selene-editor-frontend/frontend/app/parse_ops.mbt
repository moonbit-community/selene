///|
fn normalized_project_root(root : String) -> String {
  root.trim().to_owned()
}

///|
fn asset_basename(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  let base = if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_owned()
  } else {
    normalized
  }
  if base.rev_find(".") is Some(index) {
    base[:index].to_owned()
  } else {
    base
  }
}

///|
fn resource_stem(path : String) -> String {
  asset_basename(path)
}

///|
fn sorted_strings(values : Array[String]) -> Array[String] {
  let sorted : Array[String] = []
  sorted.push_iter(values.iter())
  sorted.sort_by(fn(left, right) { left.compare(right) })
  sorted
}

///|
fn parse_double_or(current : Double, input : String) -> Double {
  @string.parse_double(input[:]) catch {
    _ => current
  }
}

///|
fn parse_int_or(current : Int, input : String) -> Int {
  @string.parse_int(input[:]) catch {
    _ => current
  }
}

///|
fn parse_positive_double_or(current : Double, input : String) -> Double {
  let parsed = parse_double_or(current, input)
  if parsed <= 0.0 {
    current
  } else {
    parsed
  }
}

///|
fn parse_positive_int_or(current : Int, input : String) -> Int {
  let parsed = parse_int_or(current, input)
  if parsed <= 0 {
    current
  } else {
    parsed
  }
}

///|
fn parse_clip_frames(current : Array[String], input : String) -> Array[String] {
  let frames : Array[String] = []
  for raw in input.split(",") {
    let frame = raw.trim().to_owned()
    if frame != "" {
      frames.push(frame)
    }
  }
  if frames.is_empty() {
    current
  } else {
    frames
  }
}

///|
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}
