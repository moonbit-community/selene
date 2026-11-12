///|
let catalogue : Map[String, Bytes] = Map([
  ("assets/cards/10-C.png", assets.cards.v_10_c_png),
  ("assets/cards/10-D.png", assets.cards.v_10_d_png),
  ("assets/cards/10-H.png", assets.cards.v_10_h_png),
  ("assets/cards/10-S.png", assets.cards.v_10_s_png),
  ("assets/cards/2-C.png", assets.cards.v_2_c_png),
  ("assets/cards/2-D.png", assets.cards.v_2_d_png),
  ("assets/cards/2-H.png", assets.cards.v_2_h_png),
  ("assets/cards/2-S.png", assets.cards.v_2_s_png),
  ("assets/cards/3-C.png", assets.cards.v_3_c_png),
  ("assets/cards/3-D.png", assets.cards.v_3_d_png),
  ("assets/cards/3-H.png", assets.cards.v_3_h_png),
  ("assets/cards/3-S.png", assets.cards.v_3_s_png),
  ("assets/cards/4-C.png", assets.cards.v_4_c_png),
  ("assets/cards/4-D.png", assets.cards.v_4_d_png),
  ("assets/cards/4-H.png", assets.cards.v_4_h_png),
  ("assets/cards/4-S.png", assets.cards.v_4_s_png),
  ("assets/cards/5-C.png", assets.cards.v_5_c_png),
  ("assets/cards/5-D.png", assets.cards.v_5_d_png),
  ("assets/cards/5-H.png", assets.cards.v_5_h_png),
  ("assets/cards/5-S.png", assets.cards.v_5_s_png),
  ("assets/cards/6-C.png", assets.cards.v_6_c_png),
  ("assets/cards/6-D.png", assets.cards.v_6_d_png),
  ("assets/cards/6-H.png", assets.cards.v_6_h_png),
  ("assets/cards/6-S.png", assets.cards.v_6_s_png),
  ("assets/cards/7-C.png", assets.cards.v_7_c_png),
  ("assets/cards/7-D.png", assets.cards.v_7_d_png),
  ("assets/cards/7-H.png", assets.cards.v_7_h_png),
  ("assets/cards/7-S.png", assets.cards.v_7_s_png),
  ("assets/cards/8-C.png", assets.cards.v_8_c_png),
  ("assets/cards/8-D.png", assets.cards.v_8_d_png),
  ("assets/cards/8-H.png", assets.cards.v_8_h_png),
  ("assets/cards/8-S.png", assets.cards.v_8_s_png),
  ("assets/cards/9-C.png", assets.cards.v_9_c_png),
  ("assets/cards/9-D.png", assets.cards.v_9_d_png),
  ("assets/cards/9-H.png", assets.cards.v_9_h_png),
  ("assets/cards/9-S.png", assets.cards.v_9_s_png),
  ("assets/cards/A-C.png", assets.cards.a_c_png),
  ("assets/cards/A-D.png", assets.cards.a_d_png),
  ("assets/cards/A-H.png", assets.cards.a_h_png),
  ("assets/cards/A-S.png", assets.cards.a_s_png),
  ("assets/cards/J-C.png", assets.cards.j_c_png),
  ("assets/cards/J-D.png", assets.cards.j_d_png),
  ("assets/cards/J-H.png", assets.cards.j_h_png),
  ("assets/cards/J-S.png", assets.cards.j_s_png),
  ("assets/cards/K-C.png", assets.cards.k_c_png),
  ("assets/cards/K-D.png", assets.cards.k_d_png),
  ("assets/cards/K-H.png", assets.cards.k_h_png),
  ("assets/cards/K-S.png", assets.cards.k_s_png),
  ("assets/cards/Q-C.png", assets.cards.q_c_png),
  ("assets/cards/Q-D.png", assets.cards.q_d_png),
  ("assets/cards/Q-H.png", assets.cards.q_h_png),
  ("assets/cards/Q-S.png", assets.cards.q_s_png),
  ("assets/cards/ThaleahFat.ttf", assets.cards.thaleahfat_ttf),
])

///|
pub fn read(path : String) -> Bytes? {
  catalogue.get(path)
}

///|
pub fn paths() -> Array[String] {
  catalogue.keys().collect()
}
