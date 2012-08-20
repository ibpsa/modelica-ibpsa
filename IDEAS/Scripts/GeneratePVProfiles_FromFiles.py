# -*- coding: utf-8 -*-
"""
Script to generate one or more PV input files for Modelica simulations. 
How to use this script:
    - generate .mat files from any Modelica model having a PV system.  
      For example, use IDEAS.Electric.Photovoltaic.Examples.PVSystem
    - ATTENTION: avoid output at events in the .mat files!!
    - the .mat files do NOT need to have specific filenames
    - set the parameters below to correct values

The script will create a simdex of all found .mat files and extract the 
inclination, azimuth and nominal power from the parameters.

The generated files are in W/Wp.
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
# Where to find the PV system in the .mat file
name_of_PVSystem = 'pVSystemGeneral' 
# The inclination and azimuth are extracted from 
# name_of_PVSystem.inc and name_of_PVSystem.azi respectively
# The nominal power of the system is the product of
#  - name_of_PVSystem.pvPanel.I_mpr     
#  - name_of_PVSystem.pvPanel.V_mpr
#  - name_of_PVSystem.amount

# path to the .mat files.  ATTENTION: all found .mat files will be used!!!
mat_path = r'C:\Workspace\DSMSim\pvsimulations' 
result_path = r'c:/workspace/DSMSim/Inputs/' # where to put the generated profiles

################################################################################
chdir(mat_path)

simdex = simman.Simdex()
simdex.scan()

time = simdex.get('Time')
PPV = simdex.get(name_of_PVSystem + '.invertor.P_dc')
inclination = simdex.get(name_of_PVSystem + '.inc')
azimuth = simdex.get(name_of_PVSystem + '.azi')
I_mpr = simdex.get(name_of_PVSystem + '.pvPanel.I_mpr')
V_mpr = simdex.get(name_of_PVSystem + '.pvPanel.V_mpr')
amount = simdex.get(name_of_PVSystem + '.amount')

for sid in simdex.simulations:
    PNom = I_mpr.val[sid] * V_mpr.val[sid] * amount.val[sid]
    data = np.column_stack((time.val[sid], PPV.val[sid]/PNom))
    inc = int(inclination.val[sid]/3.1415*180)
    azi = int(azimuth.val[sid]/3.1415*180)
    filename = r'c:/workspace/DSMSim/Inputs/PV_Inc'+str(inc)+'_Azi'+str(azi)+'.txt'
    pymosim.create_input_file(data, filename)

