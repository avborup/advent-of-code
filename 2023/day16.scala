package avborup.aoc2023.day16

import scala.collection.immutable.Queue

object Day16 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    input.energize().size

  def part2(input: Input) =
    val maxR = input.grid.keys.map(_._1).max
    val maxC = input.grid.keys.map(_._2).max

    val edgeTiles = input.grid.keys
      .filter({ case (r, c) => r == 0 || r == maxR || c == 0 || c == maxC })

    val configurations = edgeTiles.flatMap(tile =>
      List(tile -> (0, 1), tile -> (0, -1), tile -> (1, 0), tile -> (-1, 0))
    )

    configurations.map(config => input.energize(Queue(config)).size).max
}

type Coord = (Int, Int)
type Direction = (Int, Int)

case class Input(grid: Map[Coord, Char]) {
  @annotation.tailrec
  final def energize(
      queue: Queue[(Coord, Direction)] = Queue(((0, 0), (0, 1))),
      energized: Set[Coord] = Set.empty,
      visited: Set[(Coord, Direction)] = Set.empty
  ): Set[Coord] =
    if queue.isEmpty then return energized

    val ((pos, dir), tail) = queue.dequeue

    if visited.contains((pos, dir)) || !grid.contains(pos) then
      return energize(tail, energized, visited)

    val nextQueue = grid(pos) match
      case '.' => tail :+ ((pos + dir), dir)
      case '\\' =>
        val newDir = if dir.isVertical then dir.ccw else dir.cw
        tail :+ ((pos + newDir), newDir)
      case '/' =>
        val newDir = if dir.isVertical then dir.cw else dir.ccw
        tail :+ ((pos + newDir), newDir)
      case '|' =>
        if dir.isVertical then tail :+ ((pos + dir), dir)
        else tail :+ ((pos + dir.ccw), dir.ccw) :+ ((pos + dir.cw), dir.cw)
      case '-' =>
        if !dir.isVertical then tail :+ ((pos + dir), dir)
        else tail :+ ((pos + dir.ccw), dir.ccw) :+ ((pos + dir.cw), dir.cw)

    energize(nextQueue, energized + pos, visited + ((pos, dir)))
}

extension (dir: Direction)
  def +(coord: Coord): Coord =
    (coord._1 + dir._1, coord._2 + dir._2)

  def isVertical = dir._1 != 0
  def cw = (dir._2, -dir._1)
  def ccw = (-dir._2, dir._1)

object Input {
  def read() =
    val grid =
      scala.io.Source.stdin.mkString.linesIterator.zipWithIndex
        .flatMap({ case (line, r) =>
          line.zipWithIndex.map({ case (char, c) => ((r, c), char) })
        })
        .toMap

    Input(grid)
}
