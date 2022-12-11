#=
--- Day 11: Monkey in the Middle ---

As you finally start making your way upriver, you realize your pack is much lighter than you 
remember. Just then, one of the items from your pack goes flying overhead. Monkeys are playing Keep 
Away with your missing things!

To get your stuff back, you need to be able to predict where the monkeys will throw your items. 
After some careful observation, you realize the monkeys operate based on how worried you are about 
each item.

You take some notes (your puzzle input) on the items each monkey currently has, how worried you are 
about those items, and how the monkey makes decisions based on your worry level. For example:

Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1

Each monkey has several attributes:

  - Starting items lists your worry level for each item the monkey is currently holding in the 
    order they will be inspected.
  - Operation shows how your worry level changes as that monkey inspects an item. (An operation 
    like new = old * 5 means that your worry level after the monkey inspected the item is five 
    times whatever your worry level was before inspection.)
  - Test shows how the monkey uses your worry level to decide where to throw an item next.
      - If true shows what happens with an item if the Test was true.
      - If false shows what happens with an item if the Test was false.

After each monkey inspects an item but before it tests your worry level, your relief that the 
monkey's inspection didn't damage the item causes your worry level to be divided by three and 
rounded down to the nearest integer.

The monkeys take turns inspecting and throwing items. On a single monkey's turn, it inspects and 
throws all of the items it is holding one at a time and in the order listed. Monkey 0 goes first, 
then monkey 1, and so on until each monkey has had one turn. The process of each monkey taking a 
single turn is called a round.

When a monkey throws an item to another monkey, the item goes on the end of the recipient monkey's 
list. A monkey that starts a round with no items could end up inspecting and throwing many items by 
the time its turn comes around. If a monkey is holding no items at the start of its turn, its turn 
ends.

In the above example, the first round proceeds as follows:

< See https://adventofcode.com/2022/day/11 for full example >

After round 1, the monkeys are holding items with these worry levels:

Monkey 0: 20, 23, 27, 26
Monkey 1: 2080, 25, 167, 207, 401, 1046
Monkey 2: 
Monkey 3: 

Monkeys 2 and 3 aren't holding any items at the end of the round; they both inspected items during 
the round and threw them all before the round ended.

This process continues for a few more rounds:

...

After round 20, the monkeys are holding items with these worry levels:
Monkey 0: 10, 12, 14, 26, 34
Monkey 1: 245, 93, 53, 199, 115
Monkey 2: 
Monkey 3: 

Chasing all of the monkeys at once is impossible; you're going to have to focus on the two most 
active monkeys if you want any hope of getting your stuff back. Count the total number of times 
each monkey inspects items over 20 rounds:

Monkey 0 inspected items 101 times.
Monkey 1 inspected items 95 times.
Monkey 2 inspected items 7 times.
Monkey 3 inspected items 105 times.

In this example, the two most active monkeys inspected items 101 and 105 times. The level of monkey 
business in this situation can be found by multiplying these together: 10605.

Figure out which monkeys to chase by counting how many items they inspect over 20 rounds. What is 
the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?
=#

mutable struct Monkey
    items::Vector{Int}
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
    rounds = 20

    for i in range(1, rounds)   # iterate over each round
        for monkey in monkeys
            while !isempty(monkey.items)
                item = monkey.op(popfirst!(monkey.items)) ÷ 3
                monkey.test(item)
            end
        end
    end

    sort!(monkeys, by = x -> x.inspects, rev = true)
    println("Monkey business! $(monkeys[1].inspects * monkeys[2].inspects)")
end

main("input.txt")