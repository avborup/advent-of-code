import scala.io.Source.fromFile

object Day02 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day02.txt")
    val input = fromFile(file).mkString.strip
    val games = Game.parseGames(input)

    println(s"Part 1: ${part1(games)}")
  }

  def part1(games: List[Game]): Int = {
    val maxPermitted = List(
      ("red", 12),
      ("green", 13),
      ("blue", 14)
    )

    games
      .filter((game) => {
        game.rounds
          .forall(round =>
            maxPermitted.forall((color, amount) =>
              round.getOrElse(color, 0) <= amount
            )
          )
      })
      .map(_.id)
      .sum
  }

  def part2(games: List[Game]): Int = {
    ???
  }
}

case class Game(id: Int, rounds: List[Map[String, Int]])

object Game {
  def parseGames(input: String): List[Game] = {
    input.linesIterator
      .map(parseGame)
      .toList
  }

  def parseGame(game: String): Game = {
    val (gamePart, roundsPart) =
      (game.split(":").toList: @unchecked) match {
        case a :: b :: Nil => (a, b)
      }

    val id = gamePart.split(" ").last.toInt
    val rounds = parseRounds(roundsPart)

    Game(id, rounds)
  }

  def parseRounds(rounds: String): List[Map[String, Int]] = {
    rounds.split(";").map(parseRound).toList
  }

  def parseRound(round: String): Map[String, Int] = {
    round
      .split(",")
      .map(_.trim)
      .map((group) => {
        val (amount, color) = group.split(" ").toSeq match {
          case Seq(amount, color, _ @_*) => (amount, color)
        }

        (color, amount.toInt)
      })
      .toMap
  }
}
