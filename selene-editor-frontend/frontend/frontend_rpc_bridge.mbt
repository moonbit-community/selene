///|
priv suberror RpcBridgeError {
  InvalidRpcPayload(String)
}

///|
fn decode_rpc_payload(
  payload : Json,
) -> @shared.RpcResponseEnvelope raise RpcBridgeError {
  @json.from_json(payload) catch {
    err => {
      console_error("RPC response decode failed: " + err.to_string())
      raise InvalidRpcPayload("Invalid server response")
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
) -> @app.Msg raise RpcBridgeError {
  let envelope = decode_rpc_payload(payload) catch {
    InvalidRpcPayload(message) => raise InvalidRpcPayload(message)
  }
  binding.response_to_msg(envelope.response) catch {
    UnexpectedRpcResponse(message) => raise InvalidRpcPayload(message)
  }
}

///|
fn rpc_cmd(
  binding : @app.RpcBinding,
  dispatch : @rabbita.Emit[@app.Msg],
) -> @rabbita.Cmd {
  @http.post("/rpc")
  .with_json(binding.request_envelope().to_json())
  .expect_json(
    dispatch.map(fn(result : Result[Json, Error]) {
      match result {
        Ok(payload) =>
          rpc_msg_from_payload(binding, payload) catch {
            InvalidRpcPayload(message) => {
              console_error("RPC " + binding.scope() + " failed: " + message)
              binding.transport_error_msg(message)
            }
          }
        Err(err) => {
          let message = err.to_string()
          console_error("RPC " + binding.scope() + " failed: " + message)
          binding.transport_error_msg(message)
        }
      }
    }),
  )
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
fn schedule_cmd(scheduler : &@cmd.Scheduler, cmd : @rabbita.Cmd) -> Unit {
  scheduler.add(cmd)
}

///|
#cfg(target="js")
extern "js" fn prompt_text(message : String, initial : String) -> String =
  #| (message, initial) => window.prompt(message, initial) || ""
