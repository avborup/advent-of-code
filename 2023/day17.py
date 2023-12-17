from heapq import heappop as pop, heappush as push
from sys import stdin
from collections import defaultdict


grid = [[int(c) for c in line.strip()] for line in stdin]
w, h = len(grid[0]), len(grid)


def adj(v, part):
    (r, c), dir, steps = v
    reachable = []

    dcw, dccw = (dir[1], -dir[0]), (-dir[1], dir[0])
    left, right, straight = [(r + d[0], c + d[1]) for d in [dcw, dccw, dir]]

    if part == 2 and steps < 4:
        if straight[0] >= 0 and straight[0] < h and straight[1] >= 0 and straight[1] < w:
            reachable.append(((straight, dir, steps + 1),
                              grid[straight[0]][straight[1]]))
        return reachable

    max_steps = 3 if part == 1 else 10
    if steps < max_steps and straight[0] >= 0 and straight[0] < h and straight[1] >= 0 and straight[1] < w:
        reachable.append(((straight, dir, steps + 1),
                         grid[straight[0]][straight[1]]))
    if left[0] >= 0 and left[0] < h and left[1] >= 0 and left[1] < w:
        reachable.append(((left, dcw, 1), grid[left[0]][left[1]]))
    if right[0] >= 0 and right[0] < h and right[1] >= 0 and right[1] < w:
        reachable.append(((right, dccw, 1), grid[right[0]][right[1]]))

    return reachable


def dijkstra(S, T, part):
    INF = 10**18
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
