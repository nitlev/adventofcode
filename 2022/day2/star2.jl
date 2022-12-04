struct Instruction
    opponent_move::Symbol
    goal::Symbol
end

struct Play
    opponent_move::Symbol
    player_move::Symbol
end

function readinput()
    lines = []
    code_parser = Dict(
        "A" => :Rock,
        "B" => :Paper,
        "C" => :Scissors,
        "X" => :Lose,
        "Y" => :Draw,
        "Z" => :Win,
    )
    for line in eachline("2022/day2/input.txt")
        opponent_move_code, player_goal_code = split(line, " ")
        opponent_move = code_parser[opponent_move_code]
        player_goal = code_parser[player_goal_code]
        push!(lines, Instruction(opponent_move, player_goal))
    end
    return lines
end

function convertinstruction(instruction::Instruction)::Play
    winnermoves = Dict(
        :Rock => :Paper,
        :Paper => :Scissors,
        :Scissors => :Rock,
    )
    losermoves = Dict(
        :Paper => :Rock,
        :Rock => :Scissors,
        :Scissors => :Paper,
    )
    if instruction.goal == :Win
        return Play(instruction.opponent_move, winnermoves[instruction.opponent_move])
    elseif instruction.goal == :Lose
        return Play(instruction.opponent_move, losermoves[instruction.opponent_move])
    else
        return Play(instruction.opponent_move, instruction.opponent_move)
    end
end

function evaluateplay(play::Play)
    movepoints = Dict(
        :Rock => 1,
        :Paper => 2,
        :Scissors => 3
    )
    whobeats = Dict(
        :Rock => :Paper,
        :Paper => :Scissors,
        :Scissors => :Rock
    )
    score = movepoints[play.player_move]
    if whobeats[play.opponent_move] == play.player_move
        score += 6
    elseif play.player_move == play.opponent_move
        score += 3
    end
    return score
end


function main()
    totalscore = 0
    for instruction in readinput()
        play = convertinstruction(instruction)
        totalscore += evaluateplay(play)
    end
    println(totalscore)
end

main()