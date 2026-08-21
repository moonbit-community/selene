///|
pub extend ActionEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionEvent with Eq::{not_equal, equal}

///|
pub extend ActionEventKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionEventKind with Eq::{not_equal, equal}

///|
pub extend ActionState with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionState with Eq::{not_equal, equal}

///|
pub extend InputAction with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend InputAction with Eq::{not_equal, equal}

///|
pub extend InputAction with Hash::{hash, hash_combine}
