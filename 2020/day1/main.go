package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

// ReadInput returns the content of the input file as an array of ints
func ReadInput() []int {
	f, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(f), "\n")
	// Assign cap to avoid resize on every append.
	nums := make([]int, 0, len(lines))

	for _, l := range lines {
		// Empty line occurs at the end of the file when we use Split.
		if len(l) == 0 {
			continue
		}
		// Atoi better suits the job when we know exactly what we're dealing
		// with. Scanf is the more general option.
		n, err := strconv.Atoi(l)
		if err != nil {
			panic(err)
		}
		nums = append(nums, n)
	}
	return nums
}

// isSumEqual2020 checks if the sum of two numbers is 2020 - mostly useful for me to learn testing
func isSumEqual2020(a int, b int) bool {
	return a+b == 2020
}

// findPair finds two items in a list that add up to 2020 - returns 0, 0 if unsuccessful
func findPair(l []int) (a int, b int) {
	for _, e1 := range l {
		for _, e2 := range l {
			if isSumEqual2020(e1, e2) {
				return e1, e2
			}
		}
	}
	return 0, 0
}

// findPair finds three items in a list that add up to 2020 - returns 0, 0, 0 if unsuccessful
func findTrio(l []int) (a int, b int, c int) {
	for _, e1 := range l {
		for _, e2 := range l {
			for _, e3 := range l {
				if e1+e2+e3 == 2020 {
					return e1, e2, e3
				}
			}
		}
	}
	return 0, 0, 0
}

func main() {
	nums := ReadInput()
	a, b := findPair(nums)
	fmt.Println(a, b)
	fmt.Println(a * b)
	a, b, c := findTrio(nums)
	fmt.Println(a, b, c)
	fmt.Println(a * b * c)
}
