from sys import stdin
import re
from collections import deque
import scipy

lines = [
    (
        re.match(r"\[(.*)\]", line).group(1),
        [tuple(int(x) for x in m.split(",")) for m in re.findall(r"\(([\d,]+)\)", line)],
        [int(x) for x in line.split()[-1][1:-1].split(",")]
    )
    for line in stdin
]

part2 = 0
for lights, buttons, joltages in lines:
    # See docs for variable name meanings: 
    # https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.linprog.html

    # Essentially: find x such that c.dot(x) is minimized and Ax = b

    A = [[0 for _ in range(len(buttons))] for _ in range(len(joltages))]
    for bi, b in enumerate(buttons):
        for ji in b:
            A[ji][bi] = 1

    c = [1 for _ in range(len(buttons))]
    b = joltages

    res = scipy.optimize.linprog(c, A_eq=A, b_eq=joltages, integrality=1)

    part2 += int(sum(res.x))

print(part2)
