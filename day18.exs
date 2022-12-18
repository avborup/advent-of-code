defmodule Part1 do
  def solve() do
    Shared.read_input()
    |> get_surface_area()
  end

  def get_surface_area(lava_blocks) do
    lava_blocks
    |> Enum.map(&Shared.count_lava_neighbours(lava_blocks, &1))
    |> Enum.map(&(6 - &1))
    |> Enum.sum()
  end
end

defmodule Shared do
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

defmodule Part2 do
  def solve() do
    Shared.read_input()
    |> get_exterior_surface_area()
  end

  # Uses flood fill: https://en.wikipedia.org/wiki/Flood_fill
  def get_exterior_surface_area(lava_blocks) do
    outside_coord = get_outside_coordinate(lava_blocks)
    steam_blocks = flood_fill(lava_blocks, outside_coord)

    steam_blocks
    |> Enum.map(&Shared.count_lava_neighbours(lava_blocks, &1))
    |> Enum.sum()
  end

  def flood_fill(lava_blocks, coordinate, visited \\ MapSet.new()) do
    visited = MapSet.put(visited, coordinate)

    Shared.neighbours(coordinate)
    |> Enum.reject(&MapSet.member?(lava_blocks, &1))
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.filter(&is_close_to_lava(lava_blocks, &1))
    |> Enum.reduce(visited, fn neighbour, visited ->
      flood_fill(lava_blocks, neighbour, visited)
    end)
  end

  def is_close_to_lava(lava_blocks, coordinate) do
    has_lava_neighbour(lava_blocks, coordinate) or
      Enum.any?(Shared.neighbours(coordinate), &has_lava_neighbour(lava_blocks, &1))
  end

  def has_lava_neighbour(lava_blocks, coordinate) do
    Shared.neighbours(coordinate) |> Enum.any?(&MapSet.member?(lava_blocks, &1))
  end

  def get_outside_coordinate(lava_blocks) do
    {x, y, z} = Enum.min(lava_blocks)
    {x - 1, y, z}
  end
end

{part1_time, part1} = :timer.tc(&Part1.solve/0)
{part2_time, part2} = :timer.tc(&Part2.solve/0)

IO.puts("Part 1: #{part1} (#{part1_time / 1000}ms)")
IO.puts("Part 2: #{part2} (#{part2_time / 1000}ms)")
