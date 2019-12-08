import itertools
from abc import ABCMeta, abstractmethod
from pathlib import Path


class Day(metaclass=ABCMeta):
    def __init__(self, input_as_string: str):
        self.input: str = input_as_string

    def input_lines(self, parsing_func=None):
        lines = self.input.split()
        if parsing_func:
            lines = [parsing_func(l) for l in lines]
        return lines

    def to_output(self, list_):
        print(list_)
        return '\n'.join(str(val) for val in list_)

    @classmethod
    def from_problem_input_file(cls):
        def get_problem_input_file_name() -> str:
            class_name = cls.__name__
            problem_input_file_name = f'{class_name.lower()}.txt'
            return problem_input_file_name

        def read_file(file_name) -> str:
            file_path = Path('./inputs') / file_name
            with file_path.open('r') as file:
                return file.read()

        input_file_name = get_problem_input_file_name()
        input_as_string = read_file(input_file_name)
        return cls(input_as_string)

    @abstractmethod
    def solve_part_1(self):
        pass

    @abstractmethod
    def solve_part_2(self):
        pass
