dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
corner_groups = [
    [[1,0], [1, 1], [0, 1]],
    [[1,0], [1, -1], [0, -1]],
    [[-1, 0], [-1, -1], [0, -1]],
    [[-1, 0], [-1, 1], [0, 1]]
] 


function problem_one()
    farm = parse_input("12/input.example") 
    nr, nc = size(farm)
    visited = zeros(Bool, nr, nc)
    cost_sum = 0
    for x in 1:nr; for y in 1:nc
        num_squares = sum(visited)
        if !visited[x, y]
            num_fences = count_fences!(farm, visited, [x, y])
            num_squares = sum(visited) - num_squares
            cost_sum += num_squares * num_fences
        end
    end; end
    println("Total cost: ", cost_sum)
end


function problem_two()
    farm = parse_input("12/input") 
    nr, nc = size(farm)
    visited = zeros(Bool, nr, nc)
    cost_sum = 0
    for x in 1:nr; for y in 1:nc
        num_squares = sum(visited)
        if !visited[x, y]
            num_fences = count_fences!(farm, visited, [x, y], false)
            num_squares = sum(visited) - num_squares
            cost_sum += num_squares * num_fences
        end
    end; end
    println("Total cost: ", cost_sum)
end


function count_fences!(farm, visited, pos, total_count=true)
    crop = farm[pos[1], pos[2]]
    num_fences = 0 
    visited[pos[1], pos[2]] = true
    if !total_count
        for corners in corner_groups
            if (outside_of_crop(farm, pos, pos .+ corners[2]) && !outside_of_crop(farm, pos, pos .+ corners[1]) && !outside_of_crop(farm, pos, pos .+ corners[3])) || (outside_of_crop(farm, pos, pos .+ corners[1]) && outside_of_crop(farm, pos, pos .+ corners[3]))
                num_fences += 1
            end
        end
    end
    for dir in dirs
        new_pos = pos .+ dir
        if outside_of_crop(farm, pos, new_pos)
            if total_count
                num_fences += 1
            end
        elseif !visited[new_pos[1], new_pos[2]]
            num_fences += count_fences!(farm, visited, new_pos, total_count)
        end
    end
    return num_fences
end


function outside_of_crop(farm, pos, new_pos)
    return !inbounds(farm, new_pos) || farm[new_pos[1], new_pos[2]] !== farm[pos[1], pos[2]]
end



function inbounds(farm, pos)
    nr, nc = size(farm) 
    return (0 < pos[1] < nr+1) && (0 < pos[2] < nc+1)
end


function parse_input(fn::String)
    data = read(fn)
    num_rows = count(i -> i==0x0a, data) + 1
    num_cols = Int((length(data) - num_rows + 1)/num_rows)
    return Char.(reshape(data[data .!== 0x0a], num_rows, num_cols)')
end