package avborup.aoc2023.day07

import scala.io.Source.fromFile

object Day07 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day07.txt")
    val input = Input.parseHands(fromFile(file).mkString)

    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
  }

  def part1(hands: List[Hand]) = {
    val games = hands
      .sortWith((a, b) => {
        (a.kind, b.kind) match
          case (ak, bk) if ak == bk => a.beatsByFirstHighCard(b)
          case (ak, bk)             => ak > bk
      })
      .reverse

    games.zipWithIndex
      .map({ case (h, i) => h.winnings * (i + 1) })
      .sum
  }

  def part2(hands: List[Hand]) = {
    part1(hands.map(_.copy(useJokers = true)))
  }
}

case class Hand(cards: String, winnings: Int, useJokers: Boolean = false) {
  def kind =
    val hist = cards.groupBy(identity).view.mapValues(_.length).toMap
    val replaced =
      if useJokers then
        val max =
          hist.filter(_._1 != 'J').maxByOption(_._2).map(_._1).getOrElse('J')
        val jokers = hist.getOrElse('J', 0)
        (hist - 'J').updatedWith(max)(_.map(_ + jokers).orElse(Some(jokers)))
      else hist

    replaced.toList.map(_._2).sorted.reverse match {
      case 5 :: _      => 6
      case 4 :: _      => 5
      case 3 :: 2 :: _ => 4
      case 3 :: _      => 3
      case 2 :: 2 :: _ => 2
      case 2 :: _      => 1
      case _           => 0
    }

  def beatsByFirstHighCard(other: Hand) = {
    numeric
      .zip(other.numeric)
      .find({ case (a, b) => a != b })
      .map({ case (a, b) => a > b })
      .getOrElse(false)
  }

  def numeric = cards.map({
    case c if c.isDigit => c.asDigit
    case 'T'            => 10
    case 'J'            => if !useJokers then 11 else 1
    case 'Q'            => 12
    case 'K'            => 13
    case 'A'            => 14
  })
}

object Input {
  def parseHands(input: String) = {
    input.linesIterator
      .map(_.split(" "))
      .map({ case Array(h, w) => Hand(h, w.toInt) })
      .toList
  }
}
