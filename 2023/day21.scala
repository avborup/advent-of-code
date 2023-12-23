package avborup.aoc2023.day21

import scala.collection.immutable.Queue

object Day21 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    val MAX_STEPS = 64
    val dists = List.unfold((Queue((input.start, 0)), Set.empty[Coord]))({
      case (queue, _) if queue.isEmpty             => None
      case (queue, _) if queue.head._2 > MAX_STEPS => None
      case (queue, visited) =>
        val ((pos, dist), tail) = queue.dequeue

        val adj = List((0, 1), (0, -1), (1, 0), (-1, 0))
          .map(_ + pos)
          .filter(input.grid.contains)
          .filterNot(visited.contains)
          .filterNot(input.grid(_) == '#')

        val nextVisited = visited ++ adj
        val nextQueue = tail.enqueue(adj.map((_, dist + 1)))

        Some((dist, (nextQueue, nextVisited)))
    })

    dists
      .groupBy(identity)
      .collect({ case (dist, atDist) if dist % 2 == 0 => atDist.size })
      .sum - 1

  def part2(input: Input) =
    ()
}

type Coord = (Int, Int)
type Direction = (Int, Int)

extension (dir: Direction)
  def +(coord: Coord): Coord =
    (coord._1 + dir._1, coord._2 + dir._2)

case class Input(start: Coord, grid: Map[Coord, Char])

object Input {
  def read() =
    val grid =
      scala.io.Source.stdin.mkString.linesIterator.zipWithIndex
        .flatMap({ case (line, r) =>
          line.zipWithIndex.map({ case (char, c) => ((r, c), char) })
        })
        .toMap

    val start = grid.find({ case (_, char) => char == 'S' }).get._1

    Input(start, grid)
}
