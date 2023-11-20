param(
    [Parameter()]
    [String[]]
    $Path = @('*.jpg','*.png'),

    [Parameter(Mandatory=$true)]
    [String]
    $Prompt,

    [Parameter(Mandatory=$true)]
    [String]
    $Destination,

    [Parameter()]
    [Switch]
    $RemoveOriginal
)

if (-not (Get-Command exiftool -ErrorAction SilentlyContinue)) {
    throw "Requires exiftool"
}

Get-ChildItem $Path |
    Foreach-Object {
        $target = Join-Path $Destination (Split-Path $_ -Leaf)
        exiftool -Comment="$Prompt" $_ -o $target
    }

if ($RemoveOriginal) {
    Remove-Item $Path
}
