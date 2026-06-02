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
  draw_commands : Int,
  uploaded_vertex_bytes : Int,
) -> Unit =
  #| (caseName, count, duration, frames, fps, p95FrameMs, drawCommands, uploadedVertexBytes) => {
  #|   const target = globalThis.document?.getElementById("perf-live");
  #|   if (!target) return;
  #|   target.textContent = [
  #|     `case=${caseName}`,
  #|     `count=${count}`,
  #|     `duration=${duration.toFixed(1)}s`,
  #|     `frames=${frames}`,
  #|     `avg_fps=${fps.toFixed(1)}`,
  #|     `p95=${p95FrameMs.toFixed(2)}ms`,
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
