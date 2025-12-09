from sys import stdin

def area(rect):
    (ax, ay), (bx, by) = rect
    return (1+abs(ax - bx)) * (1+abs(ay - by))

tiles = [tuple(map(int, line.strip().split(",")) ) for line in stdin];

print(tiles)

max_area = 0
rects = [(tiles[i], tiles[j]) for i in range(len(tiles)) for j in range(i + 1, len(tiles))]
rects.sort(key=area, reverse=True)

print("Part 1:", area(rects[0]))

edges = []
for i in range(-1, len(tiles)-1):
    (ax, ay), (bx, by) = tiles[i], tiles[i+1]
    edges.append(((ax, ay), (bx, by)))

def is_inside_polygon(point):
    x, y = point
    crossings = 0

    for (ax, ay), (bx, by) in edges:
        min_x, max_x = min(ax, bx), max(ax, bx)
        min_y, max_y = min(ay, by), max(ay, by)

        # Check if point is on EDGE of polygon
        if min_x <= x <= max_x and min_y <= y <= max_y:
            if ax == bx and x == ax:  # On vertical edge
                return True
            if ay == by and y == ay:  # On horizontal edge
                return True

        # Ray casting for vertical edges, if points are INSIDE polygon
        if ax == bx:
            if ax > x and min_y < y <= max_y:
                crossings += 1

    return crossings % 2 == 1

def segment_crosses_edge(side):
    (x1, y1), (x2, y2) = side
    for (ax, ay), (bx, by) in edges:
        if y1 == y2:  # Horizontal segment
            if ax == bx:  # Vertical edge
                seg_min_x, seg_max_x = min(x1, x2), max(x1, x2)
                edge_min_y, edge_max_y = min(ay, by), max(ay, by)
                # Crosses if edge is strictly between segment endpoints
                # and segment y is strictly within edge range
                if seg_min_x < ax < seg_max_x and edge_min_y < y1 < edge_max_y:
                    return True
        elif x1 == x2:
            if ay == by:  # Horizontal edge
                seg_min_y, seg_max_y = min(y1, y2), max(y1, y2)
                edge_min_x, edge_max_x = min(ax, bx), max(ax, bx)
                if seg_min_y < ay < seg_max_y and edge_min_x < x1 < edge_max_x:
                    return True

    return False

for (ax, ay), (bx, by) in rects:
    corners = [(ax, ay), (ax, by), (bx, ay), (bx, by)]

    if any(not is_inside_polygon(corner) for corner in corners):
        continue

    sides = [((ax, ay), (ax, by)), ((ax, by), (bx, by)),
             ((bx, by), (bx, ay)), ((bx, ay), (ax, ay))]

    if any(segment_crosses_edge(side) for side in sides):
        continue

    print("Part 2:", area(((ax, ay), (bx, by))))
    break
