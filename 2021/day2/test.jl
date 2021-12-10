using Test
include("day2.jl")

@test readinstruction("forward 2").direction == Instruction("forward", 2).direction
@test readinstruction("forward 2").distance == Instruction("forward", 2).distance

@test updateposition(Position(0, 0), Instruction("forward", 5)).x == 5
@test updateposition(Position(0, 0), Instruction("down", 5)).y == 5
@test updateposition(Position(0, 7), Instruction("up", 5)).y == 2