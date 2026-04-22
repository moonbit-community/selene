///|
async fn EditorService::dispatch_rpc_response(
  self : EditorService,
  request : @shared.RpcRequest,
  _id : Int,
) -> @shared.RpcResponse {
  match self.handle_project_rpc(request) {
    Some(response) => response
    None =>
      match self.handle_scene_rpc(request) {
        Some(response) => response
        None =>
          match self.handle_asset_rpc(request) {
            Some(response) => response
            None =>
              match self.handle_animation_rpc(request) {
                Some(response) => response
                None => abort("Unhandled RPC request")
              }
          }
      }
  }
}

///|
pub async fn EditorService::handle_rpc(
  self : EditorService,
  envelope : @shared.RpcRequestEnvelope,
) -> Json {
  let id = envelope.id
  try {
    let response = self.dispatch_rpc_response(envelope.request, id)
    @shared.rpc_response_envelope(id, response).to_json()
  } catch {
    err =>
      @shared.rpc_error_response(
        id,
        "internal_error",
        request_error_message(err),
        details=envelope.request.to_json(),
      ).to_json()
  }
}
