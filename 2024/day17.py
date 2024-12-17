from sys import stdin

A = int(next(stdin).split()[-1])
B = int(next(stdin).split()[-1])
C = int(next(stdin).split()[-1])

next(stdin)
program = [int(x) for x in next(stdin).lstrip("Program: ").strip().split(",")]

ptr = 0
output = []


def run_op(opcode, operand):
    global A, B, C, ptr

    combo = operand
    if operand == 4:
        combo = A
    elif operand == 5:
        combo = B
    elif operand == 6:
        combo = C

    if opcode == 0:
        A = A // 2**combo
    elif opcode == 1:
        B = B ^ operand
    elif opcode == 2:
        B = combo % 8
    elif opcode == 3:
        if A != 0:
            ptr = operand
    elif opcode == 4:
        B = B ^ C
    elif opcode == 5:
        output.append(combo % 8)
    elif opcode == 6:
        B = A // 2**combo
    elif opcode == 7:
        C = A // 2**combo


def run():
    global ptr

    while ptr < len(program):
        opcode = program[ptr]
        operand = program[ptr + 1]
        ptr += 2
        run_op(opcode, operand)


run()
print(",".join(str(x) for x in output))
