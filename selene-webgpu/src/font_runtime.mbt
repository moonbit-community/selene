///|
priv struct WebFontRuntime {
  mut generation : UInt
  mut metrics_revision : UInt
  mut dom_ready_generation : UInt?
  mut bytes_ready_generation : UInt?
}

///|
let web_font_runtimes : Map[String, WebFontRuntime] = Map([])

///|
fn web_font_runtime(family : String) -> WebFontRuntime {
  web_font_runtimes.get_or_init(family, () => {
    generation: 0U,
    metrics_revision: 0U,
    dom_ready_generation: None,
    bytes_ready_generation: None,
  })
}

///|
fn begin_web_font_load(family : String) -> UInt {
  let runtime = web_font_runtime(family)
  runtime.generation += 1U
  runtime.dom_ready_generation = None
  runtime.bytes_ready_generation = None
  runtime.generation
}

///|
fn web_font_load_is_current(family : String, generation : UInt) -> Bool {
  web_font_runtime(family).generation == generation
}

///|
/// Invalidates both the MoonBit layout cache and GPU textures because a
/// family may switch from browser fallback metrics to Cosmic metrics.
fn invalidate_web_font_metrics() -> Unit {
  cosmic_text_cache.clear()
  webgpu_clear_text_textures()
}

///|
/// The DOM face provides a valid Canvas fallback while the font bytes are
/// still being prepared for Cosmic rendering.
fn mark_web_font_dom_ready(family : String, generation : UInt) -> Unit {
  let runtime = web_font_runtime(family)
  guard runtime.generation == generation else { return }
  guard runtime.dom_ready_generation != Some(generation) else { return }
  runtime.dom_ready_generation = Some(generation)
  if runtime.bytes_ready_generation != Some(generation) {
    runtime.metrics_revision += 1U
    invalidate_web_font_metrics()
  }
}

///|
/// Cosmic metrics are the canonical WebGPU measurement and rendering source.
fn mark_web_font_bytes_ready(family : String, generation : UInt) -> Unit {
  let runtime = web_font_runtime(family)
  guard runtime.generation == generation else { return }
  guard runtime.bytes_ready_generation != Some(generation) else { return }
  runtime.bytes_ready_generation = Some(generation)
  runtime.metrics_revision += 1U
  invalidate_web_font_metrics()
}

///|
pub fn font_metrics_revision(family : String) -> UInt {
  web_font_runtime(family).metrics_revision
}

///|
pub fn load_font(family : String, path : String) -> Unit {
  let resolved_path = resolve_asset_path(path)
  let generation = begin_web_font_load(family)
  load_font_async(
    family,
    resolved_path,
    fn() { web_font_load_is_current(family, generation) },
    fn() { mark_web_font_dom_ready(family, generation) },
    fn(_message) { () },
  )
  webgpu_preload_font_bytes(
    family,
    resolved_path,
    fn() { web_font_load_is_current(family, generation) },
    fn() { mark_web_font_bytes_ready(family, generation) },
    fn(_message) { () },
  )
}
