///|
pub struct RpcRequest {
  id : Int
  method_name : String
  params : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RpcErrorDocument {
  code : String
  message : String
  details : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RpcSuccess {
  id : Int
  result : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RpcFailure {
  id : Int?
  error : RpcErrorDocument
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct EventEnvelope {
  kind : String
  data : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct DirectoryPickResult {
  path : String?
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn directory_pick_result(path : String?) -> DirectoryPickResult {
  { path, }
}

///|
pub enum PreviewTool {
  Select
  Translate
  Rotate
  Scale
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn preview_tool_select() -> PreviewTool {
  Select
}

///|
pub fn preview_tool_translate() -> PreviewTool {
  Translate
}

///|
pub fn preview_tool_rotate() -> PreviewTool {
  Rotate
}

///|
pub fn preview_tool_scale() -> PreviewTool {
  Scale
}

///|
pub fn rpc_request(id : Int, method_name : String, params : Json) -> RpcRequest {
  { id, method_name, params }
}

///|
pub fn rpc_success(id : Int, result : Json) -> Json {
  RpcSuccess::{ id, result }.to_json()
}

///|
pub fn rpc_failure(
  id : Int?,
  code : String,
  message : String,
  details? : Json = Json::null(),
) -> Json {
  RpcFailure::{ id, error: { code, message, details } }.to_json()
}

///|
pub fn event_envelope(kind : String, data : Json) -> EventEnvelope {
  { kind, data }
}
