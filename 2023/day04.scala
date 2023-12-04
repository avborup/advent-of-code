import scala.io.Source.fromFile
import scala.collection.immutable.SortedMap

object Day04 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day04.txt")
    val input = fromFile(file).mkString.strip
    val cards = input.linesIterator.map(Card.parseCard).toList

    println(s"Part 1: ${part1(cards)}")
    println(s"Part 2: ${part2(cards)}")
  }

  def part1(cards: List[Card]) = {
    cards
      .map(_.numWinners match
        case 0 => 0
        case n => Math.pow(2, n - 1).toInt
      )
      .sum
  }

  def part2(cards: List[Card]) = {
    val copiesHeld = Map.from(cards.map(c => c.id -> 1).toMap)

    cards
      .foldLeft(copiesHeld) { (copiesHeld, card) =>
        val numCopies = copiesHeld.get(card.id).get
        (1 to card.numWinners).foldLeft(copiesHeld) { (acc, i) =>
          acc.updatedWith(card.id + i)(_.map(_ + numCopies))
        }
      }
      .values
      .sum
  }
}

case class Card(id: Int, winners: Set[Int], has: Set[Int], numWinners: Int = 0)

object Card {
  def parseCard(line: String) = {
    val parts = line.split(raw"[\|:]")
    val number = parts(0).trim().split(" +").last.toInt
    val winners = parts(1).trim().split(" +").map(_.toInt).toSet
    val has = parts(2).trim().split(" +").map(_.toInt).toSet
    val numWinners = winners.intersect(has).size
    Card(number, winners, has, numWinners)
  }
}
