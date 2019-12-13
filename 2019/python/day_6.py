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

    @staticmethod
    def build_all_from_orbits(orbits):
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

        return set(planets_by_name.values())


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


class Day6(Day):
    def solve_part_1(self):
        def to_orbit(orbit_as_s):
            planets = orbit_as_s.split(')')
            return Orbit(planets[0], planets[1])

        orbits = self.input_lines(parsing_func=to_orbit)
        return str(orbit_count_checksum(orbits))

    def solve_part_2(self):
        pass
