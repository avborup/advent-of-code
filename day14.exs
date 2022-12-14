defmodule Part1 do
  def solve() do
    occupied = read_input()

    void_y = Enum.map(occupied, fn {_, y} -> y end) |> Enum.max()

    drop_sand(occupied, void_y)
    |> Enum.count()
    |> IO.inspect()
  end

  def drop_sand(start_pos \\ {500, 0}, occupied, max_y) do
    Stream.unfold(occupied, fn occupied ->
      case find_rest_position(start_pos, occupied, max_y) do
        nil -> nil
        pos when start_pos == pos -> nil
        pos -> {pos, MapSet.put(occupied, pos)}
      end
    end)
  end

  def find_rest_position({_, y}, _, max_y) when y >= max_y do
    nil
  end

  def find_rest_position(coord, occupied, max_y) do
    down = move(coord, :down)
    left = move(down, :left)
    right = move(down, :right)

    next = Enum.find([down, left, right], &(not MapSet.member?(occupied, &1)))

    case next do
      nil -> coord
      _ -> find_rest_position(next, occupied, max_y)
    end
  end

  def move({x, y}, direction) do
    case direction do
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  # Code below this is purely for parsing the input blocks into a set

  def read_input() do
    File.stream!("inputs/day14-input.txt")
    |> Stream.map(&read_line/1)
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
  end

  def generate_coordinate_range({{x1, y1}, {x2, y2}}) do
    cond do
      x1 == x2 -> Enum.map(y1..y2, fn y -> {x1, y} end)
      y1 == y2 -> Enum.map(x1..x2, fn x -> {x, y1} end)
    end
  end

  def read_line(line) do
    line
    |> String.trim_trailing()
    |> (&String.split(&1, " -> ")).()
    |> Enum.map(&parse_coordinate/1)
    |> pairwise()
    |> Enum.map(&generate_coordinate_range/1)
    |> Enum.reduce(MapSet.new(), &MapSet.union(MapSet.new(&1), &2))
  end

  def parse_coordinate(string) do
    String.split(string, ",")
    |> Enum.map(&String.to_integer/1)
    |> (fn [x, y] -> {x, y} end).()
  end

  def pairwise(list) do
    case list do
      [a, b | tail] -> [{a, b} | pairwise([b | tail])]
      _ -> []
    end
  end
end

Part1.solve()
