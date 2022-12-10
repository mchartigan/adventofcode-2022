#=
--- Part Two ---

Content with the amount of tree cover available, the Elves just need to know the best spot to build 
their tree house: they would like to be able to see a lot of trees.

To measure the viewing distance from a given tree, look up, down, left, and right from that tree; 
stop if you reach an edge or at the first tree that is the same height or taller than the tree 
under consideration. (If a tree is right on the edge, at least one of its viewing distances will be 
zero.)

The Elves don't care about distant trees taller than those found by the rules above; the proposed 
tree house has large eaves to keep it dry, so they wouldn't be able to see higher than the tree 
house anyway.

In the example above, consider the middle 5 in the second row:

30373
25512
65332
33549
35390

  - Looking up, its view is not blocked; it can see 1 tree (of height 3).
  - Looking left, its view is blocked immediately; it can see only 1 tree (of height 5, right next 
    to it).
  - Looking right, its view is not blocked; it can see 2 trees.
  - Looking down, its view is blocked eventually; it can see 2 trees (one of height 3, then the 
    tree of height 5 that blocks its view).

A tree's scenic score is found by multiplying together its viewing distance in each of the four 
directions. For this tree, this is 4 (found by multiplying 1 * 1 * 2 * 2).

However, you can do even better: consider the tree of height 5 in the middle of the fourth row:

30373
25512
65332
33549
35390

  - Looking up, its view is blocked at 2 trees (by another tree with a height of 5).
  - Looking left, its view is not blocked; it can see 2 trees.
  - Looking down, its view is also not blocked; it can see 1 tree.
  - Looking right, its view is blocked at 2 trees (by a massive tree of height 9).

This tree's scenic score is 8 (2 * 2 * 1 * 2); this is the ideal spot for the tree house.

Consider each tree on your map. What is the highest scenic score possible for any tree?
=#

function main(file)
    # get lines from file
    f = open(file)
    lines = readlines(f)
    close(f)

    # initialize visibility matrix of same size as input
    nrows = length(lines)
    ncols = length(lines[1])
    vis = ones(Int64, nrows, ncols)

    # transform input into matrix of Int64
    height = [[parse(Int64, c) for c in line] for line in lines]
    height = reduce(vcat, transpose(height))

    # matrix is stored natively in columns so this is faster than eachrow()
    for (i, row) in enumerate(eachcol(height'))
        for j in range(1, ncols)
            # check left of element
            first = findfirst(x -> x >= row[j], reverse(row[1:j-1]))
            vis[i,j] *= first !== nothing ? first : length(row[1:j-1])
            # check right of element
            first = findfirst(x -> x >= row[j], row[j+1:end])
            vis[i,j] *= first !== nothing ? first : length(row[j+1:end])
        end
    end

    for (j, col) in enumerate(eachcol(height))
        for i in range(1, nrows)
            # check above element
            first = findfirst(x -> x >= col[i], reverse(col[1:i-1]))
            vis[i,j] *= first !== nothing ? first : length(col[1:i-1])
            # check below element
            first = findfirst(x -> x >= col[i], col[i+1:end])
            vis[i,j] *= first !== nothing ? first : length(col[i+1:end])
        end
    end

    println("Max scenic score: $(maximum(vis))")
end

main("input.txt")