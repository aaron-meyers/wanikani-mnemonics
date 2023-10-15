param(
    [Parameter(Mandatory=$true)]
    [String]
    $SubjectUrl,

    [Parameter()]
    [Switch]
    $Fast,

    [Parameter()]
    [Switch]
    $ToClipboard
)

$discordTypeMap = @{
    'radical' = 'Radical'
    'kanji' = 'Kanji'
    'vocabulary' = 'Vocab'
}

if ($Fast) {
    $urlParts = $SubjectUrl -split '/'

    $objType = $urlParts[$urlParts.length - 2]
    if ($objType -eq 'radicals') {
        $objType = 'radical'
    }

    $slug = $urlParts[$urlParts.length - 1]
    $search = [Uri]::UnescapeDataString($slug)
} else {
    $subjects = & "$PSScriptRoot/GetSubjects.ps1"

    $subject = $subjects |
        Where-Object { $_.data.document_url -eq $SubjectUrl }
    $objType = $subject.object
    $search = ($objType -eq 'radical' ? $subject.data.slug : $subject.data.characters)
}
$field = ($objType -eq 'radical' ? 'meaning' : 'char')
$discordType = $discordTypeMap[$objType]

$s = "/show submissions $($field):$search type:$discordType"

if ($ToClipboard) {
    $s | Set-Clipboard
} else {
    return $s
}
