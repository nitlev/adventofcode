package main

import "testing"

func Test_isTreeAt(t *testing.T) {
	type args struct {
		row      []bool
		position int
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		{"everything is false", args{[]bool{false, false, false}, 1}, false},
		{"everything is true", args{[]bool{true, true, true}, 1}, true},
		{"index is out of bound", args{[]bool{true, false, false}, 3}, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := isTreeAt(tt.args.row, tt.args.position); got != tt.want {
				t.Errorf("isTreeAt() = %v, want %v", got, tt.want)
			}
		})
	}
}
