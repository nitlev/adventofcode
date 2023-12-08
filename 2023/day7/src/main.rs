use std::{env, fs, cmp, collections::HashMap, iter::zip};

fn main() {
    let filepath = env::args().nth(1).expect("Expects an argument");
    let content = fs::read_to_string(filepath).expect("Couldn't read file");

    let star1_answer = star1(&content);
    println!("{star1_answer}");
}


#[derive(Debug, Eq, Ord, PartialEq, PartialOrd, Hash)]
enum Card {
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

impl Card {
    fn from(c: char) -> Option<Card> {
        match c {
            'A' => Some(Card::Ace),
            'K' => Some(Card::King),
            'Q' => Some(Card::Queen),
            'J' => Some(Card::Jack),
            'T' => Some(Card::Ten),
            '9' => Some(Card::Nine),
            '8' => Some(Card::Eight),
            '7' => Some(Card::Seven),
            '6' => Some(Card::Six),
            '5' => Some(Card::Five),
            '4' => Some(Card::Four),
            '3' => Some(Card::Three),
            '2' => Some(Card::Two),
            _ => None
        }
    }
}

#[derive(Debug, Eq)]
struct Hand {
    cards: Vec<Card>,
    bid: u32,
}


#[derive(Debug, Eq, Ord, PartialEq, PartialOrd)]
enum HandType {
    HighCard,
    OnePair,
    TwoPairs,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        let hand_type_cmp = self.hand_type().cmp(&other.hand_type());
        if hand_type_cmp != cmp::Ordering::Equal {
            return hand_type_cmp
        }
        for (self_card, other_card) in zip(&self.cards, &other.cards) {
            if self_card.cmp(other_card) != cmp::Ordering::Equal {
                return self_card.cmp(other_card)
            }
        }
        cmp::Ordering::Equal
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Hand {
    fn eq(&self, other: &Self) -> bool {
        self.cmp(other) == cmp::Ordering::Equal
    }
}

impl Hand {
    fn from_string(s: &str) -> Hand {
        let (card_string, bid_string) = s.split_once(' ').unwrap();
        let cards: Vec<Card> = card_string.chars().filter_map(Card::from).collect();
        let bid: u32 = bid_string.parse().unwrap();
        Hand{cards, bid}
    }

    fn hand_type(&self) -> HandType {
        let mut card_counts: HashMap<&Card, u32> = HashMap::new();
        for card in &self.cards {
            *card_counts.entry(card).or_default() += 1
        }
        let mut sorted_counts: Vec<u32> = card_counts.values().cloned().collect();
        sorted_counts.sort();
        sorted_counts.reverse();

        let first_count = sorted_counts.first().unwrap();
        let second_count = sorted_counts.get(1).unwrap_or(&0);
        match (first_count, second_count) {
            (5, _) => HandType::FiveOfAKind,
            (4, _) => HandType::FourOfAKind,
            (3, 2) => HandType::FullHouse,
            (3, _) => HandType::ThreeOfAKind,
            (2, 2) => HandType::TwoPairs,
            (2, _) => HandType::OnePair,
            _ => HandType::HighCard
        }
    }
}

fn star1(input: &str) -> u32 {
    let mut hands: Vec<Hand> = input.lines().map(Hand::from_string).collect();
    hands.sort();

    hands
        .iter()
        .enumerate()
        .map(|(i, h)| ((i as u32) + 1) * h.bid)
        .sum()
}


#[cfg(test)]
mod test {
    use crate::{Hand, HandType};


    #[test]
    fn test_hand_to_hand_type() {
        assert_eq!(Hand::from_string("TTTTT 12").hand_type(), HandType::FiveOfAKind);
        assert_eq!(Hand::from_string("KKQKK 2").hand_type(), HandType::FourOfAKind);
        assert_eq!(Hand::from_string("275KJ 543").hand_type(), HandType::HighCard);
    }

    #[test]
    fn test_hand_comparison() {
        assert!(Hand::from_string("KKKKK 1") > Hand::from_string("KKKKA 1"));
        assert!(Hand::from_string("KKQKK 1") > Hand::from_string("KKKAA 1"));
        assert!(Hand::from_string("22332 1") > Hand::from_string("88779 1"));
        assert!(Hand::from_string("KQKQJ 1") > Hand::from_string("AA234 1"));
        assert!(Hand::from_string("22789 1") > Hand::from_string("AKQJT 1"));
    }
}
