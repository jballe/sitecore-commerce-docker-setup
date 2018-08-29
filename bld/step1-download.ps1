param(
    $SitecoreDownloadUser = $Null,
    $SitecoreDownloadPass = $Null,
    $FilesPath = (Join-Path $PSScriptRoot "..\files")
)
$ErrorActionPreference = "STOP"

if($SitecoreDownloadUser -eq $Null) {
    $SitecoreDownloadUser = (Read-Host "Enter username for Sitecore site")
}
if($SitecoreDownloadPass -eq $Null) {
    $SitecoreDownloadPass = (Read-Host "Enter password for ${SitecoreDownloadUser}")
}

If(-not (Test-Path $FilesPath)) {
    New-Item $FilesPath -ItemType Directory | Out-Null
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download sitecore files
Write-Host "Login to Sitecore..."
$credentials = @{
    username = $SitecoreDownloadUser
    password = $SitecoreDownloadPass
}
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$login = Invoke-RestMethod -Method Post -Uri "https://dev.sitecore.net/api/authorization" -Body (ConvertTo-Json $credentials) -ContentType "application/json;charset=UTF-8" -WebSession $session
If($login -ne $True) {
    Write-Error "Incorrect username or password"
    return
}

$files = @{
    "Sitecore 9.0.2 rev. 180604 (WDP XP0 packages).zip" = "https://dev.sitecore.net/~/media/F53E9734518E47EF892AD40A333B9426.ashx"
    "Web Forms for Marketers 9.0 rev. 180503.zip" = "https://dev.sitecore.net/~/media/3BFEB7C427D040178E619522EA272ECC.ashx"
    "Sitecore Experience Accelerator 1.7.1 rev. 180604 for 9.0.zip" = "https://dev.sitecore.net/~/media/1FF242BE683E4DE989925F74B78978FC.ashx"
    "Sitecore.Commerce.2018.07-2.2.126.zip" = "https://dev.sitecore.net/~/media/F374366CA5C649C99B09D35D5EF1BFCE.ashx"
}

foreach ($target in $files.Keys) {
    $source = $files.Item($target)

    $fullPath = (Join-Path $FilesPath $target)
    If(-not (Test-Path $fullPath)) {
        Invoke-WebRequest -WebSession $session -Verbose -Uri $source -OutFile $fullPath        
    } else {
        Write-Host "${target} already exists"
    }
}

nuget install Microsoft.Web.Xdt -Version 2.1.2 -OutputDirectory $FilesPath

Invoke-WebRequest -Uri "https://github.com/ewerkman/plumber-sc/archive/1.0-beta-6.zip" -OutFile "${FilesPath}\plumber.zip"