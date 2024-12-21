function problem_one()
    rules, updates = parse_file("05/input")
    sum_middle = 0

    for update in updates
        if correctly_ordered(update, rules)
            sum_middle += update[Int(floor(length(update)/2) + 1)]
        end
    end

    println("Middle sum: ", sum_middle)
end


function problem_two()
    rules, updates = parse_file("05/input")
    sum_middle = 0

    for update in updates
        if !correctly_ordered(update, rules)
            update = sort_update(update, rules)
            sum_middle += update[Int(floor(length(update)/2) + 1)]
        end
    end

    println("Middle sum: ", sum_middle)
end


function correctly_ordered(update, rules)
    correct_order = true
    i = 1
    while correct_order && i <= length(update)
        for j in eachindex(update)
            if update[i] in keys(rules) && j < i && update[j] in rules[update[i]]
                correct_order = false
            elseif update[j] in keys(rules) && j > i && update[i] in rules[update[j]]
                correct_order = false
            end
        end
        i += 1
    end
    return correct_order
end


function sort_update(update, rules)
    reordered_update = zeros(Int64, length(update))
    for i in eachindex(update) 
        for j in eachindex(reordered_update)
            if reordered_update[j] == 0
                reordered_update[j] = update[i]
                break
            elseif update[i] in keys(rules) && reordered_update[j] in rules[update[i]]
                reordered_update[j+1:end] .= reordered_update[j:end-1]
                reordered_update[j] = update[i]
                break
            else
                continue
            end
        end
    end

    return reordered_update
end


function parse_file(fn::String)
    fp = open(fn)

    rules = Dict{Int64, Vector{Int64}}()
    line = readline(fp)
    while line !== ""
        val, gt = parse.(Int64, split(line, '|'))

        (val ∉ keys(rules)) && (rules[val] = [])
        push!(rules[val], gt)

        line = readline(fp)
    end

    updates = Vector{Vector{Int64}}()
    line = readline(fp)
    while line !== ""
        push!(updates, parse.(Int64, split(line, ',')))
        line = readline(fp)
    end

    close(fp)
    return rules, updates
end