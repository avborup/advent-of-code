from sys import stdin
from collections import defaultdict

pairs = [line.strip().split("-") for line in stdin]

adj = defaultdict(set)
for a, b in pairs:
    adj[a].add(b)
    adj[b].add(a)

for v,w in pairs:
    print(v, "-", w, sep="")

part1, part2 = 0, 0

cliques = set()
def bron_kerbosch1(R, P, X):
    if not P and not X:
        cliques.add(tuple(sorted(R)))
        return

    for v in P.copy():
        bron_kerbosch1(R | {v}, P & adj[v], X & adj[v])
        P.remove(v)
        X.add(v)

bron_kerbosch1(set(), set(adj), set())
print(cliques)

max_len, max_clique = 0, None
for clique in cliques:
    if len(clique) > max_len:
        max_len = len(clique)
        max_clique = clique

triples = set()
for v in adj:
    for w in adj[v]:
        for x in adj[w]:
            if x in adj[v]:
                triples.add(tuple(sorted([v, w, x])))

for trip in triples:
    if any(vert.startswith("t") for vert in trip):
        part1 += 1

print("Part 1:", part1)
print("Part 2:", ','.join(sorted(max_clique)))
