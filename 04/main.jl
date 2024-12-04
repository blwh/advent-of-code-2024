using LinearAlgebra


function problem_one()
    data = data_to_matrix("04/input")
    words = (UInt8.(['X', 'M', 'A', 'S']), UInt8.(['S', 'A', 'M', 'X']))
    match_len = 4
    num_matches = 0
    num_matches += match_words(data, words, match_len)
    num_matches += match_words(data[end:-1:1, :]', words, match_len)

    println("Number of matches: ", num_matches)
end


function problem_two()
    data = data_to_matrix("04/input")
    words = (UInt8.(['M', 'A', 'S']), UInt8.(['S', 'A', 'M']))
    match_len = 3
    num_matches = 0
    num_matches += match_x_mases(data, words, match_len)

    println("Number of matches: ", num_matches)
end


function data_to_matrix(fn)
    data = read(fn)
    num_rows = count(i -> i==0x0a, data) + 1
    num_cols = Int((length(data) - num_rows + 1)/num_rows)
    return reshape(data[data .!== 0x0a], num_rows, num_cols)'
end


function match_words(data, words, match_len)
    nr, nc = size(data)
    num_matches = 0
    # Check columns for matches
    for ic in 1:nc
        for ir in 1:nr-match_len+1
            if data[(ir + (ic - 1)*nr):(ir + (ic - 1)*nr + match_len - 1)] in words
                num_matches += 1
            end
        end
    end
    # Check diagonals for matches
    for id in -nr+match_len:nr-match_len
        for i in 1:length(diagind(data, id))-match_len+1
            if data[diagind(data, id)[i:i+match_len-1]] in words
                num_matches += 1
            end
        end
    end
    return num_matches
end


function match_x_mases(data, words, match_len)
    nr, nc = size(data)
    num_matches = 0
    for ic in 1:nc-match_len+1
        for ir in 1:nr-match_len+1
            cross = @view data[ir:ir+2, ic:ic+2]
            if cross[1:4:9] in words && cross[3:2:7] in words
                num_matches += 1
            end
        end
    end

    return num_matches
end