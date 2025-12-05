from sys import stdin

chunks = "".join(stdin).split("\n\n")
ranges = [tuple(map(int, line.split("-"))) for line in chunks[0].splitlines()]
ids = [int(line.strip()) for line in chunks[1].splitlines()]

part1 = 0
for id in ids:
    if any(start <= id <= end for start, end in ranges):
        part1 += 1


def is_overlapping(a, b):
    return not (a[1] < b[0] or b[1] < a[0])


def find_overlap(ranges):
    ranges = list(ranges)
    for i in range(len(ranges)):
        for j in range(i + 1, len(ranges)):
            if is_overlapping(ranges[i], ranges[j]):
                return (ranges[i], ranges[j])
    return None


non_overlapping = set(ranges)
while (overlap := find_overlap(non_overlapping)) is not None:
    a, b = overlap
    non_overlapping.remove(a)
    non_overlapping.remove(b)
    new_range = (min(a[0], b[0]), max(a[1], b[1]))
    non_overlapping.add(new_range)

part2 = sum(end - start + 1 for start, end in non_overlapping)

print("Part 1:", part1)
print("Part 2:", part2)
