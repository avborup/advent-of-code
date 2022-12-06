defmodule Part1 do
  def solve() do
    read_input()
    |> (&find_marker(&1, 4)).()
    |> IO.inspect()
  end

  def read_input() do
    File.read!("inputs/day06-input.txt")
    |> String.trim()
    |> String.to_charlist()
  end

  def find_marker(input, marker_size) do
    0..Enum.count(input)
    |> Enum.reduce_while(input, fn index, acc ->
      if Enum.take(acc, marker_size) |> Enum.uniq() |> Enum.count() == marker_size do
        {:halt, index + marker_size}
      else
        {:cont, Enum.drop(acc, 1)}
      end
    end)
  end
end

Part1.solve()
