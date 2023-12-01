defmodule Part1 do
  def solve() do
    read_lines()
    |> Stream.filter(&is_contained?/1)
    |> Enum.count()
    |> IO.inspect()
  end

  def read_lines() do
    File.stream!("inputs/day04-input.txt")
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    String.trim(line)
    |> String.split([",", "-"])
    |> Enum.map(&String.to_integer/1)
  end

  def is_contained?([a, b, c, d]) do
    (c >= a and d <= b) or (a >= c and b <= d)
  end
end

defmodule Part2 do
  def solve() do
    Part1.read_lines()
    |> Stream.filter(&overlaps?/1)
    |> Enum.count()
    |> IO.inspect()
  end

  def overlaps?([a, b, c, d]) do
    a <= d and c <= b
  end
end

Part1.solve()
Part2.solve()
