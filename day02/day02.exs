defmodule Part1 do
  def solve() do
    read_lines()
    |> Stream.map(&calculate_points/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def read_lines() do
    File.stream!("input.txt")
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    [left, right | _] =
      String.trim(line)
      |> String.split(" ")
      |> Enum.map(&parse_char/1)

    {left, right}
  end

  def parse_char(char) do
    case char do
      c when c in ["A", "X"] -> :rock
      c when c in ["B", "Y"] -> :paper
      c when c in ["C", "Z"] -> :scissors
    end
  end

  def find_winner(left, right) do
    cond do
      left == right -> :draw
      find_shape_to_win(left) == right -> :right
      find_shape_to_lose(left) == right -> :left
    end
  end

  def find_shape_to_win(shape) do
    case shape do
      :rock -> :paper
      :paper -> :scissors
      :scissors -> :rock
    end
  end

  def find_shape_to_lose(shape) do
    case shape do
      :rock -> :scissors
      :paper -> :rock
      :scissors -> :paper
    end
  end

  def calculate_points({left, right}) do
    points_from_shape(right) + points_from_outcome(left, right)
  end

  def points_from_shape(shape) do
    case shape do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  def points_from_outcome(left, right) do
    case find_winner(left, right) do
      :left -> 0
      :draw -> 3
      :right -> 6
    end
  end
end

defmodule Part2 do
  def solve() do
    Part1.read_lines()
    |> Stream.map(&calculate_points/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def calculate_points({left, right}) do
    move =
      case right do
        :rock -> Part1.find_shape_to_lose(left)
        :paper -> left
        :scissors -> Part1.find_shape_to_win(left)
      end

    Part1.calculate_points({left, move})
  end
end

Part1.solve()
Part2.solve()
