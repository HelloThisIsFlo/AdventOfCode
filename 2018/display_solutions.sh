#!/bin/bash

pipenv install
pipenv run pytest test_run_solutions.py -s -q
