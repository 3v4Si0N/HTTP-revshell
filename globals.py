from os import listdir, sep, path

def initialize(): 
    global CLIENT_DICT
    global CURRENT_CLIENT
    global KEY_PULSED
    global MODULES
    global AUTOCOMPLETE
    CLIENT_DICT = {}
    CURRENT_CLIENT = ""
    KEY_PULSED = False
    MODULES = loadModules()
    AUTOCOMPLETE = False
    
def loadModules():
    res = {}
    # check subfolders
    lst = listdir("modules")
    dir = []
    for d in lst:
        s = path.abspath("modules") + sep + d
        if path.isdir(s) == False:
            dir.append(d.split(".")[0])
    # load the modules
    for d in dir:
        res[d] = __import__("modules." + d, fromlist = ["*"])
    return res
