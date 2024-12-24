from sys import stdin
from collections import deque, defaultdict
import itertools

inp = ''.join(line for line in stdin)
inits, gates_str = inp.split("\n\n")

def solve_with_swaps(swaps):
    wires = {}
    for line in inits.splitlines():
        name, val = line.split(": ")
        wires[name] = int(val)

    graph = defaultdict(list)
    for line in gates_str.splitlines():
        a, op, b, _, c = line.split()

        for s1, s2 in swaps:
            if c == s1: c = s2
            elif c == s2: c = s1

        # Debug printing in DOT format
        def print_dot():
            gateid = f"{a}{b}{op}{c}"
            print(f'{gateid} [label="{op}", shape=invtriangle]')
            if a in wires:
                print(f'{a} [label="{a} ({wires[a]})"]')
            if b in wires:
                print(f'{b} [label="{b} ({wires[b]})"]')
            print(f'{a} -> {gateid}')
            print(f'{b} -> {gateid}')
            print(f'{gateid} -> {c}')

        # print_dot()

        gate = (a, op, b, c)
        graph[a].append(gate)
        graph[b].append(gate)

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

    return wires


def get_wires_with_letters(wires, letter):
    sorted_wires = sorted([(k, v) for k, v in wires.items() if k.startswith(letter)], key=lambda x: x[0], reverse=True)
    return int(''.join(str(v) for k, v in sorted_wires), base=2)


wires1 = solve_with_swaps([])
part1 = get_wires_with_letters(wires1, "z")

# Insight: the input is a series of full-adder circuits. Just look up how it looks:
#    https://www.build-electronic-circuits.com/full-adder/
#
# Draw the graph in DOT format and let the layout work its magic. Then, manually go
# from top to bottom and manually identify all broken full-adders.
swaps = [
    ("z15", "htp"),
    ("z20", "hhh"),
    ("z05", "dkr"),
    ("ggk", "rhv")
];
wires2 = solve_with_swaps(swaps)
part2 = get_wires_with_letters(wires2, "z")

exp_x, exp_y = get_wires_with_letters(wires2, "x"), get_wires_with_letters(wires2, "y")
print(f"  x: {exp_x:b} +")
print(f"  y: {exp_y:b} =")
print(f"exp: {exp_x + exp_y:b}")
print(f"act: {part2:b}")
print(f"eq?: {exp_x + exp_y == part2}")
print()

print("Part 1:", part1)
print("Part 2:", ",".join(sorted(itertools.chain(*swaps))))
