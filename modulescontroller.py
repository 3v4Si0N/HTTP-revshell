
class ModulesController():
    def __init__(self, modules, command_list, command):
        self.modules = modules
        self.command_list = command_list
        self.command = command
        
        cls = self.getClassByName(modules[command_list[0]], command_list[0].capitalize())
        obj = cls(command_list, command)
        self.result = obj.execute()
    
    def __repr__(self):
        return self.result
        
    def getClassByName(self, module, className):
        return getattr(module, className)
