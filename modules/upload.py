from termcolor import colored
import base64

class Upload():
    def __init__(self, command_list, command):
        self.command_list = command_list
        self.command = command
        
    def printResult(self, result, color):
        print(colored(result, color))

    def execute(self):
        html = ""
        try:
            if (len(self.command_list) == 3 or self.command[-1] == '"'):
                if '"' in self.command_list[1]:
                    filename = self.command.split('"')[1]
                else:
                    filename = self.command_list[1]
            elif ('"' in self.command_list[1]):
                filename = self.command.split('"')[1]

            try:
                with open(filename, mode='rb') as f: # b is important -> binary
                    html = base64.b64encode(f.read()).decode('utf-8')
            except FileNotFoundError:
                print (colored("\r\n[!] Source file not found!", "red"))
        except (AttributeError, IndexError, UnboundLocalError) as e:
            print (colored("\r\n[!] Source and/or destination file not found!", "red"))
            print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
        return html
            
 
        
