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


class Node:
    def __init__(self, pos, dir, path, dist):
        self.pos = pos
        self.dir = dir
        self.path = path
        self.dist = dist

    def __lt__(self, other):
        return self.dist < other.dist


    def __hash__(self):
        return hash((self.pos, self.dir))


def adj(v):
    pos, dir, path = v.pos, v.dir, v.path
    reachable = []

    if grid[pos + dir] != '#':
        reachable.append(((pos + dir, dir, path + [pos + dir]), 1))

    for rot in [1j, 1j ** 3]:
        new_dir = dir * rot
        if grid[pos + new_dir] != '#':
            reachable.append(((pos + new_dir, new_dir, path+[pos + new_dir]), 1001))

    return reachable




def dijkstra(S, T):
    INF = float('inf')
    dist = defaultdict(lambda: INF)
    pq = []

    iters = 0

    def add(i, dst):
        n = Node(*i, dist=dst)
        if dst < dist[n]:
            dist[n] = dst
            push(pq, n)

    add((S, 1, [S]), 0)
    gucci = set()
    min_dist = INF

    while pq:
        n = pop(pq)
        D, i = n.dist, n
        if i.pos == end:
            if D > min_dist:
                return len(gucci)
            min_dist = D
            gucci = gucci.union(i.path)
        if D != dist[i]:
            continue
        for j, w in adj(i):
            iters += 1
            add(j, D + w)

    return dist[T]

print("Part 1:", dijkstra(start, end))
