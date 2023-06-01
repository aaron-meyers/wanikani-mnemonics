param(
    [String]
    $Path,

    [Switch]
    $Formatted
)
$apikey = $env:WANIKANI_API_KEY
if (-not $apikey) {
    throw 'API key not found, set $env:WANIKANI_API_KEY first'
}

$headers = @{"Authorization" = "Bearer $env:WANIKANI_API_KEY"}
$url = "https://api.wanikani.com/v2/subjects"
$data = @()
while ($url) {
    $r = Invoke-RestMethod -Uri $url -Headers $headers
    $data += $r.data
    $url = $r.pages.next_url

    Write-Host "Downloaded $($data.Count) subjects so far, next URL: $url"
}
if ($Formatted) {
    if (-not $Path) {
        $Path = 'subjects.formatted.json'
    }
    $data | ConvertTo-Json -Depth 99 | Out-File $Path
} else {
    if (-not $Path) {
        $Path = 'subjects.jsonl'
    }
    $data | Foreach-Object { $_ | ConvertTo-Json -Depth 99 -Compress } | Out-File $Path
}
Write-Host "Wrote subjects to $Path"
