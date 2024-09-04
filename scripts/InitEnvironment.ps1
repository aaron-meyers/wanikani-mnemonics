$scriptsPath = $PSScriptRoot
if (Test-Path $scriptsPath) {
    Write-Host "Adding wanikani scripts path $scriptsPath to PATH"
    $env:PATH = '{0}{1}{2}' -f $scriptsPath,[IO.Path]::PathSeparator,$env:PATH
} else {
    Write-Warning "Cannot find wanikani scripts path $scriptsPath"
}

if (-not (Get-Module PSOpenAI -ListAvailable)) {
    Write-Warning 'PSOpenAI module is not installed'
}