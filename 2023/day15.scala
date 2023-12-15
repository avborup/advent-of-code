package avborup.aoc2023.day15

object Day15 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(seq: List[String]) =
    seq.map(_.HASH).sum

  def part2(seq: List[String]) =
    ()
}

extension (s: String) {
  def HASH =
    s.foldLeft(0)((acc, cur) => (acc + cur.toInt) * 17 % 256)
}

object Input {
  def read() =
    scala.io.Source.stdin.mkString.trim().split(",").toList
}
