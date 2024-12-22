function problem_one()
    sums, numbers = parse_file("07/input.example")
    correct_sums = 0
    for i in eachindex(sums)
        instructions = zeros(Int64, length(numbers[i])-1)
        for j in 0:2^(length(numbers[i])-1)-1
            sum = calculate_by_instructions(numbers[i], instructions)
            if sum == sums[i]
                correct_sums += sums[i]
                break
            end
            add_to_base_vector!(instructions, 2)
        end
    end
    println("Correct sums: ", correct_sums)
end


function problem_two()
    sums, numbers = parse_file("07/input")
    correct_sums = 0
    for i in eachindex(sums)
        instructions = zeros(Int64, length(numbers[i])-1)
        for j in 0:3^(length(numbers[i])-1)-1
            sum = calculate_by_instructions(numbers[i], instructions)
            if sum == sums[i]
                correct_sums += sums[i]
                break
            end
            add_to_base_vector!(instructions, 3)
        end
    end
    println("Correct sums: ", correct_sums)
end


function calculate_by_instructions(numbers, instructions)
    sum = numbers[1]
    for i in eachindex(instructions)
        ins = instructions[i]
        if ins == 0
            sum += numbers[i+1]
        elseif ins == 1
            sum *= numbers[i+1]
        elseif ins == 2
            sum = sum*10^ndigits(numbers[i+1]) + numbers[i+1]
        end
    end
    return sum
end


function add_to_base_vector!(vec, base)
    carry = 1
    for i in eachindex(vec)
        vec[i] += carry
        carry = 0
        if vec[i] > base-1
            vec[i] = 0
            carry = 1
        end
    end
end


function parse_file(fn::String)
    sums = []
    numbers = []
    for line in readlines(fn)
        sl = split(line, ':')
        push!(sums, parse(Int64, sl[1]))
        push!(numbers, parse.(Int64, split(sl[2], ' ')[2:end]))
    end
    return sums, numbers
end