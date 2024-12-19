from sys import stdin

def run_op(state, program):
    ptr, A, B, C, output = state

    opcode = program[ptr]
    operand = program[ptr + 1]
    ptr += 2

    combo = operand
    if operand == 4: combo = A
    elif operand == 5: combo = B
    elif operand == 6: combo = C

    if opcode == 0: A = A // 2**combo
    elif opcode == 1: B = B ^ operand
    elif opcode == 2: B = combo % 8
    elif opcode == 3:
        if A != 0: ptr = operand
    elif opcode == 4: B = B ^ C
    elif opcode == 5: output.append(combo % 8)
    elif opcode == 6: B = A // 2**combo
    elif opcode == 7: C = A // 2**combo

    return ptr, A, B, C, output

def run(state, program):
    while state[0] < len(program):
        state = run_op(state, program)
    return state

def pretty_program(prog):
    """
    Outputs:
        B = A % 8
        B = B ^ 3
        C = A >> B
        B = B ^ 5
        A = A >> 3
        B = B ^ C
        output(B % 8)
        if A != 0: ptr = 0

    I.e. use last 3 bits of A to calc some value, shift A by 3, and repeat.
         => only groups of 3 bits of A are used for an output.
         => if A is 3 bits long, only 1 iteration occurs
    Idea: find each 3-bit group in A that satisfies the output.
    """
    for opcode, operand in zip(prog[::2], prog[1::2]):
        combo = operand
        if operand == 4: combo = "A"
        elif operand == 5: combo = "B"
        elif operand == 6: combo = "C"

        if opcode == 0: print(f"A = A >> {combo}")
        elif opcode == 1: print(f"B = B ^ {operand}")
        elif opcode == 2: print(f"B = {combo} % 8")
        elif opcode == 3: print(f"if A != 0: ptr = {operand}")
        elif opcode == 4: print(f"B = B ^ C")
        elif opcode == 5: print(f"output({combo} % 8)")
        elif opcode == 6: print(f"B = A >> {combo}")
        elif opcode == 7: print(f"C = A >> {combo}")

def solve(program, index, acc):
    for bit_group in range(2 ** 3):
        a = (acc << 3) + bit_group
        res = run((0, a, orig_B, orig_C, []), program)

        if res[4][0] == program[index]:
            if index <= 0: return a
            if (rec := solve(program, index - 1, a)) is not None:
                return rec
    return None

orig_A = int(next(stdin).split()[-1])
orig_B = int(next(stdin).split()[-1])
orig_C = int(next(stdin).split()[-1])
next(stdin)
program = [int(x) for x in next(stdin).lstrip("Program: ").strip().split(",")]

pretty_program(program)
print()

part1 = run((0, orig_A, orig_B, orig_C, []), program)
part2 = solve(program, len(program) - 1, 0)

print("Part 1:", ','.join(str(x) for x in part1[4]))
print("Part 2:", part2)
