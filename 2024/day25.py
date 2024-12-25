from sys import stdin

keys, locks = [], []
for block in ''.join(stdin.readlines()).split("\n\n"):
    tranposed = list(zip(*block.splitlines()))
    is_key = tranposed[0][0] == "#"
    heights = tuple(row.count("#") - 1 for row in tranposed)
    (keys if is_key else locks).append(heights)

fits = set()
for key in keys:
    for lock in locks:
        if all(k + l <= 5 for k, l in zip(key, lock)):
            fits.add((key, lock))

print("Part 1:", len(fits))
