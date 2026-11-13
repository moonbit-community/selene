///|
priv struct WebFontRuntime {
  mut error : String?
  mut generation : UInt32
  mut metrics_revision : UInt32
  mut dom_ready_generation : UInt32?
  mut bytes_ready_generation : UInt32?
}

///|
let web_font_runtimes : Map[String, WebFontRuntime] = Map([])

///|
fn web_font_runtime(family : String) -> WebFontRuntime {
  web_font_runtimes.get_or_init(family, () => {
    error: None,
    generation: 0U,
    metrics_revision: 0U,
    dom_ready_generation: None,
    bytes_ready_generation: None,
  })
}

///|
fn begin_web_font_load(family : String) -> UInt32 {
  let runtime = web_font_runtime(family)
  runtime.error = None
  runtime.generation += 1U
  runtime.dom_ready_generation = None
  runtime.bytes_ready_generation = None
  runtime.generation
}

///|
fn web_font_load_is_current(family : String, generation : UInt32) -> Bool {
  web_font_runtimes
  .get(family)
  .map(runtime => runtime.generation == generation)
  .unwrap_or(false)
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
fn mark_web_font_dom_ready(family : String, generation : UInt32) -> Unit {
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
fn mark_web_font_bytes_ready(family : String, generation : UInt32) -> Unit {
  let runtime = web_font_runtime(family)
  guard runtime.generation == generation else { return }
  guard runtime.bytes_ready_generation != Some(generation) else { return }
  runtime.bytes_ready_generation = Some(generation)
  runtime.metrics_revision += 1U
  invalidate_web_font_metrics()
}

///|
pub fn font_metrics_revision(family : String) -> UInt32 {
  web_font_runtime(family).metrics_revision
}

///|
fn load_font(family : String, bytes : Bytes, url : String) -> Unit {
  let generation = begin_web_font_load(family)
  if prepare_cosmic_font(family, bytes) {
    mark_web_font_bytes_ready(family, generation)
  }
  load_font_async(
    family,
    url,
    fn() { web_font_load_is_current(family, generation) },
    fn() { mark_web_font_dom_ready(family, generation) },
    fn(message) {
      if web_font_load_is_current(family, generation) {
        web_font_runtime(family).error = Some(message)
      }
    },
  )
}
