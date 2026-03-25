///|
priv suberror EditorServiceError {
  InvalidEditorPath(String)
  ProjectNotOpen
  MissingProjectManifest(String)
  SceneNotFound(String)
  Failure(String)
}

///|
struct ProjectSession {
  root : String
  manifest : @editor_bridge.ProjectManifest
  mut snapshot : Map[String, String]
}

///|
pub struct EditorService {
  module_root : String
  mut current_project : ProjectSession?
  mut next_subscriber_id : Int
  mut recent_projects : Array[String]
  mut event_log : Array[@shared.EventEnvelope]
  subscribers : Map[Int, @async.Queue[@shared.EventEnvelope]]
}

///|
pub fn EditorService::new(module_root : String) -> EditorService {
  {
    module_root,
    current_project: None,
    next_subscriber_id: 0,
    recent_projects: [],
    event_log: [],
    subscribers: {},
  }
}

///|
fn EditorService::current_project_root(self : EditorService) -> String raise {
  match self.current_project {
    Some(project) => project.root
    None => raise ProjectNotOpen
  }
}

///|
fn EditorService::current_manifest(
  self : EditorService,
) -> @editor_bridge.ProjectManifest raise {
  match self.current_project {
    Some(project) => project.manifest
    None => raise ProjectNotOpen
  }
}

///|
fn EditorService::add_recent_project(
  self : EditorService,
  root : String,
) -> Unit {
  let next : Array[String] = [root]
  self.recent_projects.each(fn(existing) {
    if existing != root {
      next.push(existing)
    }
  })
  if next.length() > 10 {
    self.recent_projects = next[:10].to_array()
  } else {
    self.recent_projects = next
  }
}

///|
fn EditorService::add_subscriber(
  self : EditorService,
) -> (Int, @async.Queue[@shared.EventEnvelope]) {
  let id = self.next_subscriber_id
  self.next_subscriber_id += 1
  let queue = @async.Queue::new(kind=Unbounded)
  self.subscribers.set(id, queue)
  (id, queue)
}

///|
fn EditorService::remove_subscriber(self : EditorService, id : Int) -> Unit {
  if self.subscribers.contains(id) {
    let queue = self.subscribers[id]
    queue.close(clear=true)
    self.subscribers.remove(id) |> ignore
  }
}

///|
fn EditorService::broadcast(
  self : EditorService,
  event : @shared.EventEnvelope,
) -> Unit {
  self.event_log.push(event)
  let stale : Array[Int] = []
  for id, queue in self.subscribers {
    ignore(queue.try_put(event)) catch {
      _ => stale.push(id)
    }
  }
  stale.each(fn(id) { self.remove_subscriber(id) })
}

///|
pub fn EditorService::drain_events(
  self : EditorService,
) -> Array[@shared.EventEnvelope] {
  let events = self.event_log
  self.event_log = []
  events
}
