include("input.jl")

function problem_one()
    println("First answer: ", sum(abs.(sort(input[:, 1]) .- sort(input[:, 2]))))
end

function problem_two()
    println("Second answer: ", mapreduce(val -> sum(input[:, 2] .== val)*val, +, input[:, 1]))
end