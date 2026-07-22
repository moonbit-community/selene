///|
priv struct PreparedTextLayout {
  lines : Array[String]
  width : Double
  height : Double
}

///|
fn prepare_text_layout(
  content : String,
  style : @render2d_types.TextStyle2D,
  layout : TextLayout,
  available_width : @geometry.AvailableSpace,
) -> PreparedTextLayout {
  let wrap_width : Double? = match available_width {
    AvailDefinite(width) => Some(@cmp.maximum(0.0, width))
    AvailMaxContent => None
    AvailMinContent => {
      let mut longest = 0.0
      for raw_line in content.split("\n") {
        for word in raw_line.split(" ") {
          longest = @cmp.maximum(
            longest,
            measure_text_fragment(style, word.to_owned())[X],
          )
        }
      }
      Some(longest)
    }
  }
  let lines : Array[String] = []
  for raw_line_view in content.split("\n") {
    let raw_line = raw_line_view.to_owned()
    match (layout.wrap, wrap_width) {
      (WordWrap, Some(max_width)) =>
        for line in wrap_line(style, raw_line, max_width) {
          lines.push(
            match (layout.overflow, available_width) {
              (Ellipsis, AvailDefinite(_)) =>
                truncate_line(style, line, max_width)
              _ => line
            },
          )
        }
      _ =>
        lines.push(
          match (layout.overflow, available_width) {
            (Ellipsis, AvailDefinite(max_width)) =>
              truncate_line(style, raw_line, max_width)
            _ => raw_line
          },
        )
    }
  }
  let mut width = 0.0
  for line in lines {
    width = @cmp.maximum(width, measure_text_fragment(style, line)[X])
  }
  let line_height = style.size * @cmp.maximum(1.0, layout.line_height)
  { lines, width, height: line_height * lines.length().to_double() }
}
