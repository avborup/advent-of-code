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
    val games = hands.map(toHand2).sortWith(_.beats(_)).reverse

    games.zipWithIndex
      .map({ case (h, i) => h.winnings * (i + 1) })
      .sum
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

def toHand2(h: Hand) = Hand2(h.cards, h.winnings)

case class Hand2(cards: String, winnings: Int) {
  def beats(other: Hand2) = {
    List(
      (c: Hand2) => c.nOfAKind(5),
      (c: Hand2) => c.nOfAKind(4),
      (c: Hand2) => c.fullHouse,
      (c: Hand2) => c.nOfAKind(3),
      (c: Hand2) => c.numPairs == 2,
      (c: Hand2) => c.numPairs == 1
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

  def nOfAKind(n: Int) =
    val hist = histogram
    hist
      .filter({
        case (c, i) if c != 'J' => n <= (i + hist.getOrElse('J', 0))
        case (c, i)             => n <= i
      })
      .headOption
      .isDefined

  def numPairs =
    val hist = histogram
    hist
      .foldLeft((0, hist.getOrElse('J', 0)))({ case ((np, js), (c, i)) =>
        if (i == 2) (np + 1, js)
        else if (c != 'J' && js > 0) (np + 1, js - 1)
        else (np, js)
      })
      ._1

  def numeric = cards.map(c =>
    if (c.isDigit) c.asDigit
    else
      c match {
        case 'T' => 10
        case 'J' => 1
        case 'Q' => 12
        case 'K' => 13
        case 'A' => 14
      }
  )

  def highCard = cards.zip(numeric).maxBy(_._2)._1

  def fullHouse = {
    val hist = histogram
    hist.keys.toList
      .combinations(2)
      .exists({ case List(a, b) =>
        (hist.getOrElse(a, 0), hist.getOrElse(b, 0)) match
          case (an, bn) if a == 'J'         => 5 - bn <= an
          case (an, bn) if b == 'J'         => 5 - an <= bn
          case (an, bn) if an > 3 || bn > 3 => false
          case (an, bn) => 5 - an - bn <= hist.getOrElse('J', 0)
      })
  }

  def beatsByFirstHighCard(other: Hand2) = {
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
