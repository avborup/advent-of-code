package avborup.aoc2023.day18

object Day18 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Instruction]) =
    val path = tracePath(input)

    // Pick's theorem: https://en.wikipedia.org/wiki/Pick%27s_theorem
    val interior = shoelace(path).toLong
    val boundary = perimeter(path)
    interior + boundary / 2 + 1

  def part2(input: List[Instruction]) =
    val corrected = input.map(_.useHexadecimalInstruction)
    part1(corrected)
}

type Coord = (Long, Long)
type Direction = (Long, Long)

def tracePath(instructions: List[Instruction]): List[Coord] =
  instructions
    .foldLeft(List((0L, 0L)))({ case (acc, instruction) =>
      val dv = instruction.dir * instruction.dist
      (acc.head + dv) :: acc
    })
    .reverse

// From https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area
def shoelace(points: List[Coord]) =
  val xx = points.map(p => p._1)
  val yy = points.map(p => p._2)
  val overlace = xx zip yy.drop(1) ++ yy.take(1)
  val underlace = yy zip xx.drop(1) ++ xx.take(1)

  val over = overlace.map(t => t._1 * t._2).sum
  val under = underlace.map(t => t._1 * t._2).sum
  (over - under).abs / 2.0

def perimeter(path: List[Coord]) =
  path
    .sliding(2)
    .map({ case List((x1, y1), (x2, y2)) =>
      (x2 - x1).abs + (y2 - y1).abs
    })
    .sum

extension (dir: Direction)
  def +(coord: Coord): Coord = (coord._1 + dir._1, coord._2 + dir._2)
  def *(scale: Long) = (dir._1 * scale, dir._2 * scale)

case class Instruction(dir: Direction, dist: Long, color: String) {
  def useHexadecimalInstruction =
    val (distStr, dirStr) = color.splitAt(color.length - 1)
    Instruction(dirStr.toDirVector, Integer.parseInt(distStr, 16), color)
}

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator
      .map(line =>
        val m = raw"(\w) (\d+) \(#(\w+)\)".r.findFirstMatchIn(line).get
        Instruction(m.group(1).toDirVector, m.group(2).toInt, m.group(3))
      )
      .toList
}

extension (s: String)
  def toDirVector: Direction =
    s match
      case "U" | "3" => (0, 1)
      case "D" | "1" => (0, -1)
      case "L" | "2" => (-1, 0)
      case "R" | "0" => (1, 0)
