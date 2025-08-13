///|
pub(all) struct Ui {}

///|
pub fn Ui::new() -> Ui {
  Ui::{  }
}

///|
pub let uis : Map[@system.Entity, Ui] = Map::new()

///|
pub const UI_ZINDEX = 100
