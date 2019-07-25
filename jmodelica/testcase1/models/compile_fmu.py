# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA

"""

from parser import parser

# DEFINE MODEL
# ------------
#mopath = 'SingleZoneVAV.mo';
#modelpath = 'SingleZoneVAV.TestCaseSupervisory'
mopath = 'SingleZoneVAV_package/TestCaseSupervisory.mo';
modelpath = 'SingleZoneVAV_package.TestCaseSupervisory'
# ------------

# COMPILE FMU
# -----------
fmupath = parser.export_fmu(modelpath, [mopath])
# -----------
