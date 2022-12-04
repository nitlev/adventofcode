using Test
include("star1.jl")

function test_evaluateplay()
    play1 = Play(:Rock, :Paper)
    play2 = Play(:Paper, :Rock)
    play3 = Play(:Scissors, :Scissors)

    # Test that evaluateplay returns 0 for all three plays
    @test evaluateplay(play1) == 8
    @test evaluateplay(play2) == 1
    @test evaluateplay(play3) == 6
end

test_evaluateplay()
