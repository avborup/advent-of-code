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

defmodule Part2 do
  def solve() do
    Part1.read_input()
    |> find_variable_value()
    |> IO.inspect()
  end

  def find_variable_value(monkeys) do
    {first, _, second} = Map.get(monkeys, "root")

    {[first_monkey | subpath], expected} =
      case {find_humn_path(monkeys, first), find_humn_path(monkeys, second)} do
        {path, nil} -> {path, Part1.calculate_yell(monkeys, second)}
        {nil, path} -> {path, Part1.calculate_yell(monkeys, first)}
      end

    solve_equation(monkeys, first_monkey, subpath, expected)
  end

  def solve_equation(_, _, [], expected) do
    expected
  end

  def solve_equation(monkeys, monkey, [next | path], expected) do
    {first, op, second} = Map.get(monkeys, monkey)
    is_left = first == next
    other_monkey = if(is_left, do: second, else: first)
    other = Part1.calculate_yell(monkeys, other_monkey)

    new_expected =
      case op do
        "+" -> expected - other
        "-" when is_left -> other + expected
        "-" -> other - expected
        "*" -> expected / other
        "/" -> expected * other
      end

    solve_equation(monkeys, next, path, new_expected)
  end

  def find_humn_path(_, "humn") do
    ["humn"]
  end

  def find_humn_path(monkeys, monkey) do
    case Map.get(monkeys, monkey) do
      num when is_integer(num) ->
        nil

      {first, _, second} ->
        case {find_humn_path(monkeys, first), find_humn_path(monkeys, second)} do
          {nil, nil} -> nil
          {first_res, nil} -> [monkey | first_res]
          {nil, second_res} -> [monkey | second_res]
        end
    end
  end
end

Part1.solve()
Part2.solve()
