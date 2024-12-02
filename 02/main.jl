function problem_one()
    input_file = open("02/input")
    num_safe_reports = 0
    line = readline(input_file)
    while line !== ""
        report = parse.(Int64, split(line))

        if is_safe(report)
            num_safe_reports += 1
        end

        line = readline(input_file)
    end

    println("The number of safe reports are: ", num_safe_reports)
end


function problem_two()
    input_file = open("02/input")
    num_safe_reports = 0
    line = readline(input_file)
    while line !== ""
        report = parse.(Int64, split(line))
        safe = is_safe(report)

        i = 1
        while !safe && i <= length(report)
            safe = is_safe([report[1:i-1]; report[i+1:end]])
            i += 1
        end

        (safe) && (num_safe_reports += 1)

        line = readline(input_file)
    end

    println("The number of safe reports are: ", num_safe_reports)
end


function is_safe(report)
    change = diff(report)
    return (all(change .< 0) || all(change .> 0)) && all(0 .< abs.(change) .< 4)
end