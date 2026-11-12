///|
/// Backend readiness, independent of registration and file-read completion.
#derive(Eq, Debug)
pub(all) enum PreparationState {
  Unprepared
  Preparing
  Ready
  Failed(String)
}

///|
pub extend PreparationState with Eq::{equal, not_equal}

///|
pub extend PreparationState with @debug.Debug::{to_repr}
