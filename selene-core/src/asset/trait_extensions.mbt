///|
pub extend AssetEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AssetEvent with Eq::{not_equal, equal}

///|
pub extend AssetEventKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AssetEventKind with Eq::{not_equal, equal}

///|
pub extend LoadState with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend LoadState with Eq::{not_equal, equal}
