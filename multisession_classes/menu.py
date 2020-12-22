from prettytable import PrettyTable
import globals, multisession_classes.readline_functions
from termcolor import colored

class Menu():
    def printSessionTable(self):
        t = PrettyTable(["Session ID", "IP", "Username", "Hostname", "Client ID"])
        for client_id in globals.CLIENT_DICT.keys():
            t.add_row([globals.CLIENT_DICT[client_id]["session"], globals.CLIENT_DICT[client_id]["IP"], globals.CLIENT_DICT[client_id]["username"], globals.CLIENT_DICT[client_id]["hostname"], globals.CLIENT_DICT[client_id]["client_id"]])
        print(colored(t.get_string(title="Sessions"), "green"))

    def construct_menu(self, menu, server):
        if menu[0] == "sessions":
            self.printSessionTable()

        elif menu[0] == "exit":
            server.server_close()
            exit(0)

        elif menu[0] == "help":
            rf = readline_functions.Readline_functions()
            rf.main_help_banner()
        
        elif menu[0] == "interact":
            if len(globals.CLIENT_DICT) == 0:
                print(colored("[!] Sorry, there are no clients!", "red"))
            else:
                try:
                    for client_id in list(globals.CLIENT_DICT.keys()):
                        if globals.CLIENT_DICT[client_id]["session"] == int(menu[1]):
                            globals.CURRENT_CLIENT = client_id
                    while True:
                        if globals.KEY_PULSED:
                            globals.KEY_PULSED = False
                            break
                        request, client_address = server.get_request()

                        if globals.CLIENT_DICT[globals.CURRENT_CLIENT]["IP"] == client_address[0]:
                            if server.verify_request(request,client_address):
                                server.process_request(request,client_address)
                        else:
                            server.finish_request(request, client_address)
                except ValueError:
                    print (colored("[!] Session number {} doesn't exist".format(menu[1]), "red"))
