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
  "assets/cards/\{self.0.to_string()}-\{self.1.to_string()}.png"
}

///|
fn Card::to_sprite(self : Card) -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(@asset2.load_image(self.to_path())),
    custom_size=Some(Vec2D(59.0, 84.0)),
  )
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
