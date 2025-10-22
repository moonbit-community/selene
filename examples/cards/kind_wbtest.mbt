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
/// Test find_best_hand with 1 card (should return HighCard with value 0)
test "find_best_hand: 1 card" {
  let cards = [Card(A, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="HighCard(14)")
}

///|
/// Test find_best_hand with 2 cards (should return HighCard with value 0)
test "find_best_hand: 2 cards" {
  let cards = [Card(A, H), Card(K, S)]
  let rank = find_best_hand(cards)
  inspect(rank, content="HighCard(14)")
}

///|
/// Test find_best_hand with 2 cards (should return HighCard with value 0)
test "find_best_hand: 2 cards one pair" {
  let cards = [Card(A, H), Card(A, S)]
  let rank = find_best_hand(cards)
  inspect(rank, content="OnePair(14)")
}

///|
/// Test find_best_hand with 3 cards (should return HighCard with value 0)
test "find_best_hand: 3 cards" {
  let cards = [Card(A, H), Card(K, S), Card(Q, D)]
  let rank = find_best_hand(cards)
  inspect(rank, content="HighCard(14)")
}

///|
test "find_best_hand: 3 cards ThreeOfKind" {
  let cards = [Card(K, H), Card(K, S), Card(K, D)]
  let rank = find_best_hand(cards)
  inspect(rank, content="ThreeOfKind(13)")
}

///|
/// Test find_best_hand with 4 cards (should return HighCard with value 0)
test "find_best_hand: 4 cards" {
  let cards = [Card(A, H), Card(K, S), Card(Q, D), Card(J, C)]
  let rank = find_best_hand(cards)
  inspect(rank, content="HighCard(14)")
}

///|
/// Test find_best_hand with 5 cards - High Card
test "find_best_hand: 5 cards - High Card" {
  let cards = [Card(A, H), Card(K, S), Card(Q, D), Card(J, C), Card(N9, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="HighCard(14)")
}

///|
/// Test find_best_hand with 5 cards - One Pair
test "find_best_hand: 5 cards - One Pair" {
  let cards = [Card(A, H), Card(A, S), Card(Q, D), Card(J, C), Card(N9, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="OnePair(14)")
}

///|
/// Test find_best_hand with 5 cards - Two Pair
test "find_best_hand: 5 cards - Two Pair" {
  let cards = [Card(A, H), Card(A, S), Card(K, D), Card(K, C), Card(N9, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="TwoPair(14, 13)")
}

///|
/// Test find_best_hand with 5 cards - Three of a Kind
test "find_best_hand: 5 cards - Three of a Kind" {
  let cards = [Card(A, H), Card(A, S), Card(A, D), Card(K, C), Card(N9, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="ThreeOfKind(14)")
}

///|
/// Test find_best_hand with 5 cards - Straight
test "find_best_hand: 5 cards - Straight" {
  let cards = [Card(A, H), Card(N2, S), Card(N3, D), Card(N4, C), Card(N5, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="Straight(14)")
}

///|
/// Test find_best_hand with 5 cards - Flush
test "find_best_hand: 5 cards - Flush" {
  let cards = [Card(A, H), Card(K, H), Card(Q, H), Card(J, H), Card(N9, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="Flush(14)")
}

///|
/// Test find_best_hand with 5 cards - Full House
test "find_best_hand: 5 cards - Full House" {
  let cards = [Card(A, H), Card(A, S), Card(A, D), Card(K, C), Card(K, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="FullHouse(14, 13)")
}

///|
/// Test find_best_hand with 5 cards - Four of a Kind
test "find_best_hand: 5 cards - Four of a Kind" {
  let cards = [Card(A, H), Card(A, S), Card(A, D), Card(A, C), Card(K, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="FourOfKind(14)")
}

///|
/// Test find_best_hand with 5 cards - Straight Flush (not Royal)
test "find_best_hand: 5 cards - Straight Flush" {
  let cards = [Card(N9, H), Card(N8, H), Card(N7, H), Card(N6, H), Card(N5, H)]
  let rank = find_best_hand(cards)
  inspect(rank, content="StraightFlush(9)")
}

///|
/// Test find_best_hand with 6 cards - should find best 5-card hand
test "find_best_hand: 6 cards - best hand is Flush" {
  // Has 5 hearts (Flush) vs Ace-King pair
  let cards = [
    Card(A, H),
    Card(K, H),
    Card(Q, H),
    Card(J, H),
    Card(N9, H),
    Card(A, S),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="Flush(14)")
}

///|
/// Test find_best_hand with 6 cards - should find Full House over Two Pair
test "find_best_hand: 6 cards - Full House" {
  let cards = [
    Card(A, H),
    Card(A, S),
    Card(A, D),
    Card(K, C),
    Card(K, H),
    Card(N9, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="FullHouse(14, 13)")
}

///|
/// Test find_best_hand with 7 cards - typical Hold'em scenario
test "find_best_hand: 7 cards - best hand is Straight" {
  // Hole: A♥, K♠
  // Community: Q♦, J♣, 10♥, 9♠, 2♣
  // Best hand: A-K-Q-J-10 Straight
  let cards = [
    Card(A, H),
    Card(K, S),
    Card(Q, D),
    Card(J, C),
    Card(N10, H),
    Card(N9, S),
    Card(N2, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="Straight(14)")
}

///|
/// Test find_best_hand with 7 cards - should find Flush
test "find_best_hand: 7 cards - Flush" {
  // 5 hearts total
  let cards = [
    Card(A, H),
    Card(K, H),
    Card(Q, H),
    Card(J, H),
    Card(N9, H),
    Card(N8, S),
    Card(N7, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="Flush(14)") // Royal Flush
}

///|
/// Test find_best_hand with 7 cards - Full House beats Flush
test "find_best_hand: 7 cards - Full House vs Flush" {
  // Hole: A♥, A♠
  // Community: A♦, K♥, K♠, Q♥, J♥
  // Has 4 hearts (almost flush) but Full House (AAA-KK) is better
  let cards = [
    Card(A, H),
    Card(A, S),
    Card(A, D),
    Card(K, H),
    Card(K, S),
    Card(Q, H),
    Card(J, H),
  ]
  let rank = find_best_hand(cards)
  // Full House base: 500 + 14*3 + 13*2 = 568
  // Flush base: 200 + 14*5 = 270
  inspect(rank, content="FullHouse(14, 13)")
}

///|
/// Test find_best_hand with 7 cards - Four of a Kind
test "find_best_hand: 7 cards - Four of a Kind" {
  let cards = [
    Card(A, H),
    Card(A, S),
    Card(A, D),
    Card(A, C),
    Card(K, H),
    Card(Q, S),
    Card(J, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="FourOfKind(14)")
}

///|
/// Test find_best_hand with 7 cards - finds best kicker for pair
test "find_best_hand: 7 cards - One Pair with best kicker" {
  // Pair of Aces, but many kickers - should find the best 5-card combo
  let cards = [
    Card(A, H),
    Card(A, S),
    Card(K, D),
    Card(Q, C),
    Card(J, H),
    Card(N10, S),
    Card(N2, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="Straight(14)")
}

///|
/// Test find_best_hand with 7 cards - Two Pair picks higher pairs
test "find_best_hand: 7 cards - Two Pair" {
  // Has A-A, K-K, Q-Q - should pick A-A and K-K
  let cards = [
    Card(A, H),
    Card(A, S),
    Card(K, D),
    Card(K, C),
    Card(Q, H),
    Card(Q, S),
    Card(N2, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="TwoPair(14, 13)")
}

///|
/// Test find_best_hand with 7 cards - Wheel straight (A-2-3-4-5)
test "find_best_hand: 7 cards - Wheel Straight" {
  let cards = [
    Card(A, H),
    Card(N2, S),
    Card(N3, D),
    Card(N4, C),
    Card(N5, H),
    Card(K, S),
    Card(Q, C),
  ]
  let rank = find_best_hand(cards)
  inspect(rank, content="Straight(14)")
}
