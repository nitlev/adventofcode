use std::collections::{HashSet, VecDeque};

struct Game {
    id: usize,
    winning_numbers: HashSet<u32>,
    revealed_numbers: HashSet<u32>,
}


fn parse_input(input: &str) -> Vec<Game> {
    let mut games = Vec::new();
    for (l, line) in input.lines().enumerate() {
        if let Some((_, numbers)) = line.split_once(':') {
            if let Some((winning_string, revealed_string)) = numbers.split_once('|') {
                games.push(Game { 
                    id: l,
                    winning_numbers: HashSet::from_iter(winning_string
                        .split_whitespace()
                        .map(|n| n.trim())
                        .map(|n| n.parse::<u32>().unwrap())
                    ),
                    revealed_numbers: HashSet::from_iter(revealed_string
                        .split_whitespace()
                        .map(|n| n.trim())
                        .map(|n| n.parse::<u32>().unwrap())
                    ),
                })
            }
        }
    }
    games
}

fn score(game: &Game) -> u32 {
    let winning_numbers:Vec<&u32> = game.revealed_numbers.intersection(&game.winning_numbers).collect();
    if !winning_numbers.is_empty() { 2u32.pow((winning_numbers.len() - 1) as u32) } else {0u32}
}

pub fn star1(input: &str) -> u32 {
    let games = parse_input(input);
    games.iter().map(score).sum()
}

fn winning_card_count(game: &Game) -> u32 {
    let winning_numbers:Vec<&u32> = game.revealed_numbers.intersection(&game.winning_numbers).collect();
    winning_numbers.len() as u32
}

pub fn star2(input: &str) -> u32 {
    let games = parse_input(input);
    let mut queue = VecDeque::from_iter(games.iter());

    let mut result = 0u32;
    while let Some(game) = queue.pop_front() {
        result += 1;
        let n = winning_card_count(game) as usize;
        if n > 0 {
            for i in (game.id + 1)..=(game.id + n) {
                if let Some(g) = games.get(i) {
                    queue.push_back(g)
                }
            }
        }
    }
    result
}
