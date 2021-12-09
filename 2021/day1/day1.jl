function parseinput(filename)
    content = open(f->split(read(f, String), "\n"), filename, "r")
    [parse(Int, x) for x in content]
end

function rollingwindows(depths, size=1)
    if size > length(depths)
        throw("Size should not be larger than length of first agurment")
    end

    windows = []
    for i in 1:(length(depths) - size + 1)
        append!(windows, [depths[i:(i+size-1)]])
    end
    windows
end

function rollingsum(depths, size=1)
    windows = rollingwindows(depths, size)
    [sum(window) for window in windows]
end

function isdeeper(depth1, depth2):Bool
    depth1 > depth2
end

function countincreases(depths::Array{Int})
    n = 0
    for i in 1:(length(depths) - 1)
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

function main2()
    depths = parseinput("test.txt")
    rollingsums = rollingsum(depths, 3)
    result = countincreases(rollingsums)
    println(result)
end

main()
main2()