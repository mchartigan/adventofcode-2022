#=
--- Part Two ---

As you walk up the hill, you suspect that the Elves will want to turn this into a hiking trail. The 
beginning isn't very scenic, though; perhaps you can find a better starting point.

To maximize exercise while hiking, the trail should start as low as possible: elevation a. The goal 
is still the square marked E. However, the trail should still be direct, taking the fewest steps to 
reach its goal. So, you'll need to find the shortest path from any square at elevation a to the 
square marked E.

Again consider the example from above:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi

Now, there are six choices for starting position (five marked a, plus the square marked S that 
counts as being at elevation a). If you start at the bottom-left square, you can reach the goal 
most quickly:

...v<<<<
...vv<<^
...v>E^^
.>v>>>^^
>^>>>>>^

This path reaches the goal in only 29 steps, the fewest possible.

What is the fewest steps required to move starting from any square with elevation a to the location 
that should get the best signal?
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

    here = nodes[fin]
    truepath = 0
    while here.prev.elev > 0    # may be off by one depending on specific path chosen
        truepath += 1
        here = here.prev
    end
    println("Shortest path from E to a: $truepath steps")
end

main("ex.txt")
