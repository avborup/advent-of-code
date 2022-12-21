defmodule Part1 do
  def solve() do
    read_input()
    |> calculate_yell("root")
    |> IO.inspect()
  end

  def calculate_yell(monkeys, monkey) do
    case Map.get(monkeys, monkey) do
      num when is_integer(num) ->
        num

      {first, operator, second} ->
        case {calculate_yell(monkeys, first), operator, calculate_yell(monkeys, second)} do
          {a, "+", b} -> a + b
          {a, "*", b} -> a * b
          {a, "-", b} -> a - b
          {a, "/", b} -> a / b
        end
    end
  end

  def read_input() do
    File.stream!("inputs/day21-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&read_line/1)
    |> Enum.reduce(%{}, fn {name, value}, acc ->
      Map.put(acc, name, value)
    end)
  end

  def read_line(line) do
    [name | remaining] = String.split(line)
    name = String.trim_trailing(name, ":")

    case remaining do
      [first, operator, second] ->
        {name, {first, operator, second}}

      [number] ->
        {name, String.to_integer(number)}
    end
  end
end

Part1.solve()
