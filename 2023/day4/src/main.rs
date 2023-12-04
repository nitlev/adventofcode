use std::{env, fs};

use day4::{star1, star2};

fn main() {
    let filepath = env::args().nth(1).expect("Must pass a filename as argument");
    let input = fs::read_to_string(filepath).expect("Could not read file");

    let star1_answer = star1(&input);
    println!("{star1_answer}");

    let star2_answer = star2(&input);
    println!("{star2_answer}")
}
