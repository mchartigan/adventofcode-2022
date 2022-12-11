#=
--- Part Two ---

You're worried you might not ever get your items back. So worried, in fact, that your relief that a 
monkey's inspection didn't damage an item no longer causes your worry level to be divided by three.

Unfortunately, that relief was all that was keeping your worry levels from reaching ridiculous 
levels. You'll need to find another way to keep your worry levels manageable.

At this rate, you might be putting up with these monkeys for a very long time - possibly 10000 
rounds!

With these new rules, you can still figure out the monkey business after 10000 rounds. Using the 
same example above:

== After round 1 ==
Monkey 0 inspected items 2 times.
Monkey 1 inspected items 4 times.
Monkey 2 inspected items 3 times.
Monkey 3 inspected items 6 times.

< See https://adventofcode.com/2022/day/11#part2 for full example >

== After round 10000 ==
Monkey 0 inspected items 52166 times.
Monkey 1 inspected items 47830 times.
Monkey 2 inspected items 1938 times.
Monkey 3 inspected items 52013 times.

After 10000 rounds, the two most active monkeys inspected items 52166 and 52013 times. Multiplying 
these together, the level of monkey business in this situation is now 2713310158.

Worry levels are no longer divided by three after each item is inspected; you'll need to find 
another way to keep your worry levels manageable. Starting again from the initial state in your 
puzzle input, what is the level of monkey business after 10000 rounds?
=#

mutable struct Monkey
    items::Vector{Int128}
    inspects::Int
    op
    test
    win::Monkey
    lose::Monkey
    Monkey() = (x = new(); x.inspects = 0; return x)
end

function pass!(self, x, func)
    #= how monkeys pass items between each other based on condition <func> =#
    func(x) ? push!(self.win.items, x) : push!(self.lose.items, x)
    self.inspects += 1
end

function initMonkeys(file)::Vector{Monkey}
    monkeys = Vector{Monkey}

    if file == "ex.txt"
        m0 = Monkey(); m0.items = [79, 98]; m0.op = x -> x * 19
        m1 = Monkey(); m1.items = [54, 65, 75, 74]; m1.op = x -> x + 6
        m2 = Monkey(); m2.items = [79, 60, 97]; m2.op = x -> x ^ 2
        m3 = Monkey(); m3.items = [74]; m3.op = x -> x + 3
        m0.test = x -> pass!(m0, x, x -> x % 23 == 0); m0.win = m2; m0.lose = m3
        m1.test = x -> pass!(m1, x, x -> x % 19 == 0); m1.win = m2; m1.lose = m0
        m2.test = x -> pass!(m2, x, x -> x % 13 == 0); m2.win = m1; m2.lose = m3
        m3.test = x -> pass!(m3, x, x -> x % 17 == 0); m3.win = m0; m3.lose = m1
        monkeys = [m0, m1, m2, m3]

    elseif file == "input.txt"
        m0 = Monkey(); m0.items = [56, 56, 92, 65, 71, 61, 79]; m0.op = x -> x * 7
        m1 = Monkey(); m1.items = [61, 85]; m1.op = x -> x + 5
        m2 = Monkey(); m2.items = [54, 96, 82, 78, 69]; m2.op = x -> x ^ 2
        m3 = Monkey(); m3.items = [57, 59, 65, 95]; m3.op = x -> x + 4
        m4 = Monkey(); m4.items = [62, 67, 80]; m4.op = x -> x * 17
        m5 = Monkey(); m5.items = [91]; m5.op = x -> x + 7
        m6 = Monkey(); m6.items = [79, 83, 64, 52, 77, 56, 63, 92]; m6.op = x -> x + 6
        m7 = Monkey(); m7.items = [50, 97, 76, 96, 80, 56]; m7.op = x -> x + 3
        m0.test = x -> pass!(m0, x, x -> x %  3 == 0); m0.win = m3; m0.lose = m7
        m1.test = x -> pass!(m1, x, x -> x % 11 == 0); m1.win = m6; m1.lose = m4
        m2.test = x -> pass!(m2, x, x -> x %  7 == 0); m2.win = m0; m2.lose = m7
        m3.test = x -> pass!(m3, x, x -> x %  2 == 0); m3.win = m5; m3.lose = m1
        m4.test = x -> pass!(m4, x, x -> x % 19 == 0); m4.win = m2; m4.lose = m6
        m5.test = x -> pass!(m5, x, x -> x %  5 == 0); m5.win = m1; m5.lose = m4
        m6.test = x -> pass!(m6, x, x -> x % 17 == 0); m6.win = m2; m6.lose = m0
        m7.test = x -> pass!(m7, x, x -> x % 13 == 0); m7.win = m3; m7.lose = m5
        monkeys = [m0, m1, m2, m3, m4, m5, m6, m7]
    end

    return monkeys
end

function main(file)
    # get monkeys manually
    monkeys = initMonkeys(file)
    rounds = 10000
    # max = 23 * 19 * 13 * 17
    max = 3 * 11 * 7 * 2 * 19 * 5 * 17 * 13

    for i in range(1, rounds)   # iterate over each round
        for monkey in monkeys
            while !isempty(monkey.items)
                item = monkey.op(popfirst!(monkey.items)) % max
                monkey.test(item)
            end
        end
    end

    sort!(monkeys, by = x -> x.inspects, rev = true)
    println("Monkey business! $(monkeys[1].inspects * monkeys[2].inspects)")
end

main("input.txt")