from collections import defaultdict
from sys import stdin

graph = defaultdict(list)

for line in stdin:
    k, vals = line.strip().split(": ")
    graph[k] = vals.split()

print(graph)

def dfs(v):
    if v == "out":
        return 1

    paths = 0
    for n in graph[v]:
        paths += dfs(n)
    return paths

print("Part 1:", dfs("you"))
