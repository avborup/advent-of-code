from sys import stdin
from collections import deque

rows = [[int(x) for x in l.split(",")] for l in stdin]
W, H = max(x[0] for x in rows), max(x[1] for x in rows)

def bfs(num_bytes):
    grid = { complex(x, y): 1 for x,y in rows[:num_bytes] }
    start, end = complex(0, 0), complex(W, H)
    queue, visited = deque([(start, 0)]), set()

    while queue:
        pos, dist = queue.popleft()

        if pos == end:
            return dist
        if pos in visited:
            continue
        visited.add(pos)

        for d in [1, -1, 1j, -1j]:
            new = pos + d
            if new not in grid and 0 <= new.real <= W and 0 <= new.imag <= H:
                queue.append((new, dist + 1))

    return None

lo, hi = 1024, len(rows) + 1
part1 = bfs(lo)

while lo < hi:
    mid = (lo + hi) // 2
    if bfs(mid) is not None:
        lo = mid + 1
    else:
        hi = mid

part2 = f"{rows[lo-1][0]},{rows[lo-1][1]}"
print("Part 1:", part1)
print("Part 2:", part2)
