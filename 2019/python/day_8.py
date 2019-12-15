from base import Day
import numpy as np
from collections import Counter
from operator import itemgetter


def split_layers(encoded_img, width, height):
    def num_of_layers():
        if (len(pixels) % (width * height)) != 0:
            raise ValueError("Invalid dimensions! Can not convert in layers")
        return int(len(pixels) / (width * height))

    pixels = [int(p) for p in encoded_img]
    return np.array(pixels).reshape((num_of_layers(), height, width))


def find_layer_with_fewest_zeros(layers):
    def num_of_zeros(layer):
        return sum(1 for d in layer.flatten() if d == 0)

    def index_of_minimum(array):
        return min(
            enumerate(array),
            key=itemgetter(1)
        )[0]

    idx_of_array_with_min_num_of_zero = index_of_minimum(
        map(num_of_zeros, layers)
    )

    return layers[idx_of_array_with_min_num_of_zero]


def layer_checksum(layer):
    digits_counter = Counter(layer.flatten())
    return digits_counter[1] * digits_counter[2]


def img_checksum(encoded_img, width, height):
    return layer_checksum(
        find_layer_with_fewest_zeros(
            split_layers(
                encoded_img,
                width,
                height
            )
        )
    )


def compute_img(encoded_img, width, height):
    def pixel(coordinates, layer_idx):
        (x, y) = coordinates
        return layers[layer_idx][y][x]

    layers = split_layers(encoded_img, width, height)
    img = np.empty((height, width), dtype=int)
    for x in range(width):
        for y in range(height):
            for layer_idx in range(len(layers)):
                p = pixel((x, y), layer_idx)
                if p == 0 or p == 1:
                    img[y][x] = p
                    break

    return img


class Day8(Day):
    def solve_part_1(self):
        encoded_img = self.input_lines()[0]
        return str(img_checksum(encoded_img, width=25, height=6))

    def solve_part_2(self):
        def to_cli_pixel(pixel):
            if pixel == 0:
                return ' '
            else:
                return 'X'

        to_cli_pixel_vec = np.vectorize(to_cli_pixel)

        encoded_img = self.input_lines()[0]
        img = compute_img(encoded_img, width=25, height=6)
        cli_img_lines = to_cli_pixel_vec(img)
        return '\n' + '\n'.join([''.join(l) for l in cli_img_lines])
