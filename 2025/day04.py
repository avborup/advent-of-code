from sys import stdin

grid = [list(line.strip()) for line in stdin]
R, C = len(grid), len(grid[0])

part1, part2 = 0, 0
changed = True
first = True

while changed:
    changed = False
    new_grid = [[col for col in row] for row in grid]

    for r in range(R):
        for c in range(C):
            diffs = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
            num_neighbors = 0
            for dr, dc in diffs:
                rr, cc = (r + dr, c + dc)
                if 0 <= rr < R and 0 <= cc < C and grid[rr][cc] == '@':
                    num_neighbors += 1
            if grid[r][c] == '@' and num_neighbors < 4:
                new_grid[r][c] = 'x'
                if first:
                    part1 += 1
                part2 += 1
                changed = True

    grid = new_grid
    first = False

print("Part 1:", part1)
print("Part 2:", part2)
