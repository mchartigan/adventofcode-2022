#=
--- Part Two ---

Your device's communication system is correctly detecting packets, but still isn't working. It 
looks like it also needs to look for messages.

A start-of-message marker is just like a start-of-packet marker, except it consists of 14 distinct 
characters rather than 4.

Here are the first positions of start-of-message markers for all of the above examples:

  - mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
  - bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
  - nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
  - nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
  - zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26

How many characters need to be processed before the first start-of-message marker is detected?
=#

function main(file)
    i = 0   # line
    last = 0
    buf = UInt8[]   # initialize buffer
    len = 13        # max length of buf - 1

    # Open file and read each character
    f = open(file)
    for c in readeach(f, UInt8)
        i += 1
        length(buf) > len && popfirst!(buf)

        # find last absolute index of occurrence
        if (temp = findlast(buf .== c)) !== nothing
            temp = i - length(buf) + temp - 1
            temp > last && (last = temp)    # only assign if latest repeat is further
        end

        i > last + len && break

        push!(buf, c)   # add char to buffer
    end
    
    close(f)
    print("chars processed: $i")
end

main("input.txt")