﻿$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/start/Start11_Setup.exe'
$checksum               = 'b1bfabd16927a5b5e80c5b9a6893cd6c15c0eee6a89df5e6e3a081036a3d22ef'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Start11*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 10 or 11... ***`n"
  throw
}ElseIf (Test-Path ${env:ProgramFiles(x86)}"\Stardock\Start10\") {
  Write-Warning "*** Stardock Start10 was found and is about to uninstall. If asked to reboot, select 'No', however, you must reboot to finish fully uninstalling the package.`n"

  $paths = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
  $uninstallString = Get-ChildItem $paths | Where-Object { $_.GetValue('DisplayName') -Match 'Stardock Start10' } | ForEach-Object { $_.GetValue('UninstallString') }

  & cmd /c $uninstallString
}

Install-ChocolateyPackage @packageArgs
