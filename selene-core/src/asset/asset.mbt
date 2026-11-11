///|
#derive(Eq, Debug)
pub(all) enum LoadState {
  NotLoaded
  Loading
  Loaded
  Failed(String)
}

///|
pub extend LoadState with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend LoadState with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum AssetEventKind {
  Added
  Modified
  Removed
  Loaded
  Failed(String)
}

///|
pub extend AssetEventKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AssetEventKind with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct AssetEvent[T] {
  handle : T
  kind : AssetEventKind
}

///|
pub extend AssetEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AssetEvent with Eq::{not_equal, equal}
