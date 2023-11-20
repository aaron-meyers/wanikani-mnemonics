param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [String[]]
    $Path
)

$toolargs = @('-j')

$paths = Get-ChildItem $Path
$toolargs += $paths

$json = (& exiftool $toolargs) | Out-String
return (ConvertFrom-Json $json)
