package avborup.aoc2023.day20

import scala.collection.immutable.Queue

import Pulse._
import Module._

object Day20 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(input: Input) =
    val (pulses, newInput) = pushButton(input)

    val (lows, highs, _) =
      (1 to 1000).foldLeft((0, 0, input))({ case ((lows, highs, input), _) =>
        val (pulses, newInput) = pushButton(input)
        val (newLows, newHighs) = pulses.foldLeft((lows, highs))({
          case ((lows, highs), (_, Low, _))  => (lows + 1, highs)
          case ((lows, highs), (_, High, _)) => (lows, highs + 1)
        })
        (newLows, newHighs, newInput)
      })

    lows * highs

  def part2(input: Input) =
    ()
}

def pushButton(input: Input) =
  val queue = Queue.from(input.broadcaster.map(("broadcaster", Low, _)))
  val continued = List
    .unfold((input, queue))({
      case (input, queue) if queue.isEmpty => None

      case (input, queue) if !input.modules.contains(queue.head._3) =>
        Some(((List.empty, input), (input, queue.tail)))

      case (input, queue) =>
        val ((from, pulse, to), queue2) = queue.dequeue

        val (newState, pulseToSend) = input.modules(to) match
          case FlipFlop(on) =>
            pulse match
              case High => (FlipFlop(on), None)
              case Low  => (FlipFlop(!on), Some(if !on then High else Low))
          case Conjunction(inputs) =>
            val newState = inputs.updated(from, pulse)
            val pulseToSend =
              if newState.values.forall(_ == High) then Low else High
            (Conjunction(newState), Some(pulseToSend))

        val newInput = input.copy(modules = input.modules.updated(to, newState))
        val pulses = pulseToSend
          .map(pulse => input.wires(to).map((to, pulse, _)))
          .toList
          .flatten

        Some(((pulses, newInput), (newInput, queue2 ++ Queue.from(pulses))))
    })

  val pulses = ("button", Low, "broadcaster") :: queue.toList ::: continued
    .map(_._1)
    .flatten
  val newInput = continued.last._2

  (pulses, newInput)

enum Module:
  case FlipFlop(on: Boolean = false)
  case Conjunction(inputs: Map[String, Pulse] = Map.empty)

enum Pulse:
  case Low
  case High

case class Input(
    broadcaster: List[String] = List.empty,
    modules: Map[String, Module] = Map.empty,
    wires: Map[String, List[String]] = Map.empty.withDefaultValue(List.empty)
) {
  def print() =
    println(s"broadcaster -> ${broadcaster.mkString(", ")}")
    modules.foreach((name, module) => {
      val sym = module match
        case FlipFlop(_)    => "%"
        case Conjunction(_) => "&"
      val outputs = wires(name).mkString(", ")
      println(s"$sym$name -> $outputs")
    })
    println()
}

object Input {
  def read() =
    val input = scala.io.Source.stdin.mkString.linesIterator
      .foldLeft(Input())((input, line) => {
        val Array(l, r) = line.split(" -> ")
        val outputs = r.split(", ").toList

        if l == "broadcaster" then input.copy(broadcaster = outputs)
        else
          val (name, module): (String, Module) = l(0) match
            case '%' => (l.substring(1), FlipFlop())
            case '&' => (l.substring(1), Conjunction())

          input.copy(
            modules = input.modules + (name -> module),
            wires = input.wires + (name -> outputs)
          )
      })

    val modulesWithConjunctionInputs =
      input.wires.foldLeft(input.modules)((modules, wires) => {
        val (module, outputs) = wires
        outputs.foldLeft(modules)((modules, output) => {
          modules.updatedWith(output)({
            case Some(Conjunction(inputs)) =>
              Some(Conjunction(inputs + (module -> Low)))
            case cur => cur
          })
        })
      })

    input.copy(modules = modulesWithConjunctionInputs)
}
