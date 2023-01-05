from fileinput import close
import os 
import sys

def print_usage():
    print("Usage:")
    print("This script edits a docker-compose manifest file to include a new version number on a container image.")
    print("\n  update-image.py <manifest file path> <service name> <new container image version>")

def augment_image(imageLabel, serviceName):
    if imageLabel.find("/") == -1:
        return "ghcr.io/eclipse-pass/" + serviceName + ":" + imageLabel
    return imageLabel

# It's possible the final argument was provided via stdin
if len(sys.argv) == 3:
    updatedImage = augment_image(sys.stdin.read().strip(), sys.argv[2])
elif len(sys.argv) != 4:
    print("\nERROR! Incorrect number of arguments provided (" + str(len(sys.argv)) + "), expected 3\n")
    print_usage()
    sys.exit(1)
else:
    updatedImage = augment_image(sys.argv[3], sys.argv[2])

lines = []

with open(sys.argv[1], 'r') as manifestFile:
    lines = manifestFile.readlines()

outputFile = ""
inServices = False
inService = False
updateDone = False
whitespaceLength = 0
whitespace = ""
for line in lines:
    if updateDone:
        outputFile += line
    elif inService:
        if line.lstrip().startswith("image:"):
            imageIndex = line.find("image:")
            whitespace = line[:imageIndex]
            outputFile += whitespace + "image: " + updatedImage + os.linesep
            updateDone = True
        else:
            nonWhitespaceIndex = (len(line) - len(line.lstrip()) - 1)
            if line.lstrip() == "" or nonWhitespaceIndex <= whitespaceLength:
                # If we've exited the service without finding an image: then we need to insert it now
                outputFile += whitespace + "  image: " + updatedImage + os.linesep
                updateDone = True
            outputFile += line
    elif inServices:
        if line.lstrip().startswith(sys.argv[2] + ":"):
            keyIndex = line.find(sys.argv[2])
            whitespace = line[:keyIndex]
            whitespaceLength = len(whitespace)
            inService = True
        outputFile += line
    else:
        if line.lstrip().startswith("services:"):
            inServices = True
        outputFile += line

with open(sys.argv[1], 'w') as yaml_file:
    yaml_file.write(outputFile)

