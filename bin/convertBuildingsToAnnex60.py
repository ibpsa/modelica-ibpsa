#!/usr/bin/env python
''' This script is used to extract a subset of models from the Buildings library
    and rename them as Annex 60 library.
    Eventually, this script will be deleted when the first version of the Annex60
    library is stable.
'''
import fnmatch
import os
import os.path
import re
import shutil

def updateFile(fil):
    dic = {"within Buildings": "within Annex60",
           "modelica://Buildings": "modelica://Annex60",
           "Buildings.Airflow": "Annex60.Airflow",
           "Buildings.BaseClasses": "Annex60.BaseClasses",
           "Buildings.BoundaryConditions": "Annex60.BoundaryConditions",
           "Buildings.Controls": "Annex60.Controls",
           "Buildings.Examples": "Annex60.Examples",
           "Buildings.Fluid": "Annex60.Fluid",
           "Buildings.HeatTransfer": "Annex60.HeatTransfer",
           "Buildings.Media": "Annex60.Media",
           "Buildings.Resources": "Annex60.Resources",
           "Buildings.Rooms": "Annex60.Rooms",
           "Buildings.Utilities": "Annex60.Utilities",
           "package Buildings": "package Annex60",
           "Buildings/Resources": "Annex60/Resources",
           "<code>Buildings": "<code>Buildings",
           "Annex60.HeatTransfer.Sources.PrescribedHeatFlow": 
           "Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow",
           "Annex60.HeatTransfer.Sources.PrescribedTemperature":
           "Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature"}

    for k, v in dic.iteritems():
        with open('temp.txt', "wt") as out:
            for line in open(fil):
                out.write(line.replace(k, v))
            os.rename('temp.txt', fil)


def deleteClass(package):
    import shutil
    import copy

    def getDirName(li):
        pacNam="."
        for p in li:
            pacNam +=  p + os.path.sep
        return pacNam[1:-1]

    def updatePackageOrder(packageName):
        filNam=os.path.join(os.path.split(packageName)[0], "package.order")
        f = open(filNam)
        out = []
        for line in f:
            if not os.path.split(packageName)[-1] in line:
                out.append(line)
        f.close()
        f = open(filNam, 'w')
        f.writelines(out)
        f.close()

    pacNam = getDirName(package)
    # Delete directory or file
    if os.path.isdir(pacNam):
        shutil.rmtree(pacNam)
    else:
        os.remove(pacNam + '.mo')
    # Update package.order file
    updatePackageOrder(pacNam)


    # Delete unit test folder
    pacRes=copy.deepcopy(package)
    pacRes.insert(1, "Dymola")
    pacRes.insert(1, "Scripts")
    pacRes.insert(1, "Resources")
    pacNam = getDirName(pacRes)
    if os.path.isdir(pacNam):
        shutil.rmtree(pacNam)
    else:
        if os.path.isfile(pacNam + '.mos'):
            os.remove(pacNam + '.mos')

    # Delete reference results
    pacRes=copy.deepcopy(package)
    pacRes.insert(1, "Dymola")
    pacRes.insert(1, "ReferenceResults")
    pacRes.insert(1, "Resources")

    filNam="Buildings"
    for p in package[1:]:
        filNam += "_" + p
    refDir=os.path.join("Annex60", "Resources", "ReferenceResults", "Dymola")
    for file in os.listdir(refDir):
        if fnmatch.fnmatch(file, filNam + '*.txt'):
            os.remove(os.path.join(refDir, file))
    # Rename reference results
    for file in os.listdir(refDir):
        os.rename(os.path.join(refDir, file), 
                  os.path.join(refDir, file.replace("Buildings_", "Annex60_")))

    # Delete images folder
    pacRes=copy.deepcopy(package)
    pacRes.insert(1, "Images")
    pacRes.insert(1, "Resources")
    pacNam = getDirName(pacRes)
    if os.path.isdir(pacNam):
        shutil.rmtree(pacNam)

# Delete directories in Resources that are not used
shutil.rmtree(os.path.join("Annex60", "Resources", "bin"))
shutil.rmtree(os.path.join("Annex60", "Resources", "C-Sources"))
shutil.rmtree(os.path.join("Annex60", "Resources", "Data"))
shutil.rmtree(os.path.join("Annex60", "Resources", "Documentation"))
shutil.rmtree(os.path.join("Annex60", "Resources", "src"))
shutil.rmtree(os.path.join("Annex60", "Resources", "weatherdata"))
shutil.rmtree(os.path.join("Annex60", "Resources", "www"))

# Delete files that are not used
os.remove(os.path.join("Annex60", "Resources", "Scripts", "Dymola", "ConvertBuildings_from_0.11_to_0.12.mos"))
os.remove(os.path.join("Annex60", "Resources", "Scripts", "Dymola", "ConvertBuildings_from_0.12_to_1.0.mos"))
os.remove(os.path.join("Annex60", "Resources", "Scripts", "Dymola", "ConvertBuildings_from_1.0_to_1.1.mos"))
os.remove(os.path.join("Annex60", "Resources", "Scripts", "Dymola", "ConvertBuildings_from_1.1_to_1.2.mos"))
os.remove(os.path.join("Annex60", "Resources", "Scripts", "Dymola", "ConvertBuildings_from_1.4_to_1.5.mos"))

# Delete unused directories and models
deleteClass(["Annex60", "BaseClasses"])
deleteClass(["Annex60", "Fluid", "Actuators"])
deleteClass(["Annex60", "Fluid", "Boilers"])
deleteClass(["Annex60", "Fluid", "Chillers"])
deleteClass(["Annex60", "Fluid", "Delays"])
deleteClass(["Annex60", "Fluid", "Storage"])
deleteClass(["Annex60", "Fluid", "Data"])
deleteClass(["Annex60", "Fluid", "BaseClasses", "PartialThreeWayResistance"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Boreholes"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "CoolingTowers"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "DXCoils"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Radiators"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "RadiantSlabs"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "DryEffectivenessNTU"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "DryCoilCounterFlow"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "WetCoilCounterFlow"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "DryCoilDiscretized"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "WetCoilDiscretized"])

deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryCoilCounterFlowMassFlow"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryCoilCounterFlowPControl"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryCoilDiscretized"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryCoilDiscretizedPControl"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryEffectivenessNTUMassFlow"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryEffectivenessNTU"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "DryEffectivenessNTUPControl"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "WetCoilCounterFlowMassFlow"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "WetCoilCounterFlowPControl"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "WetCoilDiscretized"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "Examples", "WetCoilDiscretizedPControl"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "Examples"])

deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "appartusDewPoint"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "CoilHeader"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "CoilRegister"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "DuctManifoldFixedResistance"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "DuctManifoldNoResistance"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "dynamicViscosityWater"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "epsilon_C"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "epsilon_ntuZ"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "HACoilInside"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "HADryCoil"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "HANaturalCylinder"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "HexElementLatent"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "HexElementSensible"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "Internal"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "isobaricExpansionCoefficientWater"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "lmtd"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "MassExchange"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "ntu_epsilonZ"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PartialDuctManifold"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PartialDuctPipeManifold"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PartialHexElement"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PartialPipeManifold"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PipeManifoldFixedResistance"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "PipeManifoldNoResistance"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "prandtlNumberWater"])
deleteClass(["Annex60", "Fluid", "HeatExchangers", "BaseClasses", "RayleighNumber"])

deleteClass(["Annex60", "Fluid", "Movers"])
deleteClass(["Annex60", "Fluid", "SolarCollectors"])
deleteClass(["Annex60", "Fluid", "Sources", "Outside"])
deleteClass(["Annex60", "Fluid", "Sources", "Outside_Cp"])
deleteClass(["Annex60", "Fluid", "Sources", "Outside_CpLowRise"])
deleteClass(["Annex60", "Fluid", "Sources", "Examples", "Outside"])
deleteClass(["Annex60", "Fluid", "Sources", "Examples", "Outside_Cp"])
deleteClass(["Annex60", "Fluid", "Sources", "Examples", "Outside_CpLowRise"])
deleteClass(["Annex60", "Fluid", "Sources", "BaseClasses"])
deleteClass(["Annex60", "Fluid", "Types"])
deleteClass(["Annex60", "Fluid", "Utilities"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "LosslessPipe"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "Pipe"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "SplitterFixedResistanceDpM"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "BaseClasses"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "Examples", "FixedResistance"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "Examples", "SplitterFixedResistanceDpM"])
deleteClass(["Annex60", "Fluid", "FixedResistances", "Examples", "Pipe"])
deleteClass(["Annex60", "HeatTransfer"])
deleteClass(["Annex60", "Airflow"])
deleteClass(["Annex60", "BoundaryConditions"])
deleteClass(["Annex60", "Rooms"])
deleteClass(["Annex60", "Utilities", "Comfort"])
deleteClass(["Annex60", "Utilities", "SimulationTime"])
deleteClass(["Annex60", "Utilities", "IO"])
deleteClass(["Annex60", "Utilities", "Reports"])
deleteClass(["Annex60", "Examples"])


for ROOT,DIR,FILES in os.walk("Annex60"):
    for file in FILES:
       if file.endswith(('mo', 'mos')):
          updateFile(os.path.join(ROOT, file))

