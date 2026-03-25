///|
test "initialize immediately requests a project folder" {
  let (effects, _) = update(msg_initialize(), new_model())
  inspect(effects.length(), content="4")
}

///|
test "pick project root result auto-opens the chosen directory" {
  let (_, model) = update(msg_pick_project_root(), new_model())
  let (effects, next) = update(
    msg_project_root_picked(Ok({ path: Some("/tmp/demo-project") })),
    model,
  )
  inspect(effects.length(), content="1")
  inspect(next.project_root_input, content="/tmp/demo-project")
  inspect(next.status, content="Opening project...")
}

///|
test "cancelled folder picker keeps the editor in entry state" {
  let (_, model) = update(msg_pick_project_root(), new_model())
  let (effects, next) = update(
    msg_project_root_picked(Ok({ path: None })),
    model,
  )
  inspect(effects.length(), content="0")
  inspect(next.status, content="Choose a project folder to begin")
}
