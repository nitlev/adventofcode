package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

type bag struct {
	adjective string	
	color string
}

type rule struct {
	bag bag
	capacity map[bag]int
}

func readInput(filename string) []string {
	file, err := ioutil.ReadFile((filename))
	if err != nil {
		panic(err)
	}
	return strings.Split(string(file), "\n")
}

func parseBag(s string) bag {
	pattern := regexp.MustCompile(`(\w+) (\w+) bags?`)
	match := pattern.FindStringSubmatch(s)
	return bag{
		match[1],
		match[2],
	}
}

func parseCapacity(s string) (bag, int) {
	pattern := regexp.MustCompile(`(\w+) (.+)`)
	match := pattern.FindStringSubmatch(s)
	if match[1] != "no" {
		quantity, _ := strconv.Atoi(match[1])
		return parseBag(match[2]), quantity
	}
	return bag{}, 0
}

func parseLine(line string) rule {
	s := strings.Split(line, " contain ")
	container := s[0]
	contents := strings.Split(s[1], ",")
	capacity := map[bag]int{}
	for _, s := range contents {
		bag, quantity := parseCapacity(s)
		capacity[bag] = quantity
	}
	return rule{parseBag(container), capacity}
}

func parseRules(lines []string) []rule {
	output := make([]rule, 0, len(lines))
	for _, line := range lines {
		output = append(output, parseLine(line))
	}
	return output
}

type bagSet map[bag]bool

type bagGraph map[bag]bagSet

func rulesToGraph(rules []rule) bagGraph {
	output := bagGraph{}
	for _, rule := range rules {
		for bag := range rule.capacity {
			s, ok := output[bag]
			if ok {
				s[rule.bag] = true
			} else {
				s = bagSet{rule.bag: true}
			}
			output[bag] = s
		}
	}
	return output
}

func keys(bs bagSet) []bag {
	k := make([]bag, 0, len(bs))
	for b := range bs {
		k = append(k, b)
	}
	return k
}

func searchGraph(graph bagGraph, b bag) []bag {
	seenBags := map[bag]bool{}
	bagsToCheck := keys(graph[b])
	for len(bagsToCheck) > 0 {
		nextBag := bagsToCheck[0]
		if _, found := seenBags[nextBag]; !found {
			seenBags[nextBag] = true
			for newBag := range graph[nextBag] {
				bagsToCheck = append(bagsToCheck, newBag)
			}
		}
		bagsToCheck = bagsToCheck[1:]
	}
	return keys(seenBags)
}

// star 2
type bagCount map[bag]int

type bagCountGraph map[bag]bagCount

func rulesToGraph2(rules []rule) bagCountGraph {
	output := bagCountGraph{}
	for _, rule := range rules {
		bc := bagCount{}
		for bag, quantity := range rule.capacity {
			bc[bag] = quantity
		}
		output[rule.bag] = bc
	}
	return output
}

func countBags(graph bagCountGraph, startingBag bag) int {
	count := 0
	bagsToCheck := graph[startingBag]
	for bag, n := range bagsToCheck {
		count += n * (1 + countBags(graph, bag))
	}
	return count
}

func main() {
	lines := readInput("input.txt")
	rules := parseRules(lines)
	graph := rulesToGraph(rules)
	possibleBags := searchGraph(graph, bag{"shiny", "gold"})
	fmt.Println(len(possibleBags))
	
	graphCount := rulesToGraph2(rules)
	n := countBags(graphCount, bag{"shiny", "gold"}) 
	fmt.Println(n)
}