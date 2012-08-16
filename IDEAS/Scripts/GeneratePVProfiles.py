# -*- coding: utf-8 -*-
"""
Script to generate a PV input file for Modelica simulations. 
How to use this script:
    - generate a dymosim.exe from this model: 
      IDEAS.Electric.Photovoltaic.Examples.PVSystem
    - put a copy of this script in a folder in which the generated dymosim.exe  
      can be run
    - set the parameters for the PV system below

Created on Thu Aug 02 16:46:00 2012

@author: RDC
"""
import sys
from os import chdir
import numpy as np

try:
    import pymosim
except ImportError:
    print """The module pymosim was not found.  Make sure it is installed and
    that the installation path is known by sys.path.  Alternatively, type the
    path to pymosim.py below:
        """
    p = raw_input('Path to pymosim.py, type q to quit >> ')
    if p in ['q', 'Q']:
        raise
    else:
        if p.endswith('pymosim.py'):
            p=p.rstrip('pymosim.py')
        sys.path.append(p)
        import pymosim

try:
    import simman
except ImportError:
    print """The module simman was not found.  Make sure it is installed and
    that the installation path is known by sys.path.  Alternatively, type the
    path to simman.py below:
        """
    p = raw_input('Path to simman.py, type q to quit >> ')
    if p in ['q', 'Q']:
        raise
    else:
        if p.endswith('simman.py'):
            p=p.rstrip('simman.py')
        sys.path.append(p)
        import simman            
        
            

# Parameters ###################################################################
inclination = 50 # in degrees, will be converted to radials below
azimuth = 0  # in degrees, will be converted to radials below
execute_simulation = False # if True, set inclinatin and azimuth and run the 
  # dymosim.exe.  This DID NOT WORK during the testing (simulation did NOT take
  # into account the new inclination and azimuth)
path = r'C:\Workspace\DSMSim\Work' # path to the dymosim.exe and dsin.txt
filename = r'c:/workspace/DSMSim/Inputs/PV_Inc'+str(inclination)+'_Azi'+str(azimuth)+'.txt'

################################################################################
chdir(path)

# Set inclination and azimuth and run the simulation
# Attention, make sure the start, step and stop are fine in the dymosim.exe
pymosim.set_par('inc', inclination/180.*3.1415)
pymosim.set_par('azi', azimuth/180.*3.1415)
process = pymosim.run_ds()
pymosim.kill_after(process, 100)

# extract the PV profile and save to Modelica-like input file
sim=simman.Simulation('result.mat')
simdex = simman.Simdex()
simdex.index_one_sim(sim)

pymosim.set_par('inc', 20/180.*3.1415)
pymosim.set_par('azi', azimuth/180.*3.1415)
process = pymosim.run_ds()
pymosim.kill_after(process, 100)

sim=simman.Simulation('result.mat')
simdex.index_one_sim(sim)

time=sim.get_value('Time')
PPV = -sim.get_value('pVSystemGeneral.PFinal')

data = np.column_stack((time, PPV))

pymosim.create_input_file(data, filename)


print 'Input file %s created' % (filename)

for sid in simdex.simulations:
    time = simdex.get('Time').val[sid]
    PPV = simdex.get('pVSystemGeneral.invertor.P_dc').val[sid]
    data = np.column_stack((time, PPV))
    inclination = int(simdex.get('inc').val[sid]/3.1415*180)
    filename = r'c:/workspace/DSMSim/Inputs/PV_Inc'+str(inclination)+'_Azi'+str(azimuth)+'.txt'
    pymosim.create_input_file(data, filename)