from sys import stdin

inp = ''.join(line for line in stdin)

keys, locks = [], []
for block in inp.split("\n\n"):
    lines = block.splitlines()

    tranposed = list(zip(*lines))

    is_key = tranposed[0][0] == "#"
    heights = tuple(row.count("#") - 1 for row in tranposed)

    if is_key:
        keys.append(heights)
    else:
        locks.append(heights)

fits = set()

for key in keys:
    for lock in locks:
        if all(k + l <= 5 for k, l in zip(key, lock)):
            fits.add((key, lock))

print("Part 1:", len(fits))
