from base import Day


class Vector:
    def __init__(self, length):
        self.length = length

    def trace_path(self, origin):
        path = [origin]
        for step in range(1, self.length + 1):
            path.append(self.point_at_step(origin, step))

        return path

    def __eq__(self, other):
        return (self.__class__ == other.__class__
                and self.length == other.length)


class Up(Vector):
    def point_at_step(self, origin, step):
        (origin_x, origin_y) = origin
        return (origin_x, origin_y + step)


class Down(Vector):
    def point_at_step(self, origin, step):
        (origin_x, origin_y) = origin
        return (origin_x, origin_y - step)


class Left(Vector):
    def point_at_step(self, origin, step):
        (origin_x, origin_y) = origin
        return (origin_x - step, origin_y)


class Right(Vector):
    def point_at_step(self, origin, step):
        (origin_x, origin_y) = origin
        return (origin_x + step, origin_y)


def trace_path(origin, *vectors):
    path = [origin]

    for vector in vectors:
        last_point = path.pop()
        path += vector.trace_path(origin=last_point)

    return path


def intersection(list1, list2):
    return set(list1).intersection(list2)


def find_closest(origin, candidates):
    def is_better_candidate(current_closest, candidate):
        if candidate == origin:
            return False
        return manhattan_dist(origin, candidate) <= manhattan_dist(origin, current_closest)

    closest = candidates.pop()
    for candidate in candidates:
        if is_better_candidate(closest, candidate):
            closest = candidate

    return closest


def manhattan_dist(pt1, pt2):
    (pt1x, pt1y) = pt1
    (pt2x, pt2y) = pt2

    return abs(pt1x - pt2x) + abs(pt1y - pt2y)


class Day3(Day):
    origin = (0, 0)

    def solve_part_1(self):
        def parse_wire_vectors(vectors_as_string):
            vectors = []

            vectors_as_string = [
                v.strip() for v in vectors_as_string.split(',')
            ]
            for vector_as_s in vectors_as_string:
                direction = vector_as_s[0]
                length = int(vector_as_s[1::])
                if direction == 'U':
                    vectors.append(Up(length))
                elif direction == 'D':
                    vectors.append(Down(length))
                elif direction == 'R':
                    vectors.append(Right(length))
                elif direction == 'L':
                    vectors.append(Left(length))
                else:
                    raise ValueError()

            return vectors

        [wire1_vectors, wire2_vectors] = self.input_lines(
            parsing_func=parse_wire_vectors
        )

        wire1_path = trace_path(self.origin, *wire1_vectors)
        wire2_path = trace_path(self.origin, *wire2_vectors)

        intersection_pts = intersection(wire1_path, wire2_path)
        closest_intersection_pt = find_closest(self.origin, intersection_pts)

        return str(
            manhattan_dist(self.origin, closest_intersection_pt)
        )

    def solve_part_2(self):
        pass
