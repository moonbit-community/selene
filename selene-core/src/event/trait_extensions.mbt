///|
pub extend EventDomain with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EventDomain with Eq::{not_equal, equal}

///|
pub extend ObserverHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ObserverHandle with Eq::{not_equal, equal}

///|
pub extend ObserverHandle with Hash::{hash, hash_combine}
