use crate::rules::what_is_hand;

pub type Result<T> = std::result::Result<T, HandError>;

#[derive(Debug, PartialEq)]
pub struct HandError {
    info: String,
}

impl std::fmt::Display for HandError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.info)
    }
}

impl HandError {
    pub fn new<S: AsRef<str>>(info: S) -> HandError {
        HandError {
            info: String::from(info.as_ref()),
        }
    }
}

#[derive(Debug, PartialEq)]
pub struct Hand {
    pub cards: [Card; 5],
}

impl Hand {
    pub fn from_str(txt: &str) -> Result<Hand> {
        let mut vec_cards = vec![];
        for item in txt.split_whitespace() {
            let card = Card::from_str(item)?;
            vec_cards.push(card)
        }

        if vec_cards.len() != 5 {
            return Err(HandError::new("Hand should contain five cards"));
        }

        let mut cards: [Card; 5] = [Card::default(); 5];
        for (i, card) in vec_cards.into_iter().enumerate() {
            cards[i] = card;
        }
        Ok(Hand { cards: cards })
    }

    pub fn iter<'a>(&'a self) -> Box<Iterator<Item = &Card> + 'a> {
        Box::new(self.cards.iter())
    }
    pub fn values<'a>(&'a self) -> Box<Iterator<Item = Value> + 'a> {
        Box::new(self.iter().map(|x| x.value))
    }

    pub fn suites<'a>(&'a self) -> Box<Iterator<Item = Suite> + 'a> {
        Box::new(self.iter().map(|x| x.suite))
    }

    pub fn sorted_hand(&self) -> Vec<Card> {
        let mut cards: Vec<Card> = self.iter().cloned().collect();
        cards.sort();
        cards
    }

    pub fn is_what(&self) -> Outcome {
        what_is_hand(self)
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        self.is_what().partial_cmp(&other.is_what())
    }
}

#[derive(Debug, PartialEq, PartialOrd)]
pub enum Outcome {
    HighCard(Card, Card, Card, Card, Card),
    Pair(Card),
    TwoPair(Card, Card),
    ThreeOfAKind(Card),
    FourOfAKind(Card),
    Flush(Card),
    Straight(Card),
    FullHouse(Card, Card),
    StraightFlush(Card),
}

impl Outcome {
    pub fn to_string(&self) -> String {
        match self {
            Outcome::HighCard(_, _, _, _, _) => String::from("High Card"),
            Outcome::Pair(_) => String::from("Pair"),
            Outcome::TwoPair(_, _) => String::from("Two Pair"),
            Outcome::ThreeOfAKind(_) => String::from("Three of a Kind"),
            Outcome::FourOfAKind(_) => String::from("Four of a Kind"),
            Outcome::Flush(_) => String::from("Flush"),
            Outcome::Straight(_) => String::from("Straight"),
            Outcome::FullHouse(_, _) => String::from("Full House"),
            Outcome::StraightFlush(_) => String::from("Straight Flush"),
        }
    }
}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
pub struct Card {
    pub suite: Suite,
    pub value: Value,
}

impl Card {
    pub fn from_str(txt: &str) -> Result<Card> {
        let mut suite: Option<Suite> = None;
        let mut value: Option<Value> = None;
        for c in txt.chars() {
            match Value::from_char(c) {
                Ok(x) => value = Some(x),
                Err(_) => (),
            };
            match Suite::from_char(c) {
                Ok(x) => suite = Some(x),
                Err(_) => (),
            };
        }

        if suite.is_none() | value.is_none() {
            return Err(HandError::new(format!("'{}' is not a valid card", txt)));
        }
        Ok(Card {
            suite: suite.unwrap(),
            value: value.unwrap(),
        })
    }

    pub fn to_name(&self) -> String {
        format!("{:?} of {:?}", self.value, self.suite)
    }
}

impl PartialOrd for Card {
    fn partial_cmp(&self, other: &Card) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Card {
    fn cmp(&self, other: &Card) -> std::cmp::Ordering {
        (self.value as u8).cmp(&(other.value as u8))
    }
}

impl Default for Card {
    fn default() -> Card {
        Card {
            suite: Suite::Hearts,
            value: Value::Two,
        }
    }
}

#[derive(Debug, PartialEq, Eq, Clone, Copy, Hash)]
pub enum Suite {
    Hearts,
    Spades,
    Diamonds,
    Clubs,
}

impl Suite {
    pub fn from_str(txt: &str) -> Result<Suite> {
        if txt.len() != 1 {
            return Err(HandError::new("Suite should be one character long"));
        };
        let suite = Suite::from_char(txt.chars().next().expect("should be length one"))?;
        Ok(suite)
    }

    pub fn from_char(txt: char) -> Result<Suite> {
        match txt {
            'H' => return Ok(Suite::Hearts),
            'S' => return Ok(Suite::Spades),
            'D' => return Ok(Suite::Diamonds),
            'C' => return Ok(Suite::Clubs),
            _ => (),
        };
        Err(HandError::new(format!("'{}' is not a valid suite", txt)))
    }
}

#[derive(Debug, PartialEq, PartialOrd, Eq, Clone, Copy)]
pub enum Value {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
    Ace,
}

impl Value {
    pub fn from_str(txt: &str) -> Result<Value> {
        if txt.len() != 1 {
            return Err(HandError::new("Value should be one character long"));
        };
        let value = Value::from_char(txt.chars().next().expect("should be length one"))?;
        Ok(value)
    }

    pub fn from_char(txt: char) -> Result<Value> {
        match txt {
            '2' => return Ok(Value::Two),
            '3' => return Ok(Value::Three),
            '4' => return Ok(Value::Four),
            '5' => return Ok(Value::Five),
            '6' => return Ok(Value::Six),
            '7' => return Ok(Value::Seven),
            '8' => return Ok(Value::Eight),
            '9' => return Ok(Value::Nine),
            'T' => return Ok(Value::Ten),
            'J' => return Ok(Value::Jack),
            'Q' => return Ok(Value::Queen),
            'K' => return Ok(Value::King),
            'A' => return Ok(Value::Ace),
            _ => (),
        };
        Err(HandError::new(format!("'{}' is not a valid value", txt)))
    }

    pub fn to_char(&self) -> char {
        match self {
            Value::Two => return '2',
            Value::Three => return '3',
            Value::Four => return '4',
            Value::Five => return '5',
            Value::Six => return '6',
            Value::Seven => return '7',
            Value::Eight => return '8',
            Value::Nine => return '9',
            Value::Ten => return 'T',
            Value::Jack => return 'J',
            Value::Queen => return 'Q',
            Value::King => return 'K',
            Value::Ace => return 'A',
        }
    }
}

impl Ord for Value {
    fn cmp(&self, other: &Value) -> std::cmp::Ordering {
        (*self as u8).cmp(&(*other as u8))
    }
}

#[test]
fn test_hand() {
    let hand = Hand::from_str("2H 3D 5S 9C KD");

    let expected: Result<Hand> = Ok(Hand {
        cards: [
            Card {
                suite: Suite::Hearts,
                value: Value::Two,
            },
            Card {
                suite: Suite::Diamonds,
                value: Value::Three,
            },
            Card {
                suite: Suite::Spades,
                value: Value::Five,
            },
            Card {
                suite: Suite::Clubs,
                value: Value::Nine,
            },
            Card {
                suite: Suite::Diamonds,
                value: Value::King,
            },
        ],
    });

    assert_eq!(hand, expected);
}

#[test]
fn test_hand_invalid_card() {
    assert!(Hand::from_str("testing").is_err())
}

#[test]
fn test_hand_not_enough_cards() {
    assert!(Hand::from_str("2H 3D 5S 9C").is_err())
}

#[test]
fn test_hand_invalid_card_2() {
    assert!(Hand::from_str("2H 3D 5S 9C QQ").is_err())
}

#[test]
fn test_compare_hands() {
    // full house
    let hand1 = Hand::from_str("2H KS 2S 2C KD").unwrap();
    // straight
    let hand2 = Hand::from_str("2H 3D 4S 6C 5D").unwrap();

    assert_eq!(Some(std::cmp::Ordering::Greater), hand1.partial_cmp(&hand2));
}

#[test]
fn test_compare_hands2() {
    // high card
    let hand1 = Hand::from_str("4H KD 2S 8C JD").unwrap();
    // high card
    let hand2 = Hand::from_str("2H 8D 4S JH KD").unwrap();

    assert_eq!(Some(std::cmp::Ordering::Equal), hand1.partial_cmp(&hand2));
}
