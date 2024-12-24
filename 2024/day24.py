from sys import stdin
from collections import deque, defaultdict
import itertools

inp = ''.join(line for line in stdin)
inits, idk = inp.split("\n\n")

wires = {}
for line in inits.splitlines():
    name, val = line.split(": ")
    wires[name] = int(val)

swappable = [
    ("z15", "htp"),
    ("z20", "hhh"),
    ("z05", "dkr"),
    ("ggk", "rhv")
]

graph = defaultdict(list)
for line in idk.splitlines():
    a, op, b, _, c = line.split()

    for s1, s2 in swappable:
        if c == s1:
            c = s2
        elif c == s2:
            c = s1

    gateid = f"{a}{b}{op}{c}"
    print(f'{gateid} [label="{op}", shape=invtriangle]')
    if a in wires:
        print(f'{a} [label="{a} ({wires[a]})"]')
    if b in wires:
        print(f'{b} [label="{b} ({wires[b]})"]')
    print(f'{a} -> {gateid}')
    print(f'{b} -> {gateid}')
    print(f'{gateid} -> {c}')

    gate = (a, op, b, c)
    graph[a].append(gate)
    graph[b].append(gate)

all_out_wires = set()
for adj in graph.values():
    for gate in adj:
        all_out_wires.add(gate[-1])


def get_wires_with_letters(letter):
    sorted_wires = sorted([(k, v) for k, v in wires.items() if k.startswith(letter)], key=lambda x: x[0], reverse=True)
    return int(''.join(str(v) for k, v in sorted_wires), base=2)

print(all_out_wires, len(all_out_wires))

expected_out = get_wires_with_letters("x") + get_wires_with_letters("y")

print(f" {get_wires_with_letters('x'):b} +")
print(f" {get_wires_with_letters('y'):b} =")
print(f"{expected_out:b}")
# print(expected_out)

def bfs():
    queue = deque(wires.keys())
    visited = defaultdict(bool)
    while queue:
        wire = queue.popleft()

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
print(f"{get_wires_with_letters('z'):b} <")

print(expected_out == get_wires_with_letters("z"))

print("Part 1:", get_wires_with_letters("z"))
print("Part 2:", 0)


flat = list(itertools.chain(*swappable))

print(",".join(sorted(flat)))
