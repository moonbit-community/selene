///|
/// Proof that a structural operation originates inside the Selene module.
struct Access {}

///|
let access : Access = Access::{ }

///|
pub fn acquire() -> Access {
  access
}

///|
let running_schedule : Ref[Bool] = Ref(false)

///|
let query_depth : Ref[Int32] = Ref(0)

///|
pub fn schedule_running() -> Bool {
  running_schedule.val
}

///|
pub fn set_schedule_running(value : Bool) -> Unit {
  running_schedule.val = value
}

///|
pub fn query_active() -> Bool {
  query_depth.val > 0
}

///|
pub fn enter_query() -> Unit {
  query_depth.val += 1
}

///|
pub fn leave_query() -> Unit {
  query_depth.val -= 1
}
