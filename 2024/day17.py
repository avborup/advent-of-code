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


def run(state, program):
    while state[0] < len(program):
        state = run_op(state, program)
    return state


def solve(program, index, acc):
    # bitgroups = []
    # for i in range(len(program)):
    #     for a in range(2 ** 3):
    #         res = run((0, a, orig_B, orig_C, []), program)
    #         if res[4] == [program[i]]:
    #             bitgroups.append(a)
    #             break
    # a = 0
    # for n in reversed(bitgroups):
    #     a = (a << 3) + n

    for group in range(2 ** 3):
        a = (acc << 3) + group
        res = run((0, a, orig_B, orig_C, []), program)

        if res[4] == program[index:]:
            if index <= 0:
                return a

            if (rec := solve(program, index - 1, a)) is not None:
                return rec

    return None



    print(a, bitgroups)

orig_A = int(next(stdin).split()[-1])
orig_B = int(next(stdin).split()[-1])
orig_C = int(next(stdin).split()[-1])

next(stdin)
program = [int(x) for x in next(stdin).lstrip("Program: ").strip().split(",")]

pretty_program(program)

print(run((0, orig_A, orig_B, orig_C, []), program))

print(solve(program, len(program) - 1, 0))


# min A = 2**44
# max A = 2**48

outs = []

# 1) min/max by length 16
# 2) try randoms, reduce min/max ranges with most matching final elements

# 235928149323145 : 5,3,5,1,4,4,5,6,6,5,2,5,5,5,3,0
# 235931905437136 : 4,1,2,0,5,7,1,6,3,1,4,1,5,5,3,0
# 235932903155938 : 5,0,6,0,5,1,1,5,3,1,3,1,5,5,3,0

start = 531104
stepsize = 262144
microstep = 31

# for i in range(2**45, 2**48):
#     ptr = 0
#     A = i
#     B = orig_B
#     C = orig_C
#     output.clear()
#     run()
#
#     match = 6
#     if output[:match] == program[:match]:
#         print(len(output), ":", ",".join(str(x) for x in output))
#         print("Progress", i)
#
#     outs.append((i, output.copy()))
#
#     if program == output:
#         print("Found", i)
#         break

# outs.sort(key=lambda x: x[0])
# for i, out in outs:
#     print(i, ":", ",".join(str(x) for x in out))

