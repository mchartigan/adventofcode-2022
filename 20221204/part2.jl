#=
--- Part Two ---

It seems like there is still quite a bit of duplicate work planned. Instead, the Elves would like 
to know the number of pairs that overlap at all.

In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap, while the remaining 
four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do overlap:

  - 5-7,7-9 overlaps in a single section, 7.
  - 2-8,3-7 overlaps all of the sections 3 through 7.
  - 6-6,4-6 overlaps in a single section, 6.
  - 2-6,4-8 overlaps in sections 4, 5, and 6.

So, in this example, the number of overlapping assignment pairs is 4.

In how many assignment pairs do the ranges overlap?
=#

function main(file)
    f = open(file)
    int = 0

    for line in eachline(f)
        s1, e1, s2, e2 = [parse(Int, c) for c in split(line, ['-',','])]
        elf1 = range(s1, e1)
        elf2 = range(s2, e2)

        if length(intersect(elf1, elf2)) != 0
            int += 1
        end
    end

    print("$int pairs that intersect.\n")
end

main("input.txt")