defmodule Monkey do
  defstruct id: -1,
            items: [],
            operation: nil,
            test: nil,
            true_target: nil,
            false_target: nil,
            dividend: nil,
            inspect_count: 0
end

defmodule Solution do
  def solve(part) do
    monkeys = Parsing.read_input()

    round =
      case part do
        :part1 -> 20
        :part2 -> 10000
      end

    lcm = find_lcm(monkeys)

    lose_interest =
      case part do
        :part1 -> fn n -> div(n, 3) end
        :part2 -> fn n -> rem(n, lcm) end
      end

    monkeys
    |> simulate_rounds(lose_interest)
    |> Enum.at(round)
    |> Enum.map(fn {_, monkey} -> monkey.inspect_count end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
    |> IO.inspect()
  end

  defp simulate_rounds(monkeys, lose_interest) do
    Stream.unfold(monkeys, fn monkeys ->
      {monkeys, simulate_round(monkeys, lose_interest)}
    end)
  end

  defp simulate_round(monkeys, lose_interest) do
    Map.keys(monkeys)
    |> Enum.reduce(monkeys, fn id, monkeys ->
      monkey = Map.get(monkeys, id)

      {new_monkey, throws} = simulate_turn(monkey, lose_interest)

      monkeys = Map.put(monkeys, new_monkey.id, new_monkey)

      Enum.reduce(throws, monkeys, fn {target, item}, acc ->
        target_monkey = Map.get(acc, target)

        Map.put(
          acc,
          target,
          %{target_monkey | items: target_monkey.items ++ [item]}
        )
      end)
    end)
  end

  defp simulate_turn(monkey, lose_interest) do
    {new_monkey, throws} =
      Enum.reduce(monkey.items, {monkey, []}, fn _, {monkey, throws} ->
        [item | items] = monkey.items

        worry = monkey.operation.(item) |> lose_interest.()

        target =
          case monkey.test.(worry) do
            true -> monkey.true_target
            false -> monkey.false_target
          end

        new_monkey = %{monkey | items: items, inspect_count: monkey.inspect_count + 1}

        {new_monkey, [{target, worry} | throws]}
      end)

    {new_monkey, Enum.reverse(throws)}
  end

  # All the dividends are small primes - so we essentially got prime factorization for free
  defp find_lcm(monkeys) do
    Enum.map(monkeys, fn {_, monkey} -> monkey.dividend end)
    |> Enum.reduce(1, &(&1 * &2))
  end
end

defmodule Parsing do
  def read_input() do
    File.stream!("inputs/day11-input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(&1 != ""))
    |> Stream.chunk_every(6)
    |> Stream.map(&parse_monkey/1)
    |> Enum.reduce(%{}, fn monkey, acc -> Map.put(acc, monkey.id, monkey) end)
  end

  defp parse_monkey(chunk) do
    [id_line, items_line, op_line, test_line, true_line, false_line] = chunk

    dividend = parse_dividend(test_line)

    %Monkey{
      id: parse_id(id_line),
      items: parse_items(items_line),
      operation: parse_operation(op_line),
      test: fn n -> rem(n, dividend) == 0 end,
      dividend: dividend,
      true_target: parse_throw(true_line),
      false_target: parse_throw(false_line)
    }
  end

  defp parse_id(id_line) do
    [_, id, _] = String.split(id_line, [" ", ":"])
    String.to_integer(id)
  end

  defp parse_items(items_line) do
    [_, items] = String.split(items_line, ": ")

    String.split(items, ", ")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_operation(op_line) do
    [_, whole] = String.split(op_line, " = ")
    [left, op, right] = String.split(whole, [" "])

    construct_value_getter = fn str ->
      case str do
        "old" ->
          fn old -> old end

        _ ->
          n = String.to_integer(str)
          fn _ -> n end
      end
    end

    lefty = construct_value_getter.(left)
    righty = construct_value_getter.(right)

    case op do
      "*" -> fn old -> lefty.(old) * righty.(old) end
      "+" -> fn old -> lefty.(old) + righty.(old) end
    end
  end

  defp parse_dividend(test_line) do
    [_, dividend] = String.split(test_line, "by ")
    String.to_integer(dividend)
  end

  defp parse_throw(throw_line) do
    [_, id] = String.split(throw_line, "monkey ")
    String.to_integer(id)
  end
end

Solution.solve(:part1)
Solution.solve(:part2)
