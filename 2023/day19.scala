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
    input
      .findAcceptedRanges()
      .map(_.values.map(range => range.max - range.min + 1).product)
      .sum
}

type Ratings = Map[String, Long]
type RatingRanges = Map[String, Range]
case class Range(min: Long, max: Long)

case class Input(
    workflows: Map[String, List[Rule]],
    ratings: List[Ratings]
) {
  def runWorkflow(name: String, ratings: Ratings): String =
    val next = workflows(name).toStream
      .filter(_.check(ratings))
      .head
      .next

    next match {
      case n if n == "A" || n == "R" => n
      case _                         => runWorkflow(next, ratings)
    }

  def findAcceptedRanges(
      workflow: String = "in",
      ranges: RatingRanges = Map(
        "x" -> Range(1, 4000),
        "m" -> Range(1, 4000),
        "a" -> Range(1, 4000),
        "s" -> Range(1, 4000)
      )
  ): List[RatingRanges] =
    if workflow == "R" then return List.empty
    if workflow == "A" then return List(ranges)

    workflows(workflow)
      .foldLeft((List.empty[RatingRanges], ranges))({
        case ((accepted, ranges), Rule.Fallback(next)) =>
          (findAcceptedRanges(next, ranges) ::: accepted, ranges)

        case ((accepted, ranges), Rule.Check(field, op, value, next)) =>
          val range = ranges(field)
          val (reducedRange, negation) = op match {
            case "<" => (range.copy(max = value - 1), range.copy(min = value))
            case ">" => (range.copy(min = value + 1), range.copy(max = value))
          }

          val updatedAccepted =
            if reducedRange.min <= reducedRange.max then
              findAcceptedRanges(
                next,
                ranges.updated(field, reducedRange)
              ) ::: accepted
            else accepted

          val updatedRanges =
            if negation.min <= negation.max then ranges.updated(field, negation)
            else ranges

          (updatedAccepted, updatedRanges)
      })
      ._1
}

enum Rule:
  case Fallback(next: String)
  case Check(field: String, op: String, value: Long, next: String)

extension (rule: Rule) {
  def check(ratings: Ratings): Boolean =
    rule match {
      case Rule.Fallback(_) => true
      case Rule.Check(field, op, value, _) =>
        op match {
          case "<" => ratings(field) < value
          case ">" => ratings(field) > value
        }
    }

  def next: String = rule match {
    case Rule.Fallback(next)       => next
    case Rule.Check(_, _, _, next) => next
  }
}

object Input {
  def read() =
    val Array(workflowsStr, ratingsStr) =
      scala.io.Source.stdin.mkString.split("\n\n")

    val ratings = ratingsStr.linesIterator
      .map(line =>
        raw"(\w+)=(\d+)".r
          .findAllMatchIn(line)
          .map(m => m.group(1) -> m.group(2).toLong)
          .toMap
      )
      .toList

    val workflows = workflowsStr.linesIterator
      .map(line => {
        val Array(name, conditionsStr) = line.replace("}", "").split(raw"\{")
        val matches = raw"(\w+)(<|>)(\d+):(\w+)".r.findAllMatchIn(conditionsStr)
        val conditions = matches
          .map(m =>
            Rule.Check(m.group(1), m.group(2), m.group(3).toLong, m.group(4))
          )
          .toList
        val fallback = conditionsStr.split(",").last

        (name, conditions :+ Rule.Fallback(fallback))
      })
      .toMap

    Input(workflows, ratings)
}
