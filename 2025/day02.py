ranges = [[int(n) for n in r.split("-")] for r in input().split(",")]

part1 = 0
part2 = 0

for start, end in ranges:
    for n in range(start, end + 1):
        s = str(n)

        if s[:len(s)//2] == s[len(s)//2:]:
            part1 += n
            part2 += n
        else:
            for i in range(1, len(s)//2+1):
                base = s[:i]

                if s.count(base) * len(base) == len(s):
                    part2 += n
                    break


print("Part 1:", part1)
print("Part 2:", part2)
