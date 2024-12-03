function parse_mul(mul::AbstractString)
    return prod(parse.(Int64, split(mul[5:end-1], ',')))
end


function problem_one()
    input_file = open("03/input")
    re = r"mul\([0-9]+\,[0-9]+\)"
    mul_sum = 0

    line = readline(input_file)
    while line !== ""
        all_matches = eachmatch(re, line)
        for match in all_matches
            mul_sum += parse_mul(match.match)
        end
        line = readline(input_file)
    end

    close(input_file)
    println("Sum of all multiplications: ", mul_sum)
end


function problem_two()
    input_file = open("03/input")
    re = r"mul\([0-9]+\,[0-9]+\)|do\(\)|don\'t\(\)"
    mul_sum = 0
    activated = true

    line = readline(input_file)
    while line !== ""
        all_matches = eachmatch(re, line)
        for match in all_matches
            if match.match == "do()"
                activated = true
            elseif match.match == "don't()"
                activated = false
            else
                (activated) && (mul_sum += parse_mul(match.match))
            end
        end
        line = readline(input_file)
    end

    close(input_file)
    println("Sum of all multiplications: ", mul_sum)
end