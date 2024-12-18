from sys import stdin
from collections import defaultdict, deque


rows = [[int(x) for x in l.split(",")] for l in stdin]
kb = rows[:1024]

W, H = max(x[0] for x in kb), max(x[1] for x in kb)

grid = { complex(x, y): 1 for x,y in kb }

print(len(grid))
print(W, H)
print(grid)

start, end = complex(0, 0), complex(W, H)

# print grid
for y in range(int(H) + 1):
    for x in range(int(W) + 1):
        if complex(x, y) == start:
            print("S", end="")
        elif complex(x, y) == end:
            print("E", end="")
        else:
            print("#" if complex(x, y) in grid else ".", end="")
    print()

def bfs():
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


part1 = bfs()
part2 = 0

print("Part 1:", part1)
print("Part 1:", part2)
