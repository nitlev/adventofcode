use std::{fs, env, collections::HashMap};


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
    let mut indexes : Vec<(u32, u32)> = find_digits_indexes(line.to_string());

    // Sort using the index
    indexes.sort();

    let digits: Vec<u32> = indexes.iter().map(|(_, d)| *d).collect();
    10 * digits.first().unwrap() + digits.last().unwrap()
}

fn find_digits_indexes(s:String) -> Vec<(u32, u32)> {
    let mut digit_names = HashMap::new();
    digit_names.insert("one", 1);
    digit_names.insert("two", 2);
    digit_names.insert("three", 3);
    digit_names.insert("four", 4);
    digit_names.insert("five", 5);
    digit_names.insert("six", 6);
    digit_names.insert("seven", 7);
    digit_names.insert("eight", 8);
    digit_names.insert("nine", 9);
    digit_names.insert("1", 1);
    digit_names.insert("2", 2);
    digit_names.insert("3", 3);
    digit_names.insert("4", 4);
    digit_names.insert("5", 5);
    digit_names.insert("6", 6);
    digit_names.insert("7", 7);
    digit_names.insert("8", 8);
    digit_names.insert("9", 9);
    
    let mut indexes = Vec::new();
    for (name, value) in digit_names.into_iter() {
        for (i, _) in s.match_indices(name) {
            indexes.push((i as u32, value));
        }
    };
    indexes
}
