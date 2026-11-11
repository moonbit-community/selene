///|
test "generates typed keys only for marked declarations" {
  let source =
    #|#selene.component
    #|pub(all) struct Position { x : Double }
    #|
    #|#selene.resource
    #|priv struct Clock { mut tick : Int }
    #|
    #|// #selene.component
    #|priv struct Unmarked { x : Double }
  let generated = generate(source, "state.mbt")
  assert_true(generated.contains("@ecs.ComponentKey[Position]"))
  assert_true(generated.contains("pub impl @ecs.Component for Position"))
  assert_true(generated.contains("@ecs.ResourceKey[Clock] = ResourceKey()"))
  assert_false(generated.contains("pub impl @ecs.Resource for Clock"))
  assert_false(generated.contains("Unmarked"))
}

///|
test "state markers generate identity and visibility without resource access" {
  let source =
    #|#derive(Eq)
    #|#selene.state
    #|pub enum GamePhase { Menu; Playing }
    #|
    #|#derive(Eq)
    #|#selene.state
    #|priv enum Connection { Offline; Online }
  let generated = generate(source, "phase.mbt")
  assert_true(generated.contains("@state.StateKey[GamePhase] = StateKey()"))
  assert_true(generated.contains("pub impl @state.StateType for GamePhase"))
  assert_true(generated.contains("impl @state.StateType for Connection"))
  assert_false(generated.contains("pub impl @state.StateType for Connection"))
  assert_false(generated.contains("@ecs.Resource"))
  assert_false(generated.contains("initialize"))
}

///|
test "rejects generic duplicate and parameterized state markers" {
  for
    source in [
      "#selene.state\nenum Phase[T] { Playing(T) }", "#selene.state\n#selene.resource\nenum Phase { Playing }",
      "#selene.state(factory)\nenum Phase { Playing }", "#selene.state\nfn phase() -> Unit { () }",
    ] {
    try ignore(generate(source, "phase.mbt")) catch {
      InvalidInput(_) => ()
    } noraise {
      _ => fail("expected an invalid state declaration")
    }
  }
}

///|
test "rejects a resource marker with an initializer" {
  let result = try {
    ignore(
      generate("#selene.resource(new_clock)\npriv struct Clock {}", "state.mbt"),
    )
    false
  } catch {
    InvalidInput(_) => true
  }
  assert_true(result)
}

///|
test "rejects Selene markers on functions and fields" {
  for
    source in [
      "#selene.component\nfn wrong_target() -> Unit { () }", "#selene.resource\nstruct Player {\n  #selene.component\n  score : Int\n}",
    ] {
    let result = try {
      ignore(generate(source, "state.mbt"))
      false
    } catch {
      InvalidInput(message) =>
        message.contains("must be on a top-level struct or enum")
    }
    assert_true(result)
  }
}

///|
test "ignores Selene markers in comments and strings" {
  let source =
    #|// #selene.component
    #|let marker = "#selene.resource(new_score)"
  assert_eq(generate(source, "state.mbt"), GENERATED_HEADER)
}

///|
async test "checks missing and stale companions without writing files" {
  let dir = @fs.tmpdir(prefix="selene-codegen-test")
  defer @fs.rmdir(dir, recursive=true)
  let input = dir + "/state.mbt"
  let output = dir + "/state.g.mbt"
  let source = "#selene.component\npriv struct Position { x : Int }\n"
  @fs.write_file(input, source, create_mode=CreateOrTruncate)
  let missing = try {
    check_source(input)
    false
  } catch {
    InvalidInput(message) => message.contains("missing generated companion")
    err => raise err
  }
  assert_true(missing)
  assert_false(@fs.exists(output))

  let generated = generate(source, input)
  @fs.write_file(output, generated, create_mode=CreateOrTruncate)
  check_source(input)
  let stale = generated + "// stale\n"
  @fs.write_file(output, stale, create_mode=CreateOrTruncate)
  let rejected = try {
    check_source(input)
    false
  } catch {
    InvalidInput(message) =>
      message.contains("generated companion is out of date")
    err => raise err
  }
  assert_true(rejected)
  assert_eq(@fs.read_file(output).text(), stale)
}
