use std::{fs, env};

fn main() {
    let args:Vec<String> = env::args().collect();
    let filepath = &args[1];
    let content = fs::read_to_string(filepath);

    let calibrations:Vec<u32> = content
        .unwrap()
        .lines()
        .map(calibration_from_line)
        .collect();
    println!("{}", calibrations.iter().sum::<u32>())
}

fn calibration_from_line(line: &str) -> u32{
    const RADIX:u32 = 10;
    let digits: Vec<u32> = line
        .to_string()
        .chars()
        .filter_map(|c| c.to_digit(RADIX))
        .collect();
    10 * digits.first().unwrap() + digits.last().unwrap()
}
