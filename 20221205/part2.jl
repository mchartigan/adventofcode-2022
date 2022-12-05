#=
--- Part Two ---

As you watch the crane operator expertly rearrange the crates, you notice the process isn't 
following your prediction.

Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane 
isn't a CrateMover 9000 - it's a CrateMover 9001.

The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, 
an extra cup holder, and the ability to pick up and move multiple crates at once.

Again considering the example above, the crates begin in the same configuration:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

Moving a single crate from stack 2 to stack 1 behaves the same as before:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 

However, the action of moving three crates from stack 1 to stack 3 means that those three moved 
crates stay in the same order, resulting in this new configuration:

        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3

Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:

        [D]
        [N]
[C]     [Z]
[M]     [P]
 1   2   3

Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3

In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.

Before the rearrangement process finishes, update your simulation so that the Elves know where they 
should stand to be ready to unload the final supplies. After the rearrangement procedure completes, 
what crate ends up on top of each stack?
=#

function main(file)
    f = open(file)
    stacklines = String[]
    stacks = []
    move = false
    num = 0
    temp = Char[]   # temporary stack
   
    for line in eachline(f)
        #= first, parse the stack diagram and put it into actual stacks (just lists in this case
           since julia can perform stack operations on those). next, iterate over the commands and
           apply those operations to the stacks
        =#
        if !move    # start of stack commands haven't been reached
            if !startswith(line, " 1 ")
                push!(stacklines, line)
            else    # generate stacks
                move = true
                num = parse(Int, split(strip(line), ' ')[end])  # last number in num of stacks
                stacks = [Char[] for x in range(1, num)]

                reverse!(stacklines)    # parse stacks from bottom to top

                for crates in stacklines
                    for i in range(1, num)
                        if crates[i + 1 + 3*(i-1)] != ' '   # if it isn't blank, add the crate
                            push!(stacks[i], crates[i + 1 + 3*(i-1)])
                        end
                    end
                end
            end
        else        # start of stack commands  
            if line != ""   # if line not blank
                cmd = [parse(Int, x) for x in split(line, r"move | from | to ")[2:end]]

                # not elegant as it increases runtime a little, but push to temp then pull to order
                for i in range(1, cmd[1])
                    push!(temp, pop!(stacks[cmd[2]]))
                end
                for i in range(1, cmd[1])
                    push!(stacks[cmd[3]], pop!(temp))
                end
            end
        end
    end

    ans = ""
    for i in range(1,num)
        ans = ans*pop!(stacks[i])
    end
    print(ans)
end

main("input.txt")