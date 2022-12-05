defmodule Part1 do
  def solve() do
    stream = File.stream!("inputs/day05-input.txt") |> Stream.map(&String.trim_trailing/1)

    crate_lines =
      stream
      |> Stream.take_while(&(!contains_digit?(&1)))
      |> Enum.to_list()

    num_stacks = stream |> Enum.at(Enum.count(crate_lines)) |> String.split("   ") |> Enum.count()

    stacks = parse_stacks(crate_lines, num_stacks)

    stream
    |> Stream.drop(Enum.count(crate_lines) + 2)
    |> Stream.map(&parse_instruction/1)
    |> Enum.reduce(stacks, &execute_instruction/2)
    |> Enum.map(&List.first/1)
    |> Enum.join("")
    |> IO.puts()
  end

  def execute_instruction([amount, from, onto], stacks) do
    {from, onto} = {from - 1, onto - 1}

    {taken, remaining} = Enum.at(stacks, from) |> Enum.split(amount)

    stacks
    |> List.replace_at(from, remaining)
    |> List.replace_at(onto, Enum.reverse(taken) ++ Enum.at(stacks, onto))
  end

  def parse_stacks(crate_lines, num_stacks) do
    crate_lines
    |> Enum.map(&read_crate_line(&1, num_stacks))
    |> Enum.zip_with(&Enum.to_list/1)
    |> Enum.map(&clean_stack/1)
  end

  def read_crate_line(line, num_stacks) do
    0..(num_stacks - 1)
    |> Enum.map(&(1 + &1 * 4))
    |> Enum.map(&String.at(line, &1))
  end

  def parse_instruction(line) do
    parts = String.split(line)

    Enum.map([1, 3, 5], &Enum.at(parts, &1))
    |> Enum.map(&String.to_integer/1)
  end

  def clean_stack(stack) do
    Enum.filter(stack, &(&1 != " " && &1 != nil))
  end

  def contains_digit?(string) do
    Regex.match?(~r/\d/, string)
  end
end

Part1.solve()
