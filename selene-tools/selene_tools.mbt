///|
priv struct AssetEntry {
  virtual_path : String
  offset : Int
  size : Int
}

///|
priv struct CliConfig {
  assets_dir : String
  pack_out : String?
  index_out : String?
  path_prefix : String
  blob_name : String
  lookup_fn : String
}

///|
fn usage_text() -> String {
  (
    #| Usage:
    #|   selene-embed-assets --assets-dir <dir> [--pack-out <file>] [--index-out <file>]
    #|                       [--path-prefix <prefix>] [--blob-name <name>] [--lookup-fn <name>]
    #|
    #| Options:
    #|   --assets-dir   Source asset directory to scan recursively (required)
    #|   --pack-out     Output pack file path (optional)
    #|   --index-out    Output MoonBit index file path (optional)
    #|   --path-prefix  Runtime asset prefix, default: assets
    #|   --blob-name    Embedded blob symbol name, default: embedded_assets_blob
    #|   --lookup-fn    Generated lookup function name, default: get_embedded_asset
    #|   -h, --help     Show this help
  )
}

///|
fn join_path(base : String, child : String) -> String {
  if base.is_empty() {
    child
  } else if base.has_suffix("/") || base.has_suffix("\\") {
    base + child
  } else {
    base + "/" + child
  }
}

///|
fn normalize_slashes(path : String) -> String {
  path.replace_all(old="\\", new="/")
}

///|
fn normalize_prefix(prefix : String) -> String {
  let mut normalized = normalize_slashes(prefix).trim().to_string()
  while normalized.length() > 0 && normalized.has_prefix("/") {
    normalized = normalized.unsafe_substring(start=1, end=normalized.length())
  }
  while normalized.length() > 0 && normalized.has_suffix("/") {
    normalized = normalized.unsafe_substring(
      start=0,
      end=normalized.length() - 1,
    )
  }
  normalized
}

///|
fn with_prefix(prefix : String, rel_path : String) -> String {
  if prefix.is_empty() {
    rel_path
  } else {
    prefix + "/" + rel_path
  }
}

///|
fn escape_moon_string(text : String) -> String {
  text.replace_all(old="\\", new="\\\\").replace_all(old="\"", new="\\\"")
}

///|
fn read_dir_safe(path : String) -> Result[Array[String], String] {
  try @fs.read_dir(path) catch {
    err => Err("Failed to read directory `\{path}`: \{err.to_string()}")
  } noraise {
    entries => Ok(entries)
  }
}

///|
fn is_dir_safe(path : String) -> Result[Bool, String] {
  try @fs.is_dir(path) catch {
    err => Err("Failed to inspect path `\{path}`: \{err.to_string()}")
  } noraise {
    v => Ok(v)
  }
}

///|
fn is_file_safe(path : String) -> Result[Bool, String] {
  try @fs.is_file(path) catch {
    err => Err("Failed to inspect path `\{path}`: \{err.to_string()}")
  } noraise {
    v => Ok(v)
  }
}

///|
fn read_file_to_bytes_safe(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    err => Err("Failed to read file `\{path}`: \{err.to_string()}")
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn write_bytes_safe(path : String, bytes : Bytes) -> Result[Unit, String] {
  try @fs.write_bytes_to_file(path, bytes) catch {
    err => Err("Failed to write pack file `\{path}`: \{err.to_string()}")
  } noraise {
    _ => Ok(())
  }
}

///|
fn write_string_safe(path : String, content : String) -> Result[Unit, String] {
  try @fs.write_string_to_file(path, content) catch {
    err => Err("Failed to write index file `\{path}`: \{err.to_string()}")
  } noraise {
    _ => Ok(())
  }
}

///|
fn walk_assets(
  root : String,
  rel_dir : String,
  out : Array[String],
) -> Result[Unit, String] {
  let full_dir = if rel_dir.is_empty() {
    root
  } else {
    join_path(root, rel_dir)
  }
  let entries = match read_dir_safe(full_dir) {
    Ok(entries) => entries
    Err(msg) => return Err(msg)
  }
  entries.sort()

  for name in entries {
    let rel_path = if rel_dir.is_empty() { name } else { rel_dir + "/" + name }
    let full_path = join_path(root, rel_path)
    let is_dir = match is_dir_safe(full_path) {
      Ok(v) => v
      Err(msg) => return Err(msg)
    }
    if is_dir {
      match walk_assets(root, rel_path, out) {
        Ok(_) => ()
        Err(msg) => return Err(msg)
      }
    } else {
      let is_file = match is_file_safe(full_path) {
        Ok(v) => v
        Err(msg) => return Err(msg)
      }
      if is_file {
        out.push(normalize_slashes(rel_path))
      }
    }
  }
  Ok(())
}

///|
fn collect_relative_files(assets_dir : String) -> Result[Array[String], String] {
  if !@fs.path_exists(assets_dir) {
    return Err("Assets directory not found: \{assets_dir}")
  }
  let is_dir = match is_dir_safe(assets_dir) {
    Ok(v) => v
    Err(msg) => return Err(msg)
  }
  if !is_dir {
    return Err("Assets path is not a directory: \{assets_dir}")
  }

  let files : Array[String] = []
  match walk_assets(assets_dir, "", files) {
    Ok(_) => {
      files.sort()
      Ok(files)
    }
    Err(msg) => Err(msg)
  }
}

///|
fn build_entries(
  cfg : CliConfig,
  relative_files : Array[String],
) -> Result[(Array[AssetEntry], Bytes), String] {
  let should_pack = cfg.pack_out is Some(_)
  let entries : Array[AssetEntry] = []
  let packed : Array[Byte] = []
  let mut offset = 0

  for rel_path in relative_files {
    let full_path = join_path(cfg.assets_dir, rel_path)
    let bytes = match read_file_to_bytes_safe(full_path) {
      Ok(bytes) => bytes
      Err(msg) => return Err(msg)
    }
    let size = bytes.length()
    entries.push({
      virtual_path: with_prefix(cfg.path_prefix, rel_path),
      offset,
      size,
    })
    if should_pack {
      packed.push_iter(bytes.iter())
    }
    offset += size
  }

  let packed_bytes = if should_pack {
    Bytes::from_array(packed)
  } else {
    Bytes::default()
  }
  Ok((entries, packed_bytes))
}

///|
fn build_index_source(cfg : CliConfig, entries : Array[AssetEntry]) -> String {
  let lines : Array[String] = []
  lines.push("// Generated by selene-embed-assets, DO NOT EDIT.")
  lines.push("")
  lines.push("///|")
  lines.push("fn slice_embedded_asset(start : Int, size : Int) -> Bytes {")
  lines.push(
    "  \{cfg.blob_name}.view(start=start, end=start + size).to_bytes()",
  )
  lines.push("}")
  lines.push("")
  lines.push("///|")
  lines.push("pub fn \{cfg.lookup_fn}(path : String) -> Bytes? {")
  lines.push("  match path {")
  for entry in entries {
    lines.push(
      "    \"\{escape_moon_string(entry.virtual_path)}\" => Some(slice_embedded_asset(\{entry.offset.to_string()}, \{entry.size.to_string()}))",
    )
  }
  lines.push("    _ => None")
  lines.push("  }")
  lines.push("}")
  lines.push("")
  lines.join("\n")
}

///|
fn parse_args(raw_args : Array[String]) -> Result[CliConfig?, String] {
  let mut assets_dir : String? = None
  let mut pack_out : String? = None
  let mut index_out : String? = None
  let mut path_prefix = "assets"
  let mut blob_name = "embedded_assets_blob"
  let mut lookup_fn = "get_embedded_asset"

  let mut i = 1
  while i < raw_args.length() {
    let arg = raw_args[i]
    if arg == "-h" || arg == "--help" {
      return Ok(None)
    }
    if i + 1 >= raw_args.length() {
      return Err("Missing value after \{arg}")
    }
    let value = raw_args[i + 1]
    match arg {
      "--assets-dir" => assets_dir = Some(value)
      "--pack-out" => pack_out = Some(value)
      "--index-out" => index_out = Some(value)
      "--path-prefix" => path_prefix = value
      "--blob-name" => blob_name = value
      "--lookup-fn" => lookup_fn = value
      _ => return Err("Unknown argument: \{arg}")
    }
    i += 2
  }

  let assets_dir = match assets_dir {
    Some(v) => v
    None => return Err("Missing required argument: --assets-dir")
  }
  if pack_out is None && index_out is None {
    return Err("At least one of --pack-out or --index-out must be provided")
  }
  Ok(
    Some({
      assets_dir,
      pack_out,
      index_out,
      path_prefix: normalize_prefix(path_prefix),
      blob_name,
      lookup_fn,
    }),
  )
}

///|
pub fn run_cli(raw_args : Array[String]) -> Int {
  let cfg = match parse_args(raw_args) {
    Ok(None) => {
      println(usage_text())
      return 0
    }
    Ok(Some(cfg)) => cfg
    Err(msg) => {
      println("Error: \{msg}")
      println("")
      println(usage_text())
      return 2
    }
  }

  let relative_files = match collect_relative_files(cfg.assets_dir) {
    Ok(files) => files
    Err(msg) => {
      println("Error: \{msg}")
      return 1
    }
  }

  let (entries, packed_bytes) = match build_entries(cfg, relative_files) {
    Ok(v) => v
    Err(msg) => {
      println("Error: \{msg}")
      return 1
    }
  }

  if cfg.pack_out is Some(pack_out) {
    match write_bytes_safe(pack_out, packed_bytes) {
      Ok(_) => ()
      Err(msg) => {
        println("Error: \{msg}")
        return 1
      }
    }
  }

  if cfg.index_out is Some(index_out) {
    let index_src = build_index_source(cfg, entries)
    match write_string_safe(index_out, index_src) {
      Ok(_) => ()
      Err(msg) => {
        println("Error: \{msg}")
        return 1
      }
    }
  }

  let outputs : Array[String] = []
  if cfg.pack_out is Some(pack_out) {
    outputs.push(pack_out)
  }
  if cfg.index_out is Some(index_out) {
    outputs.push(index_out)
  }
  let outputs_text = outputs.join(", ")
  println(
    "Bundled \{entries.length().to_string()} assets from \{cfg.assets_dir} -> \{outputs_text}",
  )
  0
}
