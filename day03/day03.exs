defmodule Part1 do
  def solve() do
    File.stream!("input.txt")
    |> Stream.map(&parse_line/1)
    |> Stream.map(&find_shared_item/1)
    |> Stream.map(&item_priority/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def find_shared_item({comp1, comp2}) do
    MapSet.intersection(MapSet.new(comp1), MapSet.new(comp2)) |> Enum.at(0)
  end

  def parse_line(line) do
    chars = String.trim(line) |> String.to_charlist()
    size = Enum.count(chars) |> div(2)

    {Enum.take(chars, size), Enum.take(chars, -size)}
  end

  def item_priority(item) do
    String.to_charlist("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    |> Enum.find_index(&(&1 == item))
    |> Kernel.+(1)
  end
end

Part1.solve()
