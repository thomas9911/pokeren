use crate::{Card, Hand, Outcome, Suite, Value};
use std::collections::HashSet;

pub fn what_is_hand(hand: &Hand) -> Outcome {
    if let Some(x) = get_straight_flush(hand) {
        return x;
    }
    if let Some(x) = get_full_house(hand) {
        return x;
    }
    if let Some(x) = get_straight(hand) {
        return x;
    }
    if let Some(x) = get_flush(hand) {
        return x;
    }
    if let Some(x) = get_four_of_a_kind(hand) {
        return x;
    }
    if let Some(x) = get_three_of_a_kind(hand) {
        return x;
    }
    if let Some(x) = get_two_pairs(hand) {
        return x;
    }
    if let Some(x) = get_pair(hand) {
        return x;
    }

    let mut vs: Vec<Card> = hand.iter().cloned().collect();
    vs.sort();

    Outcome::HighCard(vs[4], vs[3], vs[2], vs[1], vs[0])
}

pub fn is_straight(hand: &Hand) -> bool {
    get_straight(hand).is_some()
}
pub fn is_flush(hand: &Hand) -> bool {
    get_flush(hand).is_some()
}
pub fn is_straight_flush(hand: &Hand) -> bool {
    get_straight_flush(hand).is_some()
}
pub fn is_pair(hand: &Hand) -> bool {
    get_pair(hand).is_some()
}
pub fn is_two_pairs(hand: &Hand) -> bool {
    get_two_pairs(hand).is_some()
}
pub fn is_three_of_a_kind(hand: &Hand) -> bool {
    get_three_of_a_kind(hand).is_some()
}
pub fn is_four_of_a_kind(hand: &Hand) -> bool {
    get_four_of_a_kind(hand).is_some()
}
pub fn is_full_house(hand: &Hand) -> bool {
    get_full_house(hand).is_some()
}

pub fn get_straight(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();
    let cards = hand.sorted_hand();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    if differences == [1, 1, 1, 1] {
        Some(Outcome::Straight(
            cards.last().expect("hand is not empty").to_owned(),
        ))
    } else {
        None
    }
}

pub fn get_flush(hand: &Hand) -> Option<Outcome> {
    let suites_in_hand: HashSet<Suite> = hand.suites().collect();
    let cards = hand.sorted_hand();

    if suites_in_hand.len() == 1 {
        Some(Outcome::Flush(
            cards.last().expect("hand is not empty").to_owned(),
        ))
    } else {
        None
    }
}

pub fn get_straight_flush(hand: &Hand) -> Option<Outcome> {
    if is_straight(hand) {
        match get_flush(hand) {
            Some(x) => match x {
                Outcome::Flush(y) => Some(Outcome::StraightFlush(y)),
                _ => unreachable!(),
            },
            None => None,
        }
    } else {
        None
    }
}

pub fn get_pair(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();
    let cards = hand.sorted_hand();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    // let count_pairs = vs
    //     .windows(2)
    //     .map(|x| x[1] as u8 - x[0] as u8)
    //     .filter(|x| x == &0)
    //     .count();

    let count_pairs = differences.iter().filter(|x| x == &&0).count();

    if count_pairs == 1 {
        let pos = differences
            .iter()
            .position(|x| x == &0)
            .expect("differences should have a zero")
            + 1;
        Some(Outcome::Pair(
            cards.get(pos).expect("hand is not empty").to_owned(),
        ))
    } else {
        None
    }
}

pub fn get_two_pairs(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    for slice in differences.windows(2) {
        if slice.iter().filter(|x| x == &&0).count() != 1 {
            return None;
        }
    }

    let sorted_hand = hand.sorted_hand();

    let important_cards: Vec<usize> = differences
        .iter()
        .enumerate()
        .filter_map(|(i, x)| match x == &0 {
            true => Some(i + 1),
            false => None,
        })
        .collect();

    let card1 = sorted_hand[important_cards[0]];
    let card2 = sorted_hand[important_cards[1]];

    Some(Outcome::TwoPair(card2, card1))
}

pub fn get_three_of_a_kind(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    for slice in differences.windows(3) {
        if slice == [0, 0, 0] {
            return None;
        } else {
            if ([slice[0], slice[1]] == [0, 0]) | ([slice[1], slice[2]] == [0, 0]) {
                // return true;
                let sorted_hand = hand.sorted_hand();
                let important_cards: Vec<usize> = differences
                    .iter()
                    .enumerate()
                    .filter_map(|(i, x)| match x == &0 {
                        true => Some(i + 1),
                        false => None,
                    })
                    .collect();
                let card1 = sorted_hand[*important_cards.last().expect("kaas")];
                // println!("{:?}", card1);
                // println!("{:?}", sorted_hand);
                // return None
                return Some(Outcome::ThreeOfAKind(card1));
            }
        }
    }
    None
}

pub fn get_four_of_a_kind(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    for slice in differences.windows(3) {
        if slice == [0, 0, 0] {
            let sorted_hand = hand.sorted_hand();
            let important_cards: Vec<usize> = differences
                .iter()
                .enumerate()
                .filter_map(|(i, x)| match x == &0 {
                    true => Some(i + 1),
                    false => None,
                })
                .collect();
            let card1 = sorted_hand[*important_cards.last().expect("kaas")];
            return Some(Outcome::FourOfAKind(card1));
        }
    }
    None
}

pub fn get_full_house(hand: &Hand) -> Option<Outcome> {
    let mut vs: Vec<Value> = hand.values().collect();
    vs.sort();

    let differences: Vec<u8> = vs.windows(2).map(|x| x[1] as u8 - x[0] as u8).collect();

    let sorted_hand = hand.sorted_hand();
    if [differences[0], differences[1], differences[3]] == [0, 0, 0] {
        let card1 = sorted_hand[2];
        let card2 = sorted_hand[4];
        Some(Outcome::FullHouse(card1, card2))
    } else if [differences[0], differences[2], differences[3]] == [0, 0, 0] {
        let card1 = sorted_hand[1];
        let card2 = sorted_hand[4];
        Some(Outcome::FullHouse(card2, card1))
    } else {
        None
    }
}

#[cfg(test)]
mod tests {
    use crate::rules::*;
    use crate::{Card, Hand, Suite, Value};

    fn high_card() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Queen,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    fn pair() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    fn two_pair() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Seven,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    fn three_of_a_kind() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    fn three_of_a_kind_2() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Ace,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Ace,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Ace,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Two,
                },
            ],
        }
    }

    fn four_of_a_kind() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::King,
                },
            ],
        }
    }

    fn full_house() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Ace,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Ace,
                },
            ],
        }
    }

    fn straight() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Four,
                },
                Card {
                    suite: Suite::Hearts,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Spades,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Clubs,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    fn flush() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Jack,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Ace,
                },
            ],
        }
    }

    fn straight_flush() -> Hand {
        Hand {
            cards: [
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Four,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Three,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Five,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Six,
                },
                Card {
                    suite: Suite::Diamonds,
                    value: Value::Seven,
                },
            ],
        }
    }

    #[test]
    fn test_is_straight() {
        let hand = straight();
        assert_eq!(true, is_straight(&hand));
        let hand = flush();
        assert_eq!(false, is_straight(&hand));
    }

    #[test]
    fn test_is_flush() {
        let hand = flush();
        assert_eq!(true, is_flush(&hand));
        let hand = straight();
        assert_eq!(false, is_flush(&hand));
    }

    #[test]
    fn test_is_straight_flush() {
        let hand = straight_flush();
        assert_eq!(true, is_straight_flush(&hand));
        let hand = straight();
        assert_eq!(false, is_straight_flush(&hand));
    }

    #[test]
    fn test_is_pair() {
        let hand = pair();
        assert_eq!(true, is_pair(&hand));
        let hand = full_house();
        assert_eq!(false, is_pair(&hand));
        let hand = straight();
        assert_eq!(false, is_pair(&hand));
    }

    #[test]
    fn test_is_two_pairs() {
        let hand = two_pair();
        assert_eq!(true, is_two_pairs(&hand));
        let hand = pair();
        assert_eq!(false, is_two_pairs(&hand));
        let hand = straight();
        assert_eq!(false, is_two_pairs(&hand));
    }

    #[test]
    fn test_is_three_of_a_kind() {
        let hand = three_of_a_kind();
        assert_eq!(true, is_three_of_a_kind(&hand));
        let hand = four_of_a_kind();
        assert_eq!(false, is_three_of_a_kind(&hand));
        let hand = straight();
        assert_eq!(false, is_three_of_a_kind(&hand));
        let hand = three_of_a_kind_2();
        assert_eq!(true, is_three_of_a_kind(&hand));

    }

    #[test]
    fn test_is_four_of_a_kind() {
        let hand = four_of_a_kind();
        assert_eq!(true, is_four_of_a_kind(&hand));
        let hand = three_of_a_kind();
        assert_eq!(false, is_four_of_a_kind(&hand));
        let hand = straight();
        assert_eq!(false, is_four_of_a_kind(&hand));
        let hand = full_house();
        assert_eq!(false, is_four_of_a_kind(&hand));
    }

    #[test]
    fn test_is_full_house() {
        let hand = full_house();
        assert_eq!(true, is_full_house(&hand));
        let hand = three_of_a_kind();
        assert_eq!(false, is_full_house(&hand));
        let hand = pair();
        assert_eq!(false, is_full_house(&hand));
        let hand = two_pair();
        assert_eq!(false, is_full_house(&hand));
        let hand = four_of_a_kind();
        assert_eq!(false, is_full_house(&hand));
        let hand = straight();
        assert_eq!(false, is_full_house(&hand));
    }

    #[test]
    fn test_what_is_hand_hc() {
        let hand = high_card();
        let expected = Outcome::HighCard(
            Card {
                suite: Suite::Diamonds,
                value: Value::Queen,
            },
            Card {
                suite: Suite::Diamonds,
                value: Value::Seven,
            },
            Card {
                suite: Suite::Clubs,
                value: Value::Six,
            },
            Card {
                suite: Suite::Spades,
                value: Value::Five,
            },
            Card {
                suite: Suite::Hearts,
                value: Value::Three,
            },
        );
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_p() {
        let hand = pair();
        let expected = Outcome::Pair(Card {
            suite: Suite::Clubs,
            value: Value::Six,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_2p() {
        let hand = two_pair();
        let expected = Outcome::TwoPair(
            Card {
                suite: Suite::Diamonds,
                value: Value::Seven,
            },
            Card {
                suite: Suite::Clubs,
                value: Value::Six,
            },
        );
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_3k() {
        let hand = three_of_a_kind();
        let expected = Outcome::ThreeOfAKind(Card {
            suite: Suite::Clubs,
            value: Value::Six,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_4k() {
        let hand = four_of_a_kind();
        let expected = Outcome::FourOfAKind(Card {
            suite: Suite::Clubs,
            value: Value::Six,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_f() {
        let hand = flush();
        let expected = Outcome::Flush(Card {
            suite: Suite::Diamonds,
            value: Value::Ace,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_s() {
        let hand = straight();
        let expected = Outcome::Straight(Card {
            suite: Suite::Diamonds,
            value: Value::Seven,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_fh() {
        let hand = full_house();
        let expected = Outcome::FullHouse(
            Card {
                suite: Suite::Clubs,
                value: Value::Six,
            },
            Card {
                suite: Suite::Diamonds,
                value: Value::Ace,
            },
        );
        assert_eq!(expected, what_is_hand(&hand));
    }

    #[test]
    fn test_what_is_hand_sf() {
        let hand = straight_flush();
        let expected = Outcome::StraightFlush(Card {
            suite: Suite::Diamonds,
            value: Value::Seven,
        });
        assert_eq!(expected, what_is_hand(&hand));
    }

}
