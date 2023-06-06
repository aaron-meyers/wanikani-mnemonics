$scriptsRoot = $PSScriptRoot

Push-Location

Set-Location '~\iCloudDrive\wanikani-mnemonics\pending-upload'

#$subjects = & "$scriptsRoot\GetSubjects.ps1"

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
        "$fileName, $key, $type, $mtype, $level"

        #$subjects | Where-Object
    }

Pop-Location
