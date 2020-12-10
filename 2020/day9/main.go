package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

const preambleLength = 25

func readInput(filename string) []int {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(file), "\n")
	numbers := make([]int, len(lines))
	for i, line := range lines {
		n, _ := strconv.Atoi(line)
		numbers[i] = n
	}
	return numbers
}

func findWrongNumber(cypher []int, preambleLength int) int {
	currentSlice := make([]int, 0)
	for i, n := range cypher {
		currentSlice = append(currentSlice, n)
		if i >= preambleLength {
			if !nextValueIsValid(n, currentSlice) {
				return n
			}
			currentSlice = currentSlice[1:]
		}
	} 
	return -1
}

func nextValueIsValid(n int, s []int) bool {
	for i, n1 := range s {
		for j, n2 := range s {
			if i != j && n1 + n2 == n {
				return true
			}
		}
	}
	return false
}


func findContiguousSet(cypher []int, n int) []int {
	contiguousSet := make([]int, 0)
	acc := 0
	i := 0
	j := 0
	for acc != n {
		if acc > n {
			acc -= cypher[i]
			contiguousSet = contiguousSet[1:]
			i++
		}
		if acc < n {
			acc += cypher[j]
			contiguousSet = append(contiguousSet, cypher[j])
			j++
		}
	}
	return contiguousSet
}

func minPlusMax(s []int) int {
	min := 1000000000000000
	max := 0
	for _, v := range s {
		if v < min {
			min = v
		}
		if v > max {
			max = v
		}
	}
	return min + max
}

func main() {
	input := readInput("input.txt")
	invalidNumber := findWrongNumber(input, preambleLength)
	fmt.Println(invalidNumber)
	contiguousSet := findContiguousSet(input, invalidNumber)
	fmt.Println(contiguousSet)
	fmt.Println(minPlusMax(contiguousSet))
}