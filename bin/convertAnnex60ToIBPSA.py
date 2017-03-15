import os
import re

dryRun=True;

annex60Name = "Annex60"
newName = "IBPSA"

annex60Github = "github.com/iea-annex60/modelica-annex60"           # do not add 'https://' or 'www'  , this is treated by regex
newGithub = "github.com/ibpsa/modelica"     # do add https here

annex60Website = "iea-annex60.org"                 # do not add 'https://' or 'www' , this is treated by regex
# newWebsite = "https://ibpsa.github.io/project1"    # do add https here


path = os.path.dirname(os.path.realpath(__file__))
annex60Path = os.path.join(path[:-4],annex60Name)

# flag all references to the Annex 60 website
for path, subdirs, files in os.walk(annex60Path):
    for fileName in files:
        filePath=os.path.join(path,fileName)
        with open(filePath,'r') as f:
            text = f.read()
            filePath=os.path.join(path,fileName)


            matchString=r'(^.*(https?://)?(www\.)?' + annex60Website + '.*)$'        # annex60Github url with optionally prepended http[s] and/or www.
            it = re.finditer(matchString, text, flags=re.MULTILINE)
            for match in it:
                print "found reference to annex60 website in: " + filePath
                print match.group()

# replace stuff
for path, subdirs, files in os.walk(annex60Path):
    for fileName in files:
        filePath=os.path.join(path,fileName)
        if filePath.endswith('.mo') or filePath.endswith('.mos'):
            with open(filePath,'r') as f:
                text = f.read()
                resultText=text

                print "============================================"
                print "Starting conversion for file " + filePath

                # replace instances of modelica://Annex60/path
                matchString=r'modelica://(' + annex60Name + r')\..*$'   # matches of modelica://Annex60/something
                it = re.finditer(matchString, resultText, flags=re.MULTILINE)
                for match in it:
                    matchText = match.group(0)
                    replaceText = matchText.replace('modelica://' + annex60Name, 'modelica://' + newName) # append modelica:// to avoid accidentally replacing other stuff that contains Annex60
                    if not dryRun:
                        resultText=resultText.replace(matchText,replaceText, 1)     # only replace first instance since others are treated by iterator later
                    print "replacing " + matchText + " \nby " + replaceText+ "\n"


                # replace all references to the annex60 github page
                matchString=r'((https?://)?(www\.)?' + annex60Github + ').*$'        # annex60Github url with optionally prepended http[s] and/or www.
                it = re.finditer(matchString, resultText, flags=re.MULTILINE)

                for match in it:
                    matchText = match.group(1)
                    if not dryRun:
                        resultText=resultText.replace(matchText,newGithub, 1)       # only replace first instance since others are treated by iterator later
                    print "replacing " + matchText + " \nby " + replaceText + "\n"

                # replace references to buildings github that were wrongly replaced by link to annex60
                if not dryRun:
                    resultText=resultText.replace("github.com/lbl-srg/modelica-Annex60","github.com/lbl-srg/modelica-buildings")


                # replace all remaining references to 'Annex60'
                matchString=r'^.*' + annex60Name + '.*$'                            # fetch whole line such that it can be printed
                it = re.finditer(matchString, resultText, flags=re.MULTILINE)
                for match in it:
                    matchText = match.group(0)
                    matchTextNew = matchText
                    print "replacing " + annex60Name + " in line:\n" + matchText+ "\n"
                    matchTextNew = matchTextNew.replace(annex60Name, newName)       #replaces all instances
                    if not dryRun:
                        resultText=resultText.replace(matchText,matchTextNew, 1)    # only replace first instance since others are treated by iterator later

                # replace all remaining lower case references to 'Annex60'
                matchString=r'^.*' + annex60Name.lower() + '.*$'                            # fetch whole line such that it can be printed
                it = re.finditer(matchString, resultText, flags=re.MULTILINE)
                for match in it:
                    matchText = match.group(0)
                    print "replacing " + annex60Name.lower() + " in line:\n" + matchText.lower()+ "\n"
                    matchTextNew = matchText.replace(annex60Name.lower(), newName.lower())       #replaces all instances
                    if not dryRun:
                        resultText=resultText.replace(matchText,matchTextNew, 1)    # only replace first instance since others are treated by iterator later

                # write back the result
                with open(filePath,'w') as f:
                    f.write(resultText)

        # rename files containing 'Annex60' in the name
        if annex60Name in fileName:
            newFilePath = os.path.join(path, fileName.replace(annex60Name,newName))
            print "renaming file " + filePath + " into " + newFilePath
            if not dryRun:
                os.rename(filePath, newFilePath)
