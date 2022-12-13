#=
--- Part Two ---

Now, you just need to put all of the packets in the right order. Disregard the blank lines in your 
list of received packets.

The distress signal protocol also requires that you include two additional divider packets:

[[2]]
[[6]]

Using the same rules as before, organize all packets - the ones in your list of received packets as 
well as the two divider packets - into the correct order.

For the example above, the result of putting the packets in the correct order is:

[]
[[]]
[[[]]]
[1,1,3,1,1]
[1,1,5,1,1]
[[1],[2,3,4]]
[1,[2,[3,[4,[5,6,0]]]],8,9]
[1,[2,[3,[4,[5,6,7]]]],8,9]
[[1],4]
[[2]]
[3]
[[4,4],4,4]
[[4,4],4,4,4]
[[6]]
[7,7,7]
[7,7,7,7]
[[8,7,6]]
[9]

Afterward, locate the divider packets. To find the decoder key for this distress signal, you need 
to determine the indices of the two divider packets and multiply them together. (The first packet 
is at index 1, the second packet is at index 2, and so on.) In this example, the divider packets 
are 10th and 14th, and so the decoder key is 140.

Organize all of the packets into the correct order. What's the decoder key for the distress signal?
=#

function parseArray(str::String)::Vector
    #= parse array string into nested arrays =#

    main = []
    tree = [main]   # how many arrays in are we
    num = ""        # gotta account for 10 cuz they're cunts
    for c in str[2:end]
        if c == '['         # push new array onto stack
            push!(tree[end], [])
            push!(tree, tree[end][end])
        elseif c == ']'     # pop last array from stack
            # add previous element
            length(num) > 0 && push!(tree[end], parse(Int, num))
            num = ""        # reset
            # wrap up array depth
            pop!(tree)
        elseif c == ','     # ignore
            length(num) > 0 && push!(tree[end], parse(Int, num))
            num = ""        # reset
        else                # must be number, push onto array at top of stack
            num = num * c   # add digit to number
        end
    end

    return main
end

function compare(left, right)
    #= returns -1 if left < right, 0 if left == right, 1 if left > right =#

    for i in range(1, length(right))
        length(left) < i && return -1       # left shorter than right

        l = left[i]; r = right[i]
        if typeof(l) == Int && typeof(r) == Int # both ints
            l < r && return -1          # left less than right
            l > r && return 1           # right less than left
        elseif isa(l, Vector) && isa(r, Vector) # both vectors, return if not equal
            (res = compare(l, r)) !== 0 && return res
        else
            res = isa(l, Vector) ? compare(l, [r]) : compare([l], r)
            res !== 0 && return res     # return if they weren't equal, otherwise continue
        end
    end
    # equal or left was longer
    return length(left) - length(right) == 0 ? 0 : 1
end

function main(file)
    f = open(file)
    lines = readlines(f)
    close(f)

    packets = []

    for i in range(1, length(lines), step=3)
        left = parseArray(lines[i])
        right = parseArray(lines[i+1])
        
        push!(packets, left, right)
    end

    push!(packets, [[2]], [[6]])
    lesser(x, y) = compare(x, y) == -1 ? true : false
    sort!(packets, lt=lesser)

    val = findfirst(x -> x == [[2]], packets) * findfirst(x -> x == [[6]], packets)
    println("Decoder key: $val")
end

main("input.txt")   # input answer should be between 2000 - 5032
