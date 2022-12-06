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

  # Alternative:
  # def find_marker(input, marker_size, index \\ 0) do
  #   if Enum.take(input, marker_size) |> Enum.uniq() |> Enum.count() == marker_size do
  #     index + marker_size
  #   else
  #     find_marker(Enum.drop(input, 1), marker_size, index + 1)
  #   end
  # end
end

defmodule Part2 do
  def solve() do
    Part1.read_input()
    |> (&Part1.find_marker(&1, 14)).()
    |> IO.inspect()
  end
end

Part1.solve()
Part2.solve()
