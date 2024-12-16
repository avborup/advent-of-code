from heapq import heappop as pop, heappush as push
from sys import stdin
from collections import defaultdict


grid = {
    complex(c, r): v
    for r, ln in enumerate(l.strip() for l in stdin)
    for c, v in enumerate(ln)
}
start = next(k for k, v in grid.items() if v == 'S')
end = next(k for k, v in grid.items() if v == 'E')


def adj(v):
    pos, dir = v
    reachable = []

    if grid[pos + dir] != '#':
        reachable.append(((pos + dir, dir), 1))

    for rot in [1j, 1j ** 3]:
        new_dir = dir * rot
        if grid[pos + new_dir] != '#':
            reachable.append(((pos + new_dir, new_dir), 1001))

    return reachable


def dijkstra(S, T):
    INF = float('inf')
    dist = defaultdict(lambda: INF)
    pq = []

    iters = 0

    def add(i, dst):
        if dst < dist[i]:
            dist[i] = dst
            push(pq, (dst, iters, i))

    add((S, 1), 0)

    while pq:
        D, _, i = pop(pq)
        if i[0] == end:
            return D
        if D != dist[i]:
            continue
        for j, w in adj(i):
            iters += 1
            add(j, D + w)

    return dist[T]

print("Part 1:", dijkstra(start, end))
