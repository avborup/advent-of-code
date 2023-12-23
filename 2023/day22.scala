package avborup.aoc2023.day22

object Day22 {
  def main(args: Array[String]) =
    val input = Input.read()
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")

  def part1(bricks: List[Brick]) =
    val stack = buildBrickStack(bricks)

    bricks.count(brick =>
      val willNotLetAnythingFall = stack
        .supports(brick.id)
        .forall(s => stack.supportedBy(s).exists(id => id != brick.id))

      willNotLetAnythingFall || stack.supports(brick.id).isEmpty
    )

  def part2(bricks: List[Brick]) =
    val stack = buildBrickStack(bricks)

    def dfs(
        cur: Int,
        disintegrated: Set[Int],
        visited: Set[Int]
    ): (Set[Int], Set[Int]) =
      if visited.contains(cur) then return (disintegrated, visited)

      val toDisintegrate = stack
        .supports(cur)
        .filter(id =>
          stack.supportedBy(id).forall(id => disintegrated.contains(id))
        )

      toDisintegrate.foldLeft((disintegrated ++ toDisintegrate, visited + cur))(
        (acc, cur) => dfs(cur, acc._1, acc._2)
      )

    def disintegrate(v: Int) = dfs(v, disintegrated = Set(v), Set.empty)._1 - v

    bricks.map(b => disintegrate(b.id).size).sum
}

def buildBrickStack(input: List[Brick]) =
  val bricks = input.sortBy(_.min.z)
  bricks.foldLeft(BrickStack())(_.place(_))

case class BrickStack(
    zHeights: Map[(Int, Int), Int] = Map.empty.withDefaultValue(0),
    currentColumnSupport: Map[(Int, Int), Int] = Map.empty,
    supportedBy: Map[Int, Set[Int]] = Map.empty.withDefaultValue(Set.empty),
    supports: Map[Int, Set[Int]] = Map.empty.withDefaultValue(Set.empty)
):
  def place(brick: Brick) =
    val baseCoords = allBaseCoords(brick)
    val height = baseCoords.map(zHeights).max
    val fallenBrick = brick.copy(
      min = brick.min.copy(z = height + 1),
      max = brick.max.copy(z = height + 1 + brick.max.z - brick.min.z)
    )

    val supportingBricks = baseCoords
      .filter(zHeights(_) == height)
      .map(currentColumnSupport.get(_))
      .flatten
      .toSet

    this.copy(
      zHeights = zHeights ++ baseCoords.map(_ -> fallenBrick.max.z).toMap,
      currentColumnSupport =
        currentColumnSupport ++ baseCoords.map(_ -> fallenBrick.id).toMap,
      supportedBy = supportedBy + (fallenBrick.id -> supportingBricks),
      supports = supports ++ (supportingBricks.map(id =>
        id -> (supports(id) + fallenBrick.id)
      ))
    )

  def allBaseCoords(brick: Brick) =
    for
      x <- brick.min.x to brick.max.x
      y <- brick.min.y to brick.max.y
    yield (x, y)

case class Coord(x: Int, y: Int, z: Int)
case class Brick(id: Int, min: Coord, max: Coord):
  def apply(from: Coord, to: Coord, id: Int) =
    Brick(
      id,
      Coord(
        math.min(from.x, to.x),
        math.min(from.y, to.y),
        math.min(from.z, to.z)
      ),
      Coord(
        math.max(from.x, to.x),
        math.max(from.y, to.y),
        math.max(from.z, to.z)
      )
    )

object Input {
  def read() =
    scala.io.Source.stdin.mkString.linesIterator.zipWithIndex
      .map({ case (line, i) =>
        val c = raw"\d+".r.findAllIn(line).map(_.toInt).toList
        Brick(i, Coord(c(0), c(1), c(2)), Coord(c(3), c(4), c(5)))
      })
      .toList
}
