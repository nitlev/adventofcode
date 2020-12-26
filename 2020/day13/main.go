package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)


func readInput(filename string) (int, []int, []int) {
	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(file), "\n")
	departureTime, _ := strconv.Atoi(lines[0])
	buses := make([]int, 0)
	positions := make([]int, 0)
	for i, busID := range strings.Split(lines[1], ",") {
		if bus, ok := strconv.Atoi(busID); ok == nil {
			buses = append(buses, bus)
			positions = append(positions, i)
		}
	}
	return departureTime, buses, positions
}

func findMinDeparture(departureTime int, buses []int) (int, int) {
	minWait := 2 * departureTime
	var firstBus int
	for _, bus := range buses {
		wait := bus - departureTime % bus
		if wait < minWait {
			minWait = wait
			firstBus = bus
		}
	}
	return firstBus, minWait
}

func star1(departureTime int, buses []int) {
	bus, wait := findMinDeparture(departureTime, buses)
	fmt.Println(bus, wait, bus * wait)
}

func findSpecialTimestamp(buses []int) {
	
}

func star2(buses, positions []int) {
	fmt.Println(17, 13, 2)
	for k:=0; k < 17;k++ {
		fmt.Println(13 * k % (17))
	}
	fmt.Println(13, 19, 1)
	for k:=0; k < 13;k++ {
		fmt.Println(19 * k % (13))
	}
}

func main() {
	departureTime, buses, positions := readInput("input.txt")
	star1(departureTime, buses)
	star2(buses, positions)
}