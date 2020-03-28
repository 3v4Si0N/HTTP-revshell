# Powershell HTTP Reverse Shell (for network this http proxy)

## clientHTTP_shell.ps1 - client
Set:
    $attacker_server_url="http://192.168.136.128:4444/"   -  url to your server
    $proxy="127.0.0.1:8080"                               -  proxy server in attacking network

##  server.py

On your server:
    `python server.py`

PORT_NUMBER = 4444                                        - local port

# Wish
upload|download files
