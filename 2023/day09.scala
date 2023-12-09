package avborup.aoc2023.day09

import scala.io.Source.fromFile

object Day09 {
  def main(args: Array[String]) =
    val file = args.lift(0).getOrElse("inputs/day09.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(histories: List[Array[Int]]) =
    histories
      .map(_.levels.map(_.last).sum)
      .sum

  def part2(histories: List[Array[Int]]) =
    histories
      .map(_.levels.foldRight(0)(_.head - _))
      .sum
}

extension (sequence: Array[Int]) {
  def differences =
    sequence
      .sliding(2)
      .map({ case Array(a, b) => b - a })
      .toArray

  def levels = Seq.unfold(sequence)(s =>
    if s.forall(_ == 0) then None
    else Some((s, s.differences))
  )
}

object Input {
  def parse(input: String) =
    input.linesIterator
      .map(_.split(" ").map(_.toInt).toArray)
      .toList
}
