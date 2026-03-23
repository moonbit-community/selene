// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// 2D image or texture rendered at a specific position and size.
///
/// Fields:
///
/// * `size` : Dimensions of the picture in 2D space as width and height.
/// * `tile_path` : File path or identifier for the image/texture resource.
/// * `transform` : Geometric transformation applied to the picture (rotation,
///   scale, etc.).
/// * `repeat` : How the picture should repeat when drawn larger than its
///   natural size.
///
/// Example:
///
/// ```moonbit nocheck
/// let _picture = @sprite.Picture::new(
///   @math.Vec2D(100.0, 50.0),
///   "assets/background.png",
///   transform=@math.Transform::new(),
///   repeat=@math.RepeatMode::NoRepeat,
/// )
/// ```
///
pub(all) struct Picture {
  size : @math.Vec2D
  image : @asset.ImageHandle
  transform : @math.Transform
  repeat : @math.RepeatMode
  mut color : @render.Color

  fn new(
    size : @math.Vec2D,
    tile_path : String,
    transform? : @math.Transform,
    repeat? : @math.RepeatMode,
    color? : @render.Color,
  ) -> Picture
}

///|
/// Creates a new `Picture` with the specified size, image path, and rendering
/// options.
///
/// Parameters:
///
/// * `size` : The dimensions of the picture as a 2D vector representing width
///   and height.
/// * `tile_path` : The file path or identifier for the image/texture resource
///   to be displayed.
/// * `transform` : The geometric transformation to apply to the picture
///   (rotation, scale, translation). Defaults to an identity transform.
/// * `repeat` : How the picture should repeat when drawn larger than its
///   natural size. Defaults to `NoRepeat`.
///
/// Returns a new `Picture` instance configured with the specified properties.
///
/// Example:
///
/// ```moonbit nocheck
/// let _picture = @sprite.Picture::new(
///   @math.Vec2D(100.0, 50.0),
///   "assets/background.png",
///   transform=@math.Transform::new(),
///   repeat=@math.RepeatMode::NoRepeat,
/// )
/// ```
///
pub fn Picture::new(
  size : @math.Vec2D,
  tile_path : String,
  transform? : @math.Transform = @math.Transform::new(),
  repeat? : @math.RepeatMode = NoRepeat,
  color? : @render.Color = { r: 255U, g: 255U, b: 255U, a: 1.0 },
) -> Picture {
  Picture::from_image(
    size,
    @asset.load_image(tile_path),
    transform~,
    repeat~,
    color~,
  )
}

///|
pub fn Picture::from_image(
  size : @math.Vec2D,
  image : @asset.ImageHandle,
  transform? : @math.Transform = @math.Transform::new(),
  repeat? : @math.RepeatMode = NoRepeat,
  color? : @render.Color = { r: 255U, g: 255U, b: 255U, a: 1.0 },
) -> Picture {
  { size, image, transform, repeat, color }
}

///|
/// Renders a picture sprite to the screen at the specified position using the
/// provided backend.
///
/// Parameters:
///
/// * `backend` : The rendering backend used to draw the picture to the screen.
/// * `picture` : The picture sprite containing the image path, size,
///   transformation, and repeat mode information.
/// * `pos` : The 2D position where the picture should be rendered, representing
///   the top-left corner coordinates.
///
fn render_picture(
  picture : Picture,
  pos : @math.Vec2D,
  scale_with_zoom : Bool,
  external_transform? : @math.Transform = @math.Transform::identity(),
) -> Unit {
  let size = if scale_with_zoom {
    @system.scale_vec2(picture.size)
  } else {
    picture.size
  }
  let picture_transform = if scale_with_zoom {
    @system.scale_transform_translation(picture.transform)
  } else {
    picture.transform
  }
  let transform = external_transform * picture_transform
  let command : @render2d_types.ImageDrawCommand2D = {
    image: picture.image,
    destination: @math.Rect::{ position: pos, size },
    source: None,
    repeat: picture.repeat,
    transform,
    color: picture.color,
  }
  @render2d.push_image(command)
}
