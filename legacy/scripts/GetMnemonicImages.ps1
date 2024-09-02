function ProcessNote($note, $data) {
    if (-not $note) {
        return
    }

    $allMatches = [Regex]::Matches($note, '(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)(\/)([^\s,]+\.(png|jpg|jpeg))')
    if ($allMatches) {
        foreach ($m in $allMatches) {
            $url = $m.Groups[0].Value
            $fileName = [Uri]::UnescapeDataString($m.Groups[5].Value)

            Write-Output ([PSCustomObject]@{
                SubjectId = $data.subject_id
                SubjectType = $data.subject_type
                Url = $url
                FileName = $fileName
            })
        }
    }
}

$studyMaterials = & "$PSScriptRoot/GetWaniKaniResource.ps1" -Resource study_materials

$studyMaterials |
    Foreach-Object {
        ProcessNote $_.data.meaning_note $_.data
        ProcessNote $_.data.reading_note $_.data
    } # |
    # Select-Object -Unique # TODO: not working for some reason 
