///|
pub extend Card with Eq::{not_equal, equal}

///|
pub extend Card with Hash::{hash, hash_combine}

///|
pub extend CardNum with Eq::{not_equal, equal}

///|
pub extend CardNum with Hash::{hash, hash_combine}

///|
pub extend CardSuit with Eq::{not_equal, equal}

///|
pub extend CardSuit with Hash::{hash, hash_combine}

///|
pub extend GamePhase with Eq::{not_equal, equal}

///|
pub extend HandRank with @moonbitlang/core/debug.Debug::{to_repr}
