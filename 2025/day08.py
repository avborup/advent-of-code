from collections import defaultdict, Counter
import math
from sys import stdin
from heapq import heappush, heappop

# a = (x, y, z)
# b = (x, y, z)
# edges = (weight, a, b)

class UnionFind:
    def __init__(self):
        self.map = {}

    def union(self, a, b):
        ar, br = self.find(a), self.find(b)
        self.map[a] = ar
        self.map[br] = ar

    def find(self, a):
        while (root := self.map.get(a, a)) != a:
            a = root
        return root

    def groups(self):
        return Counter([self.find(k) for k in self.map])


uf = UnionFind()
points = [tuple(int(c) for c in line.split(",")) for line in stdin]

def dist(a, b):
    return math.sqrt(sum((a[i] - b[i]) ** 2 for i in range(3)))


edges = []
for i in range(len(points)):
    for j in range(i+1, len(points)):
        a, b = points[i], points[j]
        edges.append((dist(a, b), a, b))
edges.sort()

for i, (d, a, b) in enumerate(edges):
    if i >= 1000 or (i >= 10 and len(points) <= 20):
        break
    uf.union(a, b)

part1 = math.prod(sorted(uf.groups().values(), reverse=True)[:3])

print("Part 1:", part1)
