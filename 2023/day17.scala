package avborup.aoc2023.day17

import collection.mutable.PriorityQueue
import collection.mutable.Map as MutableMap
import scala.collection.mutable.ArrayBuffer

object Day17 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    dijkstra(input.start, input.dest, input.adj(maxSteps = 3))

  def part2(input: Input) =
    dijkstra(input.start, input.dest, input.adj(minSteps = 4, maxSteps = 10))
}

type Coord = (Int, Int)
type Direction = (Int, Int)
type Vertex = (Coord, Direction, Int)

case class Input(grid: Array[Array[Int]], w: Int, h: Int) {
  def start = (0, 0)
  def dest = (h - 1, w - 1)

  def adj(minSteps: Int = 0, maxSteps: Int)(
      v: Vertex
  ): Iterable[(Vertex, Int)] =
    val (pos, dir, steps) = v
    val reachable = ArrayBuffer.empty[(Vertex, Int)]

    def addReachable(dir: Direction, newSteps: Int) =
      val (r, c) = dir + pos
      if r >= 0 && r < h && c >= 0 && c < w then
        reachable.addOne(((r, c), dir, newSteps), grid(r)(c))

    if steps < minSteps then
      addReachable(dir, steps + 1)
      return reachable

    if steps < maxSteps then addReachable(dir, steps + 1)
    addReachable(dir.cw, 1)
    addReachable(dir.ccw, 1)

    reachable
}

def dijkstra(
    s: Coord,
    t: Coord,
    adj: Vertex => IterableOnce[(Vertex, Int)]
): Int =
  val pq = PriorityQueue.empty[(Int, Vertex)](Ordering.by(-_._1))
  val dist = MutableMap.empty[Vertex, Int].withDefaultValue(Int.MaxValue)

  def add(v: Vertex, distance: Int) =
    if distance < dist(v) then
      dist.addOne(v, distance)
      pq.addOne((distance, v))

  add((s, (1, 0), 0), 0)
  add((s, (0, 1), 0), 0)

  while pq.nonEmpty do
    val (d, v) = pq.dequeue()
    if v._1 == t then return d
    else if d != dist(v) then ()
    else for (u, w) <- adj(v) do add(u, d + w)

  Int.MaxValue

extension (dir: Direction)
  def +(coord: Coord): Coord =
    (coord._1 + dir._1, coord._2 + dir._2)

  def cw = (dir._2, -dir._1)
  def ccw = (-dir._2, dir._1)

object Input {
  def read() =
    val grid = scala.io.Source.stdin.mkString.linesIterator
      .map(_.split("").map(_.toInt).toArray)
      .toArray
    Input(grid, grid(0).length, grid.length)
}
