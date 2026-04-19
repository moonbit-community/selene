///|
test "web audio uses byte-backed sources only for local asset paths" {
  inspect(audio_prefers_byte_backed_source("assets/music/bgm.ogg"), content="true")
  inspect(audio_prefers_byte_backed_source("https://cdn.test/bgm.ogg"), content="false")
  inspect(audio_prefers_byte_backed_source("data:audio/ogg;base64,AAAA"), content="false")
  inspect(audio_prefers_byte_backed_source("blob:https://test/123"), content="false")
  inspect(audio_prefers_byte_backed_source("sounds/bgm.ogg"), content="false")
}

///|
test "web audio infers browser mime types for common formats" {
  inspect(browser_audio_mime_type("assets/music/loop.ogg"), content="audio/ogg")
  inspect(browser_audio_mime_type("assets/music/loop.mp3"), content="audio/mpeg")
  inspect(browser_audio_mime_type("assets/music/loop.wav"), content="audio/wav")
  inspect(browser_audio_mime_type("assets/music/loop.flac"), content="audio/flac")
  inspect(browser_audio_mime_type("assets/music/loop.bin"), content="application/octet-stream")
}

///|
test "web audio retries blocked playback only after a new activation epoch" {
  inspect(
    should_retry_blocked_audio_playback(
      AUDIO_PLAY_STATE_BLOCKED,
      false,
      2,
      1,
    ),
    content="true",
  )
  inspect(
    should_retry_blocked_audio_playback(
      AUDIO_PLAY_STATE_BLOCKED,
      false,
      1,
      1,
    ),
    content="false",
  )
  inspect(
    should_retry_blocked_audio_playback(
      AUDIO_PLAY_STATE_BLOCKED,
      true,
      2,
      1,
    ),
    content="false",
  )
  inspect(
    should_retry_blocked_audio_playback(
      1,
      false,
      2,
      1,
    ),
    content="false",
  )
}
