from math import floor, ceil


def digitize(number):
    return [int(d) for d in str(number)]


def slow_overengineered_digitize(number):
    def calculate_number_of_digits():
        num_digits = 0
        remaining = number
        while remaining:
            remaining = floor(remaining / 10)
            num_digits += 1
        return num_digits

    def get_digit(index):
        if index >= num_digits:
            return 0
        if index < 0:
            raise ValueError()

        def version_string():
            return int(str(number)[index])

        def version_modulo():
            d = ceil(10**(num_digits - index - 1))
            k = floor(number / d)
            return k % 10

        def version_substraction():
            a = floor(number / 10**(num_digits - index - 1))
            b = floor(number / 10**(num_digits - index)) * 10
            return a - b

        return version_string()
        # return version_modulo()
        # return version_substraction()

    num_digits = calculate_number_of_digits()
    digits = []
    for idx in range(num_digits):
        digits.append(get_digit(idx))

    return digits


class SparseList(list):
    def __init__(self, *args, filler=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.filler = filler

    def __setitem__(self, index, value):
        """
        Overrides list's __setitem__ to extend the list
        if the accessed index is out of bounds.
        """
        sparsity = index - len(self) + 1
        self.extend([self.filler] * sparsity)
        list.__setitem__(self, index, value)

    def __getitem__(self, index):
        if index < len(self):
            return super().__getitem__(index)
        return self.filler
