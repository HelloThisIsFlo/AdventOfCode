from collections import deque

from days.day import Day

BOARD_SIZE = 5


class Day4(Day):
    def __init__(self, input_as_string: str):
        super().__init__(input_as_string)
        Board(None)
        lines = self.input_lines(str)
        self.numbers = [int(i) for i in lines[0].split(',')]

        self.boards = []
        for start in range(1, len(lines), BOARD_SIZE):
            board_grid = []
            for j in range(BOARD_SIZE):
                board_line = [int(n) for n in
                              filter(lambda n: n != '',
                                     lines[start + j].split(' '))]

                board_grid.append(board_line)
            self.boards.append(Board(board_grid))

    def solve_part_1(self):
        for n in self.numbers:
            for board in self.boards:
                board.try_num(n)
                if board.is_complete():
                    return str(board.get_result())

        return "No Bingo winners! (shouldn't happen 🤔)"

    def solve_part_2(self):
        board_queue = deque(self.boards)
        for n in self.numbers:
            for _ in range(len(board_queue)):
                board = board_queue.pop()
                board.try_num(n)
                if not board.is_complete():
                    board_queue.appendleft(board)
                elif not board_queue:
                    return str(board.get_result())

        return "No Bingo winners! (shouldn't happen 🤔)"


class Board:
    def __init__(self, board):
        self.board = board
        self.checked = [[False] * BOARD_SIZE for _ in range(BOARD_SIZE)]
        self.last_num_checked = None

    def is_complete(self):
        for row in range(BOARD_SIZE):
            complete = True
            for col in range(BOARD_SIZE):
                if not self.checked[row][col]:
                    complete = False
            if complete:
                return True

        for col in range(BOARD_SIZE):
            complete = True
            for row in range(BOARD_SIZE):
                if not self.checked[row][col]:
                    complete = False
            if complete:
                return True

        return False

    def try_num(self, num):
        for row in range(BOARD_SIZE):
            for col in range(BOARD_SIZE):
                if self.board[row][col] == num:
                    self.checked[row][col] = True
                    self.last_num_checked = num

    def get_result(self):
        sum_of_all_unmarked_numbers = 0
        for row in range(BOARD_SIZE):
            for col in range(BOARD_SIZE):
                if not self.checked[row][col]:
                    sum_of_all_unmarked_numbers += self.board[row][col]
        return sum_of_all_unmarked_numbers * self.last_num_checked
