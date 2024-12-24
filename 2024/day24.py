from sys import stdin
from collections import deque, defaultdict

inp = ''.join(line for line in stdin)
inits, idk = inp.split("\n\n")

wires = {}
for line in inits.splitlines():
    name, val = line.split(": ")
    wires[name] = int(val)

graph = defaultdict(list)
for line in idk.splitlines():
    a, op, b, _, c = line.split()

    gate = (a, op, b, c)
    graph[a].append(gate)
    graph[b].append(gate)


for wire in wires:
    print(graph[wire])
    print()


def bfs():
    queue = deque(wires.keys())
    visited = defaultdict(bool)
    while queue:
        wire = queue.popleft()

        print(wire)

        visited[wire] = True

        for gate in graph[wire]:
            a, op_s, b, c = gate

            if op_s == "AND":
                op = lambda x, y: x & y
            elif op_s == "OR":
                op = lambda x, y: x | y
            elif op_s == "XOR":
                op = lambda x, y: x ^ y


            if visited[a] and visited[b] and not visited[gate]:
                wires[c] = op(wires[a], wires[b])
                visited[gate] = True

                queue.append(c)


bfs()

z_keys = sorted([(k,v) for k, v in wires.items() if k.startswith("z")], key=lambda x: x[0], reverse=True)

output = ''.join(str(v) for k, v in z_keys)

print(z_keys)
print(output)
part1, part2 = 0,0 

print("Part 1:", part1)
print("Part 2:", part2)
