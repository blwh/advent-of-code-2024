function problem_one()
    sat_map = parse_input("08/input")
    an_map = copy(sat_map); an_map .= '.'

    for sat in unique(sat_map)
        (sat == '.') && continue
        sat_ps = findall(sat_map .== sat)
        for i in eachindex(sat_ps)
            for j in i+1:length(sat_ps)
                diff = sat_ps[j] - sat_ps[i]
                if pos_within_bound(an_map, sat_ps[j] + diff)
                    an_map[sat_ps[j] + diff] = '#'
                end
                if pos_within_bound(an_map, sat_ps[i] - diff)
                    an_map[sat_ps[i] - diff] = '#'
                end
            end
        end
    end
    println("Number of antinodes: ", count(i -> i == '#', an_map))
end


function problem_two()
    sat_map = parse_input("08/input")
    an_map = copy(sat_map); an_map .= '.'

    for sat in unique(sat_map)
        (sat == '.') && continue
        sat_ps = findall(sat_map .== sat)
        for i in eachindex(sat_ps)
            for j in i+1:length(sat_ps)
                diff = sat_ps[j] - sat_ps[i]
                steps = 0
                while pos_within_bound(an_map, sat_ps[j] + steps.*diff)
                    an_map[sat_ps[j] + steps*diff] = '#'
                    steps += 1
                end
                steps = 0
                while pos_within_bound(an_map, sat_ps[i] - steps*diff)
                    an_map[sat_ps[i] - steps*diff] = '#'
                    steps += 1
                end
            end
        end
    end
    display(an_map)
    println("Number of antinodes: ", count(i -> i == '#', an_map))
end


function pos_within_bound(mat, pos)
    nr, nc = size(mat)
    return (0 < pos[1] < nr+1 && 0 < pos[2] < nc+1)
end


function parse_input(fn::String)
    data = read(fn)
    num_rows = count(i -> i==0x0a, data) + 1
    num_cols = Int((length(data) - num_rows + 1)/num_rows)
    return Char.(reshape(data[data .!== 0x0a], num_rows, num_cols)')
end