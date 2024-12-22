dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]


function problem_one()
    top_map = parse_input("10/input")
    trailheads = get_trailheads(top_map)
    total_score = 0
    for trailhead in trailheads
        score = 0
        seen_tops = []
        poss = [trailhead]
        while length(poss) > 0
            pos = pop!(poss)
            if top_map[pos[1], pos[2]] == 9 && !(pos in seen_tops)
                push!(seen_tops, pos)
                score += 1
            end
            poss = [poss; get_viable_steps(top_map, pos)]
        end
        total_score += score
    end

    println("Total score: ", total_score)
end


function problem_two()
    top_map = parse_input("10/input")
    trailheads = get_trailheads(top_map)
    total_score = 0
    for trailhead in trailheads
        score = 0
        seen_tops = []
        poss = [trailhead]
        while length(poss) > 0
            pos = pop!(poss)
            # Removing the repeat top check is literally the only change
            if top_map[pos[1], pos[2]] == 9
                push!(seen_tops, pos)
                score += 1
            end
            poss = [poss; get_viable_steps(top_map, pos)]
        end
        total_score += score
    end

    println("Total score: ", total_score)
end


function get_trailheads(top_map)
    return Tuple.(findall(top_map .== 0)) 
end


function get_viable_steps(top_map, pos)
    viable_steps = []
    for dir in dirs
        new_pos = pos .+ dir
        if is_pos_inbounds(top_map, new_pos) && is_step_viable(top_map, pos, new_pos)
            push!(viable_steps, new_pos)
        end
    end
    return viable_steps
end


function is_step_viable(top_map, pos, new_pos)
    return top_map[new_pos[1], new_pos[2]] - top_map[pos[1], pos[2]] == 1 
end


function is_pos_inbounds(top_map, pos)
    nr, nc = size(top_map)
    return (0 < pos[1] < nr+1) && (0 < pos[2] < nc+1)
end


function parse_input(fn::String)
    data = read(fn)
    num_rows = count(i -> i==0x0a, data) + 1
    num_cols = Int((length(data) - num_rows + 1)/num_rows)
    return Int64.(reshape(data[data .!== 0x0a], num_rows, num_cols)') .- 48
end