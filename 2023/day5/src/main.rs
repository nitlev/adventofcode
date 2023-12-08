use std::{env, fs};

use day5::{star1, star2};

fn main() {
    let filepath = env::args().nth(1).expect("Expect filepath as argument");
    let input = fs::read_to_string(filepath).expect("Could not read file");

    println!("{}", star1(&input));
    println!("{}", star2(&input))
}
