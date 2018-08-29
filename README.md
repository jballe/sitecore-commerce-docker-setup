# Setup local docker images

This is just some scripts to download assets and generate docker images as provided by [sitecore-docker](https://github.com/avivasolutionsnl/sitecore-docker) and [sitecore-commerce-docker](https://github.com/avivasolutionsnl/sitecore-commerce-docker).

Place your license.xml in the folder or call the script with argument, eg.

```powershell
./run.ps1 -LicenseFile e:\Sitecore\license.xml
```

The script will ask for your username and password to [dev.sitecore.net](https://dev.sitecore.net) and use that to login and download the right assets, expand and prepare so that the docker images can be built.