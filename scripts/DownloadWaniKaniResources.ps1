param(
    [Parameter()]
    [ValidateSet('subjects','study_materials')]
    [String[]]
    $Resources = @('subjects','study_materials'),

    [Parameter()]
    [String]
    $Path,

    [Parameter()]
    [Switch]
    $Formatted
)
$apikey = $env:WANIKANI_API_KEY
if (-not $apikey) {
    throw 'API key not found, set $env:WANIKANI_API_KEY first'
}

foreach ($resource in $Resources) {
    $headers = @{
        'Authorization' = "Bearer $env:WANIKANI_API_KEY"
        'Wanikani-Revision' = '20170710'
    }
    $url = "https://api.wanikani.com/v2/$resource"
    $data = @()
    while ($url) {
        $r = Invoke-RestMethod -Uri $url -Headers $headers
        $data += $r.data
        $url = $r.pages.next_url

        Write-Host "Downloaded $($data.Count) $resource so far, next URL: $url"
    }
    if ($Formatted) {
        if (-not $Path) {
            $Path = "$resource.formatted.json"
        }
        $data | ConvertTo-Json -Depth 99 | Out-File $Path
    } else {
        if (-not $Path) {
            $Path = "$resource.jsonl"
        }
        $data | Foreach-Object { $_ | ConvertTo-Json -Depth 99 -Compress } | Out-File $Path
    }
    Write-Host "Wrote $resource to $Path"
}
