defmodule Part1 do
  def solve() do
    read_input()
    |> simulate_rope()
    |> count_visited_by_tail()
    |> IO.inspect()
  end

  def count_visited_by_tail(steps) do
    steps
    |> Enum.reduce(MapSet.new(), fn {_, tail}, acc ->
      MapSet.put(acc, tail)
    end)
    |> MapSet.size()
  end

  def simulate_rope(moves) do
    Stream.unfold({{0, 0}, {0, 0}, moves}, fn {head, tail, moves} ->
      case moves do
        [] ->
          nil

        [{dir, amount} | moves] ->
          {new_head, new_tail} = execute_move(head, tail, dir)

          new_moves =
            case amount do
              1 -> moves
              _ -> [{dir, amount - 1} | moves]
            end

          {{new_head, new_tail}, {new_head, new_tail, new_moves}}
      end
    end)
  end

  def execute_move(head, tail, dir) do
    new_head =
      case dir do
        :up -> {0, 1}
        :down -> {0, -1}
        :left -> {-1, 0}
        :right -> {1, 0}
      end
      |> add(head)

    new_tail =
      if distance(new_head, tail) <= 1.5 do
        tail
      else
        case dir do
          :up -> {0, -1}
          :down -> {0, 1}
          :left -> {1, 0}
          :right -> {-1, 0}
        end
        |> add(new_head)
      end

    {new_head, new_tail}
  end

  def distance({ax, ay}, {bx, by}) do
    :math.sqrt((ax - bx) ** 2 + (ay - by) ** 2)
  end

  def add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def read_input() do
    File.stream!("inputs/day09-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&read_line/1)
    |> Enum.to_list()
  end

  def read_line(line) do
    [dir, amount] = String.split(line)

    dir =
      case dir do
        "U" -> :up
        "D" -> :down
        "L" -> :left
        "R" -> :right
      end

    {dir, String.to_integer(amount)}
  end
end

Part1.solve()
