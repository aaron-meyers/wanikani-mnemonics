param(
    [Parameter(Mandatory=$true)]
    [String]
    $SubjectUrl,

    [Parameter(Mandatory=$true)]
    [String]
    $Prompt,

    [Parameter(Mandatory=$true)]
    [ValidateSet('Meaning','Reading','Both')]
    [String]
    $MnemonicType
)

$discordTypeMap = @{
    'radical' = 'Radical'
    'kanji' = 'Kanji'
    'vocabulary' = 'Vocab'
}

$subjects = & "$PSScriptRoot/GetSubjects.ps1"

$subject = $subjects |
    Where-Object { $_.data.document_url -eq $SubjectUrl }
$char = ($subject.object -eq 'radical' ? $subject.data.slug : $subject.data.characters)
$discordType = $discordTypeMap[$subject.object]

Write-Output "/submit char:$char type:$discordType source:DALL-E 2 prompt:$Prompt mnemonictype:$MnemonicType image:"
