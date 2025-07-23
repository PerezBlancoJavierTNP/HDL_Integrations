Param([Hashtable]$parameters)

Import-Module T3PALAppsBuilder

# Download dependencies

[string] $appsVersionsList = ""
$parameters.missingDependencies | ForEach-Object {   
    $appid = $_.Split(':')[0]
    $appName = $_.Split(':')[1]
    $version = $appName.SubString($appName.LastIndexOf('_') + 1)
    $version = $version.SubString(0, $version.Length - 4)
    if ([System.String]::IsNullOrWhiteSpace($appsVersionsList)) {
        $appsVersionsList = ($appsVersionsList + ",")
        $appsVersionsList = ($appsVersionsList + $appid + ":" + $version)
    }
}

[string]$appsTempFolder = [System.IO.Path]::GetTempPath()
[string]$appsSubFolderName = [System.Guid]::NewGuid()
$appsTempFolder = Join-Path -Path $appsTempFolder -ChildPath $appsSubFolderName
New-Item -ItemType Directory -Path $appsTempFolder | Out-Null

$nuGetServerApiKey = $env:NuGetApiKey
Write-Host "Downloading dependencies from TNP Extension Source"
Write-Host "  Apps: $appsVersionsList"
Write-Host "  Temp path: $appsTempFolder"

$appsLocationsList = Get-T3PALAppFromNuGet -Apps $appsVersionsList -Destination $appsTempFolder -ApiKey $nuGetServerApiKey

# Installing missing dependencies
Write-Host "Install missing dependencies"

$copyInstalledAppsToFolder = $null
if ($parameters.ContainsKey('CopyInstalledAppsToFolder')) {
    $copyInstalledAppsToFolder = $parameters.CopyInstalledAppsToFolder
}

$appsLocationsList | ForEach-Object {
    $appLocation = $_
    if (![System.String]::IsNullOrWhiteSpace($appLocation)) {
        if ($parameters.ContainsKey('containerName')) {
            Publish-BcContainerApp -containerName $parameters.containerName -tenant $parameters.tenant -appFile $appLocation -sync -install -upgrade -checkAlreadyInstalled -skipVerification -copyInstalledAppsToFolder $copyInstalledAppsToFolder
        }
        else {
            Copy-Item -Path $appLocation -Destination $parameters.appSymbolsFolder
        }
    }
}

