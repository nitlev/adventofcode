use std::{fs, env};

#[derive(Debug)]
struct Draw {
    red: u32,
    green: u32,
    blue: u32,
}

#[derive(Debug)]
struct Game{
    id: u32,
    draws: Vec<Draw>,
}


impl Game {
    fn from_line(line: &str) -> Game {
        let mut split = line.split(':');

        let game_header = split.next().unwrap();

        let game_id = game_header.split_once(' ').unwrap().1.parse().unwrap();
        let draw_contents = split.next().unwrap().split(';');

        let mut draws = Vec::new();
        for draw_content in draw_contents {
            let mut draw = Draw{red:0, green:0, blue:0};
            for box_content in draw_content.split(',') {
                match box_content.trim().split_once(' ') {
                    Some((n, "red")) => {draw.red = n.parse().unwrap()}, 
                    Some((n, "blue")) => {draw.blue = n.parse().unwrap()}, 
                    Some((n, "green")) => {draw.green = n.parse().unwrap()}, 
                    _ => {println!("{:?}", box_content.split_once(' '))}
                }
            }
            draws.push(draw)
        }
        Game{id: game_id, draws}
    }

    fn max_draw(&self) -> Draw {
        let mut max_draw = Draw{red:0, green:0, blue:0};
        for draw in &self.draws {
            if draw.red > max_draw.red {
                max_draw.red = draw.red
            };
            if draw.green > max_draw.green {
                max_draw.green = draw.green
            };
            if draw.blue > max_draw.blue {
                max_draw.blue = draw.blue
            };
        }
        max_draw
    }

    fn power(&self) -> u32 {
        let max = &self.max_draw();
        max.red * max.green * max.blue
    }
}

fn main() {
    let args:Vec<String> = env::args().collect();
    let filepath = &args[1];
    let content = fs::read_to_string(filepath).unwrap();

    let games:Vec<Game> = content.lines().map(Game::from_line).collect();

    let mut powers: u32 = 0;
    for game in games {
        powers += game.power()
    }
    println!("{}", powers)
}
