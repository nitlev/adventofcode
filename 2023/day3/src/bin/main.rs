use day3::{read_input, star1, star2};

fn main() {
    let input = read_input();

    let star1_answer = star1(&input);
    println!("{star1_answer}");

    let star2_answer = star2(&input);
    println!("{star2_answer}")
}
