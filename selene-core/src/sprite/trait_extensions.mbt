///|
pub extend Anchor with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Anchor with Eq::{not_equal, equal}

///|
pub extend TextureAtlas with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureAtlas with Eq::{not_equal, equal}

///|
pub extend TextureAtlasLayoutHandle with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend TextureAtlasLayoutHandle with Eq::{not_equal, equal}

///|
pub extend TextureAtlasLayoutHandle with Hash::{hash, hash_combine}
