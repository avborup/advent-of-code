defmodule Part1 do
  def solve() do
    {start_pos, end_pos, map} = read_input()

    find_path(map, end_pos, &(&1 == start_pos))
    |> IO.inspect()
  end

  def find_path(map, end_pos, predicate) do
    visited = MapSet.new()
    queue = :queue.in({end_pos, 0}, :queue.new())

    bfs(map, queue, visited, predicate)
  end

  def bfs(map, queue, visited, predicate) do
    {{:value, {cur_pos, distance}}, queue} = :queue.out(queue)

    cond do
      predicate.(cur_pos) ->
        distance

      MapSet.member?(visited, cur_pos) ->
        bfs(map, queue, visited, predicate)

      true ->
        visited = MapSet.put(visited, cur_pos)

        get_all_surrounding(map, cur_pos)
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.filter(&height_difference_is_allowed?(map, cur_pos, &1))
        |> Enum.map(&{&1, distance + 1})
        |> Enum.reduce(queue, &:queue.in(&1, &2))
        |> (&bfs(map, &1, visited, predicate)).()
    end
  end

  def height_difference_is_allowed?(map, from_pos, to_pos) do
    from_height = Map.get(map, from_pos)
    to_height = Map.get(map, to_pos)

    from_height - to_height <= 1
  end

  def read_input() do
    letter_map =
      File.stream!("inputs/day12-input.txt")
      |> Stream.map(&read_line/1)
      |> Enum.to_list()
      |> matrix_to_map()

    start_pos = find_value(letter_map, ?S)
    end_pos = find_value(letter_map, ?E)

    height_map =
      letter_map
      |> Map.replace!(start_pos, ?a)
      |> Map.replace!(end_pos, ?z)
      |> Enum.map(fn {k, v} -> {k, v - ?a} end)
      |> Map.new()

    {start_pos, end_pos, height_map}
  end

  def read_line(line) do
    line
    |> String.trim_trailing()
    |> String.to_charlist()
  end

  def matrix_to_map(matrix) do
    matrix
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      Enum.reduce(line, acc, fn {letter, col}, acc ->
        Map.put(acc, {col, row}, letter)
      end)
    end)
  end

  def find_value(letter_map, value) do
    {pos, _} = Enum.find(letter_map, fn {_, v} -> v == value end)
    pos
  end

  def get_all_surrounding(map, {x, y}) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
    |> Enum.filter(&Map.has_key?(map, &1))
  end
end

defmodule Part2 do
  def solve() do
    {_, end_pos, map} = Part1.read_input()

    Part1.find_path(map, end_pos, &(Map.get(map, &1) == 0))
    |> IO.inspect()
  end
end

Part1.solve()
Part2.solve()
