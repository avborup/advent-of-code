package avborup.aoc2023.day12

object Day12 {
  def main(args: Array[String]) =
    val input = Input.read()

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Row]) =
    input.map(_.numberOfConfigs).sum

  def part2(input: List[Row]) =
    input
      .map(row =>
        row.copy(
          springs = List.fill(5)(row.springs).mkString("?"),
          groups = List.fill(5)(row.groups).flatten
        )
      )
      .map(_.numberOfConfigs)
      .sum
}

case class Row(springs: String, groups: List[Int]) {
  def numberOfConfigs = cfgs((0, groups, 0))

  type Args = (Int, List[Int], Int)
  type Key = (String, List[Int], Int)

  val cfgs = Memoized[Args, Key, Long](
    key = args => (springs.substring(args._1), args._2, args._3),
    compute = args => cfgsInner.tupled(args)
  )

  def cfgsInner(i: Int, remaining: List[Int], curLength: Int): Long =
    if i == springs.length then
      remaining match
        case List(r) if r == curLength => return 1
        case Nil if curLength == 0     => return 1
        case _                         => return 0

    lazy val expandGroup = cfgs((i + 1, remaining, curLength + 1))
    lazy val nextGroup = cfgs((i + 1, remaining.tail, 0))
    lazy val skip = cfgs((i + 1, remaining, 0))

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

case class Memoized[A, K, V](
    var memo: Map[K, V] = Map.empty[K, V],
    key: A => K,
    compute: A => V
) {
  def apply(a: A): V =
    memo.get(key(a)) match
      case Some(v) => v
      case None =>
        val v = compute(a)
        memo = memo + (key(a) -> v)
        v
}
