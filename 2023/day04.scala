import scala.io.Source.fromFile

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
      .map(card => card.winners.intersect(card.has))
      .map(heldWinners =>
        if heldWinners.isEmpty then 0
        else Math.pow(2, heldWinners.size - 1).toInt
      )
      .sum
  }

  def part2(cards: List[Card]) = {}
}

case class Card(id: Int, winners: Set[Int], has: Set[Int])

object Card {
  def parseCard(line: String) = {
    val parts = line.split(raw"[\|:]")
    val number = parts(0).trim().split(" +").last.toInt
    val winners = parts(1).trim().split(" +").map(_.toInt).toSet
    val has = parts(2).trim().split(" +").map(_.toInt).toSet
    Card(number, winners, has)
  }
}
