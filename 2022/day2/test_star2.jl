using Test
include("star2.jl")

function test_convertinstruction()
    instruction1 = Instruction(:Rock, :Win)
    instruction2 = Instruction(:Rock, :Lose)
    instruction3 = Instruction(:Scissors, :Draw)

    # Test that convertinstruction returns 0 for all three plays
    @test convertinstruction(instruction1) == Play(:Rock, :Paper)
    @test convertinstruction(instruction2) == Play(:Rock, :Scissors)
    @test convertinstruction(instruction3) == Play(:Scissors, :Scissors)
end

test_convertinstruction()