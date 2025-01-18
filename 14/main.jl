using Plots


struct Robot
    pos::Vector{Int}
    vel::Vector{Int}
end


function step!(robot::Robot)
    robot.pos .+= robot.vel
end


function teleport!(robot::Robot, system_size::Tuple{Int, Int})
    robot.pos .= mod1.(robot.pos, system_size)
end


function print_bathroom(robots::Vector{Robot}, system_size::Tuple{Int, Int})
    system = zeros(Int, system_size)
    for robot in robots
        system[robot.pos[1], robot.pos[2]] += 1
    end

    # heatmap(system') |> display
    display(system')
end


function safety_factor(robots::Vector{Robot}, system_size::Tuple{Int, Int})
    x_mid, y_mid = Int.(floor.(system_size./2)) .+ 1
    quadrants = zeros(Int, 4)
    for robot in robots
        if robot.pos[1] < x_mid
            if robot.pos[2] < y_mid
                quadrants[1] += 1
            elseif robot.pos[2] > y_mid
                quadrants[2] += 1
            end
        elseif robot.pos[1] > x_mid
            if robot.pos[2] < y_mid
                quadrants[3] += 1
            elseif robot.pos[2] > y_mid
                quadrants[4] += 1
            end
        end
    end
    display(quadrants)
    return prod(quadrants)
end

# found online that this is basically when the tree occurs..
function no_overlaps(robots::Vector{Robot})
    for i in eachindex(robots), j in i+1:length(robots)
        if robots[i].pos == robots[j].pos
            return false
        end
    end
    return true
end


function parse_input(fn::String)::Vector{Robot}
    robots::Vector{Robot} = []
    for line in readlines(fn)
        pos, vel = split(line, ' ')
        pos = parse.(Int, split(pos[3:end], ','))  .+ 1
        vel = parse.(Int, split(vel[3:end], ',')) 
        push!(robots, Robot(pos, vel))
    end
    return robots
end


function problem_one()
    robots = parse_input("14/input")
    system_size = (101, 103)
    num_seconds = 100
    for _ in 1:num_seconds
        step!.(robots)
        teleport!.(robots, (system_size, ))
    end

    println("Safety factor: ", safety_factor(robots, system_size))
end


function problem_two()
    robots = parse_input("14/input")
    system_size = (101, 103)
    tree_found = false
    num_secs = 0
    while !tree_found
        step!.(robots)
        teleport!.(robots, (system_size, ))
        num_secs += 1
        (no_overlaps(robots)) && (tree_found = true)
    end

    println("Min. time until tree: ", num_secs)
end