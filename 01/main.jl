include("input.jl")

println("First answer: ", sum(abs.(sort(input[:, 1]) .- sort(input[:, 2]))))

println("Second answer: ", mapreduce(val -> sum(input[:, 2] .== val)*val, +, input[:, 1]))