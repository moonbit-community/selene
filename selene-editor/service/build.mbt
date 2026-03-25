///|
async fn EditorService::ensure_frontend_bundle(self : EditorService) -> Unit {
  let bundle_path = self.frontend_bundle_path()
  if @fs.exists(bundle_path) {
    return
  }
  let (exit_code, output) = @process.collect_output_merged(
    "moon",
    ["build", "frontend/web", "--target", "js", "--release"],
    cwd=self.module_root,
  )
  guard exit_code == 0 else {
    raise Failure("Failed to build frontend bundle: " + output.text())
  }
}

///|
async fn EditorService::run_moon_command(
  self : EditorService,
  project_root : String,
  label : String,
  args : Array[String],
) -> Json {
  let (exit_code, stdout, stderr) = @process.collect_output(
    "moon",
    args,
    cwd=project_root,
  ) catch {
    err => {
      self.broadcast(
        @shared.event_envelope("log", {
          "stream": "stderr".to_json(),
          "label": label.to_json(),
          "message": err.to_string().to_json(),
        }),
      )
      return {
        "exit_code": (-1).to_json(),
        "stdout": "".to_json(),
        "stderr": err.to_string().to_json(),
      }
    }
  }
  let stdout_text = stdout.text() catch { _ => "" }
  let stderr_text = stderr.text() catch { _ => "" }
  if stdout_text != "" {
    self.broadcast(
      @shared.event_envelope("log", {
        "stream": "stdout".to_json(),
        "label": label.to_json(),
        "message": stdout_text.to_json(),
      }),
    )
  }
  if stderr_text != "" {
    self.broadcast(
      @shared.event_envelope("log", {
        "stream": "stderr".to_json(),
        "label": label.to_json(),
        "message": stderr_text.to_json(),
      }),
    )
  }
  {
    "exit_code": exit_code.to_json(),
    "stdout": stdout_text.to_json(),
    "stderr": stderr_text.to_json(),
  }
}
