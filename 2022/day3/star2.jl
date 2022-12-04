function readinput()
    return readlines("2022/day3/input.txt")
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
    group = []
    for line in readinput()
        push!(group, line)
        if length(group) == 3
            duplicate  = intersect(group[1], group[2], group[3])[1]
            total += priority(duplicate)
            group = []
        end
    end
    println(total)
end

main()