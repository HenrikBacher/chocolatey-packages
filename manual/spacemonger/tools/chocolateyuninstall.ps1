﻿$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = "EdgeRunner SpaceMonger*"
  fileType      = 'exe'
  silentArgs    = '"/U:' + ${env:ProgramFiles(x86)} + '\EdgeRunner\SpaceMonger\Uninstall\uninstall.xml"'
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"

      $packageArgs['file'] = ''
    }

    #Uninstall-ChocolateyPackage @packageArgs
    Write-Warning "Stardock SpaceMonger is about to uninstall. If asked to reboot, select 'No', however, you must reboot prior to reinstalling the package.`n`nSelect [Y] to continue.`n"
    ${env:ProgramFiles(x86)} + "\EdgeRunner\SpaceMonger\uninstall.exe" + " $($packageArgs['silentArgs'])" #> $null

  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}
