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
#derive(Eq, Hash)
struct Card(CardNum, CardSuit)

///|
pub extend Card with Eq::{not_equal, equal}

///|
pub extend Card with Hash::{hash, hash_combine}

///|
fn Card::to_sprite(self : Card) -> @sprite.Sprite {
  Sprite(
    image=Some(
      card_images[self.0.to_int() - 2][match self.1 {
        C => 0
        D => 1
        H => 2
        S => 3
      }],
    ),
    custom_size=Some(Vec2(59.0, 84.0)),
  )
}

///|
#derive(Eq, Hash)
enum CardNum {
  A
  N2
  N3
  N4
  N5
  N6
  N7
  N8
  N9
  N10
  J
  Q
  K
}

///|
pub extend CardNum with Eq::{not_equal, equal}

///|
pub extend CardNum with Hash::{hash, hash_combine}

///|
fn CardNum::to_int(self : CardNum) -> Int32 {
  match self {
    A => 14
    N2 => 2
    N3 => 3
    N4 => 4
    N5 => 5
    N6 => 6
    N7 => 7
    N8 => 8
    N9 => 9
    N10 => 10
    J => 11
    Q => 12
    K => 13
  }
}

///|
#derive(Eq, Hash)
enum CardSuit {
  H
  D
  C
  S
}

///|
pub extend CardSuit with Eq::{not_equal, equal}

///|
pub extend CardSuit with Hash::{hash, hash_combine}

///|
// Rows follow numeric rank 2 through ace; columns are clubs, diamonds, hearts, spades.
let card_images : Array[Array[@asset.ImageHandle]] = {
  let cards = @embedded_assets.assets.cards
  let bytes = [
    [cards.v_2_c_png, cards.v_2_d_png, cards.v_2_h_png, cards.v_2_s_png],
    [cards.v_3_c_png, cards.v_3_d_png, cards.v_3_h_png, cards.v_3_s_png],
    [cards.v_4_c_png, cards.v_4_d_png, cards.v_4_h_png, cards.v_4_s_png],
    [cards.v_5_c_png, cards.v_5_d_png, cards.v_5_h_png, cards.v_5_s_png],
    [cards.v_6_c_png, cards.v_6_d_png, cards.v_6_h_png, cards.v_6_s_png],
    [cards.v_7_c_png, cards.v_7_d_png, cards.v_7_h_png, cards.v_7_s_png],
    [cards.v_8_c_png, cards.v_8_d_png, cards.v_8_h_png, cards.v_8_s_png],
    [cards.v_9_c_png, cards.v_9_d_png, cards.v_9_h_png, cards.v_9_s_png],
    [cards.v_10_c_png, cards.v_10_d_png, cards.v_10_h_png, cards.v_10_s_png],
    [cards.j_c_png, cards.j_d_png, cards.j_h_png, cards.j_s_png],
    [cards.q_c_png, cards.q_d_png, cards.q_h_png, cards.q_s_png],
    [cards.k_c_png, cards.k_d_png, cards.k_h_png, cards.k_s_png],
    [cards.a_c_png, cards.a_d_png, cards.a_h_png, cards.a_s_png],
  ]
  bytes.map(row => {
    row.map(data => @asset.images.add(@asset.Image::from_bytes(data)))
  })
}
