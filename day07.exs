defmodule Fil do
  defstruct name: nil, size: 0
end

defmodule Dir do
  defstruct name: nil, children: %{}, size: 0
end

defmodule Part1 do
  def solve() do
    read_input_tree()
    |> search(&is_dir_size_at_most_100_000/1)
    |> Enum.map(& &1.size)
    |> Enum.sum()
    |> IO.inspect()
  end

  def is_dir_size_at_most_100_000(node) do
    case node do
      %{children: _} when node.size <= 100_000 -> true
      _ -> false
    end
  end

  def read_input_tree() do
    File.stream!("inputs/day07-input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.drop(1)
    |> parse_input()
    |> calculate_sizes()
  end

  def parse_input(lines, root \\ %Dir{name: "/"}, cwd \\ []) do
    case lines do
      [] ->
        root

      ["$ cd .." | tail] ->
        parse_input(tail, root, Enum.drop(cwd, -1))

      ["$ cd " <> target | tail] ->
        parse_input(tail, root, cwd ++ [target])

      ["$ " <> _ | tail] ->
        parse_input(tail, root, cwd)

      [entry | tail] ->
        insert_entry(root, cwd, entry)
        |> (&parse_input(tail, &1, cwd)).()
    end
  end

  def insert_entry(dir, [], "dir " <> name) do
    %{dir | children: Map.put_new(dir.children, name, %Dir{name: name})}
  end

  def insert_entry(dir, [], entry) do
    [size, name] = String.split(entry)
    size = String.to_integer(size)
    %{dir | children: Map.put(dir.children, name, %Fil{name: name, size: size})}
  end

  def insert_entry(dir, [cur_dir | cwd_tail], entry) do
    child = Map.get(dir.children, cur_dir, %Dir{})
    new_entry = insert_entry(child, cwd_tail, entry)
    %{dir | children: Map.put(dir.children, cur_dir, new_entry)}
  end

  def calculate_sizes(dir = %{children: _}) do
    new_children =
      Enum.reduce(dir.children, %{}, fn {k, child}, acc ->
        Map.put(acc, k, calculate_sizes(child))
      end)

    total_size = Map.values(new_children) |> Enum.map(& &1.size) |> Enum.sum()

    %{dir | children: new_children, size: total_size}
  end

  def calculate_sizes(file) do
    file
  end

  def search(dir, predicate, results \\ []) do
    Enum.reduce(dir.children, results, fn {_, child}, acc ->
      acc = if predicate.(child), do: [child | acc], else: acc

      case child do
        %{children: _} -> search(child, predicate, acc)
        _ -> acc
      end
    end)
  end
end

Part1.solve()
