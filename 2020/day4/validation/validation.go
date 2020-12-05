package validation

import (
	"regexp"
	"strconv"
)

var validationFunctions = map[string](func (string) bool) {
	"byr": IsValidBirthYear, 
	"iyr": IsValidIssueYear, 
	"eyr": IsValidExpirationYear, 
	"hgt": IsValidHeight, 
	"hcl": IsValidHairColor, 
	"ecl": IsValidEyeColor, 
	"pid": IsValidPID, 
}

// IsFieldValid checks if a field is valid using the associated validation function
func IsFieldValid(field, value string) bool {
	validationFunction, ok := validationFunctions[field]
	if !ok {
		return false
	}
	return validationFunction(value)
}

// IsValidBirthYear checks if birth year is in proper bound
func IsValidBirthYear(byr string) bool {
	birthYear, err := strconv.Atoi(byr)
	if err != nil {
		return false
	}
	return birthYear >= 1920 && birthYear <= 2002
}

// IsValidIssueYear checks if issue year is in proper bound
func IsValidIssueYear(iyr string) bool {
	issueYear, err := strconv.Atoi(iyr)
	if err != nil {
		return false
	}
	return issueYear >= 2010 && issueYear <= 2020
}

// IsValidExpirationYear checks if expiration year is in proper bound
func IsValidExpirationYear(eyr string) bool {
	expirationYear, err := strconv.Atoi(eyr)
	if err != nil {
		return false
	}
	return expirationYear >= 2020 && expirationYear <= 2030
}

// IsValidHeight checks if the height has a valid value
func IsValidHeight(hgt string) bool {
	hgt, unit := hgt[:len(hgt) - 2], hgt[len(hgt) - 2:]
	height, err := strconv.Atoi(hgt)
	if err != nil {
		return false
	}
	switch unit {
	case "cm":
		return height >= 150 && height <= 193
	case "in":
		return height >= 59 && height <= 76
	default:
		return false
	}
}

// IsValidHairColor checks if the color is in hexa
func IsValidHairColor(hcl string) bool {
	pattern := regexp.MustCompile(`^#[0-9a-f]{6}$`)
	return pattern.MatchString(hcl)
}

// IsValidEyeColor ensures eye color is in defined list
func IsValidEyeColor(ecl string) bool {
	switch ecl {
	case "amb", "blu", "brn", "gry", "grn", "hzl", "oth":
		return true
	default:
		return false
	}
}

// IsValidPID checks PID is a 9 digits sequence
func IsValidPID(pid string) bool {
	pattern := regexp.MustCompile(`^\d{9}$`)
	return pattern.MatchString(pid)
}