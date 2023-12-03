use std::{fs, env, str::Lines};

pub fn read_input() -> String {
    let filepath = env::args().nth(1).expect("A filepath should be passed to the command");
    fs::read_to_string(filepath).expect("File does not exist")
}


#[derive(Debug)]
struct ParsedNumber {
    value: u32,
    line: usize,
    start: usize,
    end: usize,
}

impl ParsedNumber {
    fn add(&mut self, d:u32) {
        self.value = 10 * self.value + d
    }

    fn is_part(&self, input: Lines) -> bool {
        let array: Vec<Vec<char>> = input.map(String::from).map(|l| l.chars().collect()).collect();

        // Check before on same line
        let current_line = array.get(self.line).unwrap();
        if self.start > 0 {
            match current_line.get(self.start - 1) {
                None => {},
                Some('.') => {},
                _ => return true
            }
        }

        // Check after on same line
        match current_line.get(self.end + 1) {
            None => {},
            Some('.') => {},
            _ => return true
        }

        // Previous lines
        if self.line > 0 {
            let line = array.get(self.line - 1).unwrap();
            let start = if self.start > 0 {self.start - 1} else {self.start};
            for i in (start)..(self.end + 2) {
                match line.get(i) {
                    None => {},
                    Some('.') => {},
                    Some('0'..='9') => {},
                    _ => return true
                }
            }
        }

        // Next lines
        if let Some(line) = array.get(self.line + 1) {
            let start = if self.start > 0 {self.start - 1} else {self.start};
            for i in (start)..(self.end + 2) {
                match line.get(i) {
                    None => {},
                    Some('.') => {},
                    Some('0'..='9') => {},
                    _ => return true
                }
            }
        }

        false
    }
}

fn new_parsed_number(line:usize) -> ParsedNumber {
    ParsedNumber{
        value: 0,
        line,
        start: 0,
        end:0
    }
}

fn parse_input(input: &str) -> Vec<ParsedNumber> {
    let mut numbers = Vec::new();
    for (line_number, line) in input.lines().enumerate() {
        let mut parsing = false;
        let mut number = new_parsed_number(line_number);
        for (position, c) in line.chars().enumerate() {
            match c.to_digit(10u32) {
                Some(d) => { 
                    if !parsing {
                        number.start = position;
                        parsing = true
                    }
                    number.add(d)
                }
                None => {
                    if parsing {
                        number.end = position - 1;
                        parsing = false;
                        numbers.push(number);
                        number = new_parsed_number(line_number)
                    }
                }
            }
        }
        if parsing {
            number.end = line.to_string().len() - 1;
            numbers.push(number)
        }
    }
    numbers
}

pub fn star1(input: String) -> u32 {
    let parsed_numbers = parse_input(&input);
    let parts: Vec<&ParsedNumber> = parsed_numbers.iter().filter(|n| n.is_part(input.lines())).collect();
    parts.iter().map(|p| p.value).sum()
}
