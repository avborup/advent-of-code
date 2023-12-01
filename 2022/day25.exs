defmodule Part1 do
  def solve() do
    read_input()
    |> Stream.map(&snafu_to_decimal/1)
    |> Enum.sum()
    |> decimal_to_snafu()
    |> IO.puts()
  end

  def read_input() do
    File.stream!("inputs/day25-input.txt")
    |> Stream.map(&String.trim_trailing/1)
  end

  def snafu_to_decimal(str) do
    String.to_charlist(str)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, power}, result ->
      digit =
        case char do
          ?- -> -1
          ?= -> -2
          c when c in ?0..?9 -> c - ?0
        end

      result + digit * 5 ** power
    end)
  end

  def decimal_to_snafu(num, snafu \\ [])

  def decimal_to_snafu(0, snafu) do
    case snafu do
      [] -> '0'
      _ -> snafu
    end
  end

  def decimal_to_snafu(decimal, snafu) do
    remainder = rem(decimal, 5)

    digit =
      case remainder do
        4 -> ?-
        3 -> ?=
        c when c in 0..2 -> c + ?0
      end

    next = div(decimal, 5) + if remainder > 2, do: 1, else: 0

    decimal_to_snafu(next, [digit | snafu])
  end
end

Part1.solve()
