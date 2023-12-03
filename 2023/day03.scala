import scala.io.Source.fromFile

object Day03 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day03.txt")
    val input = fromFile(file).mkString.strip
    val schematic = Schematic.parse(input)

    println(s"Part 1: ${part1(schematic)}")
    println(s"Part 2: ${part2(schematic)}")
  }

  def part1(schematic: Schematic) = {
    val partNumberKeys = schematic.entries.keys
      .filter(schematic.isDigitAt)
      .filter { case (y, x) =>
        schematic.adjacentTo(y, x).count(!_.isDigit) > 0
      }

    val partNumbers = partNumberKeys
      .foldLeft((Set.empty[(Int, Int)], List.empty[Int])) {
        case ((visited, nums), (y, x)) =>
          if visited.contains((y, x)) then (visited, nums)
          else
            (
              visited ++ schematic.keysForNumberAt(y, x),
              schematic.numberAt(y, x).get :: nums
            )
      }
      ._2

    partNumbers.sum
  }

  def part2(schematic: Schematic) = {
    ()
  }
}

case class Schematic(entries: Map[(Int, Int), Char], width: Int, height: Int) {
  def adjacentTo(y: Int, x: Int): Iterable[Char] =
    (-1 to 1)
      .flatMap { dx => (-1 to 1).map { dy => (x + dx, y + dy) } }
      .map {
        case (x, y) if x == 0 && y == 0 => None
        case (x, y)                     => entries.get((y, x))
      }
      .flatten

  def keysForNumberAt(y: Int, x: Int): Iterable[(Int, Int)] =
    (0 to x).reverse
      .takeWhile(isDigitAt(y, _))
      .lastOption
      .map(startIndex => {
        (startIndex to width)
          .takeWhile(isDigitAt(y, _))
          .map(x => (y, x))
      })
      .getOrElse(Nil)

  def isDigitAt(y: Int, x: Int) =
    entries.get((y, x)).exists(_.isDigit)

  def numberAt(y: Int, x: Int) =
    val s = keysForNumberAt(y, x)
      .map(entries.get)
      .flatten
      .mkString

    s.toIntOption
}

object Schematic {
  def parse(s: String): Schematic = {
    val map = s.linesIterator.zipWithIndex
      .flatMap { case (line, y) =>
        line.zipWithIndex.map { case (char, x) => (y, x) -> char }
      }
      .filter { case (_, char) => char != '.' }
      .toMap

    val width = map.keys.map(_._2).max
    val height = map.keys.map(_._1).max

    Schematic(map, width, height)
  }
}
