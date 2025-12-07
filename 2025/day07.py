from sys import stdin
from collections import defaultdict
from termcolor import colored
from functools import cache

grid = [list(line.strip()) for line in stdin]
R, C = len(grid), len(grid[0])
S = [(r, c) for r in range(R) for c in range(C) if grid[r][c] == "S"][0]

part1 = 0
graph = defaultdict(lambda: set())
for r in range(1, R):
    for c in range(C):
        if grid[r-1][c] not in "|S":
            continue

        if grid[r][c] in ".|":
            grid[r][c] = "|"
            graph[(r-1, c)].add((r, c))
        elif grid[r][c] == "^":
            grid[r][c-1] = "|"
            grid[r][c+1] = "|"
            part1 += 1
            graph[(r-1, c)].add((r, c-1))
            graph[(r-1, c)].add((r, c+1))

@cache
def dfs(v):
    if v[0] == R-1:
        return 1
    return sum(dfs(a) for a in graph[v])

print("Part 1:", part1)
print("Part 2:", dfs(S))
