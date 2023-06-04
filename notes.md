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
TODO - need to be able to extract image from Bing image URL to automate this flow, also still needs Discord upload in post-process
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
1. Select mnemonic text for prompt
2. Share to shortcut
   1. Edit prompt text if needed
   2. Opens bing.com/create with prompt filled in
3. Refine prompt as needed to get desired image
4. Save image
5. Copy prompt text
6. In Tsurukame, share Discord submission text (meaning or reading user note) to shortcut
   1. Get prompt text from clipboard
   2. Append prompt to Discord submission text
   3. Copy to clipboard
   4. Open Discord app
7. In Discord submission channel, paste submission text and add image
8. Copy image upload URL and paste as user note in Tsurukame (with 'image ' prefix)

## Deferred flow
1. In Tsurukame, share Discord submission text to To-Do (should include URL to WaniKani subject page)
2. From To-Do, open WaniKani subject page
3. Select mnemonic text for prompt
4. (On iOS) Share to shortcut
   (On PC) Open bing.com/create and paste mnemonic text
5. Continue from step 3 of direct to Discord flow

# Review flow - review images
## Current flow (images in iCloud)
1. Select Primary meaning in Tsurukame
2. Share to Radical/Kanji/Vocabulary shortcut
   - Opens iCloud images with search on {primary}.{r|k|v} -- may find duplicates across/within levels (this may not be a bad thing)

## Desired flow using user notes
- Meaning/reading notes with image links - select link and 'Open Link' (format 'image {url}')
- Or select link and share to shortcut to search iCloud
  1. Extract subjectId from link
  2. Search Files for 'mnemonic-{subjectId}'
- Prepend 'Primary ' to identify preferred image
- Delete unneeded image link notes
