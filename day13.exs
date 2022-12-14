defmodule Part1 do
  def solve() do
    read_input()
    |> Stream.chunk_every(2)
    |> Stream.map(fn [left, right] -> {left, right} end)
    |> Stream.with_index(1)
    |> Stream.filter(fn {pair, _} -> compare(pair) == :valid end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.sum()
    |> IO.inspect()
  end

  def compare(pair) do
    case pair do
      {left, right} when is_integer(left) and is_integer(right) ->
        cond do
          left < right -> :valid
          left > right -> :invalid
          left == right -> :unsure
        end

      {left, right} when is_list(left) and is_list(right) ->
        compare_lists(left, right)

      {left, right} when is_integer(left) and is_list(right) ->
        compare({[left], right})

      {left, right} when is_list(left) and is_integer(right) ->
        compare({left, [right]})
    end
  end

  def compare_lists(left, right) do
    case {left, right} do
      {[], []} ->
        :unsure

      {[], [_ | _]} ->
        :valid

      {[_ | _], []} ->
        :invalid

      {[l_val | l_tail], [r_val | r_tail]} ->
        case compare({l_val, r_val}) do
          :unsure -> compare_lists(l_tail, r_tail)
          res -> res
        end
    end
  end

  def read_input() do
    File.stream!("inputs/day13-input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.reject(&(String.length(&1) == 0))
    |> Stream.map(&(Code.eval_string(&1) |> elem(0)))
  end
end

defmodule Part2 do
  def solve() do
    packets =
      Part1.read_input()
      |> Enum.to_list()

    distress_packets = [[[2]], [[6]]]

    (distress_packets ++ packets)
    |> Enum.sort(fn a, b -> Part1.compare({a, b}) == :valid end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _} -> packet in distress_packets end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.product()
    |> IO.inspect()
  end
end

Part1.solve()
Part2.solve()
