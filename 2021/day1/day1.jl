function parseinput(filename)
    [parse(Int, x) for x in eachline(filename)]
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

function countincreases(depths::Array{Int})
    sum(next > current for (next, current) in zip(depths[2:end], depths))
end

function main()
    depths = parseinput("input.txt")
    result = countincreases(depths)
    println(result)
end

function main2()
    depths = parseinput("input.txt")
    rollingsums = rollingsum(depths, 3)
    result = countincreases(rollingsums)
    println(result)
end

main()
main2()