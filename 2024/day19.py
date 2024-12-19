from sys import stdin
from functools import cache

valid = next(stdin).strip().split(", ")
designs = [l.strip() for l in stdin][1:]

@cache
def solve(design):
    if len(design) == 0:
        return 1

    num_options = 0
    for pattern in valid:
        if design.startswith(pattern):
            num_options += solve(design[len(pattern):])

    return num_options

part1, part2 = 0, 0
for design in designs:
    num_options = solve(design)
    part1 += 1 if num_options > 0 else 0
    part2 += num_options

print("Part 1:", part1)
print("Part 2:", part2)
