from sys import stdin
from collections import deque

"""
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+

A to 3 via ^A
3 to 7 via ^^<<A
7 to 9 via >>A
9 to A via vvvA

    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+

A to ^ via <A
^ to A via >A
A to ^ via <A
^ to ^ via A
^ to < via v<A
< to < via A
< to A via >>^A
A to > via vA
> to > via A
> to A via ^A
A to v via v<A
v to v via A
v to v via A
v to A via >^A

A to < via v<<A
< to A via >>^A
A to > via vA
> to A via ^A
A to < via v<<A
< to A via >>^A
A to A via A
A to v via v<A
v to < via <A
< to A via >>^A
A to A via A
A to > via vA
> to > via A
> to ^ via ^<A
^ to A via >A
A to v via v<A
v to A via >^A
A to A via A
A to ^ via <A
^ to A via >A
A to v via v<A
v to < via <A
< to A via >>^A
A to A via A
A to A via A
A to > via vA
> to ^ via ^<A
^ to A via >A

^A^^<<A>>AvvvA
<A>A<AAv<AA>>^AvAA^Av<AAA>^A
v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA^<A>Av<A>^AA<A>Av<A<A>>^AAAvA^<A>A

"""

NUMERIC = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [None, '0', 'A'],
]

DIR = [
    [None, '^', 'A'],
    ['<', 'v', '>'],
]

INIT_NUM = complex(3, 2)
INIT_DIR = complex(0, 2)

dirs_to_syms = {
    complex(1, 0): 'v',
    complex(-1, 0): '^',
    complex(0, 1): '>',
    complex(0, -1): '<',
}


def find_seq(pad, start_pos, end_symbol):
    queue = deque([(start_pos, [])])
    visited = []
    while queue:
        pos, path = queue.popleft()
        if pad[int(pos.real)][int(pos.imag)] == end_symbol:
            return pos, path
        if pos in visited:
            continue
        visited.append(pos)
        for d in [1, 1j, -1, -1j]:
            new_pos = pos + d

            if 0 <= new_pos.real < len(pad) and 0 <= new_pos.imag < len(pad[0]) and pad[int(new_pos.real)][int(new_pos.imag)] is not None:
                queue.append((new_pos, path + [dirs_to_syms[d]]))


def find_presses_for_code(pad, init_pos, code):
    presses, cur_pos = [], init_pos
    for c in code:
        print(pad[int(cur_pos.real)][int(cur_pos.imag)], "to", c, "via", end=' ')
        cur_pos, path = find_seq(pad, cur_pos, c)
        print(''.join(path + ['A']))
        presses.extend(path + ['A'])
    print()
    return presses

codes = [line.strip() for line in stdin]

part1, part2 = 0, 0
for code in codes:
    rob1 = find_presses_for_code(NUMERIC, INIT_NUM, code)
    rob2 = find_presses_for_code(DIR, INIT_DIR, rob1)
    rob3 = find_presses_for_code(DIR, INIT_DIR, rob2)

    print(''.join(rob1))
    print(''.join(rob2))
    print(''.join(rob3))

    print(len(rob3), code[:-1])

    part1 += len(rob3) * int(code[:-1])

print("Part 1:", part1)
print("Part 2:", part2)
