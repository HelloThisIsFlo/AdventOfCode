import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

N = 100
ON = 255
OFF = 0
vals = [ON, OFF]
grid = None


def main():
    Main().run()

class Main:
    def __init__(self):
        self.grid = np.zeros((N, N), dtype=np.float64)
        self.fig, self.ax = plt.subplots()
        self.mat = self.ax.matshow(self.grid)
        self.ani = animation.FuncAnimation(self.fig,
                                           self.update,
                                           interval=50,
                                           save_count=50)

    def run(self):
        self.show_plot()
        pass

    def update(self, data):
        # copy grid since we require 8 neighbors for calculation
        # and we go line by line
        newGrid = self.grid.copy()
        for i in range(N):
            for j in range(N):
                # compute 8-neghbor sum
                # using toroidal boundary conditions - x and y wrap around
                # so that the simulaton takes place on a toroidal surface.
                total = (self.grid[i, (j-1) % N] + self.grid[i, (j+1) % N] +
                         self.grid[(i-1) % N, j] + self.grid[(i+1) % N, j] +
                         self.grid[(i-1) % N, (j-1) % N] + self.grid[(i-1) % N, (j+1) % N] +
                         self.grid[(i+1) % N, (j-1) % N] + self.grid[(i+1) % N, (j+1) % N])/255
                # apply Conway's rules
                if self.grid[i, j] == ON:
                    if (total < 2) or (total > 3):
                        newGrid[i, j] = OFF
                else:
                    if total == 3:
                        newGrid[i, j] = ON
        # update data
        self.mat.set_data(newGrid)
        self.grid = newGrid
        return [self.mat]

    def show_plot(self):
        # set up animation
        plt.show()


def grow(area_points: list):
    for pt_x, pt_y in area_points:
        area_points.append((pt_x+1, pt_y))
        area_points.append((pt_x-1, pt_y))
        area_points.append((pt_x, pt_y+1))
        area_points.append((pt_x, pt_y-1))


main()
