package avborup.aoc2023.day24

object Day24 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Hail]) =
    val (min, max) = (200000000000000L, 400000000000000L)

    input
      .combinations(2)
      .map({ case List(a, b) => a.intersection(b).map((a, b, _)) })
      .flatten
      .filter({ case (a, b, (x, y)) =>
        x >= min && x <= max && y >= min && y <= max
      })
      .filter({ case (a, b, (x, y)) =>
        a.time_from_pos(x, y) >= 0 && b.time_from_pos(x, y) >= 0
      })
      .size

  def part2(input: List[Hail]) =
    ()
}

case class Hail(id: Int, pos: Vec, vel: Vec):
  def intersection(other: Hail) =
    val ((x1, y1, _), (x2, y2, _)) = (pos, this.position(1))
    val ((x3, y3, _), (x4, y4, _)) = (other.pos, other.position(1))

    val x12 = (x1 - x2).toDouble;
    val x34 = (x3 - x4).toDouble;
    val y12 = (y1 - y2).toDouble;
    val y34 = (y3 - y4).toDouble;

    val c = x12 * y34 - y12 * x34;

    if (c.abs < 0.0001) then None
    else
      val a = x1 * y2 - y1 * x2;
      val b = x3 * y4 - y3 * x4;
      val x = (a * x34 - b * x12) / c;
      val y = (a * y34 - b * y12) / c;
      Some((x, y))

  def position(t: Long) =
    (pos._1 + vel._1 * t, pos._2 + vel._2 * t, pos._3 + vel._3 * t)

  def time_from_pos(x: Double, y: Double) =
    (x - pos._1) / vel._1

type Vec = (Long, Long, Long)
extension (v: Vec)
  def +(other: Vec) =
    (v._1 + other._1, v._2 + other._2, v._3 + other._3)

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator.zipWithIndex
      .map({ case (line, i) =>
        val c = raw"-?\d+".r.findAllIn(line).map(_.toLong).toList
        Hail(i, (c(0), c(1), c(2)), (c(3), c(4), c(5)))
      })
      .toList

}
