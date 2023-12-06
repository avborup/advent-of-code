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
    races
      .map(r => (0 to r.time).count(t => t * (r.time - t) > r.distance))
      .product
  }

  def part2(races: List[Race]) = {
    ()
  }
}

case class Race(time: Int, distance: Int)

object Race {
  def parseRaces(input: String) = {
    val rows =
      input.linesIterator.map(raw"\d+".r.findAllIn(_).map(_.toInt).toList)

    rows.next().zip(rows.next()).map({ case (t, d) => Race(t, d) })
  }
}
