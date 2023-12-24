package avborup.aoc2023.day23

object Day23 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(map: Input) =
    map.longestPath

  def part2(map: Input) =
    ()
}

case class Input(
    map: Map[Vec, Char],
    start: Vec,
    dest: Vec
) {
  def longestPath =
    var visited = Set.empty[Vec]

    def dfs(v: Vec, curLen: Int): Int =
      if v == dest then return curLen

      visited += v
      val longest =
        adjacent(v)
          .filterNot(visited.contains)
          .map(dfs(_, curLen + 1))
          .maxOption
          .getOrElse(0)
      visited -= v
      longest

    dfs(start, 0)

  def adjacent(v: Vec) =
    val dirs = map(v) match
      case '.' => List((-1, 0), (1, 0), (0, -1), (0, 1))
      case '^' => List((-1, 0))
      case 'v' => List((1, 0))
      case '<' => List((0, -1))
      case '>' => List((0, 1))

    dirs.map(v + _).filter(map.contains).filter(map(_) != '#')
}

object Input {
  def read() =
    val str = scala.io.Source.stdin.mkString

    val width = str.linesIterator.next().length
    val height = str.linesIterator.length

    val grid = str.linesIterator.zipWithIndex
      .flatMap({ case (line, r) =>
        line.zipWithIndex.map({ case (char, c) => ((r, c), char) })
      })
      .toMap

    val List(start, dest) = grid
      .filter({ case (v, _) =>
        v._1 == 0 || v._1 == height - 1 || v._2 == 0 || v._2 == width - 1
      })
      .filter({ case (_, c) => c == '.' })
      .keys
      .toList
      .sorted

    Input(grid, start, dest)
}

type Vec = (Int, Int)

extension (v: Vec)
  def +(other: Vec) =
    (v._1 + other._1, v._2 + other._2)
