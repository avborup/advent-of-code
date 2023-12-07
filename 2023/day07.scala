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
    val games = hands.sortWith(_.beats(_)).reverse

    games.zipWithIndex
      .map({ case (h, i) => h.winnings * (i + 1) })
      .sum
  }

  def part2(hands: List[Hand]) = {
    ()
  }
}

case class Hand(cards: String, winnings: Int) {
  def beats(other: Hand) = {
    List(
      (c: Hand) => c.nOfAKind(5),
      (c: Hand) => c.nOfAKind(4),
      (c: Hand) => c.fullHouse,
      (c: Hand) => c.nOfAKind(3),
      (c: Hand) => c.numPairs == 2,
      (c: Hand) => c.numPairs == 1
    )
      .foldLeft(None: Option[Boolean])((acc, f) =>
        acc.orElse(
          (f(this), f(other)) match
            case (true, false)  => Some(true)
            case (false, true)  => Some(false)
            case (true, true)   => Some(beatsByFirstHighCard(other))
            case (false, false) => None
        )
      )
      .getOrElse(beatsByFirstHighCard(other))
  }

  def histogram = cards.groupBy(identity).mapValues(_.length)

  def nOfAKind(n: Int) = histogram.filter(_._2 == n).keys.headOption.isDefined

  def numPairs = histogram.filter(_._2 == 2).keys.size

  def numeric = cards.map(c =>
    if (c.isDigit) c.asDigit
    else
      c match {
        case 'T' => 10
        case 'J' => 11
        case 'Q' => 12
        case 'K' => 13
        case 'A' => 14
      }
  )

  def highCard = cards.zip(numeric).maxBy(_._2)._1

  def fullHouse = {
    histogram.filter(e => e._2 == 2 || e._2 == 3).toList match {
      case List((ac, 3), (bc, 2)) => true
      case List((ac, 2), (bc, 3)) => true
      case _                      => false
    }
  }

  def beatsByFirstHighCard(other: Hand) = {
    numeric
      .zip(other.numeric)
      .find({ case (a, b) => a != b })
      .map({ case (a, b) => a > b })
      .getOrElse(false)
  }
}

object Input {
  def parseHands(input: String) = {
    input.linesIterator
      .map(_.split(" "))
      .map({ case Array(h, w) => Hand(h, w.toInt) })
      .toList
  }
}
