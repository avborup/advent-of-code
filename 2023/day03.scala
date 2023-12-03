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
        schematic.adjacentTo(y, x).count(k => !schematic.isDigitAt(k)) > 0
      }

    schematic.getNumbersAtKeys(partNumberKeys).sum
  }

  def part2(schematic: Schematic) = {
    val gearRatios = schematic.entries.toSeq
      .filter(_._2 == '*')
      .map { case ((y, x), _) =>
        val partNumberKeys = schematic
          .adjacentTo(y, x)
          .filter(schematic.isDigitAt)

        schematic.getNumbersAtKeys(partNumberKeys) match
          case a :: b :: Nil => a * b
          case _             => 0
      }

    gearRatios.sum
  }
}

type Coordinate = (Int, Int)

extension (c: Coordinate) {
  def y = c._1
  def x = c._2
}

case class Schematic(entries: Map[Coordinate, Char], width: Int, height: Int) {
  def adjacentTo(y: Int, x: Int): Iterable[Coordinate] =
    (-1 to 1)
      .flatMap { dx => (-1 to 1).map { dy => (dy + y, dx + x) } }
      .filter { case (ny, nx) => !(nx == x && ny == y) }
      .filter { case (ny, nx) => entries.contains((ny, nx)) }

  def keysForNumberAt(k: Coordinate): Iterable[Coordinate] =
    (0 to k.x).reverse
      .takeWhile(isDigitAt(k.y, _))
      .lastOption
      .map(startIndex => {
        (startIndex to width)
          .takeWhile(isDigitAt(k.y, _))
          .map(x => (k.y, x))
      })
      .getOrElse(Nil)

  def isDigitAt(key: Coordinate) =
    entries.get(key).exists(_.isDigit)

  def numberAt(y: Int, x: Int) =
    keysForNumberAt(y, x)
      .map(entries.get)
      .flatten
      .mkString
      .toIntOption

  def getNumbersAtKeys(keys: Iterable[Coordinate]) =
    keys
      .foldLeft((Set.empty[Coordinate], List.empty[Int])) {
        case ((visited, nums), (y, x)) =>
          if visited.contains((y, x)) then (visited, nums)
          else
            (
              visited ++ keysForNumberAt(y, x),
              numberAt(y, x).get :: nums
            )
      }
      ._2
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
