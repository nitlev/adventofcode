package main

import (
	"fmt"
	"testing"
)

func TestReadInput(t *testing.T) {
	want := 1322
	if got := ReadInput()[0]; got != want {
		t.Errorf("First item of ReadInput is %q, got %q", got, want)
	}
	fmt.Print(ReadInput())
}

func TestIsSumEqual2020(t *testing.T) {
	if isSumEqual2020(0, 0) {
		t.Errorf("0 and 0 should not be equal 2020")
	}

	if !isSumEqual2020(2020, 0) {
		t.Errorf("2020 and 0 should be equal 2020")
	}
}

func TestFindPair(t *testing.T) {
	input := []int{0, 2020}
	wantA := 0
	wantB := 2020
	if a, b := findPair(input); a != wantA || b != wantB {
		t.Errorf("Should have received 0, 2020")
	}

	input = []int{0, 1, 2, 2019}
	wantA = 1
	wantB = 2019
	if a, b := findPair(input); a != wantA || b != wantB {
		t.Errorf("Should have received 1, 2019")
	}
}
