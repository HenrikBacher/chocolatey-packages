﻿$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%206.0.1-latest.20220810.2.exe'
$checksum               = '2da792098f2244f0f141a9df00f9ec5db11832de718beddae363fcfa3f945dfa'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

if ( $pp.ALLUSERS) {

  $packageArgs = @{
    packageName           = $env:ChocolateyPackageName
    unzipLocation         = $toolsDir
    fileType              = 'exe'
    softwareName          = 'Lens*'
    url                   = $url
    checksum              = $checksum
    checksumType          = $checksumType
    silentArgs            = '/allusers /disableAutoUpdates /S'
    validExitCodes        = @(0, 3010, 1605, 1614, 1641)
  }

  Install-ChocolateyPackage @packageArgs

} else {

  $packageArgs = @{
    packageName           = $env:ChocolateyPackageName
    unzipLocation         = $toolsDir
    fileType              = 'exe'
    softwareName          = 'Lens*'
    url                   = $url
    checksum              = $checksum
    checksumType          = $checksumType
    silentArgs            = '/currentuser /disableAutoUpdates /S'
    validExitCodes        = @(0, 3010, 1605, 1614, 1641)
  }

  Install-ChocolateyPackage @packageArgs

}
