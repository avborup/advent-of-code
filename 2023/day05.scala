package avborup.aoc2023.day05

import scala.io.Source.fromFile
import scala.collection.SortedMap

object Day05 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day05.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  val allCategories = List(
    "seed",
    "soil",
    "fertilizer",
    "water",
    "light",
    "temperature",
    "humidity",
    "location"
  )

  def part1(input: Input) = {
    input.seeds
      .map(seed =>
        allCategories
          .sliding(2)
          .foldLeft(seed) { case (value, List(from, to)) =>
            input.map(from, to, value)
          }
      )
      .min
  }

  def part2(input: Input) = {
    ()
  }
}

case class Input(
    seeds: List[Long],
    mappings: SortedMap[(String, String), List[Mapping]]
) {
  def map(from: String, to: String, value: Long) = {
    val category = mappings.get((from, to)).get
    category
      .find(m => m.sourceStart <= value && value < m.sourceStart + m.rangeSize)
      .map(m => m.destStart + value - m.sourceStart)
      .getOrElse(value)
  }
}

case class Mapping(sourceStart: Long, destStart: Long, rangeSize: Long)

object Input {
  def parse(input: String) = {
    val blocks = input.split("\n\n")
    val (seedsBlock, categoryBlocks) = (blocks.head, blocks.tail)

    val seeds = raw"\d+".r.findAllIn(seedsBlock).map(_.toLong).toList
    val categories = categoryBlocks
      .map { block =>
        val lines = block.split("\n")

        val m = raw"(\w+)-to-(\w+)".r.findFirstMatchIn(lines.head).get
        val (from, to) = (m.group(1), m.group(2))

        val entries = lines.tail
          .map(_.split(" ").map(_.toLong).toSeq)
          .map { case Seq(a, b, c) => Mapping(b, a, c) }
          .toList

        (from, to) -> entries
      }

    val mappings = SortedMap.from(categories)

    Input(seeds, mappings)
  }
}
