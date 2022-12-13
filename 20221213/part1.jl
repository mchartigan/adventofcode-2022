#=
--- Day 13: Distress Signal ---

You climb the hill and again try contacting the Elves. However, you instead receive a signal you 
weren't expecting: a distress signal.

Your handheld device must still not be working properly; the packets from the distress signal got 
decoded out of order. You'll need to re-order the list of received packets (your puzzle input) to 
decode the message.

Your list consists of pairs of packets; pairs are separated by a blank line. You need to identify 
how many pairs of packets are in the right order.

For example:

< See ex.txt >

Packet data consists of lists and integers. Each list starts with [, ends with ], and contains zero 
or more comma-separated values (either integers or other lists). Each packet is always a list and 
appears on its own line.

When comparing two values, the first value is called left and the second value is called right. 
Then:

  - If both values are integers, the lower integer should come first. If the left integer is lower 
    than the right integer, the inputs are in the right order. If the left integer is higher than 
    the right integer, the inputs are not in the right order. Otherwise, the inputs are the same 
    integer; continue checking the next part of the input.
  - If both values are lists, compare the first value of each list, then the second value, and so 
    on. If the left list runs out of items first, the inputs are in the right order. If the right 
    list runs out of items first, the inputs are not in the right order. If the lists are the same 
    length and no comparison makes a decision about the order, continue checking the next part of 
    the input.
  - If exactly one value is an integer, convert the integer to a list which contains that integer 
    as its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert 
    the right value to [2] (a list containing 2); the result is then found by instead comparing 
    [0,0,0] and [2].

Using these rules, you can determine which of the pairs in the example are in the right order:

== Pair 1 ==
- Compare [1,1,3,1,1] vs [1,1,5,1,1]
  - Compare 1 vs 1
  - Compare 1 vs 1
  - Compare 3 vs 5
    - Left side is smaller, so inputs are in the right order

== Pair 2 ==
- Compare [[1],[2,3,4]] vs [[1],4]
  - Compare [1] vs [1]
    - Compare 1 vs 1
  - Compare [2,3,4] vs 4
    - Mixed types; convert right to [4] and retry comparison
    - Compare [2,3,4] vs [4]
      - Compare 2 vs 4
        - Left side is smaller, so inputs are in the right order

< See https://adventofcode.com/2022/day/13 for full example >

What are the indices of the pairs that are already in the right order? (The first pair has index 1, 
the second pair has index 2, and so on.) In the above example, the pairs in the right order are 1, 
2, 4, and 6; the sum of these indices is 13.

Determine which pairs of packets are already in the right order. What is the sum of the indices of 
those pairs?
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

    sum = 0

    for i in range(1, length(lines), step=3)
        left = parseArray(lines[i])
        right = parseArray(lines[i+1])
        
        compare(left, right) < 0 && (sum += Int(ceil(i / 3)))
    end

    println("Sum: $sum")
end

main("ex.txt")   # input answer should be between 2000 - 5032
