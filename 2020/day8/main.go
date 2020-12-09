package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type instruction struct {
	op string
	offset int
}


func parseInput(filename string) []instruction {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(file), "\n")
	instructions := make([]instruction, 0, len(lines))
	for _, line := range lines {
		split := strings.Split(line, " ")
		op := split[0]
		offset, _ := strconv.Atoi(split[1])
		instructions = append(instructions, instruction{op, offset})
	}
	return instructions
}

func runProgram(instructions []instruction, currentLine int, seenLines map[int]bool, accumulator int) (int, bool) {
	if currentLine >= len(instructions) {
		return accumulator, true
	}
	if seenLines[currentLine] {
		return accumulator, false
	}
	seenLines[currentLine] = true
	
	currentInstruction := instructions[currentLine]
	switch currentInstruction.op {
	case "acc":
		return runProgram(instructions, currentLine + 1, seenLines, accumulator + currentInstruction.offset)
	case "jmp":
		return runProgram(instructions, currentLine + currentInstruction.offset, seenLines, accumulator)
	case "nop":
		return runProgram(instructions, currentLine + 1, seenLines, accumulator)
	default:
		return accumulator, false
	} 
}

func modifyProgram(instructions []instruction, line int) ([]instruction, bool) {
	newProgram := make([]instruction, len(instructions))
	copy(newProgram, instructions)
	modifiedLine := instructions[line]
	switch modifiedLine.op {
	case "acc":
		return newProgram, false
	case "nop":
		newProgram[line] = instruction{"jmp", modifiedLine.offset}
		return newProgram, true
	case "jmp":
		newProgram[line] = instruction{"nop", modifiedLine.offset}
		return newProgram, true
	default:
		return newProgram, false
	}
}

func main() {
	instructions := parseInput("input.txt")
	for i := range instructions {
		if newProgram, wasChanged := modifyProgram(instructions, i); wasChanged {
			if acc, success := runProgram(newProgram, 0, map[int]bool{}, 0); success {
				fmt.Println(acc)
			}
		}
	}
}