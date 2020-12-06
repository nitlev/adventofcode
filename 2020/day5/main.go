package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)


func findValue(code string, split1, split2 byte, min, max int) int {
	if len(code) == 0 {
		return min
	}
	switch firstLetter := code[0]; firstLetter {
	case split1:
		return findValue(code[1:], split1, split2, min, (min + max) / 2)
	case split2:
		return findValue(code[1:], split1, split2, (min + max + 1) / 2, max)
	default:
		panic("Wrong code passed")
	}
}

func findRow(code string, min, max int) int {
	return findValue(code, 'F', 'B', min, max)
}

func findColumn(code string, min, max int) int {
	return findValue(code, 'L', 'R', min, max)
}

func readInput(filename string) []string {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	return strings.Split(string(file), "\n")
}

func computeID(code string) int {
	rowCode := code[:7]
	colCode := code[7:]
	return findRow(rowCode, 0, 127) * 8 + findColumn(colCode, 0, 7)
}

func main() {
	input := readInput("input.txt")
	takenSeats := [128][8]rune{}
	for row := range takenSeats {
		for col := range takenSeats[row] {
			takenSeats[row][col] = 'X'
		}
	}
	
	for _, code := range input {
		rowCode := code[:7]
		colCode := code[7:]
		row := findRow(rowCode, 0, 127)
		col := findColumn(colCode, 0, 7)
		takenSeats[row][col] = '.'
	}

	for i, row := range takenSeats {
		fmt.Println(i * 8, (i + 1) * 8 - 1, string(row[:]))
	}
}