package avborup.aoc2023.day08

import scala.io.Source.fromFile

object Day08 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day08.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  def part1(input: Input) = {
    input.stepsFrom("AAA").indexWhere(_ == "ZZZ")
  }

  // Observation: all paths in the input enters a cycle right from the get-go.
  // I.e. you reach a Z node every path-length'th step. Thus, the answer is the
  // least common multiple of the path lengths.
  //
  // Does not work for the general case where there are no cycles!
  def part2(input: Input) = {
    val lengths = input.nodes.keys
      .filter(_.endsWith("A"))
      .map(n => input.stepsFrom(n).indexWhere(_.endsWith("Z")).toLong)

    lengths.reduce(lcm)
  }
}

case class Input(instructions: String, nodes: Map[String, Node]) {
  def stepsFrom(from: String) = Iterator
    .unfold((from, 0))({ case (cur, i) =>
      val next = instructions(i % instructions.length) match {
        case 'L' => nodes(cur).left
        case 'R' => nodes(cur).right
      }

      Some((cur, (next, i + 1)))
    })
}

case class Node(name: String, left: String, right: String)

object Input {
  def parse(input: String) = {
    val lines = input.linesIterator.map(_.trim).toList
    val instructions = lines.head
    val nodes = lines
      .drop(2)
      .map(line => {
        val parts = raw"\w+".r.findAllIn(line).toList
        Node(parts(0), parts(1), parts(2))
      })
      .map(n => n.name -> n)
      .toMap

    Input(instructions, nodes)
  }
}

@annotation.tailrec
def gcd(a: Long, b: Long): Long = b match {
  case 0 => a
  case n => gcd(b, a % b)
}

def lcm(a: Long, b: Long): Long = (a * b).abs / gcd(a, b)
