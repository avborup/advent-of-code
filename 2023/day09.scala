package avborup.aoc2023.day09

import scala.io.Source.fromFile

object Day09 {
  def main(args: Array[String]) =
    val file = args.lift(0).getOrElse("inputs/day09.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    input.histories
      .map(h => {
        val sequences = Seq.unfold(h)(s => {
          if s.numbers.forall(_ == 0) then None
          else Some((s, s.differences))
        })

        sequences.map(_.numbers.last).sum
      })
      .sum

  def part2(input: Input) =
    ()
}

case class Sequence(numbers: Array[Int]) {
  def differences =
    Sequence(
      numbers
        .sliding(2)
        .map({ case Array(a, b) => b - a })
        .toArray
    )
}

case class Input(histories: List[Sequence])

object Input {
  def parse(input: String) =
    val histories =
      input.linesIterator
        .map(_.split(" ").map(_.toInt).toArray)
        .toList
        .map(Sequence(_))

    Input(histories)
}
