# -*- coding: utf-8 -*-
"""
This module automates benchmarks of `Experimental.Benchmarks.AirFlow` package
"""

import os
import buildingspy.simulate.Simulator as si
import random
import matplotlib
import matplotlib.pyplot as plt
import numpy as np


def main():
    run_experiment()
#    simulate(2, 2)
#    simulate(3, 3)
#    simulate(4, 4)
#    simulate(5, 5)



def run_experiment(runs=10):
    """Runs an experiment to test numerical efficiency of regStep vs. splice

    Parameters
    ----------

    runs : int
        Number of runs for each model
    """
    results = {'2 floors - 2 zones': [],
               '3 floors - 3 zones': [],
               '4 floors - 4 zones': [],
               '5 floors - 5 zones': []}
    finished = False

    while finished is not True:
        choices = []
        for model in results.keys():
            if len(results[model]) < runs:
                choices.append(model)
        if len(choices) > 0:
            model = random.choice(choices)
            if model == '2 floors - 2 zones':
                ex_time = simulate(2, 2)
            elif model == '3 floors - 3 zones':
                ex_time = simulate(3, 3)
            elif model == '4 floors - 4 zones':
                ex_time = simulate(4, 4)
            elif model == '5 floors - 5 zones':
                ex_time = simulate(5, 5)
            results[model].append(ex_time)
        else:
            finished = True

    print(results)



    data = [results['2 floors - 2 zones'],
            results['3 floors - 3 zones'],
            results['4 floors - 4 zones'],
            results['5 floors - 5 zones']]
    # multiple box plots on one figure
    fig, ax1 = plt.subplots(figsize=(10, 8))

    ax1.boxplot(data)
    ax1.set_title('Scaling of air flow benchmark for ' +
                  str(runs) + ' runs each', fontsize=15)
    ax1.set_ylabel('Mean CPU time per simulation in s', fontsize=15)

    xtickNames = plt.setp(ax1, xticklabels=['2 floors - 2 zones',
                                            '3 floors - 3 zones',
                                            '4 floors - 4 zones',
                                            '5 floors - 5 zones'])
    plt.setp(xtickNames, rotation=45, fontsize=15)
    plt.tight_layout()
    curr_dir = os.path.dirname(__file__)
    result_dir = os.path.join(curr_dir, 'results')
    plt.savefig(os.path.join(result_dir, 'AirBenchmarkScaling.png'))
    plt.show()


def simulate(number_of_floors, number_of_zones):
    """Runs model `MultipleFloorsVectors` and returns computation time

    Parameters
    ----------

    number_of_floors : int
    number_of_zones : int

    Returns
    -------

    comp_time : float
        Computation time in s
    """

    curr_dir = os.path.dirname(__file__)
    result_dir = os.path.join(curr_dir, 'results')
    if not os.path.exists(result_dir):
        os.mkdir(result_dir)

    model = 'MultipleFloorsVectors'
    output_dir = os.path.join(result_dir, model)

    model = 'Annex60.Experimental.Benchmarks.AirFlow.Examples.' + model
    s = si.Simulator(model, 'dymola', output_dir)
    s.addParameters({'nFloors': number_of_floors})
    s.addParameters({'nZones': number_of_zones})
    s.simulate()

    print('simulated ' + model)

    f = open(os.path.join(output_dir, 'dslog.txt'), 'r')
    for line in f.readlines():
        if 'integration' in line and 'CPU' in line:
            comp_time = float(line.split(':')[1].split(' ')[1])
            break
    f.close()
    
    print(comp_time)

    return comp_time

# Main function
if __name__ == '__main__':
    main()
