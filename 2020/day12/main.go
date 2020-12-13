package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
	"math"
)

type instruction struct {
	op rune
	value int
}

func readInput(filename string) []instruction {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(file), "\n")
	instructions := make([]instruction, len(lines))
	for i, line := range lines {
		v, _ := strconv.Atoi(line[1:])
		instruction := instruction{
			rune(line[0]),
			v,
		}
		instructions[i] = instruction
	}
	return instructions
}

type state struct {
	x, y int
	direction int
}

func (state *state) update(instruction instruction) {
	switch instruction.op {
	case 'N':
		state.y += instruction.value
	case 'S':
		state.y -= instruction.value
	case 'E':
		state.x += instruction.value
	case 'W':
		state.x -= instruction.value
	case 'L':
		state.direction += instruction.value
	case 'R':
		state.direction -= instruction.value
	case 'F':
		state.x += int(float64(instruction.value) * math.Cos(float64(state.direction) / 180 * math.Pi))
		state.y += int(float64(instruction.value) * math.Sin(float64(state.direction) / 180 * math.Pi))
	}
}

func star1(instructions []instruction) {
	state := state{0, 0, 0}
	for _, i := range instructions {
		state.update(i)
		fmt.Println(state)
		fmt.Println(math.Abs(float64(state.x)) + math.Abs(float64(state.y)))
	}
}

type state2 struct {
	x, y float64
	dx, dy float64
}

func (state *state2) update(instruction instruction) {
	switch instruction.op {
	case 'N':
		state.dy += float64(instruction.value)
	case 'S':
		state.dy -= float64(instruction.value)
	case 'E':
		state.dx += float64(instruction.value)
	case 'W':
		state.dx -= float64(instruction.value)
	case 'L':
		theta := float64(instruction.value) / 180 * math.Pi
		dx, dy := state.dx, state.dy
		state.dx = math.Cos(theta) * dx - math.Sin(theta) * dy
		state.dy = math.Sin(theta) * dx + math.Cos(theta) * dy
	case 'R':
		theta := -float64(instruction.value) / 180 * math.Pi
		dx, dy := state.dx, state.dy
		state.dx = math.Cos(theta) * dx - math.Sin(theta) * dy
		state.dy = math.Sin(theta) * dx + math.Cos(theta) * dy
	case 'F':
		state.x += float64(instruction.value) * state.dx
		state.y += float64(instruction.value) * state.dy
	}
}

func star2(instructions []instruction) {
	state := state2{0, 0, 10, 1}
	for _, i := range instructions {
		state.update(i)
		fmt.Println(state)
		fmt.Println(math.Abs(float64(state.x)) + math.Abs(float64(state.y)))
	}
}


func main() {
	instructions := readInput("input.txt")
	//star1(instructions)
	star2(instructions)
}