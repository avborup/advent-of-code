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
  // Function is symmetric across the middle peak at time/2
  def waysToBeat = (1L to time)
    .find(t => t * (time - t) > distance)
    .map(time - 2 * _ + 1)
    .get
}

object Race {
  def parseRaces(input: String) = {
    val rows =
      input.linesIterator.map(raw"\d+".r.findAllIn(_).map(_.toLong).toList)

    rows.next().zip(rows.next()).map({ case (t, d) => Race(t, d) })
  }
}
