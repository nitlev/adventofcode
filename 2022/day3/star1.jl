function readinput()
    lines = []
    for line in eachline("2022/day3/input.txt")
        # Calculate the index at which to split the line
        split_index = div(length(line), 2)

        # Split the line at the calculated index
        push!(lines, [line[1:split_index], line[split_index+1:end]])
    end
    lines
end

function findduplicate(part1, part2)
    return intersect(part1, part2)[1]
end

function priority(item)
    if islowercase(item)
        return item - 'a' + 1    
    else
        return item - 'A' + 27 
    end
end

function main()
    total = 0
    for line in readinput()
        duplicate = findduplicate(line[1], line[2])
        total += priority(duplicate)
    end
    println(total)
end

main()