#=
--- Day 9: Rope Bridge ---

This rope bridge creaks as you walk along it. You aren't sure how old it is, or whether it can even 
support your weight.

It seems to support the Elves just fine, though. The bridge spans a gorge which was carved out by 
the massive river far below you.

You step carefully; as you do, the ropes stretch and twist. You decide to distract yourself by 
modeling rope physics; maybe you can even figure out where not to step.

Consider a rope with a knot at each end; these knots mark the head and the tail of the rope. If the 
head moves far enough away from the tail, the tail is pulled toward the head.

Due to nebulous reasoning involving Planck lengths, you should be able to model the positions of 
the knots on a two-dimensional grid. Then, by following a hypothetical series of motions (your 
puzzle input) for the head, you can determine how the tail will move.

Due to the aforementioned Planck lengths, the rope must be quite short; in fact, the head (H) and 
tail (T) must always be touching (diagonally adjacent and even overlapping both count as touching):

....
.TH.
....

....
.H..
..T.
....

...
.H. (H covers T)
...

If the head is ever two steps directly up, down, left, or right from the tail, the tail must also 
move one step in that direction so it remains close enough:

.....    .....    .....
.TH.. -> .T.H. -> ..TH.
.....    .....    .....

...    ...    ...
.T.    .T.    ...
.H. -> ... -> .T.
...    .H.    .H.
...    ...    ...

Otherwise, if the head and tail aren't touching and aren't in the same row or column, the tail 
always moves one step diagonally to keep up:

.....    .....    .....
.....    ..H..    ..H..
..H.. -> ..... -> ..T..
.T...    .T...    .....
.....    .....    .....

.....    .....    .....
.....    .....    .....
..H.. -> ...H. -> ..TH.
.T...    .T...    .....
.....    .....    .....

You just need to work out where the tail goes as the head follows a series of motions. Assume the 
head and the tail both start at the same position, overlapping.

< See https://adventofcode.com/2022/day/9 for full example >

After simulating the rope, you can count up all of the positions the tail visited at least once. In 
this diagram, s again marks the starting position (which the tail also visited) and # marks other 
positions the tail visited:

..##..
...##.
.####.
....#.
s###..

So, there are 13 positions the tail visited at least once.

Simulate your complete hypothetical series of motions. How many positions does the tail of the rope 
visit at least once?
=#

function move!(tail::Vector{Int64}, head::Vector{Int64}, sgn::Int, i::Int)::Bool
    #= check if tail needs to be moved and do so if it does =#
    old = copy(head)    # store previous head
    head[i] += sgn      # update head
    if abs(head[1] - tail[1]) > 1 || abs(head[2] - tail[2]) > 1
        tail[1] = old[1]; tail[2] = old[2]  # update tail vector
        return true     # tail was moved
    end

    return false        # tail wasn't moved
end

function main(file)
    f = open(file)
    x = [0,0]   # starting position of tail
    y = [0,0]   # starting position of head
    hist = [copy(x)]  # visited points by tail

    for cmd in eachline(f)
        dir, num = split(strip(cmd), " ")
        num = parse(Int, num)

        # cover possible directions
        if dir =="L"
            sgn = -1; idx = 1
        elseif dir == "R"
            sgn =  1; idx = 1
        elseif dir == "U"
            sgn =  1; idx = 2
        elseif dir == "D"
            sgn = -1; idx = 2
        end

        for _ in range(1, num)  # repeat head move several times
            move!(x, y, sgn, idx) && push!(hist, copy(x)) # add new tail location if moved
        end
    end

    close(f)

    println("$(length(unique(hist))) unique tiles visited")
end

main("input.txt")
