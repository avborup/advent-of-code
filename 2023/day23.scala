package avborup.aoc2023.day23

object Day23 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(map: Input) =
    map.longestPath

  def part2(map: Input) =
    map.compressed.longestPath
}

case class Graph(
    adj: Map[Vec, List[(Vec, Int)]],
    start: Vec,
    dest: Vec
) {
  def longestPath =
    var visited = Set.empty[Vec]

    def dfs(v: Vec, curLen: Int): Int =
      if v == dest then return curLen

      visited += v
      val longest =
        adj(v)
          .filterNot(a => visited.contains(a._1))
          .map(a => dfs(a._1, curLen + a._2))
          .maxOption
          .getOrElse(0)
      visited -= v
      longest

    dfs(start, 0)
}

case class Input(
    map: Map[Vec, Char],
    start: Vec,
    dest: Vec,
    width: Int,
    height: Int
) {
  def longestPath =
    val adjList = map
      .filter({ case (_, c) => c != '#' })
      .foldLeft(Map.empty[Vec, List[(Vec, Int)]])((acc, v) =>
        acc + (v._1 -> adjacent(v._1).map((_, 1)))
      )

    Graph(adjList, start, dest).longestPath

  def adjacent(v: Vec, ignoreSlopes: Boolean = false) =
    val dirs = map(v) match
      case v if v == '.' || ignoreSlopes =>
        List((-1, 0), (1, 0), (0, -1), (0, 1))
      case '^' => List((-1, 0))
      case 'v' => List((1, 0))
      case '<' => List((0, -1))
      case '>' => List((0, 1))

    dirs.map(v + _).filter(map.contains).filter(map(_) != '#')

  def compressed =
    var inDegree = scala.collection.mutable.Map[Vec, Int]()
    for r <- 0 to height - 1 do
      for c <- 0 to width - 1 do
        val v = (r, c)
        if map(v) != '#' then
          adjacent(v, ignoreSlopes = true).foreach(a =>
            inDegree(a) = inDegree.getOrElse(a, 0) + 1
          )

    def findNextIntersections(
        v: Vec,
        distToSource: Int,
        visited: Set[Vec]
    ): (List[(Vec, Int)], Set[Vec]) =
      val newVisited = visited + v
      adjacent(v, ignoreSlopes = true)
        .filterNot(visited.contains)
        .foldLeft((List.empty[(Vec, Int)], newVisited))((acc, a) =>
          if inDegree(a) != 2 then ((a, distToSource + 1) :: acc._1, acc._2)
          else
            val (found, visited) =
              findNextIntersections(a, distToSource + 1, acc._2)
            (found ::: acc._1, visited)
        )

    val intersections = inDegree
      .filter(_._2 != 2)
      .keys
    val adjList = intersections
      .foldLeft(Map.empty[Vec, List[(Vec, Int)]])((acc, v) =>
        val (found, _) = findNextIntersections(v, 0, Set.empty)
        acc + (v -> found)
      )

    Graph(adjList, start, dest)
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

    Input(grid, start, dest, width, height)
}

type Vec = (Int, Int)

extension (v: Vec)
  def +(other: Vec) =
    (v._1 + other._1, v._2 + other._2)
