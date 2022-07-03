from cProfile import label
from ctypes import pointer
import fileinput
import matplotlib.pyplot as plt
import math
import numpy as np

LABELS = ["memcpy", "loop", "movs", "loop 8byte", "movs 8byte", "opt"]

xpoints = []
ypoints = [list() for _ in range(0, len(LABELS))]

for line in fileinput.input():
    numbers = list(map(float, line.split()))
    xpoints.append(int(numbers[0]))
    factor = numbers[0] / math.log2(numbers[0])

    max_result = max(*(numbers[1:]))
    for i, r in enumerate(numbers[1:]):
        ypoints[i].append(r / factor)

xticks = range(len(xpoints))
for i, yset in enumerate(ypoints):
    plt.plot(xticks, yset, label=LABELS[i])

plt.legend(LABELS)
plt.xticks(xticks, xpoints)
plt.yticks(np.arange(0, 1.0, 0.05))
plt.grid(color='g', linestyle='-', linewidth=0.1)

plt.gcf().set_size_inches(10, 6)
plt.savefig('plot.png')