package avborup.aoc2023.day11

import scala.io.Source.fromFile

object Day11 {
  def main(args: Array[String]) =
    val file = args.lift(0).getOrElse("inputs/day11.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    input.galaxies.toList
      .combinations(2)
      .map { case List((r1, c1), (r2, c2)) =>
        Math.abs(r1 - r2) + Math.abs(c1 - c2)
      }
      .sum

  def part2(input: Input) =
    ()
}

case class Input(galaxies: Set[Coord])

type Coord = (Int, Int)

object Input {
  def parse(input: String) =
    val rows = input.linesIterator.toList
    val cols = rows.transpose

    val emptyRows = rows.zipWithIndex.filter(_._1.forall(_ == '.')).map(_._2)
    val emptyCols = cols.zipWithIndex.filter(_._1.forall(_ == '.')).map(_._2)

    val galaxies = input.linesIterator.zipWithIndex
      .foldLeft((Set[Coord](), 0)) { case ((galaxies, r), (line, i)) =>
        if emptyRows.contains(i) then (galaxies, r + 2)
        else
          val cols = line.zipWithIndex.foldLeft((galaxies, 0)) {
            case ((galaxies, c), (symbol, j)) =>
              symbol match
                case _ if emptyCols.contains(j) => (galaxies, c + 2)
                case '.'                        => (galaxies, c + 1)
                case s                          => (galaxies + ((r, c)), c + 1)
          }

          (cols._1, r + 1)
      }
      ._1

    Input(galaxies)
}
