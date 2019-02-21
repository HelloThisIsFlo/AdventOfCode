#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR/../../elixir/solutions
mix run --no-halt ./lib/solution/day_6/visualization_server/start_server.exs > /dev/null &
ELIXIR_SERVER_PID=$!

cd $DIR
pipenv run python generate_gif.py
kill $ELIXIR_SERVER_PID

