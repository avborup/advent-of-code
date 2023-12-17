from heapq import heappop as pop, heappush as push
from sys import stdin
from collections import defaultdict


grid = [[int(c) for c in line.strip()] for line in stdin]
w, h = len(grid[0]), len(grid)


def adj(v, part):
    (r, c), dir, steps = v
    reachable = []

    def add_reachable(dir, new_steps):
        v = (r + dir[0], c + dir[1])
        if v[0] >= 0 and v[0] < h and v[1] >= 0 and v[1] < w:
            reachable.append(((v, dir, new_steps), grid[v[0]][v[1]]))

    if part == 2 and steps < 4:
        add_reachable(dir, steps + 1)
        return reachable

    max_steps = 3 if part == 1 else 10
    if steps < max_steps:
        add_reachable(dir, steps + 1)

    add_reachable((dir[1], -dir[0]), 1)
    add_reachable((-dir[1], dir[0]), 1)

    return reachable


def dijkstra(S, T, part):
    INF = float('inf')
    dist = defaultdict(lambda: INF)
    pq = []

    def add(i, dst):
        if dst < dist[i]:
            dist[i] = dst
            push(pq, (dst, i))

    add((S, (1, 0), 0), 0)
    add((S, (0, 1), 0), 0)

    while pq:
        D, i = pop(pq)
        if i[0] == T:
            return D
        if D != dist[i]:
            continue
        for j, w in adj(i, part=part):
            add(j, D + w)

    return dist[T]


if __name__ == '__main__':
    print("Part 1:", dijkstra((0, 0), (h-1, w-1), part=1))
    print("Part 1:", dijkstra((0, 0), (h-1, w-1), part=2))
