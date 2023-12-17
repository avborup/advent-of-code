from heapq import heappop as pop, heappush as push
from sys import stdin
from collections import defaultdict


grid = [[int(c) for c in line.strip()] for line in stdin]
w, h = len(grid[0]), len(grid)


def part1():
    print(dijkstra((0, 0), (h-1, w-1)))


def cw(dir):
    return (dir[1], -dir[0])


def ccw(dir):
    return (-dir[1], dir[0])


def adj(v):
    (r, c), dir, steps = v
    reachable = []

    dl, dr = ccw(dir), cw(dir)
    left, right, straight = [(r + d[0], c + d[1]) for d in [dl, dr, dir]]

    if left[0] >= 0 and left[0] < h and left[1] >= 0 and left[1] < w:
        reachable.append(((left, dl, 1), grid[left[0]][left[1]]))
    if right[0] >= 0 and right[0] < h and right[1] >= 0 and right[1] < w:
        reachable.append(((right, dr, 1), grid[right[0]][right[1]]))
    if steps < 3 and straight[0] >= 0 and straight[0] < h and straight[1] >= 0 and straight[1] < w:
        reachable.append(((straight, dir, steps + 1),
                         grid[straight[0]][straight[1]]))

    return reachable


def dijkstra(S, T):
    INF = 10**18
    dist = defaultdict(lambda: INF)
    pq = []

    def add(i, dst):
        if dst < dist[i]:
            dist[i] = dst
            push(pq, (dst, i))
    add((S, (1, 0), 0), 0)

    while pq:
        D, i = pop(pq)
        if i[0] == T:
            return D
        if D != dist[i]:
            continue
        for j, w in adj(i):
            add(j, D + w)

    return dist[T]


if __name__ == '__main__':
    part1()
