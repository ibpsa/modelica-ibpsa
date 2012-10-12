# -*- coding: utf-8 -*-
"""
Created on Fri Oct 12 09:20:34 2012

Optimize the equivalent thermal conductivity for buoyancy heat transfer.

@author: RDC
"""

from awesim import pymosim, Simulation
import numpy as np
import matplotlib.pyplot as plt
import sys, os


# Settings
# folder with the subfolders a05...b80
folder = os.path.abspath(r'C:\Workspace\DSMSim\Work\ValidationTank')

def run_charging(folder, lamBuo):
    """
    Run the corresponding dymosim.exe with the given lamBuo and return 
    TOut at the end of the simulation
    """
    
    pymosim.set_par('lamBuo', lamBuo, dsin=os.path.join(folder, 'dsin.txt'))
    pymosim.run_ds(dymosim=os.path.join(folder, 'dymosim.exe'))
    sim=Simulation(os.path.join(folder, 'dsres.mat'))
    TOut = sim.get_value('tank.nodes[1].T')
    return TOut[-1]
    
    
