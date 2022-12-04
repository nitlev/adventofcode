module Star1

struct Play
    opponent_move::Symbol
    player_move::Symbol
end

function readinput()
    lines = []
    code_to_move = Dict(
        "A" => :Rock,
        "B" => :Paper,
        "C" => :Scissors,
        "X" => :Rock,
        "Y" => :Paper,
        "Z" => :Scissors,
    )
    for line in eachline("2022/day2/input.txt")
        opponent_move_code, player_move_code = split(line, " ")
        opponent_move = code_to_move[opponent_move_code]
        player_move = code_to_move[player_move_code]
        push!(lines, Play(opponent_move, player_move))
    end
    return lines
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
    for play in readinput()
        totalscore += evaluateplay(play)
    end
    println(totalscore)
end

end

main()