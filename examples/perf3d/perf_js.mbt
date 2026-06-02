///|
extern "js" fn perf_query_case(default_value : String) -> String =
  #| (defaultValue) => {
  #|   const params = new URLSearchParams(globalThis.location?.search || "");
  #|   return params.get("case") || defaultValue;
  #| }

///|
extern "js" fn perf_query_mode(default_value : String) -> String =
  #| (defaultValue) => {
  #|   const params = new URLSearchParams(globalThis.location?.search || "");
  #|   return params.get("mode") || defaultValue;
  #| }

///|
extern "js" fn perf_query_count(default_value : Int) -> Int =
  #| (defaultValue) => {
  #|   const params = new URLSearchParams(globalThis.location?.search || "");
  #|   const parsed = Number.parseInt(params.get("count") || "", 10);
  #|   return Number.isFinite(parsed) && parsed > 0 ? parsed : defaultValue;
  #| }

///|
extern "js" fn perf_query_duration(default_value : Double) -> Double =
  #| (defaultValue) => {
  #|   const params = new URLSearchParams(globalThis.location?.search || "");
  #|   const parsed = Number.parseFloat(params.get("duration") || "");
  #|   return Number.isFinite(parsed) && parsed > 0 ? parsed : defaultValue;
  #| }

///|
extern "js" fn perf_now_ms() -> Double = "() => performance.now()"

///|
extern "js" fn perf_publish_live(
  case_name : String,
  count : Int,
  duration : Double,
  frames : Int,
  fps : Double,
  p95_frame_ms : Double,
  p95_work_ms : Double,
  draw_commands : Int,
  uploaded_vertex_bytes : Int,
) -> Unit =
  #| (caseName, count, duration, frames, fps, p95FrameMs, p95WorkMs, drawCommands, uploadedVertexBytes) => {
  #|   const target = globalThis.document?.getElementById("perf-live");
  #|   if (!target) return;
  #|   target.textContent = [
  #|     `case=${caseName}`,
  #|     `count=${count}`,
  #|     `duration=${duration.toFixed(1)}s`,
  #|     `frames=${frames}`,
  #|     `avg_fps=${fps.toFixed(1)}`,
  #|     `p95=${p95FrameMs.toFixed(2)}ms`,
  #|     `work_p95=${p95WorkMs.toFixed(2)}ms`,
  #|     `draw=${drawCommands}`,
  #|     `upload=${uploadedVertexBytes}B`,
  #|   ].join("  ");
  #| }

///|
extern "js" fn perf_publish_result(
  case_name : String,
  mode : String,
  count : Int,
  duration : Double,
  frames : Int,
  avg_fps : Double,
  p50_frame_ms : Double,
  p95_frame_ms : Double,
  max_frame_ms : Double,
  p50_work_ms : Double,
  p95_work_ms : Double,
  max_work_ms : Double,
  p95_game_ms : Double,
  p95_render_ms : Double,
  p95_render3d_submit_ms : Double,
  p95_render3d_items_ms : Double,
  p95_render3d_flush_ms : Double,
  submitted_items : Int,
  draw_commands : Int,
  command_groups : Int,
  uploaded_vertex_bytes : Int,
  render_bind_group_creations : Int,
) -> Unit =
  #| (
  #|   caseName,
  #|   mode,
  #|   count,
  #|   duration,
  #|   frames,
  #|   avgFps,
  #|   p50FrameMs,
  #|   p95FrameMs,
  #|   maxFrameMs,
  #|   p50WorkMs,
  #|   p95WorkMs,
  #|   maxWorkMs,
  #|   p95GameMs,
  #|   p95RenderMs,
  #|   p95Render3dSubmitMs,
  #|   p95Render3dItemsMs,
  #|   p95Render3dFlushMs,
  #|   submittedItems,
  #|   drawCommands,
  #|   commandGroups,
  #|   uploadedVertexBytes,
  #|   renderBindGroupCreations
  #| ) => {
  #|   const result = {
  #|     case: caseName,
  #|     mode,
  #|     count,
  #|     duration_s: duration,
  #|     frames,
  #|     avg_fps: avgFps,
  #|     p50_frame_ms: p50FrameMs,
  #|     p95_frame_ms: p95FrameMs,
  #|     max_frame_ms: maxFrameMs,
  #|     p50_work_ms: p50WorkMs,
  #|     p95_work_ms: p95WorkMs,
  #|     max_work_ms: maxWorkMs,
  #|     p95_game_ms: p95GameMs,
  #|     p95_render_ms: p95RenderMs,
  #|     p95_render3d_submit_ms: p95Render3dSubmitMs,
  #|     p95_render3d_items_ms: p95Render3dItemsMs,
  #|     p95_render3d_flush_ms: p95Render3dFlushMs,
  #|     submitted_items: submittedItems,
  #|     draw_commands: drawCommands,
  #|     command_groups: commandGroups,
  #|     uploaded_vertex_bytes: uploadedVertexBytes,
  #|     render_bind_group_creations: renderBindGroupCreations,
  #|   };
  #|   globalThis.__selene_perf_result = result;
  #|   const text = JSON.stringify(result, null, 2);
  #|   const target = globalThis.document?.getElementById("perf-result");
  #|   if (target) target.textContent = text;
  #|   console.log("[selene-perf]", JSON.stringify(result));
  #| }
