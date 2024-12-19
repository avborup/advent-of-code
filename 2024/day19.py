from sys import stdin
from collections import deque
from functools import cache

valid = next(stdin).strip().split(", ")
next(stdin)
designs = [l.strip() for l in stdin]

part1, part2 = 0, 0

@cache
def dfs(design):
    if len(design) == 0:
        return 1

    tot = 0
    for pattern in valid:
        if design.startswith(pattern):
            new_design = design[len(pattern):]
            tot += dfs(new_design)
    return tot


for i, design in enumerate(designs):
    res = dfs(design)
    print(i, design, res)
    part1 += res


print("Part 1:", part1)
print("Part 2:", part2)
