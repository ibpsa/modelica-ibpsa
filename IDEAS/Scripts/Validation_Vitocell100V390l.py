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
folder = os.path.abspath(r'C:\Workspace\DSMSim\Work\ValidationTank_nonlin')
nonlinear = True
run_optimization = False
figure = True

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
    

###############################################################################
def run_charging_nl(kBuo, expBuo, folder):
    """
    Run the corresponding dymosim.exe with the given kBuo, expBuo and return 
    TOut at the end of the simulation
    """
    cur_dir = os.getcwd()    
    os.chdir(folder)
    
    if os.path.exists('success'):
        os.remove('success')
    if os.path.exists('failure'):
        os.remove('failure')
    
    kBuo = float(kBuo)
    expBuo = float(expBuo) 
    
    print 'kBuo = ', kBuo,
    print 'expBuo = ', expBuo
    
    pymosim.set_par('kBuo', kBuo)
    pymosim.set_par('expBuo', expBuo)
    pymosim.run_ds(result='run_charging.mat')

    
    while True:
        if os.path.exists('success') or os.path.exists('failure'):        
            break
        
    sim=Simulation('run_charging.mat')
    TOut = sim.get_value('tank.nodes[1].T')
    os.chdir(cur_dir)
    return TOut[-1]
    
def objective_nl(x, folder, nodes, scaling=None, verbose=True):
    """
    Return the objective function for a given number of nodese
    
    x=np.array([kBuo, expBuo])
    
    """    
    #pdb.set_trace()
    if scaling is None:
        scaling = np.ones(x.shape)    
    
    if verbose:
        print 'x= ', x*scaling
        time.sleep(1)

    TOut_a = run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], 
                             os.path.join(folder, 'a'+str(nodes)))
    TOut_b = run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], 
                             os.path.join(folder, 'b'+str(nodes)))

    return (TOut_a-(273.15+45))**2 + (TOut_b-(273.15+55))**2


def runall_nl(x, folders, scaling=None, verbose=True):
    """
    Return the charging experiment for all folders and return array with results 
    
    x=np.array([kBuo, expBuo])
    
    """    
    #pdb.set_trace()
    TOut=[]    

    if scaling is None:
        scaling = np.ones(x.shape)    
    
    if verbose:
        print 'x= ', x*scaling
        time.sleep(1)
        

    for f in folders:
        TOut.append(run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], 
                                    os.path.join(folder, f)))
    
    return np.array(TOut)


if __name__ is '__main__':
    
    if nonlinear:
        print 'Running the non-linear optimization'
        
        if run_optimization:
            scaling = np.array([1e-6, 1])
            kBuo_init=1
            expBuo_init=5
            nodes=[5,10,20,40,80]
            
            x_opt = np.ndarray((len(nodes),2))
            TOut_a_opt = np.ndarray(len(nodes))
            TOut_b_opt = np.ndarray(len(nodes))
                
            for i,nds in enumerate(nodes):    
                x,f,d=optimize.fmin_l_bfgs_b(objective_nl, 
                                     x0=np.array([kBuo_init, expBuo_init]), 
                                     args=(folder, nds, scaling, False), 
                                     approx_grad=True,
                                     bounds=[(0,None), (0.1,10)],
                                     factr=1e12,
                                     epsilon=1e-4,
                                     pgtol=1e-3,
                                     maxfun=100, 
                                     disp=1)
                x_opt[i,:] = x*scaling                     
                TOut_a_opt[i] = run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], os.path.join(folder, 'a'+str(nds)))
                TOut_b_opt[i] = run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], os.path.join(folder, 'b'+str(nds)))
 
        if figure:

            plt.figure()
        
            ax1=plt.subplot(2,1,1)        
            ax1.plot([0,200], [45,45], '--', color='0.6')  
            ax1.plot([0,200], [55,55], '--', color='0.6') 
            ax1.plot(nodes, TOut_b_opt-273.15, 'gD', label='TOut_b')
            ax1.plot(nodes, TOut_a_opt-273.15, 'ro', label='TOut_a')
                               
            plt.title('Temperatures at end of charging time for optimized kBuo and expBuo')
            plt.xlabel('Number of layers')
            plt.ylabel('Temperature [degC]') 
            plt.xlim((0, nodes[-1]*1.5))
            plt.ylim((42,58))
            plt.legend()    
            
            ax2=plt.subplot(2,1,2)
            ax2.plot(nodes, x_opt[:,0], 'o-', 
                     color='b', mfc='r', label='kBuo')
            plt.ylabel(u'kBuo') 
            plt.xlim((0, nodes[-1]*1.5))
            plt.legend(loc='upper left')
            ax3=plt.twinx(ax2)
            ax3.plot(nodes, x_opt[:,1], 'D-', 
                     color='g', mfc='orange', label='expBuo')
            plt.ylabel(u'expBuo') 
            plt.title('Optimized kBuo and expBuo as function of number of layers')
            plt.xlabel('Number of layers')
            
            plt.xlim((0, nodes[-1]*1.5))
            plt.legend(loc='upper right') 

            
            for i,nds in enumerate(nodes):
                plt.figure()
                x=x_opt[i,:]
                folders = [os.path.join(folder, 'a'+str(n)) for n in nodes]
                TOut_a = runall_nl(x, folders, scaling=None)
                folders = [os.path.join(folder, 'b'+str(n)) for n in nodes]
                TOut_b = runall_nl(x, folders, scaling=None)
                
                ax1=plt.subplot(111)            
                ax1.plot([0,200], [45,45], '--', color='0.6')  
                ax1.plot([0,200], [55,55], '--', color='0.6') 
                ax1.plot(nodes, TOut_b-273.15, 'gD', label='TOut_b')
                ax1.plot(nodes, TOut_a-273.15, 'ro', label='TOut_a')
                                   
                plt.title('Temperatures for optimization at %s nodes: kBuo=%g, expBuo=%g' %(nds, x[0], x[1]))
                plt.xlabel('Number of layers')
                plt.ylabel('Temperature [degC]') 
                plt.xlim((0, nodes[-1]*1.5))
                #plt.ylim((42,58))
                plt.legend()    
               

            
    else:
        if run_optimization:
            print 'Running the linear optimization'
            nodes=[5,10,20,40,80]
            lamBuo_init={5:233,10:391,20:487,40:543,80:570,160:570}
            lamBuo_opt=[]
            TOut_a_opt = []
            TOut_b_opt = []
            for nds in nodes:    
                lamBuo_opt.append(optimize.fmin_powell(objective, x0=lamBuo_init[nds], args=(folder, nds), xtol=1, ftol=0.01, maxiter=30))
                TOut_a_opt.append(run_charging(lamBuo_opt[-1], os.path.join(folder, 'a'+str(nds))))
                TOut_b_opt.append(run_charging(lamBuo_opt[-1], os.path.join(folder, 'b'+str(nds))))
            
            TOut_a_opt = np.array(TOut_a_opt)
            TOut_b_opt = np.array(TOut_b_opt)
        
        if figure:        
            # plot the result        
            plt.figure()
        
            ax1=plt.subplot(2,1,1)        
            ax1.plot([0,200], [45,45], '--', color='0.6')  
            ax1.plot([0,200], [55,55], '--', color='0.6') 
            ax1.plot(nodes, TOut_b_opt-273.15, 'gD', label='TOut_b')
            ax1.plot(nodes, TOut_a_opt-273.15, 'ro', label='TOut_a')
            
                   
            plt.title('Temperatures at end of charging time for optimized lamBuo')
            plt.xlabel('Number of layers')
            plt.ylabel('Temperature [degC]')
            plt.ylim((42,58))
            plt.xlim((0, nodes[-1]*1.5))
            plt.legend()    
            
            ax2=plt.subplot(2,1,2)
            ax2.plot(nodes, lamBuo_opt, 'o-', 
                     color='b', mfc='r', label='lamBuo')
            plt.title('Optimized lamBuo as function of number of layers')
            plt.xlabel('Number of layers')
            plt.ylabel(u'lamBuo [W/m²K]') 
            plt.xlim((0, nodes[-1]*1.5))
            plt.legend()    
            
    plt.show()