using Test
include("day1.jl")

@test countincreases([1, 2, 3]) == 2
@test countincreases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7

@test rollingsum([1]) == [1]
@test rollingsum([1, 2]) == [1, 2]
@test rollingsum([1, 2], 2) == [3]
@test rollingsum([1, 2, 3, 4], 3) == [6, 9]