param(
    [Parameter()]
    [String[]]
    $Path = @('*.jpg','*.png'),

    [Parameter()]
    [String]
    $Prompt,

    [Parameter()]
    [Switch]
    $PromptFromClipboard,

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

if (-not $Prompt -and $PromptFromClipboard) {
    $Prompt = Get-Clipboard
    Write-Host "Prompt: $Prompt"
}

if (-not $Prompt) {
    throw "No prompt specified; nothing to do"
}

$Destination = Convert-Path $Destination

Get-ChildItem $Path |
    Foreach-Object {
        $target = Join-Path $Destination (Split-Path $_ -Leaf)

        # Note: UserComment is EXIF metadata and will show up in Windows Explorer as Comment for JPEG files.
        # There are also XMP and other metadata standard comments which may work (haven't tried this).
        # PNG files don't appear to show any metadata besides 'Date Taken' in Windows Explorer.
        # Avoid -Comment as it uses an obsolete tag that won't show in Windows Explorer.
        exiftool -UserComment="$Prompt" $_ -o $target
    }

if ($RemoveOriginal) {
    Remove-Item $Path
}
