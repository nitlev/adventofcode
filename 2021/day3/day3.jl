function readinput(filename)
    rows = readlines(filename)
    content = [parse(Int, x)
        for row in rows
        for x in row]
    reshape(content, :, length(rows))
end

function bitarr_to_int(arr)
    return sum(arr .* (2 .^ collect(length(arr)-1:-1:0)))
end

function computegammabits(bits)
    sum(bits, dims=2) .>= size(bits, 2) / 2
end

function main()
   bits = readinput("input.txt") 
   gammabits = computegammabits(bits)
   epsilonbits = .!gammabits

    gammarate = bitarr_to_int(gammabits[:])
    epsilonrate = bitarr_to_int(epsilonbits[:])
    gammarate * epsilonrate
end

function oxigengeneratorrating(bits, idx=1)
    if size(bits, 2) == 1
        bits[:]
    elseif idx > size(bits, 1)
        throw("Couldn't find bits")
    else
        gamma = computegammabits(bits)
        filteredbits = bits[:, bits[idx, :] .== gamma[idx]]
        oxigengeneratorrating(filteredbits, idx+1)
    end
end

function co2scrubberrating(bits, idx=1)
    if size(bits, 2) == 1
        bits[:]
    elseif idx > size(bits, 1)
        throw("Couldn't find bits")
    else
        epsilon = .!computegammabits(bits)
        filteredbits = bits[:, bits[idx, :] .== epsilon[idx]]
        co2scrubberrating(filteredbits, idx+1)
    end
end

function main2()
    bits = readinput("input.txt") 
    oxigengenerator = oxigengeneratorrating(bits)
    oxigengenerator = bitarr_to_int(oxigengenerator[:])
    
    co2scrubber = co2scrubberrating(bits)
    co2scrubber = bitarr_to_int(co2scrubber[:])

    oxigengenerator * co2scrubber
 end
 

main()
main2()
