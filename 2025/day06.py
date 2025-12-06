from functools import reduce
from operator import mul
from sys import stdin

lines = [line for line in stdin]
grid = []
for line in lines:
    items = [i for i in line.strip().split() if len(i) > 0]
    grid.append(items)

part1 = 0
for col in range(len(grid[0])):
    operator = grid[-1][col]
    res = 0 if operator == "+" else 1
    for row in range(len(grid)-1):
        cell = int(grid[row][col])
        if operator == "+":
            res += cell
        elif operator == "*":
            res *= cell
    part1 += res

c = 0
part2 = 0
for _ in range(len(grid[0])):
    operator = grid[-1][_]

    until = c
    for d in range(c+1, len(lines[0])):
        if lines[-1][d] != " ":
            until = d + (lines[-1][d] == "\n")
            break

    nums = []
    for cc in range(c, until-1):
        digits = []
        for row in range(len(lines)-1):
            digits.append(lines[row][cc])
        num = int(''.join(digits))
        nums.append(num)

    if operator == "+":
        part2 += sum(nums)
    else:
        part2 += reduce(mul, nums, 1)

    c = until

print("Part 1:", part1)
print("Part 2:", part2)
