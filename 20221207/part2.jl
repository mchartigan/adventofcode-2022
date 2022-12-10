#=
--- Part Two ---

Now, you're ready to choose a directory to delete.

The total disk space available to the filesystem is 70000000. To run the update, you need unused 
space of at least 30000000. You need to find a directory you can delete that will free up enough 
space to run the update.

In the example above, the total size of the outermost directory (and thus the total amount of used 
space) is 48381165; this means that the size of the unused space must currently be 21618835, which 
isn't quite the 30000000 required by the update. Therefore, the update still requires a directory 
with total size of at least 8381165 to be deleted before it can run.

To achieve this, you have the following options:

    Delete directory e, which would increase unused space by 584.
    Delete directory a, which would increase unused space by 94853.
    Delete directory d, which would increase unused space by 24933642.
    Delete directory /, which would increase unused space by 48381165.

Directories e and a are both too small; deleting them would not free up enough space. However, 
directories d and / are both big enough! Between these, choose the smallest: d, increasing unused 
space by 24933642.

Find the smallest directory that, if deleted, would free up enough space on the filesystem to run 
the update. What is the total size of that directory?
=#

mutable struct Dir
    files::Vector{Int128}
    subdirs::Vector{Dir}
end

function traverse!(tot::Vector{Int128}, dir::Dir, min::Int128)::Int128
    #= computes size of directory recursively, adds size to tot[1] if <=100,000 =#
    s = sum(dir.files)
    for subdir in dir.subdirs
        s += traverse!(tot, subdir, min)
    end

    # println(s)
    s > min && s < tot[1] && (tot[1] = s)    # set min viable dir size if smallest but > min
    return s
end

function main(file)
    f = open(file)
    dirs = Dict("/" => Dir(Int128[], Dir[])) # initialize filesystem with root
    pwd = String[]
    reading = false
    # stotal::Int128 = 0

    for line in eachline(f)
        if startswith(line, "\$ cd")
            # get cd call then either back out or go into new directory
            change = strip(split(line, " ")[end])
            change == ".." ? pop!(pwd) : push!(pwd, change)
        elseif startswith(line, "\$ ls")
            nothing     # do nothing if ls
        elseif startswith(line, "dir")
            # add to dict and push to pwd if new
            here = join(pwd, "/") * "/"     # join name with full path, dirs can have same name
            newdir = here * strip(split(line, " ")[end])
            if get(dirs, newdir, 0) == 0
                dirs[newdir] = Dir(Int128[], Dir[])
                push!(dirs[join(pwd, "/")].subdirs, dirs[newdir])
            end
        else
            # it's a file; get size and add to pwd.files
            bytes = parse(Int128, strip(split(line, " ")[1]))
            # stotal += bytes
            push!(dirs[join(pwd, "/")].files, bytes)
        end
    end

    close(f)

    fsmax::Int128 = 70000000
    dsize = Vector{Int128}([fsmax])
    fsys  = traverse!(dsize, dirs["/"], fsmax)
    traverse!(dsize, dirs["/"], 30000000 - (fsmax - fsys))
    

    println("Total size of root: $fsys")   # ($stotal)")
    println("Smallest dir > $(30000000 - (fsmax - fsys)): $(dsize[1])")
end

main("input.txt")