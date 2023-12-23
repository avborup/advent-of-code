package avborup.aoc2023.day21

import scala.collection.immutable.Queue

object Day21 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input.copy(part = 2))}")

  def part1(input: Input) =
    input.numberOfPossiblePlots(64)

  // The input has a diamond shape that repeats itself as we expand the map.
  // The number of possible plots is a quadratic function of the number of steps,
  // and we can extrapolate the function by using the points on the edge of the
  // diamond.
  def part2(input: Input) =
    val steps = List(
      (0.5 * input.width).toInt,
      (1.5 * input.width).toInt,
      (2.5 * input.width).toInt
    )

    println(s"steps: $steps")
    val List(y1, y2, y3) = steps.map(input.numberOfPossiblePlots)
    println(s"y1: $y1, y2: $y2, y3: $y3")

    val a = (y3 - (2 * y2) + y1) / 2
    val b = y2 - y1 - a
    val c = y1
    val predict = (x: Long) => a * x * x + b * x + c

    predict((26_501_365 - input.width / 2) / input.width)
}

type Coord = (Int, Int)
type Direction = (Int, Int)

extension (dir: Direction)
  def +(coord: Coord): Coord =
    (coord._1 + dir._1, coord._2 + dir._2)

case class Input(
    start: Coord,
    grid: Map[Coord, Char],
    width: Int,
    height: Int,
    part: Int = 1
) {
  def numberOfPossiblePlots(steps: Int) =
    val dists = List.unfold((Queue((start, 0)), Set.empty[Coord]))({
      case (queue, _) if queue.isEmpty         => None
      case (queue, _) if queue.head._2 > steps => None
      case (queue, visited) =>
        val ((pos, dist), tail) = queue.dequeue

        val adj = List((0, 1), (0, -1), (1, 0), (-1, 0))
          .map(_ + pos)
          .filterNot(visited.contains)
          .filter(isValidPos)

        val nextVisited = visited ++ adj
        val nextQueue = tail.enqueueAll(adj.map((_, dist + 1)))

        Some((dist, (nextQueue, nextVisited)))
    })

    dists
      .groupBy(identity)
      .collect({ case (dist, atDist) if dist % 2 == steps % 2 => atDist.size })
      .sum - ((steps + 1) % 2)

  def isValidPos(pos: Coord) =
    part match
      case 1 => grid.contains(pos) && grid(pos) != '#'
      case 2 => grid(translatePos(pos)) != '#'

  def translatePos(pos: Coord) =
    val (rOff, cOff) = (pos._1 % height, pos._2 % width)
    val r = if rOff < 0 then rOff + height else rOff
    val c = if cOff < 0 then cOff + width else cOff
    (r, c)
}

object Input {
  def read() =
    val str = scala.io.Source.stdin.mkString

    val width = str.linesIterator.next().length
    val height = str.linesIterator.length

    val grid = str.linesIterator.zipWithIndex
      .flatMap({ case (line, r) =>
        line.zipWithIndex.map({ case (char, c) => ((r, c), char) })
      })
      .toMap

    val start = grid.find({ case (_, char) => char == 'S' }).get._1

    Input(start, grid, width, height)
}
