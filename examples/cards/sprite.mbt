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
struct Card(CardNum, CardSuit) derive(Eq, Hash)

///|
fn Card::to_path(self : Card) -> String {
  "assets/\{self.0.to_string()}-\{self.1.to_string()}.png"
}

///|
fn Card::to_sprite(self : Card, zindex : Int) -> @sprite.Sprite {
  let transform = @math.Transform::from_scale(0.2, 0.2)
  let anime = @sprite.Animation::single_frame(
    self.to_path(),
    Vec2D(295, 420),
    transform~,
  )
  @sprite.Sprite::from_animation(anime, zindex)
}

///|
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
} derive(Eq, Hash)

///|
fn CardNum::to_string(self : CardNum) -> String {
  match self {
    A => "A"
    N2 => "2"
    N3 => "3"
    N4 => "4"
    N5 => "5"
    N6 => "6"
    N7 => "7"
    N8 => "8"
    N9 => "9"
    N10 => "10"
    J => "J"
    Q => "Q"
    K => "K"
  }
}

///|
fn CardNum::to_int(self : CardNum) -> Int {
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
fn CardNum::from_string(s : String) -> CardNum {
  match s {
    "A" => A
    "2" => N2
    "3" => N3
    "4" => N4
    "5" => N5
    "6" => N6
    "7" => N7
    "8" => N8
    "9" => N9
    "10" => N10
    "J" => J
    "Q" => Q
    "K" => K
    _ => abort("Invalid card number string")
  }
}

///|
enum CardSuit {
  H
  D
  C
  S
} derive(Eq, Hash)

///|
fn CardSuit::to_string(self : CardSuit) -> String {
  match self {
    H => "H"
    D => "D"
    C => "C"
    S => "S"
  }
}

///|
fn CardSuit::from_string(s : String) -> CardSuit {
  match s {
    "H" => H
    "D" => D
    "C" => C
    "S" => S
    _ => abort("Invalid card suit string")
  }
}
