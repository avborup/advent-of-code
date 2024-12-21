from sys import stdin
from functools import cache

def make_pad(grid): return {
    key: complex(r, c)
    for r, row in enumerate(grid)
    for c, key in enumerate(row) if key is not None
}

NUMERIC = make_pad([
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [None, '0', 'A'],
])

DIR = make_pad([
    [None, '^', 'A'],
    ['<', 'v', '>'],
])

@cache
def find_presses_for_code(code, max_level, level=0, cur_pos=None):
    if level > max_level:
        return len(code)

    pad = NUMERIC if level == 0 else DIR
    cur_pos = cur_pos if cur_pos is not None else pad['A']

    total_cost = 0
    for target_key in code:
        target_pos = pad[target_key]

        diff = target_pos - cur_pos
        dr, dc = int(diff.real), int(diff.imag)
        hor_symbol = '>' if dc > 0 else '<'
        ver_symbol = 'v' if dr > 0 else '^'

        hor, ver = hor_symbol * abs(dc), ver_symbol * abs(dr)
        paths = set()
        if cur_pos + complex(0, dc) in pad.values(): paths.add(hor + ver)
        if cur_pos + complex(dr, 0) in pad.values(): paths.add(ver + hor)

        def path_cost(path):
            return find_presses_for_code(path + "A", max_level, level + 1)

        total_cost += min(path_cost(path) for path in paths)
        cur_pos = target_pos

    return total_cost

codes = [line.strip() for line in stdin]

part1, part2 = 0, 0
for code in codes:
    num_code = int(code[:-1])
    part1 += find_presses_for_code(code, max_level=2) * num_code
    part2 += find_presses_for_code(code, max_level=25) * num_code

print("Part 1:", part1)
print("Part 2:", part2)
