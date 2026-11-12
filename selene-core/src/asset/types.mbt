///|
pub using @asset_types {
  type Assets,
  type Handle,
  type Image,
  type Audio,
  type Font,
  type PreparationState,
}

///|
pub let images : Assets[Image] = Assets()

///|
pub let audios : Assets[Audio] = Assets()

///|
pub let fonts : Assets[Font] = Assets()

///|
pub fn image_preparation_state(handle : ImageHandle) -> PreparationState {
  @platform_render.image_preparation_state(handle)
}

///|
pub fn font_preparation_state(handle : FontHandle) -> PreparationState {
  @platform_render.font_preparation_state(handle)
}

///|
pub fn audio_preparation_state(handle : AudioHandle) -> PreparationState {
  @platform_audio.preparation_state(handle)
}
