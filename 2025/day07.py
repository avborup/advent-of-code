from sys import stdin

grid = [list(line.strip()) for line in stdin]
R, C = len(grid), len(grid[0])
S = [(r, c) for r in range(R) for c in range(C) if grid[r][c] == "S"]

part1 = 0
for r in range(1, R):
    for c in range(C):
        if grid[r-1][c] not in ("|", "S"):
            continue

        if grid[r][c] == ".":
            grid[r][c] = "|"
        elif grid[r][c] == "^":
            grid[r][c-1] = "|"
            grid[r][c+1] = "|"
            part1 += 1

    print("".join(grid[r]))

print("Part 1:", part1)
