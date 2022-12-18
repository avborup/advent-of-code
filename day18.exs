defmodule Part1 do
  def solve() do
    read_input()
    |> get_surface_area()
    |> IO.inspect()
  end

  def get_surface_area(lava_blocks) do
    lava_blocks
    |> Enum.map(&count_lava_neighbours(lava_blocks, &1))
    |> Enum.map(&(6 - &1))
    |> Enum.sum()
  end

  def count_lava_neighbours(lava_blocks, block) do
    neighbours(block)
    |> Enum.filter(&Enum.member?(lava_blocks, &1))
    |> Enum.count()
  end

  def read_input() do
    File.stream!("inputs/day18-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&read_line/1)
    |> MapSet.new()
  end

  def read_line(line) do
    [x, y, z] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
    {x, y, z}
  end

  def neighbours({x, y, z}) do
    [
      {x + 1, y, z},
      {x, y + 1, z},
      {x, y, z + 1},
      {x - 1, y, z},
      {x, y - 1, z},
      {x, y, z - 1}
    ]
  end
end

Part1.solve()
