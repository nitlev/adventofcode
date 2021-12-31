using Test

include("day3.jl")

@test oxigengeneratorrating([1]) == [1]
@test oxigengeneratorrating([0 1 1; 0 0 1]) == [1; 0]

@test co2scrubberrating([1]) == [1]
@test co2scrubberrating([0 1 1; 0 0 1]) == [0; 0]