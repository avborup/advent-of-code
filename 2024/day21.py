from sys import stdin
from collections import deque
import itertools
from functools import cache

NUMERIC_GRID = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [None, '0', 'A'],
]
NUMERIC = {
    key: complex(r, c)
    for r, row in enumerate(NUMERIC_GRID)
    for c, key in enumerate(row) if key is not None
}

DIR_GRID = [
    [None, '^', 'A'],
    ['<', 'v', '>'],
]
DIR = {
    key: complex(r, c)
    for r, row in enumerate(DIR_GRID)
    for c, key in enumerate(row) if key is not None
}

INIT_NUM, INIT_DIR = NUMERIC['A'], DIR['A']

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
        for d in [-1, 1j, 1, -1j]:
            new_pos = pos + d

            if 0 <= new_pos.real < len(pad) and 0 <= new_pos.imag < len(pad[0]) and pad[int(new_pos.real)][int(new_pos.imag)] is not None:
                queue.append((new_pos, path + [dirs_to_syms[d]]))


@cache
def find_presses_for_code(code, level=0, cur_pos=None):
    if not code:
        return 0, ""

    pad = NUMERIC if level == 0 else DIR
    cur_pos = cur_pos
    if cur_pos is None:
        cur_pos = pad['A']

    target_key = code[0]
    target_pos = pad[target_key]

    diff = target_pos - cur_pos
    dr, dc = int(diff.real), int(diff.imag)
    hor_sym = '>' if dc > 0 else '<'
    ver_sym = 'v' if dr > 0 else '^'

    options = set()
    if cur_pos + complex(0, dc) in pad.values():
        options.add(hor_sym * abs(dc) + ver_sym * abs(dr))
    if cur_pos + complex(dr, 0) in pad.values():
        options.add(ver_sym * abs(dr) + hor_sym * abs(dc))

    # print(level * '  ', f'{level})', code, f"{options}", "from", cur_pos)

    if level < 25:
        def option_cost(option):
            option = option + "A"
            return find_presses_for_code(option, level + 1)

        cost, option = min(option_cost(option) for option in options)
    else:
        opt = next(iter(options)) + "A"
        cost, option = len(opt), opt

    subcost, suboption = find_presses_for_code(code[1:], level, target_pos)

    total_cost = cost + subcost
    total_option = option # + suboption

    # print(level * '  ', ".", code, "=", f"({cost} + {subcost})", "presses for", total_option)

    return total_cost, total_option

    print(cur_pos, target_pos, options)

    # for c in code:
    #     # print(pad[int(cur_pos.real)][int(cur_pos.imag)], "to", c, "via", end=' ')
    #     cur_pos, path = find_seq(pad, cur_pos, c)
    #     if optimise:
    #         print(''.join(path), end=' into ')
    #         path = list(optimal_order(''.join(path)))
    #         print(''.join(path))
    #     # print(''.join(path))
    #     presses.extend(path + ['A'])
    # # print()
    #
    # return presses

codes = [line.strip() for line in stdin]

part1, part2 = 0, 0
for code in codes:
    # rob1 = find_presses_for_code(NUMERIC, INIT_NUM, code)
    # rob2 = find_presses_for_code(DIR, INIT_DIR, rob1)
    # rob3 = find_presses_for_code(DIR, INIT_DIR, rob2)

    # print(''.join(rob1))
    # print(''.join(rob2))
    # print(''.join(rob3))
    #
    # print(len(rob3), code[:-1])

    cost, presses = find_presses_for_code(code)
    print(code, cost, presses)
    part1 += cost * int(code[:-1])

print("Part 1:", part1)
print("Part 2:", part2)
