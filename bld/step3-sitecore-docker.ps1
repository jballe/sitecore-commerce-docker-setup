param(
    $SitecoreDockerRoot =  (Join-Path $PSScriptRoot "..\sitecore-docker" -Resolve),
    $LicenseFile = (Join-Path $PSScriptRoot "../license.xml" -Resolve)
)
$ErrorActionPreference = "STOP"

Push-Location $SitecoreDockerRoot
Try {
    $foldersToCreate = @(
        "logs\sitecore",
        "logs\xconnect",
        "\wwwroot\sitecore",
        "files"
    )

    $foldersToCreate |ForEach-Object {
        $fullPath = (Join-Path $SitecoreDockerRoot $_)
        If(-not (Test-Path $fullPath)) {
            New-Item $fullPath -ItemType Directory | Out-Null
        }
    }

    Copy-Item $LicenseFile -Destination (Join-Path $SitecoreDockerRoot "files" -Resolve)

    if(@(Get-ChildItem (Join-Path $SitecoreDockerRoot "files") -Filter *.pfx).Length -eq 0) {
        & ./Generate-Certificates.ps1
    } Else {
        Write-Host "Certificates aready generated"
    }

    Write-Host "Now try to start docker-compose build..."
    & docker-compose build
    & cmd /c start https://sitecore/sitecore
} Finally {
    Pop-Location
}