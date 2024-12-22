from sys import stdin
from collections import defaultdict

def evolve(secret):
    MOD = 16777216
    step1 = ((secret * 64) ^ secret) % MOD
    step2 = ((step1 // 32) ^ step1) % MOD
    step3 = ((step2 * 2048) ^ step2) % MOD
    return step3

nums = [int(line) for line in stdin]

part1 = 0
all_sequences = defaultdict(int)
for secret in nums:
    prev, diffs = secret % 10, []
    for _ in range(2000):
        secret = evolve(secret)
        price = secret % 10
        diffs.append((price, price - prev))
        prev = price

    part1 += secret

    sequences = set()
    for i in range(len(diffs) - 4):
        prices, seq = zip(*diffs[i:i + 4])
        if seq not in sequences:
            sequences.add(seq)
            all_sequences[seq] += prices[-1]

part2 = max(all_sequences.values())

print("Part 1:", part1)
print("Part 2:", part2)
