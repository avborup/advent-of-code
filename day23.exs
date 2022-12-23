defmodule Part1 do
  def solve() do
    outcome =
      read_input()
      |> play_rounds()
      |> Enum.at(10)

    area = find_bounding_box_area(outcome)
    empty_tiles = area - Enum.count(outcome)

    IO.inspect(empty_tiles)
  end

  def play_rounds(elves) do
    Stream.unfold({0, elves}, fn {round, elves} ->
      {elves, {round + 1, play_round(elves, round + 1)}}
    end)
  end

  def play_round(positions, round) do
    Enum.map(positions, &{&1, find_proposal(positions, &1, round)})
    |> Enum.reduce(%{}, fn {elf, proposal}, acc ->
      case proposal do
        :stay ->
          acc

        {:move, to} ->
          Map.get_and_update(acc, to, fn current ->
            case current do
              nil -> {nil, {1, elf}}
              {count, _} -> {nil, {count + 1, elf}}
            end
          end)
          |> elem(1)
      end
    end)
    |> Enum.reject(fn {_, {count, _}} -> count > 1 end)
    |> Enum.map(fn {to, {_, from}} -> {from, to} end)
    |> Enum.reduce(positions, fn {from, to}, acc ->
      acc |> MapSet.delete(from) |> MapSet.put(to)
    end)
  end

  def find_proposal(positions, elf, round) do
    {row, col} = elf
    northern = northern_neighbours(elf)
    southern = southern_neighbours(elf)
    eastern = eastern_neighbours(elf)
    western = western_neighbours(elf)
    all = northern ++ southern ++ eastern ++ western

    if not any_elf_in(positions, all) do
      :stay
    else
      shift_by = rem(round - 1, 4)

      directions = [
        {fn -> not any_elf_in(positions, northern) end, {:move, {row - 1, col}}},
        {fn -> not any_elf_in(positions, southern) end, {:move, {row + 1, col}}},
        {fn -> not any_elf_in(positions, western) end, {:move, {row, col - 1}}},
        {fn -> not any_elf_in(positions, eastern) end, {:move, {row, col + 1}}}
      ]

      move =
        (Enum.drop(directions, shift_by) ++ Enum.take(directions, shift_by))
        |> Enum.find_value(fn {condition, target} -> if condition.(), do: target end)

      case move do
        nil -> :stay
        move -> move
      end
    end
  end

  def northern_neighbours({row, col}) do
    [{row - 1, col - 1}, {row - 1, col}, {row - 1, col + 1}]
  end

  def southern_neighbours({row, col}) do
    [{row + 1, col - 1}, {row + 1, col}, {row + 1, col + 1}]
  end

  def western_neighbours({row, col}) do
    [{row - 1, col - 1}, {row, col - 1}, {row + 1, col - 1}]
  end

  def eastern_neighbours({row, col}) do
    [{row - 1, col + 1}, {row, col + 1}, {row + 1, col + 1}]
  end

  def any_elf_in(positions, positions_to_check) do
    Enum.any?(positions_to_check, &MapSet.member?(positions, &1))
  end

  def find_bounding_box_area(elves) do
    {{min_row, min_col}, {max_row, max_col}} = find_bounding_box(elves)
    (max_row - min_row + 1) * (max_col - min_col + 1)
  end

  def find_bounding_box(elves) do
    Enum.reduce(elves, {{nil, nil}, {nil, nil}}, fn {row, col},
                                                    {{min_row, min_col}, {max_row, max_col}} ->
      min_row = if min_row == nil or row < min_row, do: row, else: min_row
      max_row = if max_row == nil or row > max_row, do: row, else: max_row
      min_col = if min_col == nil or col < min_col, do: col, else: min_col
      max_col = if max_col == nil or col > max_col, do: col, else: max_col

      {{min_row, min_col}, {max_row, max_col}}
    end)
  end

  def read_input() do
    File.stream!("inputs/day23-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_charlist/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, row}, acc ->
      Enum.reduce(line, acc, fn {tile, col}, acc ->
        if tile == ?#, do: MapSet.put(acc, {row, col}), else: acc
      end)
    end)
  end

  # Utility function for debugging
  def print(elves) do
    {{min_row, min_col}, {max_row, max_col}} = find_bounding_box(elves)

    for row <- min_row..max_row do
      for col <- min_col..max_col do
        if MapSet.member?(elves, {row, col}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end
  end
end

Part1.solve()
