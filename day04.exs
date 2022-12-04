defmodule Part1 do
  def solve() do
    File.stream!("inputs/day04-input.txt")
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&is_contained?/1)
    |> Enum.count()
    |> IO.inspect()
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

Part1.solve()
