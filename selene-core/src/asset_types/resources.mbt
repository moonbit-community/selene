///|
/// Encoded file contents. Construction does not imply successful backend decoding.
pub struct Image {
  bytes : Bytes
}

///|
pub fn Image::from_bytes(bytes : Bytes) -> Image {
  { bytes, }
}

///|
pub impl @debug.Debug for Image with fn to_repr(self) {
  @debug.Repr::literal("Image(\{self.bytes.length()} bytes)")
}

///|
pub extend Image with @debug.Debug::{to_repr}

///|
/// Encoded file contents. Construction does not imply successful backend decoding.
pub struct Audio {
  bytes : Bytes
}

///|
pub fn Audio::from_bytes(bytes : Bytes) -> Audio {
  { bytes, }
}

///|
pub impl @debug.Debug for Audio with fn to_repr(self) {
  @debug.Repr::literal("Audio(\{self.bytes.length()} bytes)")
}

///|
pub extend Audio with @debug.Debug::{to_repr}

///|
/// Encoded file contents. Construction does not imply successful backend decoding.
pub struct Font {
  bytes : Bytes
}

///|
pub fn Font::from_bytes(bytes : Bytes) -> Font {
  { bytes, }
}

///|
pub impl @debug.Debug for Font with fn to_repr(self) {
  @debug.Repr::literal("Font(\{self.bytes.length()} bytes)")
}

///|
pub extend Font with @debug.Debug::{to_repr}
