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
import time

# Settings
# folder with the subfolders a05...b80
folder = os.path.abspath(r'C:\Workspace\DSMSim\Work\ValidationTank_best')
parameters = ['powBuo']
run_optimization = True
nodes=[5,10,20,40]
figure = True

def run_charging(parvaldic, folder):
    """
    Run the corresponding dymosim.exe with the parameter/value combination 
    from parvaldic and return TOut at the end of the simulation
    
    
    """
    cur_dir = os.getcwd()    
    os.chdir(folder)
    
    if os.path.exists('success'):
        os.remove('success')
    if os.path.exists('failure'):
        os.remove('failure')
    
    for par, val in parvaldic.items():    
        pymosim.set_par(par, float(val))
    
    pymosim.run_ds(result='run_charging.mat')

    
    while True:
        if os.path.exists('success') or os.path.exists('failure'):        
            break
        
    sim=Simulation('run_charging.mat')
    TOut = sim.get_value('tank.nodes[1].T')
    os.chdir(cur_dir)
    return TOut[-1]
    
    
def objective(x, parameters, folder, nodes, scaling=None, verbose=True):
    """
    Return the objective function f(x)

    x: np.array([x0, x1, ..., xn])
    parameters: list of parameter names corresponding to x
    folder: the folder in which the dymosim.exe subfolders are
    nodes: int, number of nodes
    scaling: np.array with scaling factors between x and the real parameter
             values.  parvalue = x * scaling
    verbose: True or False
    
    
    """    
    #pdb.set_trace()
    if scaling is None:
        scaling = np.ones(x.shape)    
    
    if verbose:
        print 'x= ', x*scaling
        time.sleep(1)

    parvaldic = {par:x_val*scal_val for par, x_val, scal_val in zip(parameters, x, scaling)}
    
    TOut_a = run_charging(parvaldic, os.path.join(folder, 'a'+str(nodes)))
    TOut_b = run_charging(parvaldic, os.path.join(folder, 'b'+str(nodes)))
    
    return (TOut_a-(273.15+45))**2 + (TOut_b-(273.15+55))**2


def runall(x, parameters, folders, scaling=None, verbose=True):
    """
    Return the charging experiment for all folders and return array with results 
    
    x: np.array([x0, x1, ..., xn])
    parameters: list of parameter names corresponding to x
    
    """    
    #pdb.set_trace()
    TOut=[]    

    if scaling is None:
        scaling = np.ones(x.shape)    
    
    if verbose:
        print 'x= ', x*scaling
        time.sleep(1)
        
    parvaldic = {par:x_val*scal_val for par, x_val, scal_val in zip(parameters, x, scaling)}
    
    for f in folders:
        TOut.append(run_charging(parvaldic, os.path.join(folder, f)))
    
    return np.array(TOut)


if __name__ is '__main__':
    if run_optimization:
        scaling = np.array([10])
        bounds = [(0, None)]
        x0=np.array([1])
        
        
        x_opt = {}        
        parval_opt = {}
        TOut_a_opt = np.ndarray(len(nodes))
        TOut_b_opt = np.ndarray(len(nodes))
            
        for i,nds in enumerate(nodes):    
            x,f,d=optimize.fmin_l_bfgs_b(objective, 
                                 x0=x0, 
                                 args=(parameters, folder, nds, scaling, False), 
                                 approx_grad=True,
                                 bounds=bounds,
                                 factr=1e12,
                                 epsilon=1e-4,
                                 pgtol=1e-3,
                                 maxfun=100, 
                                 disp=1)
            x_opt[nds] = x
            parval_opt[nds] = x*scaling
            parvaldic = {par:x_val*scal_val for par, x_val, scal_val in zip(parameters, x, scaling)}                
            TOut_a_opt[i] = run_charging(parvaldic, os.path.join(folder, 'a'+str(nds)))
            TOut_b_opt[i] = run_charging(parvaldic, os.path.join(folder, 'b'+str(nds)))
 
    if figure:

        colors=['b', 'g', 'k']
        mfcs=['r', 'orange', 'magenta']
        plt.figure()
    
        ax1=plt.subplot(2,1,1)        
        ax1.plot([0,200], [45,45], '--', color='0.6')  
        ax1.plot([0,200], [55,55], '--', color='0.6') 
        ax1.plot(nodes, TOut_b_opt-273.15, 'gD', label='TOut_b')
        ax1.plot(nodes, TOut_a_opt-273.15, 'ro', label='TOut_a')
                           
        plt.title('Temperatures at end of charging time for x_opt')
        plt.xlabel('Number of layers')
        plt.ylabel('Temperature [degC]') 
        plt.xlim((0, nodes[-1]*1.5))
        plt.ylim((42,58))
        plt.legend()    
        
        ax2=plt.subplot(2,1,2)
        for i, par in enumerate(parameters):
            parvalues = [x_opt[n][i] for n in nodes]
            ax2.plot(nodes, parvalues, 'o-', 
                 color=colors[i], mfc=mfcs[i], label=par)
        plt.ylabel(u'x_opt') 
        plt.xlim((0, nodes[-1]*1.5))
        plt.legend()
        plt.title('x_opt as function of number of layers')
        plt.xlabel('Number of layers')
 

        
        for i,nds in enumerate(nodes):
            plt.figure()
            x=x_opt[nds]
            folders = [os.path.join(folder, 'a'+str(n)) for n in nodes]
            TOut_a = runall(x, parameters, folders, scaling=scaling)
            folders = [os.path.join(folder, 'b'+str(n)) for n in nodes]
            TOut_b = runall(x, parameters, folders, scaling=scaling)
            
            ax1=plt.subplot(111)            
            ax1.plot([0,200], [45,45], '--', color='0.6')  
            ax1.plot([0,200], [55,55], '--', color='0.6') 
            ax1.plot(nodes, TOut_b-273.15, 'gD', label='TOut_b')
            ax1.plot(nodes, TOut_a-273.15, 'ro', label='TOut_a')
            
            parvalstring = ''
            for j, par in enumerate(parameters):            
                parvalstring = parvalstring + par + ' = %g; ' % (parval_opt[nds][j])                   
            plt.title('Temperatures for optimization at %s nodes: ' % (nds) + parvalstring)
            plt.xlabel('Number of layers')
            plt.ylabel('Temperature [degC]') 
            plt.xlim((0, nodes[-1]*1.5))
            #plt.ylim((42,58))
            plt.legend()    

    for nds in nodes:
        s=str(nds) + ' nodes: '
        for i,par in enumerate(parameters):
            s = s + par + ' = ' + str(parval_opt[nds][i]) + '; '
        print s
        
    plt.show()