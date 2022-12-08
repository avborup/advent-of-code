defmodule Part1 do
  def solve() do
    trees = read_input()

    trees
    |> Enum.filter(&is_tree_visible?(trees, &1))
    |> Enum.count()
    |> IO.inspect()
  end

  def is_tree_visible?(trees, tree) do
    all_directions()
    |> Enum.map(&can_be_seen_from_direction?(trees, tree, &1))
    |> Enum.any?()
  end

  def can_be_seen_from_direction?(trees, {location, height}, direction) do
    trees
    |> get_all_trees_in_direction(location, direction)
    |> Enum.all?(&(&1 < height))
  end

  def read_input() do
    File.stream!("inputs/day08-input.txt")
    |> Stream.map(&read_line/1)
    |> Enum.to_list()
    |> matrix_to_map()
  end

  def read_line(line) do
    line
    |> String.trim_trailing()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  def matrix_to_map(matrix) do
    matrix
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      Enum.reduce(line, acc, fn {height, col}, acc ->
        Map.put(acc, {col, row}, height)
      end)
    end)
  end

  def all_directions() do
    [:left, :right, :up, :down]
  end

  def get_all_trees_in_direction(trees, start, direction) do
    dir_vec = direction_vector(direction)

    add_vectors(start, dir_vec)
    |> Stream.unfold(fn pos ->
      case Map.get(trees, pos) do
        nil -> nil
        height -> {height, add_vectors(pos, dir_vec)}
      end
    end)
  end

  def direction_vector(direction) do
    case direction do
      :left -> {-1, 0}
      :right -> {1, 0}
      :up -> {0, -1}
      :down -> {0, 1}
    end
  end

  def add_vectors({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end
end

Part1.solve()
