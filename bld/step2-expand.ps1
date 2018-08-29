param(
    $FilesPath = (Join-Path $PSScriptRoot "..\files"),
    $SitecoreDockerRoot =  (Join-Path $PSScriptRoot "..\sitecore-docker" -Resolve),
    $SitecoreCommerceDockerRoot =  (Join-Path $PSScriptRoot "..\sitecore-commerce-docker" -Resolve)
)
$ErrorActionPreference = "STOP"

$SitecoreDockerFiles = (Join-Path $SitecoreDockerRoot "files")
$SitecoreCommerceFiles = (Join-Path $SitecoreCommerceDockerRoot "files")

If(-not (Test-Path $SitecoreDockerFiles)) {
    New-Item $SitecoreDockerFiles -ItemType Directory | Out-Null
}

Expand-Archive "${FilesPath}\Sitecore 9.0.2 rev. 180604 (WDP XP0 packages).zip" -DestinationPath $SitecoreDockerFiles -Force
Expand-Archive "${FilesPath}\Sitecore.Commerce.2018.07-2.2.126.zip" -DestinationPath $SitecoreCommerceFiles -Force

Copy-Item "${FilesPath}\Microsoft.Web.Xdt.2.1.2\lib\net40\Microsoft.Web.XmlTransform.dll" $SitecoreCommerceFiles -Force
Copy-Item "${FilesPath}\plumber.zip" $SitecoreCommerceFiles -Force