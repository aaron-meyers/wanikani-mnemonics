param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('subjects','study_materials')]
    [String]
    $Resource
)
$dataRoot = Join-Path (Split-Path $PSScriptRoot -Parent) 'data'

Get-Content (Join-Path $dataRoot "$Resource.jsonl") | ConvertFrom-Json
