turns = Dict('^' => '>', '>' => 'v', 'v' => '<', '<' => '^')
dirs_to_vecs = Dict('^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1])


function problem_one()
    mat = parse_input("06/input")
    pos = get_start_pos(mat)
    exited = false
    while !exited
        exited = take_step!(mat, pos)
    end
    println("num. visited sites: ", count(i -> i=='x', mat))
end


function problem_two()
    mat = parse_input("06/input")
    pathmat = copy(mat)
    pos = get_start_pos(mat)
    start_pos = pos
    exited = false
    num_loops = 0
    i = 0
    while !exited
        dir = mat[pos[1], pos[2]]
        new_pos = pos .+ dirs_to_vecs[dir]
        if new_pos !== start_pos && pos_within_bound(mat, new_pos) && mat[new_pos[1], new_pos[2]] !== '#'
            mat[new_pos[1], new_pos[2]] = '#'
            pathmat .= '.'
            if check_square(mat, pos, pathmat, i)
                num_loops += 1
            end
            mat[new_pos[1], new_pos[2]] = '.'
        end
        exited = take_step!(mat, pos)
        println(i)
        i += 1
    end
    println("Possible obstructions: ", num_loops)
end


function check_square(mat, pos, pathmat, i)
    is_square = false
    done = false
    start_pos = pos
    dir = mat[pos[1], pos[2]]
    num_turns = 0
    epic_fail_case = 0
    num_steps = 0
    while !done
        # println(num_turns)
        new_pos = pos .+ dirs_to_vecs[dir]
        while pos_within_bound(pathmat, new_pos) && mat[new_pos[1], new_pos[2]] !== '#'
            # if pathmat[pos[1], pos[2]] == '+'
            #     epic_fail_case += 1
            # else
            #     epic_fail_case = 0
            # end
            pos = new_pos
            # if num_turns >= 4
            #     if ((dir == '^' && pathmat[pos[1], pos[2]] == 'u') || (dir == '>' && pathmat[pos[1], pos[2]] == 'r') || (dir == 'v' && pathmat[pos[1], pos[2]] == 'd') || (dir == '<' && pathmat[pos[1], pos[2]] == 'l')) || epic_fail_case >= 6
            #         is_square = true
            #         done = true
            #         break
            #     end
            # end
            
            # if pathmat[pos[1], pos[2]] == '.'
            #     if dir == '^'
            #         pathmat[pos[1], pos[2]] = 'u'
            #     elseif dir == '>'
            #         pathmat[pos[1], pos[2]] = 'r'
            #     elseif dir == 'v'
            #         pathmat[pos[1], pos[2]] = 'd'
            #     elseif dir == '<'
            #         pathmat[pos[1], pos[2]] = 'l'
            #     end
            # end

            new_pos = pos .+ dirs_to_vecs[dir]
            num_steps += 1
            if num_steps > 10000
                is_square = true
                done = true
            end
        end

        if !pos_within_bound(pathmat, new_pos)
            done = true
        else
            dir = turns[dir]
            num_turns += 1
            pathmat[pos[1], pos[2]] = '+'
        end
    end

    return is_square
end


function take_step!(mat, pos)
    exited = false
    dir = mat[pos[1], pos[2]]
    new_pos = pos .+ dirs_to_vecs[dir]
    if pos_within_bound(mat, new_pos)
        next_site = mat[new_pos[1], new_pos[2]]
        if next_site == '#'
            dir = turns[dir]
        else
            mat[pos[1], pos[2]] = 'X'
            pos .= new_pos
        end
        mat[pos[1], pos[2]] = dir
    else
        mat[pos[1], pos[2]] = 'X'
        exited = true
    end
    return exited
end


function pos_within_bound(mat, pos)
    nr, nc = size(mat)
    return (0 < pos[1] < nr+1 && 0 < pos[2] < nc+1)
end


function get_start_pos(mat)
    start_pos = nothing
    for dir in ['^', '>', '<', 'v']
        start_pos = findfirst(mat .== dir)
        if start_pos !== nothing
            break
        end
    end
    return [start_pos[1], start_pos[2]]
end


function parse_input(fn::String)
    data = read(fn)
    num_rows = count(i -> i==0x0a, data) + 1
    num_cols = Int((length(data) - num_rows + 1)/num_rows)
    return Char.(reshape(data[data .!== 0x0a], num_rows, num_cols)')
end