///|
test "mouse lock request stays pending until capture becomes active" {
  inspect(
    next_mouse_lock_request(true, true, false, false, false),
    content="true",
  )
}

///|
test "mouse lock request clears when capture mode is disabled" {
  inspect(
    next_mouse_lock_request(false, true, false, false, false),
    content="false",
  )
}

///|
test "mouse lock request clears on escape while already locked" {
  inspect(
    next_mouse_lock_request(true, true, true, true, false),
    content="false",
  )
}

///|
test "mouse lock request re-arms on click while unlocked" {
  inspect(
    next_mouse_lock_request(true, false, false, false, true),
    content="true",
  )
}
