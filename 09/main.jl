function problem_one()
    drive_info = read_disk_info("09/input")
    drive = input_to_vec(drive_info)
    fragmented_drive = fragment_drive(drive)

    println("Checksum: ", calculate_checksum(fragmented_drive))
end


function problem_two()
    drive_info = read_disk_info("09/input")
    drive = input_to_vec(drive_info)
    fragmented_drive = fragment_drive_compact(drive)
    display(fragmented_drive)

    println("Checksum: ", calculate_checksum(fragmented_drive))
end


function fragment_drive_compact(drive)
    fragmented_drive = copy(drive)
    j = length(fragmented_drive)
    while (j >= 1)
        if fragmented_drive[j] !== -1
            moved = false
            n_vals = count_vals(drive, j, -1)
            i = 1
            while (j > i)
                if fragmented_drive[i] == -1
                    n_empty = count_vals(drive, i)
                    if n_empty >= n_vals
                        fragmented_drive[i:i+n_vals-1] .= fragmented_drive[j]
                        fragmented_drive[j-n_vals+1:j] .= -1
                        moved = true
                        break
                    end
                end
                i += 1
            end
            if !moved
                j -= n_vals-1
            end
        end
        j -= 1
    end
    return fragmented_drive
end


function count_vals(drive, i, dir=1)
    num_vals = 1
    j = i + dir
    while (0 < j <= length(drive)) && (drive[j] == drive[i])
        j = j + dir
        num_vals += 1
    end
    return num_vals
end


function input_to_vec(drive_info::String)
    vec_size = 0
    for i in eachindex(drive_info)
        vec_size += parse(Int64, drive_info[i])
    end
    drive = zeros(Int64, vec_size)
    written_to_file = 0
    file_id = 0
    for i in eachindex(drive_info)
        val = parse(Int64, drive_info[i])
        if i % 2 == 1
            drive[written_to_file+1:written_to_file+val] .= file_id
            file_id += 1
        else
            drive[written_to_file+1:written_to_file+val] .= -1
        end
        written_to_file += val
    end
    return drive
end


function calculate_checksum(drive)
    checksum = 0
    for i in eachindex(drive)
        (drive[i] == -1) && continue
        checksum += (i-1)*drive[i]
    end
    return checksum
end


function fragment_drive(drive)
    fragmented_drive = copy(drive)
    j = 1
    for i in length(fragmented_drive):-1:1
        while j <= length(fragmented_drive) && fragmented_drive[j] !== -1
            j += 1
        end
        (i < j) && break
        fragmented_drive[j] = fragmented_drive[i]
        fragmented_drive[i] = -1
    end
    return fragmented_drive
end


function read_disk_info(fn::String)
    return readline(fn)
end