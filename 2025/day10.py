from sys import stdin
import re
from collections import deque

lines = [
    (
        re.match(r"\[(.*)\]", line).group(1),
        [tuple(int(x) for x in m.split(",")) for m in re.findall(r"\(([\d,]+)\)", line)],
        []# re.match(r"{(.*)}", line).group(1)
    )
    for line in stdin
]

part1 = 0
i = 0
for lights, buttons, joltages in lines:
    i += 1
    target = [c == "#" for c in lights]
    start = [False for c in lights]

    queue = deque([(b, start, 1) for b in buttons])
    while len(queue):
        button, cur, n = queue.popleft()
        cur = cur[:]

        for pos in button:
            cur[pos] = not cur[pos]

        if cur == target:
            print(i)
            part1 += n
            break

        for b in buttons:
            queue.append((b, cur, n+1))

print("Part 1:", part1)
