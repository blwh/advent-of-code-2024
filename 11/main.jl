function problem_one()
    stones = parse_input("11/input")
    num_blinks = 25
    println("Num stones: ", total_number_of_stones(stones, num_blinks))
end


function problem_two()
    stones = parse_input("11/input")
    num_blinks = 25
    end_num_stones = @timed total_number_of_stones(stones, num_blinks)
    write("output", "$(end_num_stones.value)\n$(end_num_stones.time)")
    println("Num stones: ", end_num_stones.value)
end


function total_number_of_stones(stones, num_blinks)
    number_of_stones = zeros(Int64, length(stones))
    Threads.@threads for i in eachindex(stones)
        println(stones[i])
        number_of_stones[i] = blink(stones[i], num_blinks)
    end
    return sum(number_of_stones)
end


function blink(stone, nleft)
    if nleft == 0
        return 1
    end

    if stone == 0
        return blink(1, nleft-1)
    elseif ndigits(stone) % 2 == 0
        nd = ndigits(stone)
        ndh = nd/2
        left_stone = Int64(floor(stone*10^(-ndh)))
        right_stone = Int64(stone - left_stone*10^(ndh))
        return blink(left_stone, nleft-1) + blink(right_stone, nleft-1)
    end

    return blink(stone*2024, nleft-1)
end


function parse_input(fn::String)
    return parse.(Int64, split(readline(fn), ' '))
end
