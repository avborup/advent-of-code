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


counter = 0
def unique():
    global counter
    counter += 1
    return counter


def dijkstra():
    INF = float('inf')
    dist = defaultdict(lambda: INF)
    pq = []

    def add(i, dst):
        global uniq
        pos, dir, *_ = i
        if dst <= dist[(pos, dir)]:
            dist[(pos, dir)] = dst
            push(pq, (dst, unique(), i))

    add((start, 1, [start]), 0)
    gucci = set()
    min_dist = INF

    while pq:
        D, _, i = pop(pq)
        pos, dir, path = i

        if pos == end:
            if D > min_dist:
                return min_dist, len(gucci)
            min_dist = D
            gucci.update(path)

        if D != dist[(pos, dir)]:
            continue

        for j, w in adj(i):
            add(j, dst=D + w)


def adj(v):
    pos, dir, path = v
    reachable = []

    if grid[pos + dir] != '#':
        reachable.append(((pos + dir, dir, path + [pos + dir]), 1))

    for rot in [1j, 1j ** 3]:
        new_dir = dir * rot
        if grid[pos + new_dir] != '#':
            reachable.append(((pos + new_dir, new_dir, path + [pos + new_dir]), 1001))

    return reachable


part1, part2 = dijkstra()
print("Part 1:", part1)
print("Part 2:", part2)
