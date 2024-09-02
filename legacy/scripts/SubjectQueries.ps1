$subjects = & "$PSScriptRoot\GetSubjects.ps1"

# List kanji with the same primary meaning in the same level
$subjects|? object -eq 'kanji'|select id,@{n='characters';e={$_.data.characters}},@{n='meaning';e={($_.data.meanings|? primary -eq $true).meaning}},@{n='level';e={$_.data.level}}|group-object meaning,level|? count -gt 1
