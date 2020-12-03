package main

import (
	"testing"
)

func TestIsCompliant(t *testing.T) {
	if isCompliant("pncmjxlvckfbtrjh", 't', 2, 8) {
		t.Errorf("pncmjxlvckfbtrjh should not be compliant with rule 2-8 t")
	}
	if !isCompliant("gssss", 's', 4, 5) {
		t.Errorf("gssss should be compliant with rule 4-5 s")
	}
}

func TestIsCompliant2(t *testing.T) {
	if !isCompliant2("abcde", 'a', 1, 3) {
		t.Errorf("abcde should be compliant with rule 1-3 a")
	}
	if isCompliant2("cdefg", 'b', 1, 3) {
		t.Errorf("cdefg should not be compliant with rule 1-3 b")
	}
	if isCompliant2("ccccccccc", 'c', 2, 9) {
		t.Errorf("cccccccccc should not be compliant with rule 2-9 c")
	}
}