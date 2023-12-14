package avborup.aoc2023.day14

import scala.collection.immutable.SortedMap

object Day14 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    input.tiltNorth.rocks
      .filter(_._2 == 'O')
      .map({ case ((_, y), _) => input.height - y })
      .sum

  def part2(input: Input) =
    ()
}

type Coord = (Int, Int)

case class Input(rocks: SortedMap[Coord, Char], height: Int, width: Int) {
  def tiltNorth =
    val newLocations = (0 to width - 1).flatMap(x => {
      rocks
        .range((x, 0), (x, height))
        .foldLeft((-1, List.empty[(Coord, Char)]))({
          case ((lastObstacle, positions), ((rx, ry), char)) =>
            if char == '#' then (ry, (rx, ry) -> char :: positions)
            else (lastObstacle + 1, (rx, lastObstacle + 1) -> char :: positions)
        })
        ._2
    })

    this.copy(rocks = SortedMap(newLocations: _*))
}

object Input {
  def read() =
    val s = scala.io.Source.stdin.mkString
    val (height, width) = s.linesIterator.size -> s.linesIterator.next.size

    val rocks = s.linesIterator.zipWithIndex
      .flatMap { case (line, r) =>
        line.zipWithIndex.map { case (char, c) => (c, r) -> char }
      }
      .filter { case (_, char) => char != '.' }
      .toList

    Input(SortedMap(rocks: _*), height, width)
}
