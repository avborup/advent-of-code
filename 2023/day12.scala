package avborup.aoc2023.day12

object Day12 {
  def main(args: Array[String]) =
    val input = Input.read()

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Row]) =
    input.map(_.cfgs()).sum

  def part2(input: List[Row]) =
    ()
}

case class Row(springs: String, groups: List[Int]) {
  def cfgs(
      i: Int = 0,
      remaining: List[Int] = this.groups,
      curLength: Int = 0
  ): Int =
    if i == springs.length then
      remaining match
        case List(r) if r == curLength => return 1
        case Nil if curLength == 0     => return 1
        case _                         => return 0

    lazy val expandGroup = cfgs(i + 1, remaining, curLength + 1)
    lazy val nextGroup = cfgs(i + 1, remaining.tail, 0)
    lazy val skip = cfgs(i + 1, remaining, 0)

    val groupIsFull = remaining.headOption.exists(_ == curLength)

    springs(i) match
      case '#' if groupIsFull                         => 0
      case '#'                                        => expandGroup
      case '.' if groupIsFull                         => nextGroup
      case '.' if curLength == 0                      => skip
      case '.' if curLength > 0                       => 0
      case '?' if groupIsFull                         => nextGroup
      case '?' if remaining.isEmpty && curLength > 0  => 0
      case '?' if remaining.isEmpty && curLength == 0 => skip
      case '?' if curLength == 0                      => expandGroup + skip
      case '?' if curLength > 0                       => expandGroup
}

object Input {
  def read() =
    scala.io.Source.stdin
      .getLines()
      .map(line =>
        val parts = line.split(" ")
        val groups = parts(1).split(",").map(_.toInt).toList
        Row(parts(0), groups)
      )
      .toList
}
