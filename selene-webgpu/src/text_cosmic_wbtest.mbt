///|
test "cosmic text pixels use style color with glyph coverage alpha" {
  let (r, g, b, a) = styled_text_pixel_rgba(
    @render.Color::{ r: 255U, g: 0U, b: 0U, a: 1.0 },
    191,
  )
  inspect(r, content="255")
  inspect(g, content="0")
  inspect(b, content="0")
  inspect(a, content="191")
}
