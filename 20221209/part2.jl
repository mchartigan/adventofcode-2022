#=
--- Part Two ---

A rope snaps! Suddenly, the river is getting a lot closer than you remember. The bridge is still 
there, but some of the ropes that broke are now whipping toward you as you fall through the air!

The ropes are moving too quickly to grab; you only have a few seconds to choose how to arch your 
body to avoid being hit. Fortunately, your simulation can be extended to support longer ropes.

Rather than two knots, you now must simulate a rope consisting of ten knots. One knot is still the 
head of the rope and moves according to the series of motions. Each knot further down the rope 
follows the knot in front of it using the same rules as before.

Using the same series of motions as the above example, but with the knots marked H, 1, 2, ..., 9, 
the motions now occur as follows:

< See https://adventofcode.com/2022/day/9 for full example >

Now, you need to keep track of the positions the new tail, 9, visits. In this example, the tail 
never moves, and so it only visits 1 position. However, be careful: more types of motion are 
possible than before, so you might want to visually compare your simulated rope to the one above.

Here's a larger example:

R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20

These motions occur as follows (individual steps are not shown):

== Initial State ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
...........H..............  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)
..........................
..........................
..........................
..........................
..........................

< See https://adventofcode.com/2022/day/9 for full example >

Now, the tail (9) visits 36 positions (including s) at least once:

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
#.........................
#.............###.........
#............#...#........
.#..........#.....#.......
..#..........#.....#......
...#........#.......#.....
....#......s.........#....
.....#..............#.....
......#............#......
.......#..........#.......
........#........#........
.........########.........

Simulate your complete series of motions on a larger rope with ten knots. How many positions does 
the tail of the rope visit at least once?
=#

function move!(rope::Matrix{Int64}, tail::Int, head::Int)::Bool
    #= check if tail needs to be moved and do so if it does =#
    old = copy(rope[tail,:])
    # head has moved beyond reach
    if abs(rope[head,1] - rope[tail,1]) > 1 || abs(rope[head,2] - rope[tail,2]) > 1
        rope[tail,1] += sign(rope[head,1] - rope[tail,1])   # move L/R if needed
        rope[tail,2] += sign(rope[head,2] - rope[tail,2])   # move U/D if needed
    end

    return rope[tail,:] !== old    # return if tail was moved
end

function main(file)
    f = open(file)
    x = zeros(Int64, 10, 2) # starting position of rope
    hist = [copy(x[10,:])]  # visited points by tail

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

        for _ in range(1, num)      # repeat head move several times
            x[1,idx] += sgn         # update head
            for i in range(1, 9)    # move entire rope
                # add new tail location if moved
                move!(x, i+1, i) && i == 9 && push!(hist, copy(x[10,:]))
            end
        end
    end

    close(f)

    println("$(length(unique(hist))) unique tiles visited")
end

main("input.txt")