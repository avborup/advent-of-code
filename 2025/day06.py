from sys import stdin

grid = []
for line in stdin:
    items = [i for i in line.strip().split() if len(i) > 0]
    grid.append(items)

part1 = 0
for col in range(len(grid[0])):
    operator = grid[-1][col]
    res = 0 if operator == "+" else 1
    for row in range(len(grid)-1):
        cell = int(grid[row][col])
        if operator == "+":
            res += cell
        elif operator == "*":
            res *= cell

    part1 += res

print(part1)
