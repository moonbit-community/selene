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
enum HandRank {
  HighCard(Int) // A-H 
  OnePair(Int) // A-H, A-D
  TwoPair(Int, Int) // A-H, A-D, 2-C, 2-D
  ThreeOfKind(Int) // A-H, A-D, A-C
  Straight(Int) // A-H, 2-D, 3-C, 4-D, 5-H
  Flush(Int) // A-H, 2-H, 3-H, 4-H, 5-H
  FullHouse(Int, Int) // A-H, A-D, 2-C, 2-D, 2-S
  FourOfKind(Int) // A-H, A-D, A-C, A-S
  StraightFlush(Int) // 10-D, J-D, Q-D, K-D, A-D
}

///|
fn count_by_num(hand : Array[Card]) -> Map[Card, Int] {
  let map = Map::new()
  for card in hand {
    let count = map.get(card).unwrap_or(0)
    map.set(card, count + 1)
  }
  map
}

///|
fn count_by_suit(hand : Array[Card]) -> Map[CardSuit, Int] {
  let map = Map::new()
  for card in hand {
    let count = map.get(card.1).unwrap_or(0)
    map.set(card.1, count + 1)
  }
  map
}

///|
fn is_straight(hand : Array[Card]) -> Int? {
  if count_by_num(hand).length() < 5 {
    return None
  }
  let hand = hand.map(fn(c) { c.0.to_int() })
  hand.sort()
  if hand[4] - hand[0] == 4 {
    return Some(hand[4])
  }
  if hand == [2, 3, 4, 5, 14] {
    return Some(14)
  }
  None
}

///|
fn is_flush(hand : Array[Card]) -> Int? {
  count_by_suit(hand).values().find_first(fn(c) { c >= 5 })
}

///|
fn eval_rank(hand : Array[Card]) -> HandRank {
  // StraightFlush 
  let straight = is_straight(hand)
  let flush = is_flush(hand)
  if straight is Some(n) && flush is Some(_) {
    return StraightFlush(n)
  }
  // FourOfKind
  let nums = count_by_num(hand)
  if nums.values().find_first(fn(c) { c == 4 }) is Some(n) {
    return FourOfKind(n)
  }
  // FullHouse
  if nums.values().find_first(fn(c) { c == 3 }) is Some(n) &&
    nums.values().find_first(fn(c) { c == 2 }) is Some(m) {
    return FullHouse(n, m)
  }
  // Flush
  if flush is Some(n) {
    return Flush(n)
  }
  // Straight
  if straight is Some(n) {
    return Straight(n)
  }
  // ThreeOfKind
  if nums.values().find_first(fn(c) { c == 3 }) is Some(n) {
    return ThreeOfKind(n)
  }
  // TwoPair
  // OnePair
  // HighCard
  ...
}
