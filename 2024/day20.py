from sys import stdin

grid = {
    complex(c, r): v
    for r, ln in enumerate(l.strip() for l in stdin)
    for c, v in enumerate(ln)
}
start = next(k for k, v in grid.items() if v == 'S')
end = next(k for k, v in grid.items() if v == 'E')

def dfs():
    path, visited = [start], set()
    for pos in path:
        visited.add(pos)
        for d in [1, -1, 1j, -1j]:
            npos = pos + d
            if grid[npos] != '#' and npos not in visited:
                path.append(npos)
    return path

path = dfs()
part1, part2 = 0, 0
for i in range(len(path)):
    for j in range(i + 1, len(path)):
        a, b = path[i], path[j]

        skip_dist = abs(a.real - b.real) + abs(a.imag - b.imag)
        time_saved = (j - i) - skip_dist

        part1 += skip_dist <= 2 and time_saved >= 100
        part2 += skip_dist <= 20 and time_saved >= 100

print("Part 1:", part1)
print("Part 2:", part2)
