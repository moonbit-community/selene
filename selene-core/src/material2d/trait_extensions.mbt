///|
pub extend ColorMaterialHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ColorMaterialHandle with Eq::{not_equal, equal}

///|
pub extend ColorMaterialHandle with Hash::{hash, hash_combine}

///|
pub extend Material2dHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Material2dHandle with Eq::{not_equal, equal}

///|
pub extend MeshMaterial2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MeshMaterial2d with Eq::{not_equal, equal}
