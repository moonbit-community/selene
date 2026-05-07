///|
fn escape_shell_prompt(prompt : String) -> String {
  prompt.replace(old="\"", new="\\\"")
}

///|
async fn collect_stdout_if_ok(cmd : String, args : Array[String]) -> String? {
  try {
    let (code, stdout) = @process.collect_stdout(cmd, args)
    if code != 0 {
      return None
    }
    let trimmed = stdout.text().trim().to_owned()
    if trimmed == "" {
      None
    } else {
      Some(trimmed)
    }
  } catch {
    _ => None
  }
}

///|
async fn pick_directory_dialog(prompt : String) -> String? {
  let escaped = escape_shell_prompt(prompt)
  let mac = collect_stdout_if_ok("osascript", [
    "-e",
    "POSIX path of (choose folder with prompt \"\{escaped}\")",
  ])
  if mac is Some(path) {
    return Some(path)
  }

  let zenity = collect_stdout_if_ok("zenity", [
    "--file-selection",
    "--directory",
    "--title=\{prompt}",
  ])
  if zenity is Some(path) {
    return Some(path)
  }

  let kdialog = collect_stdout_if_ok("kdialog", [
    "--getexistingdirectory", ".", "--title", prompt,
  ])
  if kdialog is Some(path) {
    return Some(path)
  }

  collect_stdout_if_ok("powershell", [
    "-NoProfile",
    "-Command",
    "[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.Description = \"\{escaped}\"; if ($dialog.ShowDialog() -eq 'OK') { Write-Output $dialog.SelectedPath }",
  ])
}
