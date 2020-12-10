package main

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strconv"
	"strings"
)

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


func orderAdapters(s []int) []int {
	sort.Ints(s)
	s = append([]int{0}, s...)
	s = append(s, s[len(s) - 1] + 3)
	return s
}

func computeDistribution(s []int) (n1 int, n3 int) {
	fmt.Println(s)
	for i, n := range s {
		if i < len(s) - 1 {
			switch s[i+1] - n {
			case 1:
				n1++
			case 3:
				n3++
			default:
				continue
			}
		}
	}
	return n1, n3
}

func computeContiguous(s []int) []int {
	sort.Ints(s)
	count := 1
	output := []int{}
	for i, n := range s {
		if i < len(s) - 1 {
			switch s[i+1] - n {
			case 1:
				count++
			case 3:
				output = append(output, count)
				count = 1
			default:
				continue
			}
		}
	}
	return output
}

func arrangements(nContiguous int) int {
	switch nContiguous {
	case 1:
		return 1
	case 2:
		return 1
	case 3:
		return 2
	default:
		return arrangements(nContiguous - 1) + arrangements(nContiguous - 2) + arrangements(nContiguous - 3)
	}
}

func totalArrangements(contiguousLentghs []int) int {
	acc := 1
	for _, l := range contiguousLentghs {
		fmt.Println(l, arrangements(l))
		acc *= arrangements(l)
	}
	return acc
}

func main() {
	input := readInput("input.txt")
	input = orderAdapters(input)
	n1, n3 := computeDistribution(input)
	fmt.Println(n1*n3)  // star 1

	contiguous := computeContiguous(input)
	fmt.Println(totalArrangements(contiguous))  // star 2
}