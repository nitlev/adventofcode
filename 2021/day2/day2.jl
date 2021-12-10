struct Instruction
    direction
    distance::Int
end

struct Position
    x::Int
    y::Int
    aim::Int
end

function readinstruction(line)
    begin
        direction, distance = split(line)
        Instruction(direction, parse(Int, distance))
    end
end

function parseinput(filename)::Array{Instruction}
    begin
        stream = open(filename, "r")
        lines = split(read(stream, String), "\n")
        [readinstruction(line) for line in lines]
    end
end

function updateposition(position::Position, instruction::Instruction)
    newx = position.x
    newy = position.y
    if instruction.direction == "forward"
        newx += instruction.distance
    elseif instruction.direction == "down"
        newy += instruction.distance
    elseif instruction.direction == "up"
        newy -= instruction.distance
    end
    Position(newx, newy, 0)
end

function updateposition(position::Position, instruction::Instruction)
    newx = position.x
    newy = position.y
    if instruction.direction == "forward"
        newx += instruction.distance
    elseif instruction.direction == "down"
        newy += instruction.distance
    elseif instruction.direction == "up"
        newy -= instruction.distance
    end
    Position(newx, newy, 0)
end

function main()
    instructions = parseinput("input.txt")
    position = Position(0, 0, 0)
    for instruction in instructions
        position = updateposition(position, instruction)
    end
    position.x * position.y
end

function updateposition2(position::Position, instruction::Instruction)
    newx = position.x
    newy = position.y
    newaim = position.aim
    if instruction.direction == "forward"
        newx += instruction.distance
        newy += newaim * instruction.distance
    elseif instruction.direction == "down"
        newaim += instruction.distance
    elseif instruction.direction == "up"
        newaim -= instruction.distance
    end
    Position(newx, newy, newaim)
end

function main2()
    instructions = parseinput("test.txt")
    position = Position(0, 0, 0)
    for instruction in instructions
        position = updateposition2(position, instruction)
    end
    position.x * position.y
end

main()
main2()