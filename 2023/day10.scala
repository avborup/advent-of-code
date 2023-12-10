package avborup.aoc2023.day10

import scala.io.Source.fromFile
import scala.collection.immutable.Queue

object Day10 {
  def main(args: Array[String]) =
    val file = args.lift(0).getOrElse("inputs/day10.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    val initialQueue = Queue(input.start)
    val initialVisited = Set[Coord]()
    val initialDistances = Map[Coord, Int](input.start -> 0)

    val dists = Stream
      .unfold((initialQueue, initialVisited, initialDistances))({
        case (queue, _, _) if queue.isEmpty => None
        case (queue, visited, distances) =>
          val (coord, rest) = queue.dequeue
          val dist = distances(coord)
          val next = input
            .adjacent(coord)
            .filterNot(visited.contains)
            .foldLeft((rest, visited, distances)) { case ((q, v, d), c) =>
              (q.enqueue(c), v + c, d.updated(c, dist + 1))
            }

          Some((distances, next))
      })
      .last

    dists.values.max

  def part2(input: Input) =
    ()
}

type Coord = (Int, Int)
case class Input(map: Map[Coord, Char], start: Coord) {
  // Be aware, for a pipe setup like -L, the - will go to the L, even though
  // they're not actually connected.
  def adjacent(coord: Coord) =
    val coords = map.getOrElse(coord, '.') match
      case '|' => List(coord.north, coord.south)
      case '-' => List(coord.east, coord.west)
      case 'L' => List(coord.north, coord.east)
      case 'J' => List(coord.north, coord.west)
      case '7' => List(coord.south, coord.west)
      case 'F' => List(coord.south, coord.east)
      case _   => ???

    coords.filter(map.contains)
}

extension (coord: Coord) {
  def north = (coord._1 - 1, coord._2)
  def south = (coord._1 + 1, coord._2)
  def east = (coord._1, coord._2 + 1)
  def west = (coord._1, coord._2 - 1)
}

object Input {
  def parse(input: String) =
    val map = input.linesIterator.zipWithIndex.flatMap { case (line, r) =>
      line.toIterator.zipWithIndex.filter(_._1 != '.').map { case (symbol, c) =>
        (r, c) -> symbol
      }
    }.toMap

    val start = map.find(_._2 == 'S').map(_._1).get
    val startKind =
      if goesSouth(start.north, map) then
        if goesNorth(start.south, map) then '|'
        else if goesEast(start.west, map) then 'J'
        else if goesWest(start.east, map) then 'L'
        else ???
      else if goesNorth(start.south, map) then
        if goesEast(start.west, map) then '7'
        else if goesWest(start.east, map) then 'F'
        else ???
      else if goesEast(start.west, map) then '-'
      else if goesWest(start.east, map) then '-'
      else ???

    Input(map.updated(start, startKind), start)

  def goesSouth(coord: Coord, map: Map[Coord, Char]) =
    map.get(coord) match
      case Some('|' | '7' | 'F') => true
      case _                     => false

  def goesNorth(coord: Coord, map: Map[Coord, Char]) =
    map.get(coord) match
      case Some('|' | 'L' | 'J') => true
      case _                     => false

  def goesEast(coord: Coord, map: Map[Coord, Char]) =
    map.get(coord) match
      case Some('-' | 'F' | 'L') => true
      case _                     => false

  def goesWest(coord: Coord, map: Map[Coord, Char]) =
    map.get(coord) match
      case Some('-' | '7' | 'J') => true
      case _                     => false
}