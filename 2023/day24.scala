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
    val h0 = input(0)
    val centered =
      input.map(h => h.copy(pos = h.pos - h0.pos, vel = h.vel - h0.vel))

    val h1 = centered(1)
    val normal = (h1.pos + h1.vel).cross(h1.pos)

    val (intersection2, d2) = line_plane_intersection(normal, centered(2))
    val (intersection3, d3) = line_plane_intersection(normal, centered(3))

    val dir = (intersection3 - intersection2) / (d3 - d2) + h0.vel
    val pos = intersection2 - ((dir - h0.vel) * d2) + h0.pos

    pos.x + pos.y + pos.z
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

  def time_from_pos(x: BigDecimal, y: BigDecimal) =
    (x - pos._1) / vel._1

type Vec = (BigDecimal, BigDecimal, BigDecimal)

extension (v: Vec)
  def x = v._1
  def y = v._2
  def z = v._3

  def +(other: Vec) =
    (v.x + other.x, v.y + other.y, v.z + other.z)

  def -(other: Vec) =
    (v.x - other.x, v.y - other.y, v.z - other.z)

  def *(scale: BigDecimal) =
    (v.x * scale, v.y * scale, v.z * scale)

  def /(div: BigDecimal) =
    (v.x / div, v.y / div, v.z / div)

  def cross(other: Vec) =
    (
      v.y * other.z - v.z * other.y,
      v.z * other.x - v.x * other.z,
      v.x * other.y - v.y * other.x
    )

  def dot(other: Vec) =
    v.x * other.x + v.y * other.y + v.z * other.z

def line_plane_intersection(
    normal: Vec,
    hail: Hail
) =
  val zero: Vec = (0, 0, 0)
  val d = (zero - hail.pos).dot(normal) / hail.vel.dot(normal)
  (hail.pos + (hail.vel * d), d)

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator.zipWithIndex
      .map({ case (line, i) =>
        val c = raw"-?\d+".r.findAllIn(line).map(BigDecimal(_)).toList
        Hail(i, (c(0), c(1), c(2)), (c(3), c(4), c(5)))
      })
      .toList

}
