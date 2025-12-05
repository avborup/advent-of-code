from sys import stdin

chunks = "".join(stdin).split("\n\n")
ranges = [tuple(map(int, line.split("-"))) for line in chunks[0].splitlines()]
ids = [int(line.strip()) for line in chunks[1].splitlines()]

part1, part2 = 0, 0

for id in ids:
    if any(start <= id <= end for start, end in ranges):
        part1 += 1

print("Part 1:", part1)
print("Part 2:", part2)
