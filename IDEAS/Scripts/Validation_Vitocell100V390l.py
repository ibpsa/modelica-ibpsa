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
folder = os.path.abspath(r'C:\Workspace\DSMSim\Work\ValidationTank')
nonlinear = False
run_optimization = True
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
    
def objective_nl(x, folder, case, scaling=None, verbose=True):
    """
    Return the objective function for the non-linear case 'a' or 'b'
    
    x=np.array([kBuo, expBuo])
    
    """    
    #pdb.set_trace()
    folders = [f for f in os.listdir(folder) if os.path.split(f)[1].find(case)>-1]
    TOut=[]    
    #pdb.set_trace()
    if scaling is None:
        scaling = np.ones(x.shape)

    if verbose:
        print '\n\nBefore scaling: x= ', x
        print 'After scaling: x= ', x[0]*scaling[0], x[1]*scaling[1]
        time.sleep(1.5)
        
    
    for f in folders:
        TOut.append(run_charging_nl(x[0]*scaling[0], x[1]*scaling[1], 
                                    os.path.join(folder, f)))
    
    if case == 'a':
        TRef = 273.15+45
    elif case == 'b':
        TRef = 273.15+55
    else:
        raise ValueError('Case has to be "a" or "b"')
        
    diff = np.array(TOut) - TRef   
    return np.sum(diff**2)     


def runall_nl(x, folder, case, scaling=None, verbose=True):
    """
    Return the objective function for the non-linear case 'a' or 'b'
    
    x=np.array([kBuo, expBuo])
    
    """    
    #pdb.set_trace()
    folders = [f for f in os.listdir(folder) if os.path.split(f)[1].find(case)>-1]
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
        
        scaling = np.array([1e-6, 1])
        kBuo_init=1
        expBuo_init=5
        TOut_a_opt = []
        TOut_b_opt = []
        if run_optimization:
            #pdb.set_trace()
            x_a,f_a,d_a=optimize.fmin_l_bfgs_b(objective_nl, 
                                 x0=np.array([kBuo_init, expBuo_init]), 
                                 args=(folder, 'a', scaling), 
                                 approx_grad=True,
                                 bounds=[(0,None), (0.1,10)],
                                 factr=1e12,
                                 epsilon=1e-4,
                                 pgtol=1e-3,
                                 maxfun=100, 
                                 disp=1                                )

        
                  
            x_b,f_b,d_b=optimize.fmin_l_bfgs_b(objective_nl, 
                                 x0=np.array([kBuo_init, expBuo_init]), 
                                 args=(folder, 'b', scaling), 
                                 approx_grad=True,
                                 bounds=[(0,None), (0.1,10)],
                                 factr=1e12,
                                 epsilon=1e-4,
                                 pgtol=1e-3,
                                 maxfun=100)

        if figure:
            TOut_a_opt_a = runall_nl(x_a, folder, 'a', scaling)
            TOut_b_opt_a = runall_nl(x_a, folder, 'b', scaling)            
            TOut_a_opt_b = runall_nl(x_b, folder, 'a', scaling)
            TOut_b_opt_b = runall_nl(x_b, folder, 'b', scaling)
            
            
            # plot the result        
            plt.figure()
            folders = [f for f in os.listdir(folder) if os.path.split(f)[1].find('a')>-1]        
            nodes = [int(os.path.split(f)[1][1:]) for f in folders]
            plt.plot(nodes, 45*np.ones(len(nodes)), '--', color='0.8')  
            plt.plot(nodes, 55*np.ones(len(nodes)), '--', color='0.8') 
            plt.plot(nodes, TOut_a_opt_a-273.15, 'ro', label='TOut_a, opt a')
            plt.plot(nodes, TOut_b_opt_a-273.15, 'rD', label='TOut_b, opt a')
            plt.plot(nodes, TOut_a_opt_b-273.15, 'go', label='TOut_a, opt b')
            plt.plot(nodes, TOut_b_opt_b-273.15, 'gD', label='TOut_b, opt b')
            
            plt.title('kBuo and expBuo for optimization on a: '+str(x_a*scaling) +' / on b: '+str(x_b*scaling))
            plt.xlabel('Number of layers')
            plt.ylabel('Temperature [degC]')        
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
            ax1.plot([0,100], [45,45], '--', color='0.8')  
            ax1.plot([0,100], [55,55], '--', color='0.8') 
            ax1.plot(nodes, TOut_b_opt-273.15, 'gD', label='TOut_b')
            ax1.plot(nodes, TOut_a_opt-273.15, 'ro', label='TOut_a')
            
                   
            plt.title('Temperatures at end of charging time for optimized lamBuo')
            plt.xlabel('Number of layers')
            plt.ylabel('Temperature [degC]') 
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