using Printf

struct Arcade
    SA
    SB
    V
    C
end


function problem_one()
    arcades = parse_file("13/input")
    total_cost = 0
    for arcade in arcades
        nA, nB = number_of_presses(arcade)
        @printf "%.3f, %.3f\n" nA nB
        if isinteger(nA) && isinteger(nB)
            @printf "%.3f, %.3f\n" nA nB
            total_cost += arcade.C[1]*nA + arcade.C[2]*nB
        end
    end
    println("Total cost: ", total_cost)
end


function problem_two()
    prize_error=10000000000000
    arcades = parse_file("13/input")
    total_cost = 0
    for arcade in arcades
        arcade.V .+= prize_error
        nA, nB = number_of_presses(arcade)
        # nAp, nBp = number_of_presses(arcade)
        if isinteger(nA) && isinteger(nB)
            # println(arcade)
            # @printf "%.20f, %.10f\n" nA nB
            @printf "%.10f\n" nA
            total_cost += arcade.C[1]*nA + arcade.C[2]*nB
        end
    end
    @printf "total_cost: %d\n" total_cost
end


# function number_of_presses(arcade::Arcade)
#     A = [arcade.SA[1] arcade.SB[1]; arcade.SA[2] arcade.SB[2]]
#     nA, nB = inv(A)*(arcade.V)
#     return nA, nB
# end


function number_of_presses(arcade::Arcade)
    nA = (arcade.V[2]*arcade.SB[1] - arcade.V[1]*arcade.SB[2])/(arcade.SA[2]*arcade.SB[1] - arcade.SA[1]*arcade.SB[2])
    nB = (arcade.V[1] - nA*arcade.SA[1])/arcade.SB[1]
    return nA, nB
end


function parse_file(fn::String)
    C = [3, 1]
    vals = Int64[]
    arcades = []
    re = r"\d+"
    for line in readlines(fn)
        for match in eachmatch(re, line)
            push!(vals, parse(Int64, match.match))
        end
        if length(vals) == 6
            push!(arcades, Arcade(vals[1:2], vals[3:4], vals[5:6], C))
            vals = Int64[]
        end
    end
    return arcades
end