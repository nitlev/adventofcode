using Test
include("day1.jl")

@test isdeeper(2, 1)
@test !isdeeper(1, 2)
@test countincreases([1, 2, 3]) == 2
@test countincreases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7