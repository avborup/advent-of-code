from sys import stdin
from collections import defaultdict, deque


rows = [[int(x) for x in l.split(",")] for l in stdin]
W, H = max(x[0] for x in rows), max(x[1] for x in rows)

# # print grid
# for y in range(int(H) + 1):
#     for x in range(int(W) + 1):
#         if complex(x, y) == start:
#             print("S", end="")
#         elif complex(x, y) == end:
#             print("E", end="")
#         else:
#             print("#" if complex(x, y) in grid else ".", end="")
#     print()

def bfs(num_bytes):
    grid = { complex(x, y): 1 for x,y in rows[:num_bytes] }
    start, end = complex(0, 0), complex(W, H)

    queue = deque([(start, 0)])
    visited = set()

    while queue:
        pos, dist = queue.popleft()

        if pos in visited:
            continue
        visited.add(pos)

        if pos == end:
            return dist

        for dir in [1, -1, 1j, -1j]:
            new_pos = pos + dir
            if new_pos.real < 0 or new_pos.imag < 0 or new_pos.real > W or new_pos.imag > H:
                continue
            if new_pos not in grid and new_pos not in visited:
                queue.append((new_pos, dist + 1))

    return None


initial = 1024
part1 = bfs(initial)

lo, hi = initial, len(rows) + 1
while lo < hi:
    mid = (lo + hi) >> 1
    if bfs(mid) is not None:
        lo = mid + 1
    else:
        hi = mid

part2 = f"{rows[lo-1][0]},{rows[lo-1][1]}"

print("Part 1:", part1)
print("Part 1:", part2)
