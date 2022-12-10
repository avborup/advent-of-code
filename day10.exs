defmodule CPU do
  defstruct register: 1, cycle: 0, instructions: []
end

defmodule Part1 do
  def solve() do
    cycles =
      parse_input()
      |> create_cycles()

    samples =
      cycles
      |> Enum.drop(19)
      |> Enum.take_every(40)

    samples
    |> Enum.map(&(&1.cycle * &1.register))
    |> Enum.sum()
    |> IO.inspect()
  end

  def create_cycles(all_instructions) do
    Stream.unfold(%CPU{instructions: all_instructions}, fn cpu ->
      case cpu do
        nil ->
          nil

        cpu ->
          cpu = %{cpu | cycle: cpu.cycle + 1}

          applied =
            case cpu.instructions do
              [] -> nil
              [{n, ins} | tail] when n > 1 -> %{cpu | instructions: [{n - 1, ins} | tail]}
              [{_, ins} | tail] -> %{apply_instruction(cpu, ins) | instructions: tail}
            end

          {cpu, applied}
      end
    end)
  end

  def apply_instruction(cpu, instruction) do
    case instruction do
      :noop -> cpu
      {:addx, x} -> %{cpu | register: cpu.register + x}
    end
  end

  def parse_input() do
    File.stream!("inputs/day10-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(line) do
    case line do
      "noop" -> {1, :noop}
      "addx " <> x -> {2, {:addx, String.to_integer(x)}}
    end
  end
end

Part1.solve()
