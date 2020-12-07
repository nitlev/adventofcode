package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func readInput(filename string) [][]string {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	groups := strings.Split(string(file), "\n\n")
	output := make([][]string, 0, len(groups))
	
	for _, group := range groups {
		output = append(output, strings.Split(group, "\n"))
	}
	return output
}

// unionAnswers finds all answers where ANYONE answered YES - for star 1
func unionAnswers(answers string, previousAnswers map[string]bool) map[string]bool {
	for _, l := range answers {
		previousAnswers[string(l)] = true
	}
	return previousAnswers
}

func unionOneGroupAnswers(groupAnswers []string) map[string]bool {
	output := map[string]bool{}
	for _, answers := range groupAnswers {
		output = unionAnswers(answers, output)
	}
	return output
}

// intersectAnswers finds all answers where EVERYONE answered YES - for star 2
func intersectAnswers(answers string, previousAnswers map[string]bool) map[string]bool {
	intersection := map[string]bool{}
	for _, l := range answers {
		if previousAnswers[string(l)] {
			intersection[string(l)] = true
		}
	}
	return intersection
}

func intersectOneGroupAnswers(groupAnswers []string) map[string]bool {
	output := unionAnswers(groupAnswers[0], map[string]bool{})
	for _, answers := range groupAnswers {
		output = intersectAnswers(answers, output)
	}
	return output
}

type combiner func(groupAnswers []string) map[string]bool

func gatherGroupsAnswers(groupsAnswers [][]string, f combiner) []map[string]bool {
	output := []map[string]bool{}
	for _, oneGroupAnswers := range groupsAnswers {
		output = append(output, f(oneGroupAnswers))
	}
	return output
}

func sumOfLengths(groupAnswers []map[string]bool) (sum int) {
	for _, groupAnswer := range groupAnswers {
		sum += len(groupAnswer)
	}
	return sum
}

func main() {
	input := readInput("input.txt")
	// allGroupsAnswers := gatherGroupsAnswers(input, unionOneGroupAnswers)  // for star1
	allGroupsAnswers := gatherGroupsAnswers(input, intersectOneGroupAnswers)  // for star2
	fmt.Println(sumOfLengths(allGroupsAnswers))
}