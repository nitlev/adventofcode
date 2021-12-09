function parseinput(filename)
    content = open(f->split(read(f, String), "\n"), filename, "r")
    [parse(Int, x) for x in content]
end

function isdeeper(depth1, depth2):Bool
    depth1 > depth2
end

function countincreases(depths::Array{Int})
    n = 0
    for i in range(1, stop=length(depths) - 1)
        if isdeeper(depths[i+1], depths[i])
            n += 1
        end
    end
    n
end

function main()
    depths = parseinput("input.txt")
    result = countincreases(depths)
    println(result)
end

main()