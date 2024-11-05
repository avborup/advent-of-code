defmodule Valve do
  defstruct name: nil, flow_rate: -1, leads_to: []
end

defmodule Graph do
  defstruct vertices: %{}, edges: %{}, distances: %{}

  def init_graph(valves) do
    vertices =
      Enum.reduce(valves, %{}, fn valve, map ->
        Map.put(map, valve.name, valve)
      end)

    edges =
      Enum.reduce(valves, %{}, fn valve, map ->
        Enum.reduce(valve.leads_to, map, fn other, map ->
          Map.put(map, {valve.name, other}, 1)
        end)
      end)

    %Graph{vertices: vertices, edges: edges}
  end

  # https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm
  def floyd_warshall(graph) do
    names = Enum.map(graph.vertices, fn {_, v} -> v.name end)
    cartesian_product = for i <- names, j <- names, k <- names, do: {i, j, k}

    inf = 1337

    distances =
      Enum.reduce(cartesian_product, graph.edges, fn {i, j, k}, distances ->
        Map.update(distances, {i, j}, inf, fn cur ->
          min(cur, Map.get(distances, {i, k}, inf) + Map.get(distances, {k, j}, inf))
        end)
      end)
      |> Enum.reject(fn {_, v} -> v == inf end)
      |> Map.new()

    %Graph{graph | distances: distances}
  end
end

defmodule Part1 do
  def solve() do
    valves = read_input()

    graph = Graph.init_graph(valves)

    graph
    |> Graph.floyd_warshall()
    |> IO.inspect()
  end

  def read_input() do
    File.stream!("inputs/day16-sample.txt")
    |> Stream.map(&read_line/1)
    |> Enum.to_list()
  end

  def read_line(line) do
    regex = ~r/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)\n/
    [_, name, flow_rate, leads_to] = Regex.run(regex, line)

    %Valve{
      name: name,
      flow_rate: String.to_integer(flow_rate),
      leads_to: String.split(leads_to, ", ")
    }
  end
end

Part1.solve()
