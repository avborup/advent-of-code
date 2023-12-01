import scala.io.Source.fromFile

object Day01 {
  def main(args: Array[String]): Unit = {
    val input = fromFile("inputs/day01.txt").mkString.strip

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  def part1(input: String): Int = {
    input.linesIterator
      .map(_.filter(_.isDigit).map(_ - '0'))
      .map(digits =>
        digits.headOption.getOrElse(0) * 10 + digits.lastOption.getOrElse(0)
      )
      .sum
  }

  def part2(input: String): Int = {
    input.linesIterator
      .map((line) => {
        (0 to line.length - 1).foldLeft((None: Option[Int], None: Option[Int]))(
          (acc, i) => {
            (
              acc._1.orElse(parseDigitFrom(line.substring(i))),
              acc._2.orElse(parseDigitFrom(line.substring(line.length - i - 1)))
            )
          }
        )
      })
      .map(digits => digits._1.getOrElse(0) * 10 + digits._2.getOrElse(0))
      .sum
  }

  def parseDigitFrom(s: String): Option[Int] = {
    val pairs = List(
      ("one", 1),
      ("two", 2),
      ("three", 3),
      ("four", 4),
      ("five", 5),
      ("six", 6),
      ("seven", 7),
      ("eight", 8),
      ("nine", 9),
      ("1", 1),
      ("2", 2),
      ("3", 3),
      ("4", 4),
      ("5", 5),
      ("6", 6),
      ("7", 7),
      ("8", 8),
      ("9", 9)
    )

    pairs.find((word, _) => s.startsWith(word)).map(_._2)
  }
}
