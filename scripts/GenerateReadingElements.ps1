# TODO - need to generate a more concise description of the elements. Focus on two to four unique visual attributes that will make the character or object memorable when used as an element in mnemonic images.
$systemMessage = @"
# Overview
You are an assistant helping Japanese language learners to master kanji. You will assist by
creating vivid mnemonic image prompts that will be used to generate images corresponding with
colorful mnemonics that help people remember the components and readings of various kanji.

# Task instructions
For the current task, you will be provided with a set of mnemonics for kanji that share a common
reading. Extract a description of the common element in these mnemonics. This element may be a
character or object and will be identified by <reading> tags in the mnemonic text. Include traits
or attributes of the element in your description. Embellish your description of this common element
with visual details that will aid memorization. This description will be used to give a consistent
portrayal of the element in mnemonic images for all the kanji that share this reading. In your
description of the element, include an art style that would be appropriate for depicting this
element in memorable mnemonic images.

Respond with the following format:
Element: <name of element>
Reading: <reading>
Description: <visual description of element>
"@

$subj = GetWaniKaniResource 'subjects' |
    Where-Object object -eq 'kanji' |
    ForEach-Object {
        [PSCustomObject]@{
            id = $_.id
            object = $_.object
            url = $_.url
            meaning = $_.data.meanings | Where-Object primary -eq True | Select-Object -ExpandProperty meaning
            meaning_mnemonic = $_.data.meaning_mnemonic
            meaning_hint = $_.data.meaning_hint
            reading = $_.data.readings | Where-Object primary -eq True | Select-Object -ExpandProperty reading
            reading_mnemonic = $_.data.reading_mnemonic
            reading_hint = $_.data.reading_hint
        }
    }

$readings = $subj.reading |
    Group-Object |
    Where-Object Count -gt 1 |
    Sort-Object Count |
    Select-Object -Last 10 # TODO: remove

$runId = 1
while ($true) {
    $folder = "run{0:d5}" -f $runId
    if (-not (Test-Path $folder)) {
        $folder = New-Item $folder -Type Directory
        break
    } else {
        $runId++
    }
}

$info = [ordered]@{}
foreach ($readingGroup in $readings) {
    $reading = $readingGroup.Name
    # TODO - filter to only subjects that contain the specified reading in their mnemonic (in <ja> tags)
    # Also consider extracting out <reading> tags and grouping on these...
    $details = $subj | Where-Object reading -eq $reading
    $userMessage = @"
Reading: $reading
Associated mnemonics:
$(($details | ForEach-Object { @"
- Mnemonic: $($_.reading_mnemonic)
  Hint: $($_.reading_hint)
"@}) -join [Environment]::NewLine)
"@
    $descrip = Request-ChatCompletion -SystemMessage $systemMessage -Message $userMessage -Model gpt-4o-2024-08-06
    Write-Output "Description:"
    Write-Output $descrip.Answer

    $imagePrompt = Request-ChatCompletion -SystemMessage 'Create a prompt for use with DALL-E 3 to visualize the character or object described by the user.' -Message ([string]$descrip.Answer) -Model gpt-4o-2024-08-06
    Write-Output "Image prompt:"
    Write-Output $imagePrompt

    Request-ImageGeneration -Prompt ([string]$imagePrompt.Answer) -Model dall-e-3 -OutFile "$folder/$reading.png"
    $info[$reading] = [ordered]@{
        description = $descrip
        imagePrompt = $imagePrompt
    }
}

$info | ConvertTo-Yaml -OutFile "$folder/meta.yaml"