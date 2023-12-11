package avborup.aoc2023.day11

object Day11 {
  def main(args: Array[String]) =
    val file = args.lift(0).getOrElse("inputs/day11.txt")
    val input = scala.io.Source.fromFile(file).mkString

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: String) =
    Input.parse(input, 2).summedDistances

  def part2(input: String) =
    Input.parse(input, 1_000_000).summedDistances
}

extension (galaxies: List[Coord]) {
  def summedDistances =
    galaxies
      .combinations(2)
      .map { case List((r1, c1), (r2, c2)) =>
        Math.abs(r1 - r2) + Math.abs(c1 - c2)
      }
      .sum
}

type Coord = (Long, Long)

object Input {
  def parse(input: String, expansionSize: Int) =
    val rows = input.linesIterator.toList
    val cols = rows.transpose

    val emptyRows = rows.zipWithIndex.filter(_._1.forall(_ == '.')).map(_._2)
    val emptyCols = cols.zipWithIndex.filter(_._1.forall(_ == '.')).map(_._2)

    val (galaxies, _) = input.linesIterator.zipWithIndex
      .foldLeft((List[Coord](), 0)) { case ((galaxies, r), (line, i)) =>
        if emptyRows.contains(i) then (galaxies, r + expansionSize)
        else
          val (galaxiesAcc, _) = line.zipWithIndex.foldLeft((galaxies, 0)) {
            case ((galaxies, c), (symbol, j)) =>
              symbol match
                case _ if emptyCols.contains(j) => (galaxies, c + expansionSize)
                case '.'                        => (galaxies, c + 1)
                case s                          => ((r, c) :: galaxies, c + 1)
          }

          (galaxiesAcc, r + 1)
      }

    galaxies
}
