///|
fn test_loaded_model(
  scene : @editor_bridge.SceneDocument,
  dirty : Bool,
  base_hash : String,
  base_revision : Int,
) -> Model {
  let loaded = with_loaded_scene_session(
    {
      ..new_model(),
      current_root: Some("/tmp/demo"),
      scene_refs: [@editor_bridge.scene_ref("scenes/main.scene.json")],
    },
    "scenes/main.scene.json",
    scene,
    base_hash,
    base_revision,
  )
  let session = match loaded.scene_session {
    Some(session) => session
    None => empty_scene_session("scenes/main.scene.json")
  }
  { ..loaded, scene_session: Some({ ..session, dirty, }) }
}

///|
fn test_session(model : Model) -> SceneSession {
  match model.scene_session {
    Some(session) => session
    None => empty_scene_session("scenes/main.scene.json")
  }
}

///|
test "view state mapping keeps ui-visible fields stable" {
  let model = {
    ..new_model(),
    status: "Ready",
    move_snap_enabled: true,
    move_snap_step: 8.0,
  }
  let view = view_state(model)
  inspect(view.status, content="Ready")
  inspect(view.move_snap_enabled, content="true")
  inspect(view.move_snap_step, content="8")
}

///|
test "initialize subscribes to service and preview channels" {
  let (effects, _) = update(msg_initialize(), new_model())
  inspect(effects.length(), content="5")
}

///|
test "save scene uses cas base hash and revision from scene session" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Dirty Scene",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(msg_save_scene(), model)
  inspect(next.status, content="Saving scene...")
  match effects {
    [Rpc(target=SceneSaved, request~)] =>
      match request.request {
        @shared.SceneSave(path~, scene~, base_hash~, base_revision~) => {
          inspect(path, content="scenes/main.scene.json")
          inspect(scene.name, content="Dirty Scene")
          inspect(base_hash, content="hash-before")
          inspect(base_revision, content="11")
        }
        _ => fail("expected scene.save request")
      }
    _ => fail("expected exactly one save rpc effect")
  }
}

///|
test "scene save success clears dirty and updates base metadata" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Dirty Scene",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(
    msg_scene_saved(
      Ok(
        Saved(
          @shared.scene_save_result("scenes/main.scene.json", "hash-after", 12),
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  let session = test_session(next)
  inspect(session.dirty, content="false")
  inspect(session.base_hash, content="hash-after")
  inspect(session.base_revision, content="12")
  inspect(next.status, content="Scene saved")
  inspect(session.conflict_state is NoConflict, content="true")
}

///|
test "scene save conflict keeps local scene and records conflict state" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Keep Mine",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(
    msg_scene_saved(
      Ok(
        Conflict(
          @shared.rpc_conflict_document(
            "scenes/main.scene.json", "hash-before", "hash-on-disk", 11, 13,
          ),
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  let session = test_session(next)
  inspect(session.scene.name, content="Keep Mine")
  inspect(session.dirty, content="true")
  inspect(
    next.status,
    content="Save conflict detected for scenes/main.scene.json",
  )
  match session.conflict_state {
    SaveConflict(
      path~,
      base_hash~,
      current_hash~,
      base_revision~,
      current_revision~
    ) => {
      inspect(path, content="scenes/main.scene.json")
      inspect(base_hash, content="hash-before")
      inspect(current_hash, content="hash-on-disk")
      inspect(base_revision, content="11")
      inspect(current_revision, content="13")
    }
    _ => fail("expected save conflict state")
  }
}

///|
test "dirty scene does not reload when current scene file changes on disk" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Unsaved Local",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(
    msg_service_event(
      Ok(
        @shared.editor_event_project_delta(
          @shared.project_delta_scene_file_changed(
            "scenes/main.scene.json", "hash-disk", 15,
          ),
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  let session = test_session(next)
  inspect(session.scene.name, content="Unsaved Local")
  inspect(session.dirty, content="true")
  inspect(
    next.status,
    content="Scene changed on disk while local edits are unsaved",
  )
  match session.conflict_state {
    ExternalSceneChanged(path~, disk_hash~, disk_revision~) => {
      inspect(path, content="scenes/main.scene.json")
      inspect(disk_hash, content="hash-disk")
      inspect(disk_revision, content="15")
    }
    _ => fail("expected external scene changed conflict")
  }
}

///|
test "clean scene reloads automatically when current scene file changes on disk" {
  let scene = @editor_bridge.SceneDocument::default_main()
  let model = test_loaded_model(scene, false, "hash-before", 11)
  let (effects, next) = update(
    msg_service_event(
      Ok(
        @shared.editor_event_project_delta(
          @shared.project_delta_scene_file_changed(
            "scenes/main.scene.json", "hash-disk", 15,
          ),
        ),
      ),
    ),
    model,
  )
  inspect(next.status, content="Reloading changed scene...")
  match effects {
    [Rpc(target=SceneLoaded, request~)] =>
      match request.request {
        @shared.SceneLoad(path~) =>
          inspect(path, content="scenes/main.scene.json")
        _ => fail("expected scene.load request")
      }
    _ => fail("expected one scene.load effect")
  }
}

///|
test "workspace delta never overwrites in-memory scene session" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Unsaved Local",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(
    msg_service_event(
      Ok(
        @shared.editor_event_project_delta(
          @shared.project_delta_workspace_changed(),
        ),
      ),
    ),
    model,
  )
  inspect(effects.length(), content="0")
  let session = test_session(next)
  inspect(session.scene.name, content="Unsaved Local")
  inspect(session.dirty, content="true")
  inspect(next.status, content="Workspace settings updated")
}

///|
test "toggle move snap never reloads or rolls back unsaved scene edits" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Unsaved Local",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(msg_toggle_move_snap(), model)
  let session = test_session(next)
  inspect(effects.length() > 0, content="true")
  inspect(session.scene.name, content="Unsaved Local")
  inspect(session.dirty, content="true")
}

///|
test "switching tool never mutates current scene session" {
  let scene = @editor_bridge.SceneDocument::default_main().with_name(
    "Unsaved Local",
  )
  let model = test_loaded_model(scene, true, "hash-before", 11)
  let (effects, next) = update(
    msg_set_tool(@shared.preview_tool_translate()),
    model,
  )
  let session = test_session(next)
  inspect(effects.length() > 0, content="true")
  inspect(session.scene.name, content="Unsaved Local")
  inspect(session.dirty, content="true")
}
