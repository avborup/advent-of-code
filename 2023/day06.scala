package avborup.aoc2023.day06

import scala.io.Source.fromFile

object Day06 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day06.txt")
    val input = Race.parseRaces(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  def part1(races: List[Race]) = {
    races.map(_.waysToBeat).product
  }

  def part2(races: List[Race]) = {
    val join = (nums: List[Long]) => nums.mkString.toLong
    val race = Race(join(races.map(_.time)), join(races.map(_.distance)))
    race.waysToBeat
  }
}

case class Race(time: Long, distance: Long) {
  def waysToBeat =
    val (x1, x2) = quadraticRoots(-1, time, -distance)
    val min = math.min(x1, x2) match
      case x if !x.isInt => math.ceil(x1).toLong
      case x             => x.toLong + 1

    time - 2 * min + 1
}

object Race {
  def parseRaces(input: String) = {
    val rows =
      input.linesIterator.map(raw"\d+".r.findAllIn(_).map(_.toLong).toList)

    rows.next().zip(rows.next()).map({ case (t, d) => Race(t, d) })
  }
}

// Assumes that two both roots exist
def quadraticRoots(a: Long, b: Long, c: Long) = {
  val d = b * b - 4 * a * c
  val x1 = (-b + math.sqrt(d)) / (2 * a)
  val x2 = (-b - math.sqrt(d)) / (2 * a)
  (x1, x2)
}

extension (f: Double) {
  def isInt = (f - f.round).abs < 1e-9
}
