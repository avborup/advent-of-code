package aoc2023.day03.graph;

import scala.io.Source.fromFile

object Day03 {
  def main(args: Array[String]): Unit = {
    val file = args.lift(0).getOrElse("inputs/day03.txt")
    val input = fromFile(file).mkString.strip
    val schematic = Schematic.parse(input)

    println(s"Part 1: ${part1(schematic)}")
    println(s"Part 2: ${part2(schematic)}")
  }

  def part1(schematic: Schematic) = {
    schematic.vertices.values
      .filter(_.value.number.isDefined)
      .filter(_.adjacent.exists(schematic.get(_).value.symbol.isDefined))
      .flatMap(_.value.number)
      .sum
  }

  def part2(schematic: Schematic) = {
    schematic.vertices.values
      .filter(_.value.symbol == Some('*'))
      .map(_.adjacent.flatMap(schematic.get(_).value.number))
      .filter(_.size == 2)
      .map(_.product)
      .sum
  }
}

case class Vertex[A, V](id: A, value: V, adjacent: List[A])

case class Graph[A, V](vertices: Map[A, Vertex[A, V]]) {
  def addVertex(v: Vertex[A, V]): Graph[A, V] = {
    Graph(vertices.updatedWith(v.id) {
      case Some(old) => Some(v.copy(adjacent = old.adjacent ++ v.adjacent))
      case None      => Some(v)
    })
  }

  def get(id: A): Vertex[A, V] = vertices.get(id).get

  def pruneEmptyEdges(): Graph[A, V] = {
    Graph(vertices.map { case (id, v) =>
      (id, v.copy(adjacent = v.adjacent.filter(vertices.contains)))
    })
  }

  def makeUndirected(): Graph[A, V] = {
    val opposite = vertices.values
      .flatMap { v =>
        v.adjacent.map { adj =>
          Vertex(adj, vertices(adj).value, List(v.id))
        }
      }

    (vertices.values ++ opposite).toList
      .foldLeft(Graph.empty[A, V])(_.addVertex(_))
      .deduplicate()
  }

  def deduplicate(): Graph[A, V] = {
    Graph(vertices.map { case (id, v) =>
      (id, v.copy(adjacent = v.adjacent.distinct))
    })
  }
}

extension (graph: Graph[Coordinate, SchematicItem]) {
  def print() = {
    println("Graph:")
    graph.vertices.toList.sortBy(_._1).foreach { case (id, v) =>
      println(s"  $id ${v.value}:")
      v.adjacent.toList.sorted.foreach { adj =>
        println(s"    -> $adj ${graph.vertices.get(adj).map(_.value)}")
      }
    }
    graph
  }
}

object Graph {
  def empty[A, V]: Graph[A, V] = Graph(Map.empty)
}

type Coordinate = (Int, Int)

enum SchematicItem {
  case Number(value: Int)
  case Symbol(value: Char)
}

extension (s: SchematicItem) {
  def symbol = s match
    case SchematicItem.Number(_) => None
    case SchematicItem.Symbol(c) => Some(c)

  def number = s match
    case SchematicItem.Number(n) => Some(n)
    case SchematicItem.Symbol(_) => None
}

def adjacentCoordinates(coordinate: Coordinate): Set[Coordinate] = {
  val adj = (-1 to 1).flatMap { dx =>
    (-1 to 1).map { dy => (dy + coordinate._1, dx + coordinate._2) }
  }.toSet
  adj - coordinate
}

type Schematic = Graph[Coordinate, SchematicItem]

object Schematic {
  def parse(s: String): Schematic = {
    s.linesIterator.zipWithIndex
      .flatMap(parseLine)
      .foldLeft(Graph.empty[Coordinate, SchematicItem])(_.addVertex(_))
      .pruneEmptyEdges()
      .makeUndirected()
  }

  def parseLine(line: String, y: Int) = {
    def consumeDigits(seq: IndexedSeq[(Char, Int)], x: Int) = {
      seq.span(_._1.isDigit) match {
        case (digitChars, rest) =>
          val num = digitChars.map(_._1).mkString.toInt
          val indices = digitChars.map(_._2)
          val adjacent = indices.foldLeft(Set.empty[Coordinate]) { (adj, x) =>
            adj ++ adjacentCoordinates((y, x))
          } -- indices.map((y, _))

          val v =
            Vertex((y, x), SchematicItem.Number(num), adjacent.toList)

          (v, rest)
      }
    }

    def consumeSymbol(seq: IndexedSeq[(Char, Int)], x: Int) = {
      val adjacent = adjacentCoordinates((y, x))
      val v = Vertex((y, x), SchematicItem.Symbol(seq.head._1), adjacent.toList)
      (v, seq.tail)
    }

    Seq.unfold(line.zipWithIndex) { (withDots) =>
      val line = withDots.dropWhile(_._1 == '.')
      line.headOption.map { case (c, x) =>
        c match {
          case c if c.isDigit => consumeDigits(line, x)
          case c              => consumeSymbol(line, x)
        }
      }
    }
  }
}
