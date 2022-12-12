#=
--- Day 12: Hill Climbing Algorithm ---

You try contacting the Elves using your handheld device, but the river you're following must be too 
low to get a decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows 
the local area from above broken into a grid; the elevation of each square of the grid is given by 
a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to 
the highest elevation, z.

Also included on the heightmap are marks for your current position (S) and the location that should 
get the best signal (E). Your current position (S) has elevation a, and the location that should 
get the best signal (E) has elevation z.

You'd like to reach E, but to save energy, you should do it in as few steps as possible. During 
each step, you can move exactly one square up, down, left, or right. To avoid needing to get out 
your climbing gear, the elevation of the destination square can be at most one higher than the 
elevation of your current square; that is, if your current elevation is m, you could step to 
elevation n, but not to elevation o. (This also means that the elevation of the destination square 
can be much lower than the elevation of your current square.)

For example:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi

Here, you start in the top-left corner; your goal is near the middle. You could start by moving 
down or right, but eventually you'll need to head toward the e at the bottom. From there, you can 
spiral around to the goal:

v..v<<<<
>v.vv<<^
.>vv>E^^
..v>>>^^
..>>>>>^

In the above diagram, the symbols indicate whether the path exits each square moving up (^), down 
(v), left (<), or right (>). The location that should get the best signal is still E, and . marks 
unvisited squares.

This path reaches the goal in 31 steps, the fewest possible.

What is the fewest steps required to move from your current position to the location that should 
get the best signal?
=#

mutable struct Node
    nbrs::Vector{Node}
    dist::Int
    prev
    elev::Int
    start::Bool
    finish::Bool
end

function getNodes!(file, ends::Vector{CartesianIndex})::Matrix{Node}
    #= parses file and returns network of nodes =#

    # get file input
    f = open(file)
    lines = readlines(f)
    close(f)

    # make map of nodes
    nrows = length(lines); ncols = length(lines[1])
    nodes = Matrix{Node}(undef, nrows, ncols)

    for (i, line) in enumerate(lines)
        for j in range(1, ncols)
            h = Int(line[j]) - Int('a') 
            nodes[i,j] = Node(Node[], 1000000, 0, h, h == -14 ? true : false, h == -28 ? true : false)
        end
    end

    # correct and add start and finish
    srt = findfirst(x -> x.start, nodes)    # starting indices
    fin = findfirst(x -> x.finish, nodes)   # ending indices
    nodes[srt].elev = Int('a') - Int('a')   # correct elevation
    nodes[srt].dist = 0
    nodes[fin].elev = Int('z') - Int('a')
    push!(ends, srt)
    push!(ends, fin)

    for i in range(1, nrows)
        for j in range(1, ncols)
            here = nodes[i,j]

            for next in [(-1,0),(1,0),(0,-1),(0,1)]
                try
                    n = nodes[i+next[1], j+next[2]]
                    n.elev - here.elev <= 1 && push!(here.nbrs, n)
                catch   # catch BoundsError
                    nothing
                end
            end
        end
    end

    return nodes
end

function main(file)
    ends = CartesianIndex[]
    nodes = getNodes!(file, ends)
    srt = ends[1]; fin = ends[2]
    nrows = length(nodes[:,1]); ncols = length(nodes[1,:])

    # djikstras shortest path
    dist = zeros(Int, nrows, ncols)
    queue = vec(nodes)

    while length(queue) > 0
        sort!(queue, by = x -> x.dist)
        u = popfirst!(queue)
        for n in u.nbrs
            if n ∈ queue
                dist = u.dist + 1
                if dist < n.dist
                    n.dist = dist
                    n.prev = u
                end
            end
        end
    end

    println("Shortest path: $(nodes[fin].dist) steps")
end

main("input.txt")
