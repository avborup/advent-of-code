package avborup.aoc2023.day12

object Day12 {
  def main(args: Array[String]) =
    val input = Input.read()

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Row]) =
    input.withNumberOfConfigs.sum

  def part2(input: List[Row]) =
    input
      .map(row =>
        row.copy(
          springs = List.fill(5)(row.springs).mkString("?"),
          groups = List.fill(5)(row.groups).flatten
        )
      )
      .withNumberOfConfigs
      .sum
}

extension (rows: List[Row]) {
  def withNumberOfConfigs =
    rows
      .foldLeft((List.empty[Long], Map.empty: Memo))({
        case ((acc, memo), row) =>
          val (res, updatedMemo) = row.cfgs(memo = memo)
          (res :: acc, updatedMemo)
      })
      ._1
}

type Memo = Map[(String, List[Int], Int), Long]

case class Row(springs: String, groups: List[Int]) {
  def cfgs(
      i: Int = 0,
      remaining: List[Int] = this.groups,
      curLength: Int = 0,
      memo: Memo = Map.empty
  ): (Long, Memo) =
    val memoKey = (springs.substring(i), remaining, curLength)

    if memo.contains(memoKey) then return (memo(memoKey), memo)

    if i == springs.length then
      remaining match
        case List(r) if r == curLength => return (1, memo)
        case Nil if curLength == 0     => return (1, memo)
        case _                         => return (0, memo)

    def memoized(res: (Long, Memo)) = (res._1, res._2 + (memoKey -> res._1))

    lazy val expandGroup = memoized {
      cfgs(i + 1, remaining, curLength + 1, memo)
    }
    lazy val nextGroup = memoized {
      cfgs(i + 1, remaining.tail, 0, memo)
    }
    lazy val skip = memoized {
      cfgs(i + 1, remaining, 0, memo)
    }
    lazy val expandOrSkip =
      val (r1, memo1) = expandGroup
      val (r2, memo2) = cfgs(i + 1, remaining, 0, memo1)
      memoized { (r1 + r2, memo2) }

    val groupIsFull = remaining.headOption.exists(_ == curLength)
    val invalid = (0L, memo)

    springs(i) match
      case '#' if groupIsFull                         => invalid
      case '#'                                        => expandGroup
      case '.' if groupIsFull                         => nextGroup
      case '.' if curLength == 0                      => skip
      case '.' if curLength > 0                       => invalid
      case '?' if groupIsFull                         => nextGroup
      case '?' if remaining.isEmpty && curLength > 0  => invalid
      case '?' if remaining.isEmpty && curLength == 0 => skip
      case '?' if curLength == 0                      => expandOrSkip
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
