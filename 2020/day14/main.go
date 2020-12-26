package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)


type instruction struct {
	op string
	mask string
	memory int
	value int
}


func readInput(filename string) []instruction {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(file), "\n")
	instructions := make([]instruction, 0, len(lines))
	memPattern := regexp.MustCompile(`^mem\[(\d+)\] = (\d+)$`)
	for _, line := range lines {
		var i instruction
		if strings.HasPrefix(line, "mask = ") {
			i = instruction{"mask", line[len("mask = "):], 0, 0}
		} else {
			match := memPattern.FindStringSubmatch(line)
			address, _ := strconv.Atoi(match[1])
			value, _ := strconv.Atoi(match[2])
			i = instruction{"mem", "", address, value}
		}
		instructions = append(instructions, i)
	}
	return instructions
}

type mask func(int) int 

func makeMask(mask string) mask {
	return func(i int) int {
		binary := fmt.Sprintf("%036b", i)
		output := make([]byte, 0, 36)
		for i, v := range mask {
			switch v {
			case '0':
				output = append(output, '0')
			case '1':
				output = append(output, '1')
			default:
				output = append(output, binary[i])
			}
		}
		n, _ := strconv.ParseInt(string(output), 2, 0)
		return int(n)
	}
}

func applyProgram(instructions []instruction) map[int]int {
	mem := make(map[int]int)
	var mask mask
	for _, instruction := range instructions {
		if instruction.op == "mem" {
			mem[instruction.memory] = mask(instruction.value)
		} else {
			mask = makeMask(instruction.mask)
		}
	}
	return mem
}

func computeSum(mem map[int]int) int {
	s := 0
	for _, value := range mem {
		s += value
	}
	return s
}

func star1() {
	instructions := readInput("input.txt")
	mem := applyProgram(instructions)
	fmt.Println(mem)
	result := computeSum(mem)
	fmt.Println(result)
}


func buildAddresses(binary, mask string, cur string) []int {
	for i, v := range mask {
		switch v {
			case '0':
				cur = cur + string(binary[i])
			case '1':
				cur = cur + "1"
			default:
				return append(buildAddresses(binary[(i+1):], mask[(i+1):], cur + "1"), buildAddresses(binary[(i+1):], mask[(i+1):], cur + "0")...)
		}
	}
	n, _ := strconv.ParseInt(string(cur), 2, 0)
	return []int{int(n)}
}

type mask2 func(int) []int

func makeMaskV2(mask string) mask2 {
	return func(i int) []int {return buildAddresses(fmt.Sprintf("%036b", i), mask, "")}
}

func applyProgramV2(instructions []instruction) map[int]int {
	mem := make(map[int]int)
	var mask mask2
	for _, instruction := range instructions {
		if instruction.op == "mem" {
			for _, address := range mask(instruction.memory) {
				mem[address] = instruction.value
			}
		} else {
			mask = makeMaskV2(instruction.mask)
		}
	}
	return mem
}

func star2() {
	instructions := readInput("input.txt")
	mem := applyProgramV2(instructions)
	fmt.Println(mem)
	result := computeSum(mem)
	fmt.Println(result)
}

func main() {
	star2()
}