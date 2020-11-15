from termcolor import colored
import base64

class Download():
    def __init__(self, command_list, command):
        self.command_list = command_list
        self.command = command
        
    def printResult(self, result, color):
        print(colored(result, color))

    def execute(self):
        html = ""
        try:
            download = self.command_list[0]
            srcFile = self.command_list[1]
            dstFile = self.command_list[2]
        except IndexError:
            print (colored("\r\n[!] Source and/or destination file not found!", "red"))
            print (colored("\t- Usage: download C:\\src\\path\\file /dst/path/file\n", "red"))
        
        return html
            
 
        
