# -*- coding: utf-8 -*-
"""
This module is an example python-based testing interface.  It uses the
``requests`` package to make REST API calls to the test case container,
which mus already be running.  A controller is tested, which is 
imported from a different module.
  
"""

# GENERAL PACKAGE IMPORT
# ----------------------
import requests
import numpy as np
# ----------------------

# TEST CONTROLLER IMPORT
# ----------------------
# ----------------------

def run(plot=False):
    '''Run test case.
    
    Parameters
    ----------
    plot : bool, optional
        True to plot timeseries results.
        Default is False.
        
    Returns
    -------
    kpi : dict
        Dictionary of KPI names and values.
        {kpi_name : value}    
    res : dict
        Dictionary of trajectories of inputs and outputs.
    
    '''

    # SETUP TEST CASE
    # ---------------
    # Set URL for testcase
    url = 'http://127.0.0.1:4000'
    # Set simulation parameters
    length = 48*3600
    step = 3600
    # ---------------
    
    # GET TEST INFORMATION
    # --------------------
    print('\nTEST CASE INFORMATION\n---------------------')
    # Available test cases
    name = requests.get('{0}/emulator'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))

    # Check the default test case
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))

    # Select test case
    name = requests.put('{0}/name'.format(url), data={'name':"LargeOfficeFDD"})

    # Check the current test case
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))

    # Inputs available
    inputs = requests.get('{0}/inputs'.format(url)).json()
    print('Control Inputs:\t\t\t{0}'.format(inputs))
    # Measurements available
    measurements = requests.get('{0}/measurements'.format(url)).json()
    print('Measurements:\t\t\t{0}'.format(measurements))
    # Default simulation step
    step_def = requests.get('{0}/step'.format(url)).json()
    print('Default Simulation Step:\t{0}'.format(step_def))
    # --------------------


    # RUN TEST CASE
    # -------------
    # Reset test case
    print('Resetting test case if needed.')
    res = requests.put('{0}/reset'.format(url))
    # Set simulation step
    print('Setting simulation step to {0}.'.format(step))
    res = requests.put('{0}/step'.format(url), data={'step':step})
    print('\nRunning test case...')
    # Initialize u

    # Simulation Loop
    for i in range(int(length/step)):
        # Advance simulation by overwritting the return temp of the floor 2 AHU as a fixed value
        y = requests.post('{0}/advance'.format(url), data={"floor2_aHU_con_oveTRet_u":"293.15","floor2_aHU_con_oveTRet_activate":"1"}).json()
        # Compute next control signal

    print('\nTest case complete.')
    # -------------

if __name__ == "__main__":
#    kpi, res = run()
        run()