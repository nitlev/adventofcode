package main

import (
	"testing"
)

func Test_findRow(t *testing.T) {
	type args struct {
		code string
		min  int
		max  int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		{"F should return 0 for 0-1", args{"F", 0, 1}, 0},
		{"B should return 1 for 0-1", args{"B", 0, 1}, 1},
		{"FB should return 1 for 0-3", args{"FB", 0, 3}, 1},
		{"BFB should return 5 for 0-7", args{"BFB", 0, 7}, 5},
		{"FBFBBFF should return 43 for 0-127", args{"FBFBBFF", 0, 127}, 44},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := findRow(tt.args.code, tt.args.min, tt.args.max); got != tt.want {
				t.Errorf("findRow(%v, %v, %v) = %v, want %v", tt.args.code, tt.args.min, tt.args.max, got, tt.want)
			}
		})
	}
}

func Test_findColumn(t *testing.T) {
	type args struct {
		code string
		min  int
		max  int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		{"L should return 0 for 0-1", args{"L", 0, 1}, 0},
		{"R should return 1 for 0-1", args{"R", 0, 1}, 1},
		{"LR should return 1 for 0-3", args{"LR", 0, 3}, 1},
		{"RLR should return 5 for 0-7", args{"RLR", 0, 7}, 5},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := findColumn(tt.args.code, tt.args.min, tt.args.max); got != tt.want {
				t.Errorf("findColumn() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_computeID(t *testing.T) {
	code := "FBFBBFFRLR"
	want := 357
	if got := computeID(code); got != want {
		t.Errorf("ID of FBFBBFFRLR is %v, expected 357", got)
	}
}