#!/usr/bin/env python
import sys
from os import path

from computer import Program


# HARD_CODED_INTCODE = '3,0,4,0,99'
HARD_CODED_INTCODE = '3,11,3,12,1,11,12,13,4,13,99'


def intcode_passed_as_argv():
    return len(sys.argv) >= 2


def get_from_argv():
    def is_file():
        return path.exists(intcode_arg)

    def read_from_file():
        intcode_file_path = intcode_arg
        with open(intcode_file_path) as f:
            return f.readline()

    intcode_arg = sys.argv[1]
    if is_file():
        return read_from_file()
    else:
        return intcode_arg


def get_intcode():
    if intcode_passed_as_argv():
        intcode_str = get_from_argv()
    else:
        intcode_str = HARD_CODED_INTCODE

    return [int(num) for num in intcode_str.split(',')]


Program(get_intcode()).run(interactive_mode=True)
