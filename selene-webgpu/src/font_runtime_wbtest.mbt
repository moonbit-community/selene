///|
test "web font metrics revision follows current async readiness" {
  let family = "__selene_font_revision_test__"
  let first = begin_web_font_load(family)
  assert_eq(font_metrics_revision(family), 0U)

  mark_web_font_dom_ready(family, first)
  assert_eq(font_metrics_revision(family), 1U)
  mark_web_font_dom_ready(family, first)
  assert_eq(font_metrics_revision(family), 1U)

  mark_web_font_bytes_ready(family, first)
  assert_eq(font_metrics_revision(family), 2U)

  let second = begin_web_font_load(family)
  mark_web_font_dom_ready(family, first)
  mark_web_font_bytes_ready(family, first)
  assert_eq(font_metrics_revision(family), 2U)

  mark_web_font_bytes_ready(family, second)
  assert_eq(font_metrics_revision(family), 3U)
  mark_web_font_dom_ready(family, second)
  assert_eq(font_metrics_revision(family), 3U)
}
