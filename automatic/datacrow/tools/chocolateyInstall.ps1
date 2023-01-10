﻿$packageName = 'datacrow'
$installerType = 'exe'
$silentArgs = ''
$url = 'https://sourceforge.net/projects/datacrow/files/latest/download'
$checksum = '542930397d7b4cdfd112253eb40c2f04d48ef239fc18cb4a1666ee7c9aeacd87'
$checksumType = 'sha256'
$validExitCodes = @(0)

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$silentArgs32 = "$toolsDir\chocolateyInstall32.xml"
$silentArgs64 = "$toolsDir\chocolateyInstall64.xml"

$tempDir = Join-Path $env:Temp "$packageName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir) | Out-Null}
$tempDir = Join-Path $tempDir $env:packageVersion
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir) | Out-Null}
$zipFile = Join-Path $tempDir 'datacrow_windows_installer.zip'
$installFile32 = "$tempDir\setup32bit.exe"
$installFile64 = "$tempDir\setup64bit.exe"

Get-ChocolateyWebFile -PackageName "$packageName" `
                      -FileFullPath "$zipFile" `
                      -Url "$url" `
                      -Checksum "$checksum" `
                      -ChecksumType "$checksumType"

Get-ChocolateyUnzip -FileFullPath "$zipFile" `
                    -Destination "$tempDir" `
                    -PackageName "$packageName"

if ((Get-ProcessorBits 64) -and ($env:chocolateyForceX86)) {
  $installFile = $installFile32
  $silentArgs = $silentArgs32
}
if ((Get-ProcessorBits 64) -and (-not($env:chocolateyForceX86))) {
  $installFile = $installFile64
  $silentArgs = $silentArgs64
}
if (-not(Get-ProcessorBits 64)) {
  $installFile = $installFile32
  $silentArgs = $silentArgs64
}

Start-ChocolateyProcessAsAdmin -Statements "/c `"$installFile`" $silentArgs" `
                               -ExeToRun "cmd.exe"
