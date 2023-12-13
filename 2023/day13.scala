package avborup.aoc2023.day13

object Day13 {
  def main(args: Array[String]) =
    val input = Input.read()

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Valley]) =
    input.map(_.score).sum

  def part2(input: List[Valley]) =
    ()
}

case class Valley(mirrors: List[String]) {
  def score =
    val rows = mirrors
    lazy val cols = mirrors.transpose.map(_.mkString)

    findReflectionIn(rows)
      .map(_._1 * 100)
      .orElse(findReflectionIn(cols).map(_._1))
      .get

  def findReflectionIn(dimension: List[String]) =
    dimension.indices
      .sliding(2)
      .map({ case Seq(i, j) => (i, j) })
      .find(pair => isReflection(dimension, pair))
      .map({ case (i, j) => (i + 1, j + 1) })

  def isReflection(lines: List[String], center: (Int, Int)) =
    val pairs = Iterator.unfold(center)({
      case (i, j) if i < 0 || j >= lines.size => None
      case (i, j)                             => Some(((i, j), (i - 1, j + 1)))
    })

    pairs.forall({ case (i, j) => lines(i) == lines(j) })
}

object Input {
  def read() =
    scala.io.Source.stdin.mkString
      .split("\n\n")
      .map(block => Valley(block.linesIterator.toList))
      .toList
}
