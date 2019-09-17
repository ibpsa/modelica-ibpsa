# import from future to make Python2 behave like Python3
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from future import standard_library
standard_library.install_aliases()
from builtins import *
from io import open
# end of from future import

from multiprocessing import Pool
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd
import datetime as dt
import scipy.interpolate as interpolate
import matplotlib.pyplot as plt
import numpy as np
import os

def simulateCase(s):
	""" Set common parameters and run a simulation.

	:param s: A simulator object.

	"""
	s.setStopTime(stopTime)
	s.setStartTime(startTime)
	#s.setResultFile(resultName)
	s.setSolver(solver)
	s.setTolerance(tolerance)
	s.printModelAndTime()
	s.simulate()
	#s.translate()
	#s.simulate_translated()


## Get the current package path of the script
path = os.path.dirname(os.path.abspath(__file__))

## Set simulation parameters
startTime = 0
stopTime = 1
solver = "dassl"
tolerance = 1e-08

model = "IBPSA.Media.Examples.SteamTemperatureEnthalpyInversionError"
s = Simulator(model, "dymola")
s.setResultFile('results')

T0 = np.arange(0,600,10)+273.15
error = np.zeros(len(T0))

for i in range(len(T0)):
	t0 = T0[i]
	s.addParameters({'T0':t0})
	simulateCase(s)
	
	r = Reader("results.mat","dymola")
	t, err = r.values('err')
	error[i]=err[-1]
res = pd.DataFrame({'T0':T0,'error':error})
res.to_csv('error.csv')

plt.figure(figsize=(12,8))
plt.plot(T0-273.15,error)
plt.grid()
plt.xlabel('$T_0$ [$^\circ$C]')
plt.ylabel('Error [$^\circ$C]')
plt.savefig('steam-error.pdf')
plt.savefig('steam-error.png')
plt.show()
	
	




