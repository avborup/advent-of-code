from collections import defaultdict
from sys import stdin
from functools import cache

part1 = 0

gifts = []
areas = []
reqs = []

parts = stdin.read().strip().split("\n\n")
gifts_strs, req_strs = parts[:-1], parts[-1]

for gifts_str in gifts_strs:
    gift = set()
    rows = gifts_str.strip().split("\n")[1:]
    for r, row in enumerate(rows):
        for c, ch in enumerate(row):
            if ch == "#":
                gift.add((r, c))
    gifts.append(gift)
    areas.append(len(gift))

for req_str in req_strs.split("\n"):
    l, r = req_str.split(": ")
    width, height = [int(x) for x in l.split("x")]
    amounts = [int(x) for x in r.split(" ")]
    reqs.append((width, height, amounts))


# i am so mad
for width, height, amounts in reqs:
    required_area = width * height
    takes_up_at_least = sum(amount * 9 for amount in amounts)
    if takes_up_at_least <= required_area:
        part1 += 1

print("Part 1:", part1)
