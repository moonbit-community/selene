///|
test "frame pacing respects target and refresh rates with timestamp jitter" {
  let jitter = [0.0, -0.05, 0.05, -0.02]
  for
    (refresh, target) in [
      (30, 60),
      (60, 60),
      (120, 60),
      (144, 60),
      (120, 30),
      (144, 120),
    ] {
    let pacer = {
      interval: Some(1000.0 / target.to_double()),
      previous_frame: None,
      remainder: 0.0,
    }
    assert_eq(pacer.tick(0.0), None)
    let mut frames = 0
    let mut elapsed_total = 0.0
    let mut last_frame_time = 0.0
    let ticks = refresh * 10
    for tick in 1..<=ticks {
      let time = tick.to_double() * (1000.0 / refresh.to_double()) +
        jitter[tick % 4]
      if pacer.tick(time) is Some(elapsed) {
        frames += 1
        elapsed_total += elapsed
        last_frame_time = time
      }
    }
    let expected = if refresh < target { refresh * 10 } else { target * 10 }
    assert_true(
      frames >= expected - 1 && frames <= expected,
      msg="refresh=\{refresh}, target=\{target}, frames=\{frames}",
    )
    assert_true((elapsed_total - last_frame_time).abs() < 0.000001)
  }
}

///|
test "frame delta measures wall time independently of the pacing remainder" {
  let pacer = { interval: Some(10.0), previous_frame: None, remainder: 0.0, }
  assert_eq(pacer.tick(0.0), None)
  assert_eq(pacer.tick(8.0), None)
  assert_eq(pacer.tick(16.0), Some(16.0))
  assert_eq(pacer.tick(24.0), Some(8.0))
  assert_eq(pacer.tick(32.0), Some(8.0))
}

///|
test "a stalled frame renders once and reports the full elapsed time" {
  let pacer = { interval: Some(10.0), previous_frame: None, remainder: 0.0, }
  assert_eq(pacer.tick(100.0), None)
  assert_eq(pacer.tick(1105.0), Some(1005.0))
  assert_eq(pacer.tick(1105.0), None)
  assert_eq(pacer.tick(1108.0), None)
  assert_eq(pacer.tick(1110.0), Some(5.0))
}

///|
test "uncapped frames consume every RAF timestamp with actual elapsed time" {
  let pacer = { interval: None, previous_frame: None, remainder: 0.0, }
  assert_eq(pacer.tick(0.0), None)
  assert_eq(pacer.tick(8.3), Some(8.3))
  assert_true((pacer.tick(16.7).unwrap() - 8.4).abs() < 0.000001)
  assert_true((pacer.tick(25.0).unwrap() - 8.3).abs() < 0.000001)
}
