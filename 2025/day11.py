from collections import defaultdict
from sys import stdin
from functools import cache

graph = defaultdict(list)
for line in stdin:
    k, vals = line.strip().split(": ")
    graph[k] = vals.split()

@cache
def dfs(v, dac, fft, part2):
    if v == "out" and (not part2 or dac and fft):
        return 1

    return sum(dfs(n, dac or (n == "dac"), fft or (n == "fft"), part2) for n in graph[v])

print("Part 1:", dfs("you", False, False, False))
print("Part 2:", dfs("svr", False, False, True))
