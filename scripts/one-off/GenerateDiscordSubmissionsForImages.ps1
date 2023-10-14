$scriptsRoot = $PSScriptRoot

Push-Location

Set-Location '~\iCloudDrive\wanikani-mnemonics\pending-upload'

$subjects = & "$scriptsRoot\GetSubjects.ps1"

$subjectList = $subjects |
    Select-Object id,object,@{n='url';e={$_.data.document_url}},@{n='characters';e={$_.data.characters}},@{n='meaning';e={($_.data.meanings|? primary -eq $true).meaning}},@{n='level';e={$_.data.level}}

$typeMap = @{
    'r' = 'radical'
    'k' = 'kanji'
    'v' = 'vocabulary'
}
$discordTypeMap = @{
    'r' = 'Radical'
    'k' = 'Kanji'
    'v' = 'Vocab'
}
$mtypeMap = @{
    'm' = 'Meaning'
    'r' = 'Reading'
    'mr' = 'Both'
}

Get-ChildItem *.jpg -Recurse |
    Foreach-Object {
        $fileName = $_.Name
        $dir = $_.Directory.Name

        if ($fileName -match "^([^.]+)\.([rkv])(m?r?)") {
            $key = $Matches[1]
            $type = $Matches[2]
            $mtype = $Matches[3]
        }
        if ($dir -match "[0-9]+$") {
            $level = [int]($Matches[0])
        }
        #"$fileName, $key, $type, $mtype, $level"

        $object = $typeMap[$type]
        $discordType = $discordTypeMap[$type]
        $mnemonictype = $mtypeMap[$mtype]

        $subject = $subjectList |
            Where-Object {$_.level -eq $level -and $_.meaning -eq $key -and $_.object -eq $object}
        if ($subject.Count -eq 1) {
            $char = ($type -eq 'r' ? $subject.meaning.ToLower() : $subject.characters)
            Write-Output "========== $dir\$fileName =========="
            Write-Output "/submit char:$char type:$discordType source:DALL-E 2 prompt:<don't remember> mnemonictype:$mnemonictype image:"
            Write-Output $subject.url
            Write-Output ''
        } else {
            Write-Warning "Multiple matches found for $key in level $level"
        }
    }

Pop-Location
