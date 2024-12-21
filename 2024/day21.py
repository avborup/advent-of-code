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
    if not code:
        return 0, ""

    pad = NUMERIC if level == 0 else DIR
    cur_pos = cur_pos if cur_pos is not None else pad['A']

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

    if level < max_level:
        def option_cost(option):
            option = option + "A"
            return find_presses_for_code(option, max_level, level + 1)

        cost, option = min(option_cost(option) for option in options)
    else:
        opt = next(iter(options)) + "A"
        cost, option = len(opt), opt

    subcost, suboption = find_presses_for_code(code[1:], max_level, level, target_pos)

    total_cost = cost + subcost
    total_option = option # + suboption

    # print(level * '  ', ".", code, "=", f"({cost} + {subcost})", "presses for", total_option)

    return total_cost, total_option

codes = [line.strip() for line in stdin]

part1, part2 = 0, 0
for code in codes:
    num_code = int(code[:-1])
    part1 += find_presses_for_code(code, max_level=2)[0] * num_code
    part2 += find_presses_for_code(code, max_level=25)[0] * num_code

print("Part 1:", part1)
print("Part 2:", part2)
