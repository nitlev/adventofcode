package validation

import (
	"testing"
)

func TestIsValidBirthYear(t *testing.T) {
	tests := []struct {
		name string
		byr  string
		want bool
	}{
		{"2002 is valid", "2002", true},
		{"2003 is invalid", "2003", false},
		{"1919 is invalid", "1919", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidBirthYear(tt.byr); got != tt.want {
				t.Errorf("IsValidBirthYear() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIsValidIssueYear(t *testing.T) {
	tests := []struct {
		name string
		iyr  string
		want bool
	}{
		{"2010 is valid", "2010", true},
		{"2009 is invalid", "2009", false},
		{"2021 is invalid", "2021", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidIssueYear(tt.iyr); got != tt.want {
				t.Errorf("IsValidIssueYear() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIsValidHeight(t *testing.T) {
	tests := []struct {
		name string
		hgt  string
		want bool
	}{
		{"150cm is valid", "150cm", true},
		{"150in is invalid", "150in", false},
		{"194cm is invalid", "194cm", false},
		{"76cm is invalid", "76cm", false},
		{"76in is valid", "76in", true},
		{"76ux is invalid", "76ux", false},
		{"76icm is invalid", "76icm", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidHeight(tt.hgt); got != tt.want {
				t.Errorf("IsValidHeight(%v) = %v, want %v", tt.hgt, got, tt.want)
			}
		})
	}
}

func TestIsValidColor(t *testing.T) {
	tests := []struct {
		name  string
		color string
		want  bool
	}{
		{"#000000 is valid color", "#000000", true},
		{"#ffffff is valid color", "#ffffff", true},
		{"#1a2e3f is valid color", "#1a2e3f", true},
		{"#00000 is invalid color", "#00000", false},
		{"#fffffff is invalid color", "#fffffff", false},
		{"#gggggg is invalid color", "#gggggg", false},
		{"1a2e3f is invalid color", "1a2e3f", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidHairColor(tt.color); got != tt.want {
				t.Errorf("IsValidColor() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIsValidEyeColor(t *testing.T) {
	tests := []struct {
		name  string
		color string
		want  bool
	}{
		{"amb is valid color", "amb", true},
		{"blu is valid color", "blu", true},
		{"inv is invalid color", "inv", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidEyeColor(tt.color); got != tt.want {
				t.Errorf("IsValidEyeColor(%v) = %v, want %v", tt.color, got, tt.want)
			}
		})
	}
}

func TestIsValidPID(t *testing.T) {
	tests := []struct {
		name  string
		pid string
		want  bool
	}{
		{"123456789 is valid pid", "123456789", true},
		{"999999999 is valid pid", "999999999", true},
		{"123a56789 is is not digits only", "123a56789", false},
		{"12345678 is has to few digits", "12345678", false},
		{"0123456789 is has to many digits", "0123456789", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsValidPID(tt.pid); got != tt.want {
				t.Errorf("IsValidPID(%v) = %v, want %v", tt.pid, got, tt.want)
			}
		})
	}
}
