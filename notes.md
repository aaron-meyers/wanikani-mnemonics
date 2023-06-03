# Artifacts
- Radical meaning images
- Kanji meaning images
- Kanji reading images
- Vocabulary meaning images
- Vocabulary reading images

## Community image URIs
https://wk-mnemonic-images.b-cdn.net/{Radicals|Kanji|Vocabulary}/{Meaning|Reading}/{subjectId}{.png|-thumb.jpg}

## Discord submission required info
- Subject type (radical, kanji, vocabulary)
- Subject name (radicals) or characters (kanji, vocabulary)
- Meaning or Reading
- Prompt

## Potential JSON representation
Extending WaniKani's subject JSON representation:
```json
{
    id: <number>,
    object: "<radical|kanji|vocabulary>",
    url: "https://api.wanikani.com/v2/subjects/<id>",
    data: {
        level: <number>,
        meaning_mnemonic_images: [
            {
                url: "<url>",
                metadata: {
                    prompt: "<string>",
                    style_name: "<thumb|...>"
                },
                content_type: "<image/png|image/jpeg|...>"
            }
        ],
        reading_mnemonic_images: [
            ...
        ]
    }
}
```

# Lesson flow - create images
## Current flow (images in iCloud)
1. Open bing.com/create (possibly in side-by-side on iPad)
2. Copy or construct prompt
3. Generate image (and wait)
4. If no images are satisfactory, repeat from step 2
5. Copy primary meaning from Tsurukame
6. Save image to iCloud under level folder with {primary}.{r|k|v}{m|r} name

### Missing info for Discord submission
- Subject characters - can be derived from level+primary meaning except for the 15 cases of duplicate meanings in the same level; could additionally disambiguate with the reading for those exceptions ({reading}.{primary}... name)
- Prompt

## Alternate flow - direct to Discord
1. Open bing.com/create (possibly in side-by-side on iPad)
2. Copy or construct prompt
3. Generate image (and wait)
4. If no images are satisfactory, repeat from step 2
5. Open Discord submission channel
6. Fill out Discord submission prompt
   1. Type in characters
   2. Copy prompt
7. Copy upload URL from Discord
8. Fill out spreadsheet (or Typeform, ...)
   - TODO: Can copy info from Discord submission?
   - TODO: Can access Discord channel programatically?

## Alternate flow - save link to Bing image (includes prompt)
1. Open bing.com/create (possibly in side-by-side on iPad)
2. Copy or construct prompt
3. Generate image (and wait)
4. If no images are satisfactory, repeat from step 2
5. Copy primary meaning from Tsurukame
6. Share Bing image URL to {Shortcut? To-Do?} with info {level}.{primary}.{r|k|v}{m|r}

## Desired flow
1. Select mnemonic text for prompt
2. Share to shortcut
   1. Edit prompt text if needed
   2. Opens bing.com/create with prompt filled in
3. Refine prompt as needed to get desired image
4. Copy Bing image URL
5. In Tsurukame, select trigger text (meaning or reading user note)
6. Share to shortcut
   1. Parses trigger text and grabs Bing image URL from clipboard
   2. Saves to a file in iCloud for processing

## Desired flow - direct to Discord
Note - this approach is ideal only if it is possible to later grab content from the Discord channel programatically
1. Select mnemonic text for prompt
2. Share to shortcut
   1. Edit prompt text if needed
   2. Opens bing.com/create with prompt filled in
3. Refine prompt as needed to get desired image
4. Save image
5. Copy prompt text
6. In Tsurukame, copy Discord submission text (meaning or reading user note)
7. In Discord submission channel, paste submission text

# Review flow - review images
## Current flow (images in iCloud)
1. Select Primary meaning in Tsurukame
2. Share to Radical/Kanji/Vocabulary shortcut
   - Opens iCloud images with search on {primary}.{r|k|v} -- may find duplicates across/within levels (this may not be a bad thing)

## Desired flow using user notes
1. Meaning/reading notes with image links - select link and 'Open Link'
