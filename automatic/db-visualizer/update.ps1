$ErrorActionPreference = 'Stop'
import-module au

$releases = 'https://www.dbvis.com/download'

function global:au_SearchReplace {
	@{
		'tools/chocolateyInstall.ps1' = @{
			"(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
			"(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
			"(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
		}
	}
}

function global:au_GetLatest {
	Write-Output 'Check Folder'
	$links = $(((Invoke-WebRequest -Uri $releases -UseBasicParsing).Links | Where-Object  {$_.href -match 'dbvis_windows'} | Where-Object  {$_.href -match 'exe'} | Where-Object {$_.href -notMatch '_jre'})).href | Select-Object -First 1

	$version = $links.split('-')[-1].replace('x64_','').replace('.exe','').replace('_','.')
	if($version -eq '13.0.4') {
		$version = '13.0.4.22060901'
	}

	$url64 = $links

	$Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
	return $Latest
}

update
