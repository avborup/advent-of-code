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

def find_presses_for_code(code, max_level, level=0, cur_pos=None):
    if not code:
        return 0, ""

    pad = NUMERIC if level == 0 else DIR
    cur_pos = cur_pos if cur_pos is not None else pad['A']

    total_cost = 0
    total_option = ""
    for i, target_key in enumerate(code):
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

        from_key = next(k for k, v in pad.items() if v == cur_pos)
        print(level * '  ', f'{level})', target_key, f"{options}", "from", from_key.__repr__())

        if level < max_level:
            def option_cost(option):
                option = option + "A"
                return find_presses_for_code(option, max_level, level + 1)

            min_cost, min_option = min(option_cost(option) for option in options)
        else:
            opt = next(iter(options)) + "A"
            min_cost, min_option = len(opt), opt

        total_cost += min_cost
        total_option += min_option

        cur_pos = target_pos

        print(level * '  ', ".", code[:i+1], "=", f"{total_cost} (+{min_cost})", "presses for", total_option)

    return total_cost, total_option

codes = [line.strip() for line in stdin]

part1, part2 = 0, 0
for code in codes:
    num_code = int(code[:-1])
    part1 += find_presses_for_code(code, max_level=2)[0] * num_code
    print()
    # part2 += find_presses_for_code(code, max_level=25)[0] * num_code

print("Part 1:", part1)
print("Part 2:", part2)
