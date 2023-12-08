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
    input.steps.takeWhile(_ != "ZZZ").size
  }

  def part2(input: Input) = {
    ()
  }
}

case class Input(instructions: String, nodes: Map[String, Node]) {
  def steps = Iterator
    .unfold(("AAA", 0))({ case (cur, i) =>
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
