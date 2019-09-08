use std::cmp::Ordering;

pub mod rules;
pub mod structs;

pub use structs::{Card, Hand, HandError, Outcome, Result, Suite, Value};

use std::io::{self, stdin, stdout, Write};

fn main() -> io::Result<()> {
    print!("Black: ");
    stdout().flush().unwrap();
    let mut buffer = String::new();

    stdin().read_line(&mut buffer)?;
    let black = match Hand::from_str(&buffer) {
        Ok(x) => x,
        Err(e) => return Ok(println!("{}", e)),
    };

    print!("White: ");
    stdout().flush().unwrap();

    buffer.clear();
    stdin().read_line(&mut buffer)?;

    let white = match Hand::from_str(&buffer) {
        Ok(x) => x,
        Err(e) => return Ok(println!("{}", e)),
    };

    // println!("{:?}", Hand::from_str("2H 3D 5S 9C KD"))

    // let black = Hand::from_str("2H 3D 6S 9C AD").unwrap();
    // let white = Hand::from_str("2H 3D 5S 9C AD").unwrap();

    let black_what = black.is_what();
    let white_what = white.is_what();

    match black_what.partial_cmp(&white_what) {
        Some(Ordering::Greater) => {
            let default = format!("Black WINS with '{}'", black_what.to_string());
            match why_winning(&black_what, &white_what) {
                Some(x) => println!("{} with '{}'", default, x),
                None => println!("{}", default),
            }
        }
        Some(Ordering::Equal) => {
            println!("TIE");
        }
        Some(Ordering::Less) => {
            let default = format!("White WINS with '{}'", white_what.to_string());
            match why_winning(&white_what, &black_what) {
                Some(x) => println!("{} with '{}'", default, x),
                None => println!("{}", default),
            }
        }
        None => {
            println!("something went wrong");
        }
    }
    Ok(())
}

fn why_winning(winnig_hand: &Outcome, losing_hand: &Outcome) -> Option<String> {
    match (winnig_hand, losing_hand) {
        (Outcome::HighCard(c1, c2, c3, c4, c5), Outcome::HighCard(t1, t2, t3, t4, t5)) => {
            if c1 == t1 {
                if c2 == t2 {
                    if c3 == t3 {
                        if c4 == t4 {
                            if c5 == t5 {
                                None
                            } else {
                                Some(c5.to_name())
                            }
                        } else {
                            Some(c4.to_name())
                        }
                    } else {
                        Some(c3.to_name())
                    }
                } else {
                    Some(c2.to_name())
                }
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::Pair(c1), Outcome::Pair(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::TwoPair(c1, c2), Outcome::TwoPair(t1, t2)) => {
            if c1 == t1 {
                if c2 == t2 {
                    None
                } else {
                    Some(c2.to_name())
                }
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::ThreeOfAKind(c1), Outcome::ThreeOfAKind(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::FourOfAKind(c1), Outcome::FourOfAKind(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::Flush(c1), Outcome::Flush(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::Straight(c1), Outcome::Straight(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::FullHouse(c1, c2), Outcome::FullHouse(t1, t2)) => {
            if c1 == t1 {
                if c2 == t2 {
                    None
                } else {
                    Some(c2.to_name())
                }
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::StraightFlush(c1), Outcome::StraightFlush(t1)) => {
            if c1 == t1 {
                None
            } else {
                Some(c1.to_name())
            }
        }
        (Outcome::HighCard(c1, _, _, _, _), _) => Some(c1.to_name()),
        (Outcome::Pair(c1), _) => Some(c1.to_name()),
        (Outcome::TwoPair(c1, _), _) => Some(c1.to_name()),
        (Outcome::ThreeOfAKind(c1), _) => Some(c1.to_name()),
        (Outcome::FourOfAKind(c1), _) => Some(c1.to_name()),
        (Outcome::Flush(c1), _) => Some(c1.to_name()),
        (Outcome::Straight(c1), _) => Some(c1.to_name()),
        (Outcome::FullHouse(c1, _), _) => Some(c1.to_name()),
        (Outcome::StraightFlush(c1), _) => Some(c1.to_name()),
    }
}
