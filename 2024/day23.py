from sys import stdin
from collections import defaultdict

pairs = [line.strip().split("-") for line in stdin]
adj = defaultdict(set)
for a, b in pairs:
    adj[a].add(b)
    adj[b].add(a)

triples = set()
for v in adj:
    for w in adj[v]:
        for x in adj[w]:
            if x in adj[v]:
                triples.add(tuple(sorted([v, w, x])))

part1 = sum(any(v.startswith("t") for v in trip) for trip in triples)

# https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
maximal_cliques = set()
def bron_kerbosch(R, P, X):
    if not P and not X:
        maximal_cliques.add(tuple(sorted(R)))
        return

    for v in P.copy():
        bron_kerbosch(R | {v}, P & adj[v], X & adj[v])
        P.remove(v)
        X.add(v)

bron_kerbosch(set(), set(adj), set())
maximum_clique = max(maximal_cliques, key=len)

print("Part 1:", part1)
print("Part 2:", ','.join(maximum_clique))
