param(
    $SitecoreDownloadUser = $Null,
    $SitecoreDownloadPass = $Null,
    $LicenseFile = (Join-Path $PSScriptRoot "../license.xml" -Resolve)
)
$ErrorActionPreference = "STOP"

if($SitecoreDownloadUser -eq $Null) {
    $SitecoreDownloadUser = (Read-Host "Enter username for Sitecore site")
}
if($SitecoreDownloadPass -eq $Null) {
    $SitecoreDownloadPass = (Read-Host "Enter password for ${SitecoreDownloadUser}")
}

$params = @{
    SitecoreDownloadUser = $SitecoreDownloadUser
    SitecoreDownloadPass = $SitecoreDownloadPass
    LicenseFile = $LicenseFile
}

& "$PSScriptRoot/bld/step1-download.ps1" @params
& "$PSScriptRoot/bld/step2-expand.ps1" @params
& "$PSScriptRoot/bld/step3-sitecore-docker.ps1" @params
& "$PSScriptRoot/bld/step4-sitecore-commerce-docker.ps1" @params