package main

import (
	"fmt"
	"io/ioutil"
	"nitlev/adventofcode2020/day4/validation"
	"strings"
)

func isSeparator(r rune) bool {
	return r == '\n' || r == ' '
}

var mandatoryFields = []string{
	"byr",
	"iyr",
	"eyr",
	"hgt",
	"hcl",
	"ecl",
	"pid",
}
var validFields = append(mandatoryFields, "cid")

// Passport holds a few data about a passport line from the input file
type Passport map[string]string

func readInput(filename string) []Passport {
	f, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(f), "\n\n")
	passports := make([]Passport, 0, len(lines))
	for _, line := range lines {
		fields := strings.FieldsFunc(line, isSeparator)
		p := make(map[string]string)
		for _, field := range fields {
			s := strings.Split(field, ":")
			p[s[0]] = s[1]
		}
		passports = append(passports, p)
	}
	return passports
}

// IsValid checks that all required fields are found in the passport info
func IsValid(passport Passport) bool {
	for _, field := range mandatoryFields {
		value, found := passport[field]
		if !found {
			return false
		}
		if !validation.IsFieldValid(field, value) {
			return false
		}
	}
	return true
}

func countValidPassports(passports []Passport) int {
	n := 0
	for _, p := range passports {
		if IsValid(p) {
			n ++
		}
	}
	return n
}

func main() {
	passports := readInput("input.txt")
	n := countValidPassports(passports)
	fmt.Println(n)
}
