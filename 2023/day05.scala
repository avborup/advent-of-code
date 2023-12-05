//> using dep org.scala-lang.modules::scala-parallel-collections:1.0.4

package avborup.aoc2023.day05

import scala.io.Source.fromFile
import scala.collection.parallel.CollectionConverters.*

object Day05 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day05.txt")
    val input = Input.parse(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  def part1(input: Input) = {
    input.seeds
      .map(input.mapAll)
      .min
  }

  def part2(input: Input) = {
    val seedRanges = input.seeds
      .grouped(2)
      .map { case List(a, b) => (a, b) }
      .toList

    val reversedInput = input.flip()

    def canFindSeedFor(location: Long) = {
      val seed = reversedInput.mapAll(location)
      seedRanges.exists { case (seedsStart, seedsSize) =>
        seedsStart <= seed && seed < seedsStart + seedsSize
      }
    }

    // The non-parallel version - runs in approx. 30 seconds:
    // Iterator
    //   .from(0)
    //   .find(canFindSeedFor)
    //   .get

    // Run in batches of 1 million numbers, checking those 1
    // million numbers in parallel before checking the next million.
    // Runs in approx. 7 seconds
    Iterator
      .unfold(0L)(start => {
        val stop = start + 1_000_000 - 1
        val res =
          (start to stop).toArray.par.map(canFindSeedFor).indexWhere(identity)
        val l = if res != -1 then Some(start + res) else None
        Some(l, stop + 1)
      })
      .find(_.isDefined)
      .get
      .get
  }
}

case class Input(
    seeds: List[Long],
    mappings: Map[(String, String), List[Mapping]],
    allMappings: List[(String, String)]
) {
  def map(value: Long, mapping: (String, String)) = {
    val category = mappings.get(mapping).get
    category
      .find(m => m.sourceStart <= value && value < m.sourceStart + m.rangeSize)
      .map(m => m.destStart + value - m.sourceStart)
      .getOrElse(value)
  }

  def mapAll(value: Long) = allMappings.foldLeft(value)(map)

  def flip() = {
    this.copy(
      mappings = mappings.map { case ((from, to), mappings) =>
        (to, from) -> mappings.map(m =>
          m.copy(destStart = m.sourceStart, sourceStart = m.destStart)
        )
      },
      allMappings = allMappings.map { case (from, to) => (to, from) }.reverse
    )
  }
}

case class Mapping(sourceStart: Long, destStart: Long, rangeSize: Long)

object Input {
  def parse(input: String) = {
    val blocks = input.split("\n\n")
    val (seedsBlock, categoryBlocks) = (blocks.head, blocks.tail)

    val seeds = raw"\d+".r.findAllIn(seedsBlock).map(_.toLong).toList
    val categories = categoryBlocks.map { block =>
      val lines = block.split("\n")

      val m = raw"(\w+)-to-(\w+)".r.findFirstMatchIn(lines.head).get
      val (from, to) = (m.group(1), m.group(2))

      val entries = lines.tail
        .map(_.split(" ").map(_.toLong).toSeq)
        .map { case Seq(a, b, c) => Mapping(b, a, c) }
        .toList

      (from, to) -> entries
    }

    val allMappings = categories
      .flatMap { case ((from, to), _) => List(from, to) }
      .toList
      .distinct
      .sliding(2)
      .map { case List(a, b) => (a, b) }
      .toList

    Input(seeds, categories.toMap, allMappings)
  }
}
