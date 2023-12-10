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
    val path = input.findPath(input.start)
    Math.ceil(path.size / 2.0).toInt

  def part2(input: Input) =
    val path = input.findPath(input.start)

    val enclosed = path
      .groupBy(_._2)
      .map({ case (col, coords) => input.findEnclosedInColumn(col, coords) })
      .flatMap(identity)
      .toSet

    // printMap(input, path, enclosed)

    enclosed.size
}

case class Input(map: Map[Coord, Char], start: Coord) {
  def findPath(start: Coord) =
    @annotation.tailrec
    def dfs(v: Coord, visited: Set[Coord], path: List[Coord]): List[Coord] =
      adjacent(v).filterNot(visited.contains).headOption match
        case Some(c) => dfs(c, visited + c, c :: path)
        case None    => path

    dfs(start, Set(start), List(start))

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

  def findEnclosedInColumn(col: Int, pathCoordinatesInColumn: List[Coord]) =
    def isConnected(p1: Coord, p2: Coord) =
      ((p1._1 + 1) to p2._1).forall(r => goesNorth((r, col), map))

    def flipsDirection(p1: Coord, p2: Coord) =
      def check(a: Coord, b: Coord) =
        goesWest(a, map) && goesEast(b, map)
      check(p1, p2) || check(p2, p1)

    def findBetween(p1: Coord, p2: Coord) =
      (p1._1 + 1 to p2._1 - 1).map((_, col))

    val edges = pathCoordinatesInColumn
      .sortBy(_._1)
      .filter(c => goesEast(c, map) || goesWest(c, map))

    edges
      .sliding(2)
      .foldLeft((Set[Coord](), true))({
        case ((found, isInside), List(p1, p2)) =>
          if isConnected(p1, p2) then
            if flipsDirection(p1, p2) then (found, isInside)
            else (found, !isInside)
          else if isInside then (found ++ findBetween(p1, p2), !isInside)
          else (found, !isInside)
      })
      ._1
}

type Coord = (Int, Int)

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
}

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

def printMap(input: Input, path: List[Coord], toHighlight: Set[Coord]) =
  val maxR = input.map.keys.map(_._1).max
  val minR = input.map.keys.map(_._1).min
  val maxC = input.map.keys.map(_._2).max
  val minC = input.map.keys.map(_._2).min

  def pipeFromChar(c: Char) =
    c match
      case '|' => '║'
      case '-' => '═'
      case 'L' => '╚'
      case 'J' => '╝'
      case '7' => '╗'
      case 'F' => '╔'
      case _   => ???

  (minR to maxR).foreach(r => {
    (minC to maxC).foreach(c => {
      val s =
        if path.contains((r, c)) then pipeFromChar(input.map((r, c)))
        else if toHighlight.contains((r, c)) then 'X'
        else ' '
      print(s)
    })
    println()
  })
