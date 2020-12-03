package main

import (
	"fmt"
	"regexp"
	"strings"
	"io/ioutil"
	"strconv"
)

type Entry struct {
	min int
	max int
	letter rune
	password string
}

func parseInput() []Entry {
	f, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(f), "\n")
	entries := make([]Entry, 0, len(lines))

	pattern, err := regexp.Compile("([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)")
	if err != nil {
		panic(err)
	}

	for _, l := range lines {
		// Empty line occurs at the end of the file when we use Split.
		if len(l) == 0 {
			continue
		}
		// Atoi better suits the job when we know exactly what we're dealing
		// with. Scanf is the more general option.
		groups := pattern.FindStringSubmatch(l)[1:]
		min, _ := strconv.Atoi(groups[0])
		max, _ := strconv.Atoi(groups[1])
		entry := Entry{ min, max, rune(groups[2][0]), groups[3] }

		if err != nil {
			panic(err)
		}
		entries = append(entries, entry)
	}
	return entries
}

func isCompliant(password string, letter rune, min, max int) bool {
	count := 0
	for _, l := range password {
		if l == letter {
			count++
		}
	}
	return (count >= min) && (count <= max)
}

func isCompliant2(password string, letter rune, min, max int) bool {
	switch {
	case rune(password[min - 1]) == letter && rune(password[max - 1]) == letter:
		return false
	case rune(password[min - 1]) == letter || rune(password[max - 1]) == letter:
		return true
	default:
		return false
	}
}

func main() {
	entries := parseInput()
	nValidPasswords := 0
	nValidPasswords2 := 0
	for _, entry := range entries {
		if isCompliant(entry.password, entry.letter, entry.min, entry.max) {
			nValidPasswords++
		}
		if isCompliant2(entry.password, entry.letter, entry.min, entry.max) {
			nValidPasswords2++
		}
	}
	fmt.Println(nValidPasswords)
	fmt.Println(nValidPasswords2)
}