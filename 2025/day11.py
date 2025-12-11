from collections import defaultdict
from sys import stdin
from functools import cache

graph = defaultdict(list)

for line in stdin:
    k, vals = line.strip().split(": ")
    graph[k] = vals.split()

print(graph)

@cache
def dfs(v, dac, fft):
    if v == "out" and dac and fft:
        return 1

    return sum(dfs(n, dac or (n == "dac"), fft or (n == "fft")) for n in graph[v])

print("Part 2:", dfs("svr", False, False))
