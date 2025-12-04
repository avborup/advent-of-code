from sys import stdin

grid = [line.strip() for line in stdin]
R, C = len(grid), len(grid[0])

part1, part2 = 0, 0
lolleren = set()

for r in range(R):
    for c in range(C):
        diffs = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        num_neighbors = 0
        for dr, dc in diffs:
            rr, cc = (r + dr, c + dc)
            if 0 <= rr < R and 0 <= cc < C and grid[rr][cc] == '@':
                num_neighbors += 1
        if grid[r][c] == '@' and num_neighbors < 4:
            lolleren.add((r, c))
            part1 += 1

for r in range(R):
    for c in range(C):
        if (r, c) in lolleren:
            print("X", end="")
        else:
            print(grid[r][c], end="")
    print()

print("Part 1:", part1)

# ..xx.xx@x.
# x@@.@.@.@@
# @@@@@.x.@@
# @.@@@@..@.
# x@.@@@@.@x
# .@@@@@@@.@
# .@.@.@.@@@
# x.@@@.@@@@
# .@@@@@@@@.
# x.x.@@@.x.
