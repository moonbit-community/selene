///|
fn decode_rpc_payload(
  payload : Json,
) -> Result[@shared.RpcResponseEnvelope, String] {
  Ok(@json.from_json(payload)) catch {
    err => {
      console_error("RPC response decode failed: " + err.to_string())
      Err("Invalid server response")
    }
  }
}

///|
#cfg(target="js")
extern "js" fn console_error(message : String) =
  #| (message) => console.error(message)

///|
fn current_scene_path(model : @app.ViewState) -> String {
  match model.scene_session {
    Some(session) => session.path
    None =>
      if model.scene_refs.is_empty() {
        "scenes/main.scene.json"
      } else {
        model.scene_refs[0].path
      }
  }
}

///|
fn current_scene(model : @app.ViewState) -> @editor_bridge.SceneDocument? {
  model.scene_session.map(fn(session) { session.scene })
}

///|
fn rpc_msg_from_payload(
  binding : @app.RpcBinding,
  payload : Json,
) -> Result[@app.Msg, String] {
  match decode_rpc_payload(payload) {
    Ok(envelope) => binding.response_to_msg(envelope.response)
    Err(message) => Err(message)
  }
}

///|
fn rpc_cmd(
  binding : @app.RpcBinding,
  on_result : (Result[@app.Msg, String]) -> @rabbita.Cmd,
) -> @rabbita.Cmd {
  @http.post(
    "/rpc",
    @http.Body::Json(binding.request_envelope().to_json()),
    expect=@http.Json(on_result, fn(payload) {
      rpc_msg_from_payload(binding, payload)
    }),
  )
}

///|
fn[T] log_rpc_result_error(scope : String, result : Result[T, String]) -> Unit {
  match result {
    Ok(_) => ()
    Err(message) => console_error("RPC " + scope + " failed: " + message)
  }
}

///|
#cfg(target="js")
extern "js" fn subscribe_events_forever(
  url : String,
  on_data : (String) -> Unit,
  on_error : (String) -> Unit,
) =
  #| (url, onData, onError) => {
  #|   const source = new EventSource(url);
  #|   source.onmessage = (event) => onData(event.data);
  #|   source.onerror = () => onError("EventSource error");
  #| }

///|

///|
fn schedule_cmd(scheduler : @cmd.Scheduler, cmd : @rabbita.Cmd) -> Unit {
  scheduler.add(cmd)
}

///|
#cfg(target="js")
extern "js" fn prompt_text(message : String, initial : String) -> String =
  #| (message, initial) => window.prompt(message, initial) || ""
