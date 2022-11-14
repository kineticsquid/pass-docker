import sys

def print_usage():
    print("Usage:")
    print("This script looks for the version of a project within a POM file")
    print("\n  find-pom-version.py <POM file path>")

def find_version(line):
    versionIndex = line.find("<version>")
    if versionIndex >= 0:
        endIndex = line.find("</version>")
        return line[versionIndex+9:endIndex] if endIndex else line[versionIndex+9:]
    return None

if len(sys.argv) != 2:
    print("\nERROR! Incorrect number of arguments provided (" + str(len(sys.argv)) + "), expected 1\n")
    print_usage()
    exit(1)

lines = []

with open(sys.argv[1], 'r') as pomFile:
    lines = pomFile.readlines()

parentVersion = None
inProject = False
inParent = False
topLevelElement = None
for line in lines:
    if inProject:
        if topLevelElement != None:
            if inParent and parentVersion == None:
                parentVersion = find_version(line)
            if line.find("</" + topLevelElement + ">") >= 0:
                topLevelElement = None
                if inParent:
                    inParent = False
        else:
            version = find_version(line)
            if version != None:
                print(version)
                exit()
            
            tagIndex = line.find("<")
            if tagIndex >= 0:
                endTagIndex = line.find(">")
                topLevelElement = line[tagIndex+1:endTagIndex]
                if line.find("</" + topLevelElement + ">") >= 0:
                    topLevelElement = None
                elif topLevelElement == "parent":
                    inParent = True
    else:
        projectIndex = line.find("<project")
        if projectIndex >= 0:
            inProject = True

print(parentVersion)