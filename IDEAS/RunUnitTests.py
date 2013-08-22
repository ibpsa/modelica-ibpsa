# -*- coding: utf-8 -*-
"""
Created on Thu Jul 18 18:29:36 2013

@author: u0088104
"""

import buildingspy as BP
import buildingspy.development.unittest as UT
import os

"""
 If If this file is not ran from the Modelicalibrary home directory (which 
 contains the package.mo-file) Set working directory to that directory.
 The working directory is copied to a temp directory where the simulations are
 ran. 
 The simulation logs (from the simulation environment) are copied back to this directory
"""
#os.chdir("E:\work\ideas\IDEAS")

tester=UT.Tester()
""" number of parallel processes started."""
tester.setNumberOfThreads(1)
tester.validate_html = False

""" Leave Dymola open after the simulation is finished for debugging.
--> python waits until Dymola is closed to continue.
"""
#tester.exitSimulator(False)
""" Run the unittest
Outputs will be rendered"""
tester.run()
