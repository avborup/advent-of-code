package avborup.aoc2023.day15

import scala.collection.mutable.ListBuffer

object Day15 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(seq: List[String]) =
    seq.map(_.HASH).sum

  def part2(seq: List[String]) =
    var boxes = Array.fill(256)(ListBuffer[(String, Int)]())

    def add(label: String, i: Int) =
      val hash = label.HASH
      boxes(hash).map(_._1).indexOf(label) match
        case -1 => boxes(hash).append((label, i))
        case j  => boxes(hash).update(j, (label, i))

    def remove(label: String) =
      val hash = label.HASH
      boxes(hash).map(_._1).indexOf(label) match
        case -1 => ()
        case j  => boxes(hash).remove(j)

    seq.foreach({
      case op if op.contains("=") => {
        val Array(label, value) = op.split("=")
        add(label, value.toInt)
      }
      case op if op.contains("-") =>
        val Array(label) = op.split("-")
        remove(label)
    })

    boxes.zipWithIndex
      .flatMap({ case (box, boxNumber) =>
        box.zipWithIndex.map({ case ((label, l), i) =>
          (boxNumber + 1) * (i + 1) * l
        })
      })
      .sum
}

extension (s: String) {
  def HASH =
    s.foldLeft(0)((acc, cur) => (acc + cur.toInt) * 17 % 256)
}

object Input {
  def read() =
    scala.io.Source.stdin.mkString.trim().split(",").toList
}
