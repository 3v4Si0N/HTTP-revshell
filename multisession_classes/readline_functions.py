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
