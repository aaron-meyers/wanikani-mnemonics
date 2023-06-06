$dataRoot = Join-Path (Split-Path $PSScriptRoot -Parent) 'data'

Get-Content (Join-Path $dataRoot 'subjects.jsonl') | ConvertFrom-Json
