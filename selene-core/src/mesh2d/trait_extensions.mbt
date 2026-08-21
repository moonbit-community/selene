///|
pub extend Mesh2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2d with Eq::{not_equal, equal}

///|
pub extend Mesh2dAsset with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dAsset with Eq::{not_equal, equal}

///|
pub extend Mesh2dHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dHandle with Eq::{not_equal, equal}

///|
pub extend Mesh2dHandle with Hash::{hash, hash_combine}

///|
pub extend Mesh2dPrimitive with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mesh2dPrimitive with Eq::{not_equal, equal}
