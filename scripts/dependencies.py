from subprocess import run as _run, Popen, PIPE
from os import chdir, fdopen, getcwd, environ
import json
import os


def run(script, capture_output=False, text=False, input=None, encoding=None):
    '''
        Run the given `script` in shell
    '''
    return _run(script, shell=True, capture_output=capture_output, text=text, input=input, encoding=encoding)


def readjson(filepath):
    with open(filepath) as jsonfile:
        return json.load(jsonfile);


def writejsonfile(filepath, mapdata):
    with open(filepath, 'w+') as jsonfile:
        json.dump(mapdata, jsonfile, indent=2)   

def writestrtofile(filepath, contain):
    with fdopen(os.open(filepath, os.O_WRONLY | os.O_CREAT, 0o600), 'w') as sfile: # Write file with permition rw-------
        sfile.write(contain)   

