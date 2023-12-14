package avborup.aoc2023.day14

import scala.collection.immutable.SortedMap

object Day14 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(rocks: Rocks) =
    rocks
      .tilt(Direction.North)
      .northLoad

  def part2(rocks: Rocks) =
    var seen = Map.empty[String, Int]
    var r = rocks
    val dirs =
      List(Direction.North, Direction.West, Direction.South, Direction.East)

    var i = 0
    while !seen.contains(r.visualize) do
      seen = seen.updated(r.visualize, i)
      for dir <- dirs do r = r.tilt(dir)
      i += 1

    val cycleLength = i - seen(r.visualize)
    val itersToPerform = 1_000_000_000
    val repetitions = (itersToPerform - i) / cycleLength
    val skippedTo = i + repetitions * cycleLength

    i = skippedTo
    while i < itersToPerform do
      for dir <- dirs do r = r.tilt(dir)
      i += 1

    r.northLoad
}

type Coord = (Int, Int)

enum Direction:
  case North, East, South, West

type Rocks = Array[Array[Char]]

extension (rocks: Rocks) {
  def tiltWest =
    rocks.map(row => {
      val (lastObstacle, round, newRow) = row.zipWithIndex
        .foldLeft((-1, 0, List.empty[Char]))({
          case ((lastObstacle, round, res), (char, col)) =>
            char match
              case '.' => (lastObstacle, round, res)
              case '#' =>
                (
                  col,
                  0,
                  '#' :: (List.fill(col - lastObstacle - 1 - round)('.') ++ res)
                )
              case 'O' => (lastObstacle, round + 1, 'O' :: res)
        })

      (List.fill(rocks.width - newRow.size)('.') ++ newRow).reverse.toArray
    })

  def width = rocks.size
  def height = rocks.head.size

  def tilt(direction: Direction) =
    val axes = direction match
      case Direction.North => rocks.transpose
      case Direction.East  => rocks.map(_.reverse)
      case Direction.South => rocks.transpose.map(_.reverse)
      case Direction.West  => rocks

    val tilted = axes.tiltWest

    direction match
      case Direction.North => tilted.transpose
      case Direction.East  => tilted.map(_.reverse)
      case Direction.South => tilted.map(_.reverse).transpose
      case Direction.West  => tilted

  def findRockLocations =
    for
      r <- 0 to rocks.height - 1
      c <- 0 to rocks.width - 1
      if rocks(r)(c) != '.'
    yield (r, c) -> rocks(r)(c)

  def northLoad =
    rocks.findRockLocations
      .filter(_._2 == 'O')
      .map({ case ((r, _), _) => rocks.height - r })
      .sum

  def visualize = rocks.map(_.mkString).mkString("\n")
}

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator
      .map(_.toCharArray)
      .toArray
}
