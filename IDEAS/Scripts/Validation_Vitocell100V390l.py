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
from scipy import optimize
import pdb

# Settings
# folder with the subfolders a05...b80
folder = os.path.abspath(r'C:\Workspace\DSMSim\Work\ValidationTank')

def run_charging(lamBuo, folder):
    """
    Run the corresponding dymosim.exe with the given lamBuo and return 
    TOut at the end of the simulation
    """
    cur_dir = os.getcwd()    
    os.chdir(folder)
    
    if os.path.exists('success'):
        os.remove('success')
    if os.path.exists('failure'):
        os.remove('failure')
    
    lamBuo = float(lamBuo)    
    pymosim.set_par('lamBuo', lamBuo)
    pymosim.run_ds(result='run_charging.mat')

    
    while True:
        if os.path.exists('success') or os.path.exists('failure'):        
            break
        
    sim=Simulation('run_charging.mat')
    TOut = sim.get_value('tank.nodes[1].T')
    os.chdir(cur_dir)
    return TOut[-1]
    
def objective(lamBuo, folder, nodes):
    """
    Return the objective function
    """    
    #pdb.set_trace()
    TOut_a = run_charging(lamBuo, os.path.join(folder, 'a'+str(nodes)))
    TOut_b = run_charging(lamBuo, os.path.join(folder, 'b'+str(nodes)))
    
    return (TOut_a-(273.15+45))**2 + (TOut_b-(273.15+55))**2   
    
    
if __name__ is '__main__':
    
    print 'write here your optimize calls and print a nice plot'
    nodes=[5,10,20,40,80,160]
    lamBuo_init={5:233,10:391,20:487,40:543,80:570,160:570}
    lamBuo_opt=[]
    TOut_a_opt = []
    TOut_b_opt = []
    for nds in nodes:    
        lamBuo_opt.append(optimize.fmin_powell(objective, x0=lamBuo_init[nds], args=(folder, nds), xtol=1, ftol=0.001, maxiter=10))
        TOut_a_opt.append(run_charging(lamBuo_opt[-1], os.path.join(folder, 'a'+str(nds))))
        TOut_b_opt.append(run_charging(lamBuo_opt[-1], os.path.join(folder, 'b'+str(nds))))
 
    