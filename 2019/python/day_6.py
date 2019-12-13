from base import Day
from typing import NamedTuple

PlanetName = str

# 'Thing' around which everything orbits, ie sun in the solar system
CENTER_OF_MASS = 'COM'


class Orbit(NamedTuple):
    orbited: PlanetName
    orbiting: PlanetName

    def __repr__(self):
        return f"'{self.orbited}){self.orbiting}'"


class Planet:
    @staticmethod
    def build_all_from_orbits(orbits):
        return set(Planet.build_all_from_orbits_by_name(orbits).values())

    @staticmethod
    def build_all_from_orbits_by_name(orbits):
        def validate_orbits():
            def has_duplicates(list_):
                return len(list_) != len(set(list_))

            planet_names = []
            for orbit in orbits:
                planet_names.append(orbit.orbiting)
            if has_duplicates(planet_names):
                raise ValueError('Make sure that no planet orbits 2 planets')

        validate_orbits()

        planets_by_name = {}
        planets_by_name['COM'] = Planet('COM', orbits_around=None)

        def build_and_save_planet(orbit):
            def find_orbit(planet_name, all_orbits):
                for orbit in all_orbits:
                    if orbit.orbiting == planet_name:
                        return orbit
                raise ValueError(f"Orbit for planet '{planet_name}' not found")

            def save(planet):
                planets_by_name[planet.name] = planet

            name = orbit.orbiting
            orbits_around_name = orbit.orbited

            if name in planets_by_name:
                return

            if orbits_around_name in planets_by_name:
                orbits_around = planets_by_name[orbits_around_name]
                save(Planet(name, orbits_around))
                return

            orbits_around_orbit = find_orbit(
                orbits_around_name,
                orbits
            )
            build_and_save_planet(orbits_around_orbit)
            build_and_save_planet(orbit)

        for orbit in orbits:
            build_and_save_planet(orbit)

        return planets_by_name

    def __init__(self, name: PlanetName, orbits_around: 'Planet'):
        self.name = name
        self.orbits_around = orbits_around

    def __repr__(self):
        key = self.__key()
        return f'Planet[{key[0]}){key[1]}]'

    def __key(self):
        if self.orbits_around:
            orbits_around_name = self.orbits_around.name
        else:
            orbits_around_name = None

        return (self.name, orbits_around_name)

    def __eq__(self, other):
        return (
            self.__class__ == other.__class__ and
            self.__key() == other.__key()
        )

    def __hash__(self):
        return hash(self.__key())

    def path_to_COM(self):
        if self.name == CENTER_OF_MASS or \
                self.orbits_around.name == CENTER_OF_MASS:
            return []

        path = self.orbits_around.path_to_COM()
        path.append(self.orbits_around)
        return path

        # return [self]


class IndirectOrbitsCounter:
    def __init__(self, orbits):
        self.planets = Planet.build_all_from_orbits(orbits)

    def count(self):
        def indirect_orbit_count(planet):
            if not planet.orbits_around:
                return 0
            if not planet.orbits_around.orbits_around:
                return 0

            return indirect_orbit_count(planet.orbits_around) + 1

        return sum(indirect_orbit_count(p) for p in self.planets)


def orbit_count_checksum(orbits):
    indirect_orbit_counter = IndirectOrbitsCounter(orbits)
    direct_orbit_count = len(orbits)  # Each orbit represents a direct orbit
    return direct_orbit_count + indirect_orbit_counter.count()


def min_orbital_transfers(orbits):
    def find_first_common_ancestor():
        common_ancestors = [p for p in my_path if p in santas_path]
        return common_ancestors[-1]

    def dist(planet, ancestor):
        if planet == ancestor:
            return 0
        return dist(planet.orbits_around, ancestor) + 1

    planets = Planet.build_all_from_orbits_by_name(orbits)

    me = planets['YOU']
    santa = planets['SAN']
    my_path = me.path_to_COM()
    santas_path = santa.path_to_COM()

    common_ancestor = find_first_common_ancestor()

    # -2 Because it isn't the distance between Santa and I that matter
    # but the distance between the planet santa is orbitting and the one
    # I am orbitting.
    # So that's 2 jumps less than between me and santa
    return dist(me, common_ancestor) + dist(santa, common_ancestor) - 2


class Day6(Day):
    def orbits(self):
        def to_orbit(orbit_as_s):
            planets = orbit_as_s.split(')')
            return Orbit(planets[0], planets[1])

        return self.input_lines(parsing_func=to_orbit)

    def solve_part_1(self):
        return str(orbit_count_checksum(self.orbits()))

    def solve_part_2(self):
        return str(min_orbital_transfers(self.orbits()))
