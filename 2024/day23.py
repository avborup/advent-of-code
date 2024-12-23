from sys import stdin
from collections import defaultdict

pairs = [line.strip().split("-") for line in stdin]

adj = defaultdict(list)
for a, b in pairs:
    adj[a].append(b)
    adj[b].append(a)

part1, part2 = 0, 0

triples = set()
for v in adj:
    for w in adj[v]:
        for x in adj[w]:
            if x in adj[v]:
                triples.add(tuple(sorted([v, w, x])))

print(len(triples))

for trip in triples:
    if any(vert.startswith("t") for vert in trip):
        part1 += 1

print("Part 1:", part1)
print("Part 2:", part2)
