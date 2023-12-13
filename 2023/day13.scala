package avborup.aoc2023.day13

object Day13 {
  def main(args: Array[String]) =
    val input = Input.read()

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Valley]) =
    input.map(_.reflections.head.score).sum

  def part2(input: List[Valley]) =
    input
      .map(valley => {
        val curReflection = valley.reflections.head

        val allCoords = (0 to valley.mirrors.size - 1).flatMap(r => {
          (0 to valley.mirrors(r).size - 1).map(c => {
            (r, c)
          })
        })

        val modifiedValleys = allCoords.toStream.map({ case (r, c) =>
          val cur = valley.mirrors(r)(c)
          val flipped = if cur == '#' then '.' else '#'

          valley.copy(
            mirrors =
              valley.mirrors.updated(r, valley.mirrors(r).updated(c, flipped))
          )
        })

        modifiedValleys
          .map(_.reflections)
          .map(_.find(_ != curReflection))
          .collectFirst({ case Some(r) => r.score })
          .get
      })
      .sum
}

case class Reflection(mult: Int, between: (Int, Int)) {
  def score = mult * between._1
}

case class Valley(mirrors: List[String]) {
  def reflections =
    val (rows, cols) = (mirrors, mirrors.transpose.map(_.mkString))

    findReflectionsIn(cols).map(Reflection(1, _)) ++ findReflectionsIn(rows)
      .map(Reflection(100, _))

  def findReflectionsIn(dimension: List[String]) =
    dimension.indices
      .sliding(2)
      .map({ case Seq(i, j) => (i, j) })
      .filter(pair => isReflection(dimension, pair))
      .map({ case (i, j) => (i + 1, j + 1) })
      .toList

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
