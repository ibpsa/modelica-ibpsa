# Python script for managing the stopTime value between the .mos scripts and the annotation
#
# The .mos scripts are in the folder ../Buildings/Resources/Scripts/Dymola/...
# look at every .mos script and identify the name of the model that is simulated in the
# .mos file (typically these are examples)
#
# Once you know the model name,

import os
import re

def recursive_glob(rootdir='.', suffix=''):
    return [os.path.join(rootdir, filename) for rootdir, dirnames, filenames in os.walk(rootdir) for filename in filenames if ( filename.endswith(suffix) and ("ConvertBuildings_from" not in filename)) ]


mos_files = recursive_glob('../Annex60/Resources/Scripts/Dymola', '.mos')

mo_files = recursive_glob('../Annex60/', '.mo')

# number of modified models
N_modify_mos = 0
    
# number of modified models
N_modify_models = 0
    
# number of .mos scripts with problems
N_mos_problems = 0

def capitalize_first(name):
    lst = [word[0].upper() + word[1:] for word in name.split()]
    return " ".join(lst)

def write_file(mos_file, content):
    
    # Delete the old file
    # print "\tDeleting the old mos script..."
    os.system("rm "+mos_file)

    # Create a new one with the same name
    fm = open(mos_file,"w")

    for line in content:
        fm.write(line)

    # close and exit
    fm.close()
    
    
def replace_content(content, name, value, para, foundStop):
    # Delete the old file
    i=0
    while i < len(content):
        line = content[i]
        i += 1
        # Remove white spaces
        line.replace(" ", "")
        if ""+name+"="+"" in line:
            newLine = line.replace(""+name+"="+"" + str(value), ""+name+"="+""+str(para))
            content[i-1] = newLine
            foundStop = True
            return foundStop, content
    

def replace_stoptime(content, name, value, foundStop):
    # Delete the old file
    i=0
    while i < len(content):
        line = content[i]
        i += 1
        # Remove white spaces
        line.replace(" ", "")
        if "stopTime=" in line:
            newLine = line.replace("stopTime" , ""+name+"="+"" + str(value) + ", stopTime")
            content[i-1] = newLine
            foundStop = True
            return foundStop, content

def replace_resultfile(content, name, value, foundStop):
    # Delete the old file
    i=0
    while i < len(content):
        line = content[i]
        i += 1
        # Remove white spaces
        line.replace(" ", "")
        if "resultFile=" in line:
            newLine = line.replace("resultFile" , ""+name+"="+"" + str(value) + ", resultFile")
            content[i-1] = newLine
            foundStop = True
            return foundStop, content

# Number of .mos files
N_mos_files = len(mos_files)

def fixParameters (name):

    global N_modify_models
    global N_modify_mos
    global N_mos_problems   

    N_modify_models=0
    N_modify_mos=0
    N_mos_problems=0

    j = 1
    for mos_file in mos_files:
        os.system("clear")
        #print str(j)+": "+str(mos_file)
        j += 1
        
        f = open(mos_file,"r")
        
        content = f.readlines()
        found = False
        i = 0
        while found == False and i<len(content):
            l = content[i]
            if "simulateModel(" in l:
                line = l
                found = True
            i += 1
        
        #print "\n\tContains: "+str(line)
        
        # The format is simulateModel("MODEL.PATH.NAME", xxx***, stopTime=#####.###, ***);
        
        # Remove white spaces
        line.replace(" ", "")
        
        try:
            pModel    = re.compile('simulateModel\("([^\(|^"]+)[\S]*"')
            mModel    = pModel.match(line)
            modelName = mModel.group(1)
            if ""+name+"="+name+"" in line:
                value = ""+name+""
            elif ""+name+"="+"" in line:
                # Old version, does not work with 86400*900
                # pTime    = re.compile(r"[\d\S\s.,]*(stopTime=)([\d]*[.]*[\d]*[e]*[+|-]*[\d]*)")
                pTime    = re.compile(r"[\d\S\s.,]*("+name+"=)([\d]*[.]*[\d]*[eE]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[eE]*[+|-]*[\d]*)")
                mTime    = pTime.match(line)
                value = mTime.group(2)
                if (""+name+"="+"" == "tolerance=" and float(value) > 1e-6):
                    foundStop = False
                    #tolerance="1e-6"
                    consPar="1e-6"
                    foundStop, content = replace_content(content, name, value, consPar, foundStop)
                    #print "\t================================="
                    #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MOS (N/y)?")
                    #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MOS (N/y)?")
                    #rewrite = 'y'
                    #if rewrite == 'y':
                    write_file(mos_file, content)    
                if (""+name+"="+"" == "numberOfIntervals=" and (float(value) != 0 and float(value) < 500)):
                    foundStop = False
                    #tolerance="1e-6"
                    consPar="500"
                    foundStop, content = replace_content(content, name, value, consPar, foundStop)
                    #print "\t================================="
                    #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MOS (N/y)?")
                    #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MOS (N/y)?")
                    #rewrite = 'y'
                    #if rewrite == 'y':
                    write_file(mos_file, content)       
            else:
                # print "\tThe name is not in the simulation command row... go ahead"
                found = False
                while found == False and i<len(content):
                    line = content[i]
                    i += 1
                    # Remove white spaces
                    line.replace(" ", "")
                    
                    if ""+name+"="+"" in line:
                        found = True
                        pTime    = re.compile(r"[\d\S\s.,]*("+name+"=)([\d]*[.]*[\d]*[eE]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[eE]*[+|-]*[\d]*)[\S\s.,]*")
                        mTime    = pTime.match(line)
                        value = mTime.group(2)
                        #startTime = startTime[:-1]
                    if ""+name+"="+name+"" in line:
                        value = ""+name+""
                            
                if found == False:
                    if (name=="startTime"):
                        #print "\t"+ name + " not found, defined the default startTime=0.0"
                        value = "0.0"
                    elif (name=="stopTime"):
                        #print "\t"+ name + " not found, defined the default stopTime=1.0"
                        value="1.0"
                    elif(name=="tolerance"):
                        #print "\t"+ name + " not found, defined the default tolerance=1e-6"
                        value="1e-6"
                    elif(name=="numberOfIntervals"):
                        #print "\t"+ name + " not found, defined the default numberOfIntervals=500"
                        value="500"
                    foundStop=False
                    if (name=="stopTime"):
                        foundStop, content = replace_resultfile(content, name, value, foundStop)
                    else:
                        foundStop, content = replace_stoptime(content, name, value, foundStop)
                    if foundStop == False:
                        #print("stopTime not found in simulateModel() for model " 
                        #+ mos_file + ". This needs to be present. Please correct the mos file.")
                        exit(1)
                    #print "\t================================="
                    #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MOS (N/y)?")
                    #rewrite = 'y'
                    #if rewrite == 'y':
                    write_file(mos_file, content) 
                    
		    #print "\tNew mos script is available!"
                    N_modify_mos += 1    
    
            #print "\t" + name + ": " +str(value)
            #print "\tModelName: "+str(modelName)
    
    
        except AttributeError:
            #print "\tThe script does not contain the simulation command! Maybe it is a plot script..."
            value = "NA"
            N_mos_problems += 1
            
        if (""+name+"="+"" != "numberOfIntervals=" ):
            if value != "NA" and value != ""+name+"":        
                
                modelPath = ""
                modelPath = modelName.replace(".", "/")
                modelPath = "../"+modelPath+".mo"
            
                #print "\n\tThe model is here: "+str(modelPath)
                fm = open(modelPath,"r")
                
                modelContent = fm.readlines()
                Nlines = len(modelContent)
                
                found = False
                
                for i in range(Nlines-1, 0, -1):
                    
                    line = modelContent[i]
                    
                    # if the lines contains experiment stop time, replace it
                    # experiment(StopTime=2)
                    if ""+capitalize_first(name)+"="+"" in line and not found:
                        # found the stopTime assignment, replace with the value in the mos file
                        #print "\t==================="
                        #print "\t REPLACE"
                        #print "\t"+line
                        
                        pStopTime    = re.compile(r"[\d\S\s.,]*("+capitalize_first(name)+"=[\d]*[.]*[\d]*[eE]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[eE]*[+|-]*[\d])")
                        mStopTime    = pStopTime.match(line)
                        stopTimeStr  = mStopTime.group(1)
                        
                        newLine = line.replace(stopTimeStr,""+capitalize_first(name)+"="+""+str(value))
                        #print "\t WITH"
                        #print "\t"+newLine
                        
                        # replace
                        modelContent[i] = newLine
                        found = True
                    
                    # check if we shouldn't remove spaces in lines to avoid this?
                    if ("annotation (" in line or "annotation(" in line or " annotation(" in line) and not found:    
                        # we reach the beginning of the annotation and we don't found the stop time
                        # let's add it
                        #print "\t=============================================="
                        #print "\t NOT FOUND, ADD Start time STATEMENT. REPLACE "
                    
                        # if true, reached the end of the annotations
                        # Go back and look for the __DymolaCommand and replace it adding the experiment
                        # stopTime command
                        for k in range(Nlines-1, i-1, -1):
                            
                            line = modelContent[k]
                            line.replace(" ", "")
                            if (name=="stopTime"):
                                #print "\t"+line
                                newLine = line.replace("__Dymola_Commands(" , "\nexperiment(StopTime="+str(value)+"),\n__Dymola_Commands(")
                                #print "\t WITH"
                                #print "\t"+newLine
                                # replace
                                modelContent[k] = newLine
                                # replacement done
                                found = True    
                                
                            else:
                                if "StopTime=" in line:
                                    #print "\t"+line
                                    newLine = line.replace("StopTime" , ""+capitalize_first(name)+"="+""+str(value)+", StopTime")
                                    #print "\t WITH"
                                    #print "\t"+newLine
                                    
                                    # replace
                                    modelContent[k] = newLine
                                    
                                    # replacement done
                                    found = True    
                
                # rewrite in an other file with the same name
                #fm.close()
                
                #print "\t================================="
                #rewrite = raw_input("\n\tARE YOU SURE TO REWRITE THE MO (N/y)?")
                #rewrite = 'y'
                #if rewrite == 'y':
                write_file(modelPath, modelContent)
                #print "\tNew model is available!"
                N_modify_models += 1  
                
            elif value == ""+name+"":
                #print "\n\t*******************************"
                print "\tDO THAT MODIFICATION AT HAND!!!"
            
        f.close()
        
    #raw_input("\n\tContinue?")
    
    
if __name__ == "__main__":

    for i in ["stopTime", "tolerance", "tolerance", "startTime", "numberOfIntervals"]:
        fixParameters(i)
        print "Fixing ***"  + str(i) + "*** in the Modelica files."
        print "\n* Number of mos files = "+str(len(mos_files))
        print "\n* Number of modified mo = "+str(N_modify_models) 
        print "\n* Number of modified mos = "+str(N_modify_mos)
        print "\n* Number of mos scripts with problems = "+str(N_mos_problems)
        print "\n"
    n_files_tol=0
    n_files_fmus=0
    for mos_file in mos_files:
        f = open(mos_file,"r")
        content = f.readlines()
        found = False
        i=0
        while found == False and i<len(content):
            l = content[i]
            if "tolerance=1e" in l.lower():
                line = l
                found = True
                n_files_tol += 1
                break
            elif ("translateModelFMU" in l):
                n_files_fmus += 1
            i += 1
        # File which contains the translateModel command are not valid
        # mos file
        #if found == False and  'FMUs' in mos_file:
        #    n_files_fmus += 1       
        f.close()  
    print "Number of mos files found " + str (len(mos_files))
    print "Files found with **tolerance** " + str (n_files_tol)
    print "Files found with **translateModelFMU** " + str (n_files_fmus)
    print "Number of files expected with **tolerance** " + str (len(mos_files) - n_files_fmus)

