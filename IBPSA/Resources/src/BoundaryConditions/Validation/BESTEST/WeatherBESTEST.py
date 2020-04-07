#####################################################################
# This script is used to validate weather reading and postprocessing
# for tilted and oriented surfaces according to the BESTEST standard
# at the end it will create a folder in the current working directory
# called simulations and inside there can be the .mat files and the
# .json files or just the .json files
# Creates folders in "Temp" directory
# Copies library from local-git-hub repository
# executes simulations and prints results in current working directory
# ettore.zanetti@polimi.it                                 2020-03-11
#####################################################################
import json
import os
import shutil
import numpy as np 
import copy
from datetime import date
# Make code Verbose
CodeVerbose = True
# check if it just implements post-process (from .mat files to Json files)
POST_PROCESS_ONLY = False
# Erase old .mat files
CLEAN_MAT = True
# Erse anything but the Json file results in the ResultJson folder and .matfiles
DelEvr = False
#Get IBPSA library from gitHub
FROM_GIT_HUB = False
# Modelica IBPSA Library working branch
#BRANCH = 'issue1314_BESTEST_weather'
BRANCH ='master'
#Path to local library copy
LIBPATH = "C:\\Users\\ettor\\Documents\\Repositories\\MODELICA\\TRY\\modelica-ibpsa\\IBPSA"
# simulator, Dymola
TOOL = 'dymola'

# List of cases and result cases
PACKAGES = 'IBPSA.BoundaryConditions.BESTEST.Validation'

CASES = ['WD100','WD200','WD300','WD400','WD500','WD600']


reVals= ['Azi000Til00.H', 'Azi000Til00.HPer', 'Azi000Til00.HDir.H', 'Azi000Til00.HDiffIso.H', \
 'Azi000Til00.HDiffPer.H', 'Azi000Til90.H', 'Azi000Til90.HPer', 'Azi000Til90.HDir.H', \
 'Azi000Til90.HDiffIso.H', 'Azi000Til90.HDiffPer.H', 'Azi270Til90.H', 'Azi270Til90.HPer',\
 'Azi270Til90.HDir.H', 'Azi270Til90.HDiffIso.H', 'Azi270Til90.HDiffPer.H', \
 'Azi180Til90.H', 'Azi180Til90.HPer', 'Azi180Til90.HDir.H', 'Azi180Til90.HDiffIso.H',\
 'Azi180Til90.HDiffPer.H', 'Azi090Til90.H', 'Azi090Til90.HPer', 'Azi090Til90.HDir.H',\
 'Azi090Til90.HDiffIso.H', 'Azi090Til90.HDiffPer.H', 'Azi315Til90.H', 'Azi315Til90.HPer',\
 'Azi315Til90.HDir.H', 'Azi315Til90.HDiffIso.H', 'Azi315Til90.HDiffPer.H', 'Azi045Til90.H',\
 'Azi045Til90.HDir.H', 'Azi045Til90.HDiffIso.H', 'Azi045Til90.HDiffPer.H', 'Azi270Til30.H', \
 'Azi270Til30.HDir.H', 'Azi270Til30.HDiffIso.H', 'Azi270Til30.HDiffPer.H', 'Azi000Til30.H', \
 'Azi000Til30.HDir.H', 'Azi000Til30.HDiffIso.H', 'Azi000Til30.HDiffPer.H', 'Azi000Til30.HPer',\
 'Azi090Til30.H', 'Azi090Til30.HPer', 'Azi090Til30.HDir.H', 'Azi090Til30.HDiffPer.H', \
 'toDryAir.XiDry', 'weaBus.pAtm', 'weaBus.TDryBul', 'weaBus.relHum', 'weaBus.TBlaSky', \
 'weaBus.TDewPoi', 'weaBus.TWetBul', 'weaBus.nOpa', 'weaBus.nTot', 'weaBus.winDir', \
 'weaBus.winSpe', 'weaBusDew.TBlaSky','Azi270Til30.HPer','Azi045Til90.HPer','Azi090Til30.HDiffIso.H']



#Software specifications 
modeler_organization = 'LBNL'
modeler_organization_for_tables_and_charts ='LBNL'
program_name_and_version = 'IBPSA v4.0.0dev commit: 44c8cb5446f16e6f241494fb47f7d61418248f69, Buildings v7.0.0dev 56a796c3f2b93d86e5ea8c9aa3084457b160a478'
program_name_for_tables_and_charts = 'BuildingsPy & Python'
program_version_release_date = '08/28/2018'
results_submission_date = str(date.today().strftime('%m/%d/%Y'))

def create_working_directory():
    ''' Create working directory in temp folder
    '''
    import tempfile
    import getpass
    worDir = tempfile.mkdtemp( prefix='tmp_Weather_Bestest' + getpass.getuser() )
    if CodeVerbose:
        print("Created directory {}".format(worDir))    
    return worDir
def checkout_repository(working_directory, CaseDict):
    ''' The function will download the repository from GitHub or a copy from a local library 
          to the temporary working directory
          
    :param working_directory: Current working directory
    :param CaseDict : from_git_hub get the library repository from local copy or git_hub,
    BRANCH, to specify branch from git_hub, LIBPATH, to specify the local library path
          
    '''
    import os
    from git import Repo
    import git
    d = {}
    if CaseDict['from_git_hub']:
        git_url = "https://github.com/ibpsa/modelica-ibpsa"
        r = Repo.clone_from(git_url, working_directory)
        g = git.Git(working_directory)
        g.checkout(BRANCH)
        if CodeVerbose:
            print("Checking out repository IBPSA repository branch {}".format(BRANCH))
        # Print commit
        d['branch'] = CaseDict['BRANCH']
        d['commit'] = str(r.active_branch.commit)
    else:
        # This is a hack to get the local copy of the repository
        des =  os.path.join(working_directory, "IBPSA")
        #des = "\\\\?\\" + os.path.join(working_directory, "IBPSA")
        if CodeVerbose:
            print("*** Copying IBPSA library to {}".format(des))
        #   shutil.copytree("\\\\?\\"+"C:\\Users\\ettor\\Documents\\Repositories\\MODELICA\\TRY\\modelica-ibpsa\\IBPSA", des) 
        shutil.copytree(CaseDict['LIBPATH'], des) 
    return d

def get_cases(CaseDict):
    ''' Return the simulation cases that are used for the case study.
        The cases are stored in this function as they are used
        for the simulation and for the post processing.
        
        :param CaseDict : In the dictionary are reported the options for the Dymola simulations
    '''
    cases = list()
    for case in CaseDict["CASES"] :
        cases.append( \
        {'model': CaseDict["PACKAGES"] +'.'+case,
         "name": case,
         "tex_label": "p",
         "start_time": CaseDict["StartTime"],
         "stop_time":  CaseDict["StopTime"],
         "solver": CaseDict["Solver"],
         "setTolerance":CaseDict["setTolerance"],
         "ShowGUI":CaseDict["ShowGUI"],
         "nIntervals":CaseDict["nIntervals"],
         "CWD":CaseDict['CWD'],
         "CLEAN_MAT":CaseDict['CLEAN_MAT'],
         "DelEvr": CaseDict["DelEvr"],
         "lib_dir": CaseDict['lib_dir']})
    return cases

def _simulate(spec):
    ''' 
    This function execute the simulation of a specific Case model and stores
    the result in the simulation directory, then copies the result to the current
    working directory and if CLEAN_MAT option is selected the old .mat files are removed
        
    '''
    from buildingspy.simulate.Simulator import Simulator

    out_dir = os.path.join(spec['lib_dir'], "simulations", spec["name"])
    os.makedirs(out_dir)

    # Write git information if the simulation is based on a github checkout
    if 'git' in spec:
        with open(os.path.join(out_dir, "version.txt"), "w+") as text_file:
            text_file.write("branch={}\n".format(spec['git']['branch']))
            text_file.write("commit={}\n".format(spec['git']['commit']))

    # Get current library directory 
    IBPSAtemp = os.path.join(spec['lib_dir'], 'IBPSA')
    # Set Model to simulate, the tool, the output dir and the package directory
    s=Simulator(spec["model"], TOOL, outputDirectory=out_dir, packagePath = IBPSAtemp )
    #Add all necessary parameters from Case Dict
    s.addPreProcessingStatement("OutputCPUtime:= true;")
    s.setSolver(spec["solver"])
    if 'parameters' in spec:
        s.addParameters(spec['parameters'])
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setNumberOfIntervals(spec["nIntervals"])
    s.setTolerance(spec["setTolerance"])
    s.showGUI(spec["ShowGUI"])
    if CodeVerbose:
        print("Starting simulation in {}".format(out_dir))
    s.simulate()

    #Copy results back
    res_des = os.path.join(spec["CWD"], "simulations", spec["name"])
    if CodeVerbose:
        print("*** Copying results to {}".format(res_des))
        
    #Removing old results directory
    if os.path.isdir(res_des) and spec["CLEAN_MAT"]:
        shutil.rmtree(res_des)
        shutil.copytree(out_dir, res_des)
    elif os.path.isdir(res_des) and not spec["CLEAN_MAT"]:
        pass
    else:
        shutil.copytree(out_dir, res_des)

def _organize_cases(mat_dir):
    ''' Create a list of dictionaries. Each a dictionary include the case name and the mat file path.
    :param mat_dir: path to .matfiles directory
    '''
    matFiles = list()
    for r, d, f in os.walk(mat_dir):
        for file in f:
            if '.mat' in file:
                matFiles.append(os.path.join(r, file))
    
    caseList = list()
    if len(CASES) == len(matFiles):
        for case in CASES:
            temp = {'case': case}
            for matFile in matFiles:
                #matFilen = os.path.basename(matFile)
                tester = case + '.mat'
                if tester in matFile:
                    temp['matFile'] = os.path.join(mat_dir, matFile)
            caseList.append(temp)
    else:
        raise ValueError("*** There is failed simulation and has no result file or the cwd was accidentally changed. Check the simulations or cwd. ***")
    return caseList

def _extract_data(matFile, reVal):
    """
    Extract time series data from mat file.
    :param matFile: modelica simulation result path
    :param relVal: list of variables that the data should be extracted
    """
    from buildingspy.io.outputfile import Reader


    nPoi = CaseDict["nIntervals"]

    try:
        r = Reader(matFile, TOOL)
    except IOError:
        raise ValueError("Failed to read {}.".format(matFile))

    result = list()
    for var in reVal:
        time = []
        val = []
        try:
            var_mat = var
            (time, val) = r.values(var_mat)
            timen, valn = _CleanTimeSeries(time, val,nPoi)
        except KeyError:
            raise ValueError("Result {} does not have variable {}.".format(matFile, var))
        temp = {'variable': var,
                'time': timen,
                'value': valn}
        result.append(temp)
    return result


def _CleanTimeSeries(time, val, nPoi):
    """
    Clean doubled time values and checks with wanted number of nPoi
    :param time: time .
    :param val: variable values.
    :param nPoi: Number of result points.
    """
    import numpy as np
    #Create shift array
    Shift = np.array([0.0], dtype='f')
    # Shift time to right and left and subtract
    timeSr = np.concatenate((Shift,time))
    timeSl = np.concatenate((time,Shift))
    timeD = timeSl-timeSr
    timeDn = timeD[0:-1]
    # get new values for time and val
    tol = 1E-5
    timen=time[timeDn>tol]
    valn=val[timeDn>tol]
    if len(timen) != nPoi:
        raise ValueError("_CleatTimeSeries encouterd an error time length and number of results points do not match")
    return timen, valn

def WeatherJson(resForm,Matfd,CaseDict):
    """
    This function take the results and writes them in the required json BESTEST
    format
    
    :param resForm: json file format.
    :param Matfd: list of the results matfiles and their path.
    :param CaseDict: in CaseDict are stored the simulation cases "reVals"
    """
    # list of type of results
    #taking hourly variables
    resFin=copy.deepcopy(resForm)
    for dic in Matfd:
        matFile = dic["matFile"]
        results = _extract_data(matFile, CaseDict["reVals"])
        k = 0
        for result in results:
            resSplit = result['variable'].split('.')
            if resSplit[-1] in 'TDryBul_TBlaSky_TWetBul_TDewPoi':
                #pass from K to °C
                results[k]['value'] = results[k]['value']-273.15
            elif 'relHum' in resSplit[-1]:
                #pass from [0,1] to %
                results[k]['value'] = results[k]['value']*100     
            k+=1        
        MapDymolaAndJson(results,dic['case'],resFin)
    return resFin
      
def MapDymolaAndJson(results,case,resFin):
    """
    This function couples the .mat file variable with the final .json variable
    :param results: the result that come out from the _extract_data function
    :param case: dict that specifies the BESTEST case
    :para resFin: dict with the same format as the desired json file
    """
  
    dictHourly = [ {'json':'dry_bulb_temperature',
                'mat':'weaBus.TDryBul'},               
              {'json':'relative_humidity',
               'mat':'weaBus.relHum'},
              {'json':'humidity_ratio',
               'mat': 'toDryAir.XiDry'},
              {'json':'wet_bulb_temperature',
               'mat':'weaBus.TWetBul'},
              {'json':'wind_speed', 
               'mat':'weaBus.winSpe'},
              {'json':'wind_direction',
               'mat':'weaBus.winDir'},
              {'json':'station_pressure', 
               'mat':'weaBus.pAtm'},
              {'json':'total_cloud_cover', 
               'mat':'weaBus.nTot'},
              {'json':'opaque_cloud_cover', 
               'mat':'weaBus.nOpa'},
              {'json':'sky_temperature',
               'matHor':'weaBus.TBlaSky',
               'matDew':'weaBusDew.TBlaSky'},
              {'json':'total_horizontal_radiation',
               'matIso':'Azi000Til00.H',
               'matPer':'Azi000Til00.HPer'},
              {'json':'beam_horizontal_radiation',
               'mat':'Azi000Til00.HDir.H'},
              {'json':'diffuse_horizontal_radiation',
               'matIso':'Azi000Til00.HDiffIso.H',
               'matPer':'Azi000Til00.HDiffPer.H'},             
              {'json':'total_radiation_s_90',
               'matIso':'Azi000Til90.H',
               'matPer':'Azi000Til90.HPer'},
              {'json':'total_beam_radiation_s_90',
               'mat':'Azi000Til90.HDir.H'},
              {'json':'total_diffuse_radiation_s_90',
               'matIso':'Azi000Til90.HDiffIso.H',
               'matPer':'Azi000Til90.HDiffPer.H'},
              {'json':'total_radiation_e_90',
               'matIso':'Azi270Til90.H',
               'matPer':'Azi270Til90.HPer'},
              {'json':'total_beam_radiation_e_90',
               'mat':'Azi270Til90.HDir.H'},
              {'json':'total_diffuse_radiation_e_90',
               'matIso':'Azi270Til90.HDiffIso.H',
               'matPer':'Azi270Til90.HDiffPer.H'},
              {'json':'total_radiation_n_90',
               'matIso':'Azi180Til90.H',
               'matPer':'Azi180Til90.HPer'},
              {'json':'total_beam_radiation_n_90',
               'mat':'Azi180Til90.HDir.H'},
              {'json':'total_diffuse_radiation_n_90',
               'matIso':'Azi180Til90.HDiffIso.H',
               'matPer':'Azi180Til90.HDiffPer.H'},
              {'json':'total_radiation_w_90',
               'matIso':'Azi090Til90.H',
               'matPer':'Azi090Til90.HPer'},
              {'json':'total_beam_radiation_w_90',
               'mat':'Azi090Til90.HDir.H'},
              {'json':'total_diffuse_radiation_w_90',
               'matIso':'Azi090Til90.HDiffIso.H',
               'matPer':'Azi090Til90.HDiffPer.H'},
              {'json':'total_radiation_45_e_90',
               'matIso':'Azi315Til90.H',
               'matPer':'Azi315Til90.HPer'},
              {'json':'total_beam_radiation_45_e_90',
               'mat':'Azi315Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_e_90', 
               'matIso':'Azi315Til90.HDiffIso.H',
               'matPer':'Azi315Til90.HDiffPer.H'},
              {'json':'total_radiation_45_w_90',
               'matIso':'Azi045Til90.H',
               'matPer':'Azi045Til90.HPer'},
              {'json':'total_beam_radiation_45_w_90',
               'mat':'Azi045Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_w_90',
               'matIso':'Azi045Til90.HDiffIso.H',
               'matPer':'Azi045Til90.HDiffPer.H'},
              {'json':'total_radiation_e_30',
               'matIso':'Azi270Til30.H',
               'matPer':'Azi270Til30.HPer'},
              {'json':'total_beam_radiation_e_30',
               'mat':'Azi270Til30.HDir.H'},
              {'json':'total_diffuse_radiation_e_30',
               'matIso':'Azi270Til30.HDiffIso.H',
               'matPer':'Azi270Til30.HDiffPer.H'},
              {'json':'total_radiation_s_30',
               'matIso':'Azi000Til30.H',
               'matPer':'Azi000Til30.HPer'},
              {'json':'total_beam_radiation_s_30',
               'mat':'Azi000Til30.HDir.H'},
              {'json':'total_diffuse_radiation_s_30',
               'matIso':'Azi000Til30.HDiffIso.H',
               'matPer':'Azi000Til30.HDiffPer.H'},
              {'json':'total_radiation_w_30',
               'matIso':'Azi090Til30.H',
               'matPer':'Azi090Til30.HPer'},
              {'json':'total_beam_radiation_w_30',
               'mat':'Azi090Til30.HDir.H'},
              {'json':'total_diffuse_radiation_w_30',
               'matIso':'Azi090Til30.HDiffIso.H',
               'matPer':'Azi090Til30.HDiffPer.H'}]
    dictSubHourly =  [ {'json':'dry_bulb_temperature',
                'mat':'weaBus.TDryBul'},               
              {'json':'relative_humidity',
               'mat':'weaBus.relHum'},
              {'json':'total_horizontal_radiation',
               'matIso':'Azi000Til00.H',
               'matPer':'Azi000Til00.HPer'},
              {'json':'beam_horizontal_radiation',
               'mat':'Azi000Til00.HDir.H'},
              {'json':'diffuse_horizontal_radiation',
               'matIso':'Azi000Til00.HDiffIso.H',
               'matPer':'Azi000Til00.HDiffPer.H'},             
              {'json':'total_radiation_s_90',
               'matIso':'Azi000Til90.H',
               'matPer':'Azi000Til90.HPer'},
              {'json':'total_beam_radiation_s_90',
               'mat':'Azi000Til90.HDir.H'},
              {'json':'total_diffuse_radiation_s_90',
               'matIso':'Azi000Til90.HDiffIso.H',
               'matPer':'Azi000Til90.HDiffPer.H'},
              {'json':'total_radiation_e_90',
               'matIso':'Azi270Til90.H',
               'matPer':'Azi270Til90.HPer'},
              {'json':'total_beam_radiation_e_90',
               'mat':'Azi270Til90.HDir.H'},
              {'json':'total_diffuse_radiation_e_90',
               'matIso':'Azi270Til90.HDiffIso.H',
               'matPer':'Azi270Til90.HDiffPer.H'},
              {'json':'total_radiation_n_90',
               'matIso':'Azi180Til90.H',
               'matPer':'Azi180Til90.HPer'},
              {'json':'total_beam_radiation_n_90',
               'mat':'Azi180Til90.HDir.H'},
              {'json':'total_diffuse_radiation_n_90',
               'matIso':'Azi180Til90.HDiffIso.H',
               'matPer':'Azi180Til90.HDiffPer.H'},
              {'json':'total_radiation_w_90',
               'matIso':'Azi090Til90.H',
               'matPer':'Azi090Til90.HPer'},
              {'json':'total_beam_radiation_w_90',
               'mat':'Azi090Til90.HDir.H'},
              {'json':'total_diffuse_radiation_w_90',
               'matIso':'Azi090Til90.HDiffIso.H',
               'matPer':'Azi090Til90.HDiffPer.H'},
              {'json':'total_radiation_45_e_90',
               'matIso':'Azi315Til90.H',
               'matPer':'Azi315Til90.HPer'},
              {'json':'total_beam_radiation_45_e_90',
               'mat':'Azi315Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_e_90', 
               'matIso':'Azi315Til90.HDiffIso.H',
               'matPer':'Azi315Til90.HDiffPer.H'},
              {'json':'total_radiation_45_w_90',
               'matIso':'Azi045Til90.H',
               'matPer':'Azi045Til90.HPer'},
              {'json':'total_beam_radiation_45_w_90',
               'mat':'Azi045Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_w_90',
               'matIso':'Azi045Til90.HDiffIso.H',
               'matPer':'Azi045Til90.HDiffPer.H'},
              {'json':'total_radiation_e_30',
               'matIso':'Azi270Til30.H',
               'matPer':'Azi270Til30.HPer'},
              {'json':'total_beam_radiation_e_30',
               'mat':'Azi270Til30.HDir.H'},
              {'json':'total_diffuse_radiation_e_30',
               'matIso':'Azi270Til30.HDiffIso.H',
               'matPer':'Azi270Til30.HDiffPer.H'},
              {'json':'total_radiation_s_30',
               'matIso':'Azi000Til30.H',
               'matPer':'Azi000Til30.HPer'},
              {'json':'total_beam_radiation_s_30',
               'mat':'Azi000Til30.HDir.H'},
              {'json':'total_diffuse_radiation_s_30',
               'matIso':'Azi000Til30.HDiffIso.H',
               'matPer':'Azi000Til30.HDiffPer.H'},
              {'json':'total_radiation_w_30',
               'matIso':'Azi090Til30.H',
               'matPer':'Azi090Til30.HPer'},
              {'json':'total_beam_radiation_w_30',
               'mat':'Azi090Til30.HDir.H'},
              {'json':'total_diffuse_radiation_w_30',
               'matIso':'Azi090Til30.HDiffIso.H',
               'matPer':'Azi090Til30.HDiffPer.H'},
              {'json':'integrated_total_horizontal_radiation',
               'matIso':'Azi000Til00.H',
               'matPer':'Azi000Til00.HPer'},
              {'json':'integrated_beam_horizontal_radiation',
               'mat':'Azi000Til00.HDir.H'},
              {'json':'integrated_diffuse_horizontal_radiation',
               'matIso':'Azi000Til00.HDiffIso.H',
               'matPer':'Azi000Til00.HDiffPer.H'}]
    dictYearly = [ {'json':'average_dry_bulb_temperature',
                'mat':'weaBus.TDryBul'},               
              {'json':'average_relative_humidity',
               'mat':'weaBus.relHum'},
              {'json':'average_humidity_ratio',
               'mat': 'toDryAir.XiDry'},
              {'json':'average_wet_bulb_temperature',
               'mat':'weaBus.TWetBul'},
              {'json':'average_dew_point_temperature',
               'mat':'weaBus.TDewPoi'},
              {'json':'total_horizontal_solar_radiation',
               'matIso':'Azi000Til00.H',
               'matPer':'Azi000Til00.HPer'},
              {'json':'total_horizontal_beam_solar_radiation',
               'mat':'Azi000Til00.HDir.H'},
              {'json':'total_horizontal_diffuse_solar_radiation',
               'matIso':'Azi000Til00.HDiffIso.H',
               'matPer':'Azi000Til00.HDiffPer.H'},             
              {'json':'total_radiation_s_90',
               'matIso':'Azi000Til90.H',
               'matPer':'Azi000Til90.HPer'},
              {'json':'total_beam_radiation_s_90',
               'mat':'Azi000Til90.HDir.H'},
              {'json':'total_diffuse_radiation_s_90',
               'matIso':'Azi000Til90.HDiffIso.H',
               'matPer':'Azi000Til90.HDiffPer.H'},
              {'json':'total_radiation_e_90',
               'matIso':'Azi270Til90.H',
               'matPer':'Azi270Til90.HPer'},
              {'json':'total_beam_radiation_e_90',
               'mat':'Azi270Til90.HDir.H'},
              {'json':'total_diffuse_radiation_e_90',
               'matIso':'Azi270Til90.HDiffIso.H',
               'matPer':'Azi270Til90.HDiffPer.H'},
              {'json':'total_radiation_n_90',
               'matIso':'Azi180Til90.H',
               'matPer':'Azi180Til90.HPer'},
              {'json':'total_beam_radiation_n_90',
               'mat':'Azi180Til90.HDir.H'},
              {'json':'total_diffuse_radiation_n_90',
               'matIso':'Azi180Til90.HDiffIso.H',
               'matPer':'Azi180Til90.HDiffPer.H'},
              {'json':'total_radiation_w_90',
               'matIso':'Azi090Til90.H',
               'matPer':'Azi090Til90.HPer'},
              {'json':'total_beam_radiation_w_90',
               'mat':'Azi090Til90.HDir.H'},
              {'json':'total_diffuse_radiation_w_90',
               'matIso':'Azi090Til90.HDiffIso.H',
               'matPer':'Azi090Til90.HDiffPer.H'},
              {'json':'total_radiation_45_e_90',
               'matIso':'Azi315Til90.H',
               'matPer':'Azi315Til90.HPer'},
              {'json':'total_beam_radiation_45_e_90',
               'mat':'Azi315Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_e_90', 
               'matIso':'Azi315Til90.HDiffIso.H',
               'matPer':'Azi315Til90.HDiffPer.H'},
              {'json':'total_radiation_45_w_90',
               'matIso':'Azi045Til90.H',
               'matPer':'Azi045Til90.HPer'},
              {'json':'total_beam_radiation_45_w_90',
               'mat':'Azi045Til90.HDir.H'},
              {'json':'total_diffuse_radiation_45_w_90',
               'matIso':'Azi045Til90.HDiffIso.H',
               'matPer':'Azi045Til90.HDiffPer.H'},
              {'json':'total_radiation_e_30',
               'matIso':'Azi270Til30.H',
               'matPer':'Azi270Til30.HPer'},
              {'json':'total_beam_radiation_e_30',
               'mat':'Azi270Til30.HDir.H'},
              {'json':'total_diffuse_radiation_e_30',
               'matIso':'Azi270Til30.HDiffIso.H',
               'matPer':'Azi270Til30.HDiffPer.H'},
              {'json':'total_radiation_s_30',
               'matIso':'Azi000Til30.H',
               'matPer':'Azi000Til30.HPer'},
              {'json':'total_beam_radiation_s_30',
               'mat':'Azi000Til30.HDir.H'},
              {'json':'total_diffuse_radiation_s_30',
               'matIso':'Azi000Til30.HDiffIso.H',
               'matPer':'Azi000Til30.HDiffPer.H'},
              {'json':'total_radiation_w_30',
               'matIso':'Azi090Til30.H',
               'matPer':'Azi090Til30.HPer'},
              {'json':'total_beam_radiation_w_30',
               'mat':'Azi090Til30.HDir.H'},
              {'json':'total_diffuse_radiation_w_30',
               'matIso':'Azi090Til30.HDiffIso.H',
               'matPer':'Azi090Til30.HDiffPer.H'}]    
    Days={'WD100':{	'days': ['yearly','may4','jul14','sep6' ],
               'tstart' : [0,10627200,16761600,21427200],
            	'tstop' : [0,10713600,16848000,21513600]},
     'WD200':{ 'days': ['yearly','may24','aug26' ],
            	'tstart' : [0,12355200,20476800],
            	'tstop' : [0,12441600,20563200]},
     'WD300':{ 'days': ['yearly','feb7','aug13' ],
            	'tstart' : [0,3196800,19353600],
            	'tstop' : [0,3283200,19440000]},
     'WD400':{'days': ['yearly','jan24','jul1' ],
               	'tstart' : [0,1987200,15638400],
            	'tstop' : [0,2073600,15724800]},
     'WD500':{ 'days': ['yearly','mar1','sep14' ],
            	'tstart' : [0,5097600,22118400],
            	'tstop' : [0,5184000,22204800]},
     'WD600':{'days': ['yearly','may4','jul14','sep6' ],
              'tstart' : [0,10627200,16761600,21427200],
              'tstop' : [0,10713600,16848000,21513600]}}
    caseDays =[{key : value[i] for key, value in Days[case].items()} for i in range(len(Days[case]['days']))] 
    
    outDir=resFin

    missing=list()
    for dR in results:
        for day in caseDays:
            if day['days'] in 'yearly':
                res = ExtrapolateResults(dictYearly,dR,day)
                if not res:
                    missing.append(day['days']+'_'+dR['variable'])
                else:
                         outDir[case]['annual_results'][res['json']] = float(res['res'])
            else:
                 resH = ExtrapolateResults(dictHourly,dR,day)
                 ressH = ExtrapolateResults(dictSubHourly,dR,day)
                 if not resH:
                      missing.append(day['days']+'_hourly_'+dR['variable'])
                 else:
                      resH['res']=resH['res'][0::4]
                      resH['time']=resH['time'][0::4]
                      HRlist =list()
                      k=0
                      for HR in resH['res']:
                          HRdict ={}
                          HRdict['time'] = float((resH['time'][k]-resH['time'][0])/3600)
                          HRdict['value'] = float(HR)
                          HRlist.append(HRdict)
                          k+=1
                      outDir[case]['hourly_results'][day['days']][resH['json']] = HRlist
                 if not ressH:
                     missing.append(day['days']+'_subhourly_'+dR['variable'])
                 else:
                     sHRlist=list()
                     k=0
                     for sHR in ressH['res']:
                          
                          sHRdict ={}
                          sHRdict['time'] =float( (ressH['time'][k]-ressH['time'][0])/3600)
                          if 'radiation' in ressH['json']:
                              sHRdict['value'] = float(sHR*900/3600)
                          else:
                              sHRdict['value'] = float(sHR)
                          sHRlist.append(sHRdict)
                          k+=1
                     outDir[case ]['subhourly_results'][day['days']][ressH['json']] = sHRlist
                     #manually update integrated values for 'integrated' variables for subhourly results
                     if 'horizontal_radiation' in ressH['json']: 
                         ressH['time'] = ressH['time']
                         time_int = ressH['time'][0::4]                         
                         H_int = np.interp(time_int, ressH['time'], ressH['res'])
                         sHRlist=list()
                         k=0
                         for sHR in H_int:
                          sHRdict ={}
                          sHRdict['time'] = float((time_int[k]-time_int[0])/3600)
                          sHRdict['value'] = float(sHR)
                          sHRlist.append(sHRdict)
                          k+=1                         
                         outDir[case ]['subhourly_results'][day['days']]['integrated_'+ressH['json']] = sHRlist

        
        
def ExtrapolateResults(dicT,dR,day):
    """
     This function takes a result time series matches it with the corresponding
    json, and extrapolates the data
    
    :param dictT: This is the dictionary with the mapping between .mat and .Json variables
    :param dR: in this dictionary is contained the name, time and value of a certain variable in the .mat file
    :param day: day is a subdictionary with all the days required for the bestest see table 3 in BESTEST package
    """
    OutDict = {}
    for dT in dicT:
        if dR['variable'] in list(dT.values()) and 'integrated' not in dT['json']:
            if day['days'] in 'yearly':
                if 'Azi' in dR['variable']:
                    res = np.trapz(dR['value'],x = dR['time'])/3600
                    
                else:
                    res = np.mean(dR['value'])
            else:
                tStart = day ['tstart']
                tStop = day ['tstop']
                idxStart = FindNearest(dR['time'], tStart)
                idxStop = FindNearest(dR['time'], tStop)
                res = dR['value'][idxStart:idxStop]
                OutDict['time']=dR['time'][idxStart:idxStop]
            OutDict['res']=res           
            OutDict.update(dT)
    return OutDict            
               
               
               
def FindNearest(array, value): 
    '''
    This function finds the nearest desired value 'value' in an array 'array'
    '''
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx                           
        
                
def RemoveString(Slist,String):
    '''
    This function strips a list of strings from elements that contain a certain substring
    '''
    Slist[:] = [x for x in Slist if String not in x]
    return Slist
       


############End of functions main code portion###################
if __name__=='__main__':
    from multiprocessing import Pool, freeze_support
    CWD = os.getcwd()
    CaseDict ={'PACKAGES': PACKAGES,
           'CASES': CASES,
           'reVals':reVals,
           'StartTime':0,
           'StopTime':31536000,
           'Solver':'Euler',
           'setTolerance':1E-6,
           'ShowGUI':False,
           'nIntervals':35040,
           'CWD': CWD,
           'from_git_hub': FROM_GIT_HUB,
           'BRANCH': BRANCH,
           'LIBPATH': LIBPATH,
           'CLEAN_MAT': CLEAN_MAT,
           'DelEvr': DelEvr}
    if not POST_PROCESS_ONLY:  
        #Get list of case to simulate with their parameters        
        lib_dir = create_working_directory()
        CaseDict['lib_dir']=lib_dir
        list_of_cases = get_cases(CaseDict)
        d = checkout_repository(lib_dir, CaseDict)
        # Add the directory where the library has been checked out
        for case in list_of_cases:
            case['lib_dir'] = lib_dir
            if FROM_GIT_HUB:
                case['git'] = d        
        # # Run all cases
        freeze_support() #you need this in windows
        po = Pool()
        po.map(_simulate, list_of_cases)
        po.close()
        po.join()  # block at this line until all processes are done
        # Delete the temporary folder    
        if CodeVerbose:
            print(" Erasing temperarary folder {}".format(lib_dir))
        #Going back to original working directory and removing temporary working directory
        os.chdir(CWD)
        shutil.rmtree(lib_dir)
    
    # Organize results 
    mat_dir=os.path.join(CWD,'simulations')
    Matfd=_organize_cases(mat_dir)
    # Create Json file for each case (ISO,PEREZ,TBSKY_HOR,TBSKY_DEW)
    # import results template 
    with open('WeatherDriversResultsSubmittal.json') as f:
        resForm = json.load(f) 
    # Add library and organization details
    resForm["modeler_organization"] = modeler_organization
    resForm["modeler_organization_for_tables_and_charts"] = modeler_organization_for_tables_and_charts
    resForm["program_name_and_version"] = program_name_and_version
    resForm["program_name_for_tables_and_charts"] = program_name_for_tables_and_charts
    resForm["program_version_release_date"] = program_version_release_date
    resForm["results_submission_date"] = results_submission_date
    #Create new Json result folder
    nJsonRes = os.path.join(mat_dir,'JsonResults')
    if not os.path.exists(nJsonRes):
        os.makedirs(nJsonRes)
    #execute all the Subcases
    if CodeVerbose:
        print(" Converting .mat files into .json and copying it into ".format(nJsonRes))
    Subcases=['Iso','Per']
    for Subcase in Subcases:
        if Subcase in 'Iso':
            CaseDictIsoHor = copy.deepcopy(CaseDict)
            CaseDictIsoHor['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'Per')
            CaseDictIsoHor['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'weaBusDew')
            resFinIsoHor =  WeatherJson(resForm,Matfd,CaseDict)
            with open(os.path.join(nJsonRes,'WeatherIsoHor.json'),'w') as outfile:
                json.dump(resFinIsoHor,outfile, sort_keys=True, indent=4)
            CaseDictIsoDew = copy.deepcopy(CaseDict)              
            CaseDictIsoDew['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'Per')
            CaseDictIsoDew['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'weaBus.TDewPoi')
            resFinIsoDew =  WeatherJson(resForm,Matfd,CaseDict)
            with open(os.path.join(nJsonRes,'WeatherIsoDew.json'),'w') as outfile:
                json.dump(resFinIsoDew,outfile, sort_keys=True, indent=4)
        elif Subcase in 'Per':
            CaseDictPerHor = copy.deepcopy(CaseDict)
            CaseDictPerHor['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'Per')
            CaseDictPerHor['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'weaBusDew')
            resFinPerHor =  WeatherJson(resForm,Matfd,CaseDict)
            with open(os.path.join(nJsonRes,'WeatherPerHor.json'),'w') as outfile:
                json.dump(resFinPerHor,outfile, sort_keys=True, indent=4)
            CaseDictPerDew = copy.deepcopy(CaseDict)
            CaseDictPerDew['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'Per')
            CaseDictPerDew['reVals'] = RemoveString(CaseDictIsoHor['reVals'],'weaBus.TDewPoi')
            resFinPerDew =  WeatherJson(resForm,Matfd,CaseDict)
            with open(os.path.join(nJsonRes,'WeatherPerDew.json'),'w') as outfile:
                json.dump(resFinPerDew,outfile, sort_keys=True, indent=4)
    if DelEvr:
        if CodeVerbose:
            print(" Erasing evrything but .json folder ")
            for matfd in Matfd:
                shutil.rmtree(os.path.dirname(matfd['matFile']))
                
        
 
            
        
