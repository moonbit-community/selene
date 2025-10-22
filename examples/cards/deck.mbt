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
/// Initialize a full 52-card deck
fn create_deck() -> Array[Card] {
  let deck = []
  let ranks = [A, N2, N3, N4, N5, N6, N7, N8, N9, N10, J, Q, K]
  let suits = [H, D, C, S]
  for rank in ranks {
    for suit in suits {
      deck.push(Card(rank, suit))
    }
  }
  deck
}

///|
/// Shuffle the deck using Fisher-Yates algorithm
fn shuffle_deck(deck : Array[Card], rand : @random.Rand) -> Unit {
  for i in 0..<deck.length() {
    let range = (deck.length() - i).reinterpret_as_uint()
    let j_offset = rand.uint() % range
    let j = i + j_offset.reinterpret_as_int()
    let temp = deck[i]
    deck[i] = deck[j]
    deck[j] = temp
  }
}

///|
/// Deal one card from the deck
fn deal_card() -> Card? {
  if game_state.deck.length() > 0 {
    game_state.deck.pop()
  } else {
    None
  }
}
