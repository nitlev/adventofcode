package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func readInput() [][]bool {
	f, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(f), "\n")
	rows := make([][]bool, 0, len(lines))

	for _, l := range lines {
		// Empty line occurs at the end of the file when we use Split.
		if len(l) == 0 {
			continue
		}
		row := make([]bool, 0, len(l))

		for _, r := range l {
			row = append(row, r == '#')
		}
		rows = append(rows, row)
	}
	return rows
}

func isTreeAt(row []bool, position int) bool {
	return row[position % len(row)]
}

// Slope has a dx and a dy (duh)
type Slope struct {
	dx int
	dy int
}

func coordinatesGenerator(slope Slope) (func() (int, int)) {
	x, y := -slope.dx, -slope.dy
	return func() (int, int) {
		x, y = x + slope.dx, y + slope.dy
		return x, y
	}
}


func countHits(rows [][]bool, slope Slope) int {
	updateCoordinates := coordinatesGenerator(slope)
	count := 0
	for x, y := updateCoordinates(); x < len(rows); x, y = updateCoordinates() {
		if isTreeAt(rows[x], y) {
			count++
		}
	}
	return count
}

func main() {
	rows := readInput()
	slopes := []Slope{
		{1, 1},
		{1, 3},
		{1, 5},
		{1, 7},
		{2, 1},
	}
	mul := 1
	for _, slope := range slopes {
		count := countHits(rows, slope)
		fmt.Println(count)
		mul *= count
	}
	fmt.Println(mul)
}
