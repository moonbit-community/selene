///|
pub extend AudioInstance with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioInstance with Eq::{not_equal, equal}

///|
pub extend AudioInstance with Hash::{hash, hash_combine}
