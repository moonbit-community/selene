///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Text2d {
  blend_mode : @render.BlendMode2D
}

///|
pub extend Text2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Text2d with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct TextBounds {
  width : Double
  height : Double
}

///|
pub extend TextBounds with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextBounds with Eq::{not_equal, equal}

///|
pub fn Text2d::Text2d(blend_mode~ : @render.BlendMode2D = Alpha) -> Text2d {
  { blend_mode, }
}

///|
pub fn TextBounds::TextBounds(width : Double, height : Double) -> TextBounds {
  { width: @cmp.maximum(0.0, width), height: @cmp.maximum(0.0, height), }
}
