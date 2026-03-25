///|
test "rpc success and failure round trip" {
  let success : RpcSuccess = @json.from_json(
    rpc_success(7, { "ok": true.to_json() }),
  )
  let failure : RpcFailure = @json.from_json(
    rpc_failure(Some(9), "broken", "Something failed"),
  )
  let ok = match success.result {
    Json::Object(fields) => fields["ok"]
    _ => Json::null()
  }
  inspect(success.id, content="7")
  inspect(ok, content="True")
  inspect(failure.id, content="Some(9)")
  inspect(failure.error.details, content="Null")
}
