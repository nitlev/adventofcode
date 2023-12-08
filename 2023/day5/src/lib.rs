
pub fn star1(input: &str) -> u64 {
    let (seed_section, mapping_section) = input.split_once("\n\n").unwrap();
    let seeds: Vec<u64> = seed_section
        .split_once(':')
        .unwrap()
        .1
        .split_whitespace()
        .map(|c| c.parse().unwrap())
        .collect();

    let mut mappings = Vec::new();
    for section in mapping_section.split("\n\n") {
        let mut map_ranges = Vec::new();
        let param_content = section.split_once('\n').unwrap().1;
        let params: Vec<Vec<u64>> = param_content
            .lines()
            .map(|l| l.split_whitespace().map(|d| d.parse().unwrap()).collect())
            .collect();
        for param in params {
            if let &[x, y, z] = &param[..3] {
                map_ranges.push(MapRange {
                    destination_from: x,
                    source_from: y,
                    range_size: z,
                })
            }
        }
        mappings.push(map_ranges)
    }
    println!("Finished building maps");

    let mut loc_number = u64::MAX;
    for seed in seeds {
        let mut s = seed;
        for mapping in mappings.iter() {
            s = map_to(s, mapping.iter().collect())
        }
        if s < loc_number {
            loc_number = s;
        }
    }
    loc_number
}

struct MapRange {
    destination_from: u64,
    source_from: u64,
    range_size: u64,
}


fn map_to(source: u64, mappings: Vec<&MapRange>) -> u64 {
    for mapping in mappings {
        if source >= mapping.source_from && source < mapping.source_from + mapping.range_size {
            return mapping.destination_from + source - mapping.source_from
        }
    }
    source
}

pub fn star2(_input: &str) -> u64 {
    1
}

#[cfg(test)]
mod tests {
    use crate::{map_to, MapRange};
    use crate::build_map;

    #[test]
    fn test_build_map() {
        // Given
        let mappings = vec![MapRange {
            destination_from: 50,
            source_from: 98,
            range_size: 2,
        }];

        assert_eq!(map_to(1, mappings.iter().collect()), 1);
        assert_eq!(map_to(98, mappings.iter().collect()), 50);
        assert_eq!(map_to(99, mappings.iter().collect()), 51);
        assert_eq!(map_to(100, mappings.iter().collect()), 100);
    }
}
