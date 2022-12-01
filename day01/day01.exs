defmodule Part1 do
  def solve() do
    read_calories()
    |> Enum.max()
    |> IO.puts()
  end

  def read_calories() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&sum_elf/1)
  end

  def sum_elf(elf) do
    elf
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end

defmodule Part2 do
  def solve() do
    Part1.read_calories()
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
    |> IO.puts()
  end
end

Part1.solve()
Part2.solve()
