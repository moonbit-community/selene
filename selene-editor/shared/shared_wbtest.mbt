///|
test "rpc request, response, and event round trip" {
  let request : RpcRequestEnvelope = @json.from_json(
    rpc_request_envelope(
      7,
      ProjectOpen(root="/tmp/demo"),
    ).to_json(),
  )
  let response : RpcResponseEnvelope = @json.from_json(
    rpc_response_envelope(
      7,
      SavedOk,
    ).to_json(),
  )
  let failure : RpcResponseEnvelope = @json.from_json(
    rpc_error_response(9, "broken", "Something failed").to_json(),
  )
  let event : EventEnvelope = @json.from_json(
    event_envelope(Log(label="core", message="ready")).to_json(),
  )
  inspect(request.id, content="7")
  inspect(request.request, content="ProjectOpen(root=\"/tmp/demo\")")
  inspect(response.response, content="SavedOk")
  inspect(
    failure.response,
    content=
      "Error(error={code: \"broken\", message: \"Something failed\", details: Null})",
  )
  inspect(event.event, content="Log(label=\"core\", message=\"ready\")")
}
