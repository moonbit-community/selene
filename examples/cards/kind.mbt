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
} derive(Show)

///|
/// Convert hand rank to display string
fn HandRank::hand_rank_to_string(rank : HandRank) -> String {
  match rank {
    HighCard(_) => "High Card"
    OnePair(_) => "One Pair"
    TwoPair(_, _) => "Two Pair"
    ThreeOfKind(_) => "Three of a Kind"
    Straight(_) => "Straight"
    Flush(_) => "Flush"
    FullHouse(_, _) => "Full House"
    FourOfKind(_) => "Four of a Kind"
    StraightFlush(v) => if v == 14 { "Royal Flush" } else { "Straight Flush" }
  }
}

///|
/// Get base award multiplier for each hand rank
fn hand_rank_base_award(rank : HandRank) -> Int {
  match rank {
    HighCard(n) => n
    OnePair(n) => 15 + n * 2
    TwoPair(m, n) => 50 + m * 2 + n * 2
    ThreeOfKind(n) => 120 + n * 3
    Straight(n) => 200 + n * 5
    Flush(n) => 300 + n * 5
    FullHouse(n, m) => 500 + n * 3 + m * 2
    FourOfKind(n) => 2000 + n * 4
    StraightFlush(14) => 20000
    StraightFlush(n) => 8000 + n * 5
  }
}

///|
/// Find the best 5-card hand from up to 7 cards by evaluating all combinations
fn find_best_hand(cards : Array[Card]) -> HandRank {
  if cards.length() < 5 {
    // For fewer than 5 cards, just evaluate what we have
    return eval_rank(cards)
  }
  if cards.length() == 5 {
    return eval_rank(cards)
  }

  // For 6-7 cards, we need to evaluate all C(n,5) combinations
  let mut best_rank = HighCard(0)
  let mut best_value = 0

  // Generate all 5-card combinations from 6-7 cards
  let n = cards.length()
  for i in 0..<n {
    for j in (i + 1)..<n {
      for k in (j + 1)..<n {
        for l in (k + 1)..<n {
          for m in (l + 1)..<n {
            let hand_5 = [cards[i], cards[j], cards[k], cards[l], cards[m]]
            let rank = eval_rank(hand_5)
            let value = hand_rank_base_award(rank)
            if value > best_value {
              best_value = value
              best_rank = rank
            }
          }
        }
      }
    }
  }
  best_rank
}

///|
fn count_by_num(hand : Array[Card]) -> Map[CardNum, Int] {
  let map = Map::new()
  for card in hand {
    let count = map.get(card.0).unwrap_or(0)
    map.set(card.0, count + 1)
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
  // Check if there's a suit with 5+ cards
  let suit_counts = count_by_suit(hand)
  for entry in suit_counts {
    if entry.1 >= 5 {
      // Found a flush, return the high card value of that suit
      let flush_cards = hand.filter(fn(c) { c.1 == entry.0 })
      let values = flush_cards.map(fn(c) { c.0.to_int() })
      values.sort()
      return Some(values[values.length() - 1])
    }
  }
  None
}

///|
fn eval_rank(hand : Array[Card]) -> HandRank {
  // For hands with fewer than 5 cards, we can still check for pairs, etc.
  let nums = count_by_num(hand)

  // Check for straight and flush only if we have exactly 5 cards
  if hand.length() == 5 {
    let straight = is_straight(hand)
    let flush = is_flush(hand)
    // StraightFlush
    if straight is Some(n) && flush is Some(_) {
      return StraightFlush(n)
    }
    // Flush
    if flush is Some(n) {
      return Flush(n)
    }
    // Straight
    if straight is Some(n) {
      return Straight(n)
    }
  }

  // FourOfKind
  for entry in nums {
    if entry.1 == 4 {
      return FourOfKind(entry.0.to_int())
    }
  }
  // FullHouse
  let mut three_kind : Int? = None
  let mut pair : Int? = None
  for entry in nums {
    if entry.1 == 3 {
      three_kind = Some(entry.0.to_int())
    }
    if entry.1 == 2 {
      pair = Some(entry.0.to_int())
    }
  }
  if three_kind is Some(n) && pair is Some(m) {
    return FullHouse(n, m)
  }
  // ThreeOfKind
  if three_kind is Some(n) {
    return ThreeOfKind(n)
  }
  // TwoPair
  let pairs = nums.iter().filter(fn(entry) { entry.1 == 2 }).to_array()
  if pairs.length() >= 2 {
    let pair_values = pairs.map(fn(entry) { entry.0.to_int() })
    pair_values.sort()
    let high_pair = pair_values[pair_values.length() - 1]
    let low_pair = pair_values[pair_values.length() - 2]
    return TwoPair(high_pair, low_pair)
  }
  // OnePair
  if pairs.length() == 1 {
    return OnePair(pairs[0].0.to_int())
  }
  // HighCard
  let card_values = hand.map(fn(c) { c.0.to_int() })
  card_values.sort()
  return HighCard(card_values[card_values.length() - 1])
}
