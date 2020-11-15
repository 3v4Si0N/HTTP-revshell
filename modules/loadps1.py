from termcolor import colored
import base64

class Loadps1():
    def __init__(self, command_list, command):
        self.command_list = command_list
        self.command = command
        
    def printResult(self, result, color):
        print(colored(result, color))

    def execute(self):
        html = ""
        try:
            filename = self.command_list[1]
            try:
                with open(filename, "rb") as f:
                    html = base64.b64encode(f.read()).decode()[::-1]
            except FileNotFoundError:
                print (colored("\r\n[!] File not found!", "red"))
        except IndexError:
            print (colored("\r\n[!] file not found!", "red"))
            print (colored("\t- Usage: load /path/to/file/to/load.ps1\n", "red"))
        return html
            
 
        
