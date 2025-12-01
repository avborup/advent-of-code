from sys import stdin

nums = [(line[0], int(line[1:])) for line in stdin]

prev, pos = 50, 50
part1, part2 = 0, 0
for dir, val in nums:
    num_rots = val // 100

    match dir:
        case 'R':
            pos += val
        case 'L':
            pos -= val
    pos %= 100

    part2 += num_rots
    if pos == 0:
        part1 += 1
        part2 += 1
    elif prev != 0:
        match dir:
            case "L":
                if prev < pos:
                    part2 += 1
            case "R":
                if prev > pos:
                    part2 += 1

    prev = pos

print("Part 1:", part1)
print("Part 2:", part2)
