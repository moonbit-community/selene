///|
pub extend AudioEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioEvent with Eq::{not_equal, equal}

///|
pub extend AudioPlayer with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioPlayer with Eq::{not_equal, equal}

///|
pub extend PlaybackMode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PlaybackMode with Eq::{not_equal, equal}

///|
pub extend PlaybackSettings with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PlaybackSettings with Eq::{not_equal, equal}
