defmodule Reading do
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

defmodule Solution do
  def solve(rope_length) do
    Reading.read_input()
    |> simulate_rope(rope_length)
    |> count_visited_by_tail()
    |> IO.inspect()
  end

  def count_visited_by_tail(steps) do
    steps
    |> Enum.reduce(MapSet.new(), fn rope, acc ->
      MapSet.put(acc, Enum.at(rope, -1))
    end)
    |> MapSet.size()
  end

  def simulate_rope(moves, length) do
    rope = Enum.map(1..length, fn _ -> {0, 0} end)

    Stream.unfold({rope, moves}, fn {rope, moves} ->
      case moves do
        [] ->
          nil

        [{dir, amount} | moves] ->
          new_rope = execute_move(rope, dir)

          new_moves =
            case amount do
              1 -> moves
              _ -> [{dir, amount - 1} | moves]
            end

          {new_rope, {new_rope, new_moves}}
      end
    end)
  end

  def execute_move(rope, dir) do
    [head | remaining_rope] = rope

    new_head =
      case dir do
        :up -> {0, 1}
        :down -> {0, -1}
        :left -> {-1, 0}
        :right -> {1, 0}
      end
      |> add(head)

    Enum.reduce(remaining_rope, [new_head], fn cur, new_rope ->
      [prev | _] = new_rope

      next =
        if distance(cur, prev) <= 1.5 do
          cur
        else
          {dx, dy} = sub(prev, cur)
          add(cur, {sign(dx), sign(dy)})
        end

      [next | new_rope]
    end)
    |> Enum.reverse()
  end

  def distance({ax, ay}, {bx, by}) do
    :math.sqrt((ax - bx) ** 2 + (ay - by) ** 2)
  end

  def add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def sub({ax, ay}, {bx, by}) do
    {ax - bx, ay - by}
  end

  def sign(x) do
    case x do
      x when x > 0 -> 1
      x when x < 0 -> -1
      _ -> 0
    end
  end
end

defmodule Part1 do
  def solve() do
    Solution.solve(2)
  end
end

defmodule Part2 do
  def solve() do
    Solution.solve(10)
  end
end

Part1.solve()
Part2.solve()
