from buildingspy.io.outputfile import Reader

import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator
import numpy as np
import os

def main():

    # Read results
    modelName = 'ClusterBoreholes_100boreholes.mat'
    ofr = Reader(modelName, 'dymola')
    # Number of boreholes
    nBor = int(ofr.values('nBor')[1][0])
    x = np.array([ofr.values('cooBor[{:d}, 1]'.format(i))[1][0] for i in range(1,nBor+1)])
    y = np.array([ofr.values('cooBor[{:d}, 2]'.format(i))[1][0] for i in range(1,nBor+1)])
    labels = [int(ofr.values('labels[{:d}]'.format(i))[1][0]) for i in range(1,nBor+1)]

    plt.rc('figure')
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    # Axis labels
    ax1.set_xlabel(r'x $[m]$')
    ax1.set_ylabel(r'y $[m]$')
    # Axis limits
    ax1.axis('equal')
    # Show minor ticks
    ax1.xaxis.set_minor_locator(AutoMinorLocator())
    ax1.yaxis.set_minor_locator(AutoMinorLocator())
    # Adjust to plot window
    plt.tight_layout()
    marks = ['r-o', 'b--s', 'k-.^', 'g:v', 'y-*', 'mx']
    for i in range(nBor):
        ax1.plot(x[i], y[i], marks[labels[i]-1], lw=1.5)

    return ofr

# Main function
if __name__ == "__main__":
    ofr = main()
