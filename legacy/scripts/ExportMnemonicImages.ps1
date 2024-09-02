param(
    [Parameter()]
    [String]
    $Path = '.'
)

& "$PSScriptRoot/GetMnemonicImages.ps1" |
    Foreach-Object {
        $targetDir = Join-Path $Path $_.SubjectType
        if (-not (Test-Path $targetDir)) {
            [void](New-Item $targetDir -ItemType Directory)
        }
        $targetFile = Join-Path $targetDir $_.FileName
        if (Test-Path $targetFile) {
            Write-Host "Skipping existing $targetFile"
        } else {
            Invoke-WebRequest $_.Url -OutFile $targetFile
            Write-Host "Saved $targetFile, sleeping for 1 second"
            Start-Sleep -Seconds 1
        }
    }
