from sys import stdin

def evolve(secret):
    MOD = 16777216
    step1 = ((secret * 64) ^ secret) % MOD
    step2 = ((step1 // 32) ^ step1) % MOD
    step3 = ((step2 * 2048) ^ step2) % MOD
    return step3

nums = [int(line) for line in stdin]

part1, part2 = 0, 0
for secret in nums:
    for _ in range(2000):
        secret = evolve(secret)
    part1 += secret

print("Part 1:", part1)
print("Part 2:", part2)
