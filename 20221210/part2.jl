#=
--- Part Two ---

It seems like the X register controls the horizontal position of a sprite. Specifically, the sprite 
is 3 pixels wide, and the X register sets the horizontal position of the middle of that sprite. (In 
this system, there is no such thing as "vertical position": if the sprite's horizontal position 
puts its pixels where the CRT is currently drawing, then those pixels will be drawn.)

You count the pixels on the CRT: 40 wide and 6 high. This CRT screen draws the top row of pixels 
left-to-right, then the row below that, and so on. The left-most pixel in each row is in position 
0, and the right-most pixel in each row is in position 39.

Like the CPU, the CRT is tied closely to the clock circuit: the CRT draws a single pixel during 
each cycle. Representing each pixel of the screen as a #, here are the cycles during which the 
first and last pixel in each row are drawn:

Cycle   1 -> ######################################## <- Cycle  40
Cycle  41 -> ######################################## <- Cycle  80
Cycle  81 -> ######################################## <- Cycle 120
Cycle 121 -> ######################################## <- Cycle 160
Cycle 161 -> ######################################## <- Cycle 200
Cycle 201 -> ######################################## <- Cycle 240

So, by carefully timing the CPU instructions and the CRT drawing operations, you should be able to 
determine whether the sprite is visible the instant each pixel is drawn. If the sprite is 
positioned such that one of its three pixels is the pixel currently being drawn, the screen 
produces a lit pixel (#); otherwise, the screen leaves the pixel dark (.).

The first few pixels from the larger example above are drawn as follows:

Sprite position: ###.....................................

Start cycle   1: begin executing addx 15
During cycle  1: CRT draws pixel in position 0
Current CRT row: #

During cycle  2: CRT draws pixel in position 1
Current CRT row: ##
End of cycle  2: finish executing addx 15 (Register X is now 16)
Sprite position: ...............###......................

Start cycle   3: begin executing addx -11
During cycle  3: CRT draws pixel in position 2
Current CRT row: ##.

< See https://adventofcode.com/2022/day/10 for full example >

Allowing the program to run to completion causes the CRT to produce the following image:

##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....

Render the image given by your program. What eight capital letters appear on your CRT?
=#

function main(file)
    # get commands
    f = open(file)

    x = 1       # starting value of register X
    buf = 0     # time buffer til next command is executed
    toadd = 0   # number to add to X when current command finishes

    for c in range(1, 240)
        i = (c - 1) % 40    # screen row pixel position

        if buf == 0 # if buffer has run out
            x += toadd
            line = readline(f)

            if startswith(line, "noop")
                buf += 1  # increment wait cycles (noop takes 1)
                toadd = 0
            elseif startswith(line, "addx")
                _, toadd = split(strip(line), " ")
                toadd = parse(Int, toadd)   # get number to add
                buf += 2  # increment wait cycles (addx takes 2)
            end
        end

        abs(x - i) <= 1 ? print("#") : print(" ")   # print char if sprite occupies tile
        c % 40 == 0 && print("\n")                  # print newline when that matters

        buf -= 1    # reduce cycle wait time
    end

    close(f)
end

main("input.txt")