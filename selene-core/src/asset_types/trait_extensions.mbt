///|
pub extend AudioHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioHandle with Eq::{not_equal, equal}

///|
pub extend AudioHandle with Hash::{hash, hash_combine}

///|
pub extend FontHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FontHandle with Eq::{not_equal, equal}

///|
pub extend FontHandle with Hash::{hash, hash_combine}

///|
pub extend ImageHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageHandle with Eq::{not_equal, equal}

///|
pub extend ImageHandle with Hash::{hash, hash_combine}
