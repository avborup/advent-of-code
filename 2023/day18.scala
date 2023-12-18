package avborup.aoc2023.day18

import scala.collection.immutable.Queue
import io.AnsiColor._

object Day18 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: List[Instruction]) =
    val (path, colorized) = tracePath(input)
    visualize(path, colorized)
    val classified = classify(path, colorized)
    println()
    visualize(path, classified)

    (classified.filter(_._2 == 0).map(_._1) ++ path).size

  def part2(input: List[Instruction]) =
    ()
}

type Coord = (Int, Int)
type Direction = (Int, Int)
type Color = Int

def tracePath(instructions: List[Instruction]) =
  val initialState = (List((0, 0)), Set.empty[(Coord, Color)])
  val (path, colorized) = instructions
    .foldLeft(initialState)({ case (acc, instruction) =>
      val dir = instruction.dir.toDirVector
      val curPos = acc._1.head
      (0 to instruction.dist).foldLeft(acc)((acc, dist) =>
        val newPath = (curPos + (dir * dist)) :: acc._1
        val left = ((newPath.head + dir.ccw), 1)
        val right = ((newPath.head + dir.cw), 0)
        val newColorized = acc._2 + left + right
        (newPath, newColorized)
      )
    })

  val pathSet = path.toSet
  (path.reverse, colorized.filterNot({ case (pos, _) => pathSet.contains(pos) }))

def classify(path: List[Coord], colorized: Set[(Coord, Color)]) =
  val all = path ++ colorized.map(_._1)
  val (minX, maxX) = (all.map(_._1).min, all.map(_._1).max)
  val (minY, maxY) = (all.map(_._2).min, all.map(_._2).max)

  @annotation.tailrec
  def floodFill(
      queue: Queue[(Coord, Color)],
      visited: Set[Coord],
      colorized: Set[(Coord, Color)]
  ): Set[(Coord, Color)] =
    if queue.isEmpty then return colorized

    val ((pos, color), tail) = queue.dequeue

    val nextQueue = List((0, 1), (0, -1), (-1, 0), (1, 0))
      .map(d => (pos + d, color))
      .filterNot(a => visited.contains(a._1))
      .filterNot({ case ((x, y), _) =>
        x < minX || x > maxX || y < minY || y > maxY
      })
      .foldLeft(tail)((acc, next) => acc.enqueue(next))

    floodFill(nextQueue, visited + pos, colorized + ((pos, color)))

  floodFill(Queue.from(colorized), path.toSet ++ colorized.map(_._1), colorized)

def visualize(path: List[Coord], colorized: Set[(Coord, Color)]): Unit =
  val all = path ++ colorized.map(_._1)
  val (minX, maxX) = (all.map(_._1).min, all.map(_._1).max)
  val (minY, maxY) = (all.map(_._2).min, all.map(_._2).max)

  for y <- maxY to minY by -1 do
    for x <- minX to maxX do
      val coord = (x, y)
      print(coord match
        case c if path.contains(c)           => s"${BOLD}#${RESET}"
        case c if colorized.contains((c, 0)) => s"${RED}*${RESET}"
        case c if colorized.contains((c, 1)) => s"${BLUE}*${RESET}"
        case _                               => '.'
      )
    println()

extension (s: String)
  def toDirVector: Direction =
    s match
      case "U" => (0, 1)
      case "D" => (0, -1)
      case "L" => (-1, 0)
      case "R" => (1, 0)

extension (dir: Direction)
  def +(coord: Coord): Coord = (coord._1 + dir._1, coord._2 + dir._2)
  def *(scale: Int) = (dir._1 * scale, dir._2 * scale)
  def cw = (dir._2, -dir._1)
  def ccw = (-dir._2, dir._1)

case class Instruction(dir: String, dist: Int, color: String)

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator
      .map(line =>
        val m = raw"(\w) (\d+) \(#(\w+)\)".r.findFirstMatchIn(line).get
        Instruction(m.group(1), m.group(2).toInt, m.group(3))
      )
      .toList
}
