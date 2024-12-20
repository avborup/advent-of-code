from sys import stdin
from collections import deque, defaultdict
from typing import Counter

grid = defaultdict(lambda: '#', {
    complex(c, r): v
    for r, ln in enumerate(l.strip() for l in stdin)
    for c, v in enumerate(ln)
})
start = next(k for k, v in grid.items() if v == 'S')
end = next(k for k, v in grid.items() if v == 'E')


def bfs():
    q = deque([(start, 0)])
    non_walls, visited = [], set()
    while q:
        pos, dist = q.popleft()

        if pos in visited:
            continue

        visited.add(pos)
        non_walls.append(pos)

        if pos == end:
            return dist, non_walls

        for d in [1, -1, 1j, -1j]:
            npos = pos + d
            if npos not in visited and grid[npos] != '#':
                q.append((npos, dist + 1))

best_dist, non_walls = bfs()
part1, part2 = 0, 0

for i in range(len(non_walls)):
    for j in range(i + 1, len(non_walls)):
        a, b = non_walls[i], non_walls[j]

        skip_dist = abs(a.real - b.real) + abs(a.imag - b.imag)
        time_saved = (j - i) - skip_dist

        if skip_dist <= 20:
            if time_saved >= 100:
                part1 += 1

print("Part 1:", part1)
print("Part 2:", part2)
