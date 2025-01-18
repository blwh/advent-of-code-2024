dirs = ('^', '>', 'v', '<')
dirs_to_movement = Dict('^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1])


function parse_input(fn::String; double=false)
    fp = open(fn)
    reading_warehouse = true
    warehouse_row = []
    warehouse::Vector{Vector{Char}} = []
    movement = ""
    while !eof(fp)
        ch = read(fp, Char)
        (ch in dirs) && (reading_warehouse = false)
        if reading_warehouse
            if ch == '\n' && length(warehouse_row) > 0
                push!(warehouse, warehouse_row)
                warehouse_row = []
            else
                if double
                    if ch == 'O'
                        push!(warehouse_row, '[')
                        push!(warehouse_row, ']')
                    elseif ch == '@'
                        push!(warehouse_row, '@')
                        push!(warehouse_row, '.')
                    else
                        push!(warehouse_row, ch)
                        push!(warehouse_row, ch)
                    end
                else
                    push!(warehouse_row, ch)
                end
            end
        else
            (ch !== '\n') && (movement = movement * ch)
        end
    end
    close(fp)
    return Matrix(stack(warehouse)'), movement
end


# Lol
function Base.adjoint(ch::Char)
    return ch
end


function get_robot_pos(warehouse::Matrix{Char})
    cpos = findall(warehouse .== '@')
    return [cpos[1][1], cpos[1][2]]
end


function get_new_pos(pos::Vector{Int}, dir::Char)
    return pos .+ dirs_to_movement[dir]
end


function get_right_pos(pos::Vector{Int}, dir::Char)
    return get_side_pos(:right, pos, dir) 
end


function get_left_pos(pos::Vector{Int}, dir::Char)
    return get_side_pos(:left, pos, dir) 
end


function get_side_pos(side, pos::Vector{Int}, dir::Char)
    if !(side in [:left, :right])
        return [-1, -1]
    end
    a = 1
    (side == :right) && (a = -1)
    if dir == '^'
        return pos .+ [0, -1]*a
    elseif dir == '>'
        return pos .+ [-1, 0]*a
    elseif dir == 'v'
        return pos .+ [0, 1]*a
    elseif dir == '<'
        return pos .+ [1, 0]*a
    end
end


function is_viable_step(warehouse::Matrix{Char}, pos::Vector{Int}, dir::Char)
    next_pos = get_new_pos(pos, dir)
    next_site = warehouse[next_pos[1], next_pos[2]]
    viable_step = begin
        if next_site == '#' 
            return false
        elseif (next_site == '[' && dir == '^') || (next_site == ']' && dir == 'v')
            return is_viable_step(warehouse, next_pos, dir) && is_viable_step(warehouse, get_right_pos(next_pos, dir), dir)
        elseif (next_site == ']' && dir == '^') || (next_site == '[' && dir == 'v')
            return is_viable_step(warehouse, next_pos, dir) && is_viable_step(warehouse, get_left_pos(next_pos, dir), dir)
        elseif next_site in ['O', '[', ']']
            return is_viable_step(warehouse, next_pos, dir)
        elseif next_site == '.'
            return true
        else
            return false
        end
    end
    return viable_step
end


function move_square!(warehouse::Matrix{Char}, pos::Vector{Int}, dir::Char)
    next_pos = get_new_pos(pos, dir)
    next_site = warehouse[next_pos[1], next_pos[2]]
    if (next_site == '[' && dir == '^') || (next_site == ']' && dir == 'v')
        move_square!(warehouse, next_pos, dir)
        move_square!(warehouse, get_right_pos(next_pos, dir), dir)
    elseif (next_site == ']' && dir == '^') || (next_site == '[' && dir == 'v')
        move_square!(warehouse, next_pos, dir)
        move_square!(warehouse, get_left_pos(next_pos, dir), dir)
    elseif warehouse[next_pos[1], next_pos[2]] in ['O', '[', ']']
        move_square!(warehouse, next_pos, dir)
    end
 
    warehouse[next_pos[1], next_pos[2]] = warehouse[pos[1], pos[2]]
    warehouse[pos[1], pos[2]] = '.'
end


function take_step!(warehouse::Matrix{Char}, pos::Vector{Int}, dir::Char)
    if is_viable_step(warehouse, pos, dir)
        move_square!(warehouse, pos, dir)
    end
end


function get_all_box_coordinates(warehouse::Matrix{Char}, box_symbol='O')
    Nx, Ny = size(warehouse)
    box_coordinates = zeros(Int, sum(warehouse .== box_symbol))
    i = 1
    for x in 1:Nx, y in 1:Ny
        if warehouse[x, y] == box_symbol
            box_coordinates[i] = (x - 1)*100 + (y - 1)
            i += 1
        end
    end
    return box_coordinates
end


function problem_one()
    warehouse, dirs = parse_input("15/input") 
    for dir in dirs
        pos = get_robot_pos(warehouse)
        take_step!(warehouse, pos, dir)
    end
    box_coordinates = get_all_box_coordinates(warehouse)
    display(warehouse)

    println("Coordinate sum: ", sum(box_coordinates))
end


function problem_two()
    warehouse, dirs = parse_input("15/input", double=true)
    for dir in dirs
        pos = get_robot_pos(warehouse)
        take_step!(warehouse, pos, dir)
    end
    box_coordinates = get_all_box_coordinates(warehouse, '[')
    display(warehouse)

    println("Coordinate sum: ", sum(box_coordinates))
end