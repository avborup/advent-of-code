from sys import stdin

banks = [[int(x) for x in line.strip()] for line in stdin]

def solve(digits):
    sum = 0
    for bank in banks:
        out = []
        left, right = 0, len(bank) - 1
        for i in range(digits):
            space = digits - i - 1

            best = 0
            for j in range(left, right + 1 - space):
                if bank[j] > best:
                    best = bank[j]
                    left = j + 1

            out.append(best)

        res = 0
        for i in range(digits):
            res = res * 10 + out[i]
        sum += res

    return sum

print("Part 1:", solve(2))
print("Part 2:", solve(12))
