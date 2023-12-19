package avborup.aoc2023.day19

object Day19 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    input.ratings
      .filter(ratings => input.runWorkflow("in", ratings) == "A")
      .flatMap(_.values)
      .sum

  def part2(input: Input) =
    ()
}

case class Input(
    workflows: Map[String, List[Condition]],
    ratings: List[Ratings]
) {
  def runWorkflow(name: String, ratings: Ratings): String =
    val next = workflows(name).toStream
      .filter(_.rule(ratings))
      .head
      .next

    next match {
      case n if n == "A" || n == "R" => n
      case _                         => runWorkflow(next, ratings)
    }
}

case class Condition(rule: Ratings => Boolean, next: String)
type Ratings = Map[String, Int]

object Input {
  def read() =
    val Array(workflowsStr, ratingsStr) =
      scala.io.Source.stdin.mkString.split("\n\n")

    val ratings = ratingsStr.linesIterator
      .map(line =>
        raw"(\w+)=(\d+)".r
          .findAllMatchIn(line)
          .map(m => m.group(1) -> m.group(2).toInt)
          .toMap
      )
      .toList

    val workflows = workflowsStr.linesIterator
      .map(line => {
        val Array(name, conditionsStr) = line.replace("}", "").split(raw"\{")
        val matches =
          raw"(\w+)(<|>)(\d+):(\w+)".r.findAllMatchIn(conditionsStr)
        val conditions = matches
          .map(m =>
            val (field, op, value, next) =
              (m.group(1), m.group(2), m.group(3), m.group(4))

            val pred: Ratings => Boolean = op match
              case "<" => ratings => ratings(field) < value.toInt
              case ">" => ratings => ratings(field) > value.toInt

            Condition(pred, next)
          )
          .toList

        val fallback = conditionsStr.split(",").last

        (name, conditions :+ Condition(_ => true, fallback))
      })
      .toMap

    Input(workflows, ratings)
}
