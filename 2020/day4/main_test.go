package main

import "testing"

func TestIsValid(t *testing.T) {
	tests := []struct {
		name     string
		passport Passport
		want     bool
	}{
		{"Empty passport is not valid", Passport{}, false},
		{
			"Full passport is valid",
			Passport{
				"byr": "byr",
				"iyr": "iyr",
				"eyr": "eyr",
				"hgt": "hgt",
				"hcl": "hcl",
				"ecl": "ecl",
				"pid": "pid",
				"cid": "cid",
			},
			true,
		},
		{
			"Partial passport without pid is valid",
			Passport{
				"byr": "byr",
				"iyr": "iyr",
				"eyr": "eyr",
				"hgt": "hgt",
				"hcl": "hcl",
				"ecl": "ecl",
				"cid": "cid",
			},
			true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValid(tt.passport); got != tt.want {
				t.Errorf("IsValid() = %v, want %v", got, tt.want)
			}
		})
	}
}
