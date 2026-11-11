///|
pub fn push_image_with_depth(
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, None, Image(command), sorting~)
}

///|
pub fn push_image_with_depth_for_entity(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.ImageDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, entity_id, Image(command), sorting~)
}

///|
pub fn push_image_with_depth_to_camera(
  camera_entity_id : UInt32,
  depth : Double,
  command : @render2d_types.ImageDrawCommand2D,
  entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Image(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_image_with_depth(0.0, command)
}

///|
pub fn push_ui_image_to_camera(
  camera_entity_id : UInt32?,
  command : @render2d_types.ImageDrawCommand2D,
) -> Unit {
  push_ui_command(Image(command), camera_entity_id)
}

///|
pub fn push_ui_image(command : @render2d_types.ImageDrawCommand2D) -> Unit {
  push_ui_image_to_camera(None, command)
}

///|
pub fn push_text_with_depth(
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, None, Text(command), sorting~)
}

///|
pub fn push_text_with_depth_for_entity(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.TextDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, entity_id, Text(command), sorting~)
}

///|
pub fn push_text_with_depth_to_camera(
  camera_entity_id : UInt32,
  depth : Double,
  command : @render2d_types.TextDrawCommand2D,
  entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Text(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_text_with_depth(0.0, command)
}

///|
pub fn push_ui_text_to_camera(
  camera_entity_id : UInt32?,
  command : @render2d_types.TextDrawCommand2D,
) -> Unit {
  push_ui_command(Text(command), camera_entity_id)
}

///|
pub fn push_ui_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  push_ui_text_to_camera(None, command)
}

///|
pub fn push_rect_with_depth(
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, None, Rect(command), sorting~)
}

///|
pub fn push_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.RectDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, entity_id, Rect(command), sorting~)
}

///|
pub fn push_rect_with_depth_to_camera(
  camera_entity_id : UInt32,
  depth : Double,
  command : @render2d_types.RectDrawCommand2D,
  entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Rect(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_rect_to_camera(
  camera_entity_id : UInt32?,
  command : @render2d_types.RectDrawCommand2D,
) -> Unit {
  push_ui_command(Rect(command), camera_entity_id)
}

///|
pub fn push_ui_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  push_ui_rect_to_camera(None, command)
}

///|
pub fn push_circle_with_depth(
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, None, Circle(command), sorting~)
}

///|
pub fn push_circle_with_depth_for_entity(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.CircleDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, entity_id, Circle(command), sorting~)
}

///|
pub fn push_circle_with_depth_to_camera(
  camera_entity_id : UInt32,
  depth : Double,
  command : @render2d_types.CircleDrawCommand2D,
  entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    Circle(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_circle_with_depth(0.0, command)
}

///|
pub fn push_ui_circle_to_camera(
  camera_entity_id : UInt32?,
  command : @render2d_types.CircleDrawCommand2D,
) -> Unit {
  push_ui_command(Circle(command), camera_entity_id)
}

///|
pub fn push_ui_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  push_ui_circle_to_camera(None, command)
}

///|
pub fn push_gradient_rect_with_depth(
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, None, GradientRect(command), sorting~)
}

///|
pub fn push_gradient_rect_with_depth_for_entity(
  depth : Double,
  entity_id : UInt32?,
  command : @render2d_types.GradientRectDrawCommand2D,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(depth, entity_id, GradientRect(command), sorting~)
}

///|
pub fn push_gradient_rect_with_depth_to_camera(
  camera_entity_id : UInt32,
  depth : Double,
  command : @render2d_types.GradientRectDrawCommand2D,
  entity_id~ : UInt32? = None,
  sorting~ : Sorting2d = Sorting2d(),
) -> Unit {
  push_world_command(
    depth,
    entity_id,
    GradientRect(command),
    camera_entity_id=Some(camera_entity_id),
    sorting~,
  )
}

///|
pub fn push_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_gradient_rect_with_depth(0.0, command)
}

///|
pub fn push_ui_gradient_rect_to_camera(
  camera_entity_id : UInt32?,
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_ui_command(GradientRect(command), camera_entity_id)
}

///|
pub fn push_ui_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  push_ui_gradient_rect_to_camera(None, command)
}

///|
pub fn push_ui_clip_for_camera(
  rect : @math.Rect,
  camera_entity_id : UInt32?,
) -> Unit {
  push_ui_command(PushClip({ rect, }), camera_entity_id)
}

///|
pub fn push_ui_clip(rect : @math.Rect) -> Unit {
  push_ui_clip_for_camera(rect, None)
}

///|
pub fn pop_ui_clip_for_camera(camera_entity_id : UInt32?) -> Unit {
  push_ui_command(PopClip, camera_entity_id)
}

///|
pub fn pop_ui_clip() -> Unit {
  pop_ui_clip_for_camera(None)
}
