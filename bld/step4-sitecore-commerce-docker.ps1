param(
    $SitecoreDockerRoot =  (Join-Path $PSScriptRoot "..\sitecore-docker" -Resolve),
    $SitecoreCommerceDockerRoot =  (Join-Path $PSScriptRoot "..\sitecore-commerce-docker" -Resolve),
    $LicenseFile = (Join-Path $PSScriptRoot "../license.xml" -Resolve)
)
$ErrorActionPreference = "STOP"

Push-Location $SitecoreCommerceDockerRoot
Try {
    $foldersToCreate = @(
        ".\logs\sitecore",
        ".\logs\xconnect",
        ".\logs\commerce\CommerceAuthoring_Sc9",
        ".\logs\commerce\CommerceMinions_Sc9",
        ".\logs\commerce\CommerceOps_Sc9",
        ".\logs\commerce\CommerceShops_Sc9",
        ".\logs\commerce\SitecoreIdentityServer",
        "\wwwroot\sitecore",
        "files"
    )
    $foldersToCreate | ForEach-Object {
        $fullPath = (Join-Path $SitecoreCommerceDockerRoot $_)
        If(-not (Test-Path $fullPath)) {
            New-Item $fullPath -ItemType Directory | Out-Null
        }
    }

    $commerceFilesPath = (Join-Path $SitecoreCommerceDockerRoot "files" -Resolve)
    Copy-Item $LicenseFile -Destination $commerceFilesPath

    if(@(Get-ChildItem $commerceFilesPath -Filter *.pfx).Length -eq 0) {
        & ./Generate-Certificates.ps1
    } Else {
        Write-Host "Certificates aready generated"
        Copy-Item (Join-Path $SitecoreDockerRoot "files\*.pfx") $commerceFilesPath -Force -Verbose
    }

    Write-Host "Now try to start docker-compose build..."
    & docker-compose build
    & cmd /c start https://sitecore/sitecore
} Finally {
    Pop-Location
}