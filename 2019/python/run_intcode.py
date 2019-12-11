#!/usr/bin/env python
import sys

from computer import Program


# HARD_CODED_INTCODE = '3,0,4,0,99'
HARD_CODED_INTCODE = '3,11,3,12,1,11,12,13,4,13,99'


def get_intcode():
    if len(sys.argv) >= 2:
        intcode_str = sys.argv[1]
    else:
        intcode_str = HARD_CODED_INTCODE

    return [int(num) for num in intcode_str.split(',')]


Program(get_intcode()).run()
