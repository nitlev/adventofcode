package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

// Grid represents the seats matrix
type Grid [][]rune

func readInput(filename string) Grid {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(file), "\n")
	spaces := make([][]rune, len(lines))
	for i, line := range lines {
		spaces[i] = []rune(line)
	}
	return spaces
}

func (grid Grid) display() {
	for _, row := range grid {
		fmt.Println(string(row))
	}
	fmt.Println("")
}

func (grid Grid) get(i, j int) rune {
	if i < 0 || i >= len(grid) {
		return '.'
	}
	if j < 0 || j >= len(grid[i]) {
		return '.'
	}
	return grid[i][j]
}

type coord struct {
	x, y int
}

func (grid Grid) getAdjacent(i, j, maxDist int) []rune {
	directions := [8]coord{
		{-1, -1},	{-1, 0}, 	{-1, 1},
		{0, -1},				{0, 1},
		{1, -1},	{1, 0}, 	{1, 1},
	}
	output := make([]rune, 0)
	for _, dir := range directions {
		for d:=1; d<=maxDist; d++ {
			if v:= grid.get(i + d * dir.x, j + d * dir.y); v != '.' {
				output = append(output, v)
				break
			}
		}
	}
	return output
}

func countAdjacentSeats(adjacents []rune) int {
	count := 0
	for _, v := range adjacents {
		if v == '#' {
			count++
		}
	}
	return count
}

func (grid Grid) nextState(i, j, max, dist int) (rune, bool) {
	currentValue := grid.get(i, j)
	adjacents := grid.getAdjacent(i, j, dist)
	count := countAdjacentSeats(adjacents)
	switch {
	case currentValue == 'L' && count == 0:
		return '#', true
	case currentValue == '#' && count >= max:
		return 'L', true
	default:
		return currentValue, false
	}
}

func (grid Grid) update(max, dist int) (Grid, bool) {
	newGrid := make([][]rune, len(grid))
	updated := false
	for i := range grid {
		newRow := make([]rune, len(grid[i]))
		for j := range grid[i] {
			newValue, changed := grid.nextState(i, j, max, dist)
			newRow[j] = newValue
			if changed {
				updated = true
			}
		}
		newGrid[i] = newRow
	}
	return newGrid, updated
}

func (grid Grid) countOccupied() int {
	count := 0
	for _, row := range grid {
		for _, v := range row {
			if v == '#' {
				count++
			}
		}
	}
	return count
}

func star1(grid Grid) {
	updated := true
	for i:=0; updated; i++ {
		grid, updated = grid.update(4, 1)
	}
	fmt.Println(grid.countOccupied())
}

func star2(grid Grid) {
	updated := true
	for i:=0; updated; i++ {
		// grid.display()
		grid, updated = grid.update(5, 5)
	}
	fmt.Println(grid.countOccupied())
}

func main() {
	grid := readInput("input.txt")
	star1(grid)
	star2(grid)
}
