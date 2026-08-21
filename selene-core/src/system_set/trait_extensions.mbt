///|
pub extend SystemSet with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SystemSet with Eq::{not_equal, equal}

///|
pub extend SystemSet with Hash::{hash, hash_combine}
