from sys import stdin

nums = [(line[0], int(line[1:])) for line in stdin]

pos = 50
part1 = 0
for dir, val in nums:
    match dir:
        case 'R':
            pos += val
        case 'L':
            pos -= val
    pos %= 100
    if pos == 0:
        part1 += 1

print("Part 1:", part1)
