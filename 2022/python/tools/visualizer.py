import random
import string
from pathlib import Path

from graphviz import Digraph, Graph

DIR_PATH = Path(__file__).resolve().parent
GRAPHVIZ_DIR_PATH = DIR_PATH / ".." / ".." / "graphviz_tmp"


class GraphvizVisualizer:
    def __init__(self, filename=None):
        if not filename:
            filename = "".join(
                random.choice(string.ascii_lowercase) for _ in range(10)
            )
        self.graph = Graph("G", filename=GRAPHVIZ_DIR_PATH / filename)
