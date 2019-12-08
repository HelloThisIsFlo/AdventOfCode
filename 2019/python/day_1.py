from base import Day

from math import floor


def fuel_required_for_given_mass(mass):
    fuel = floor(mass / 3) - 2
    if fuel < 0:
        fuel = 0
    return fuel


class FuelCalc:
    def __init__(self, mass):
        self.mass_to_calculate_fuel_for = mass
        self.total_fuel = 0

    def total_fuel_required(self):
        while self.mass_to_calculate_fuel_for:
            fuel = fuel_required_for_given_mass(
                self.mass_to_calculate_fuel_for
            )

            self.mass_to_calculate_fuel_for = fuel
            self.total_fuel += fuel

        return self.total_fuel


def full_required_all_inclusive(mass):
    return FuelCalc(mass).total_fuel_required()


class Day1(Day):
    def solve_part_1(self):
        sum_of_fuel_requirement = sum(
            fuel_required_for_given_mass(mass) for mass in self.input_lines(int)
        )
        return str(sum_of_fuel_requirement)

    def solve_part_2(self):
        sum_of_fuel_requirement = sum(
            full_required_all_inclusive(mass) for mass in self.input_lines(int)
        )
        return str(sum_of_fuel_requirement)
