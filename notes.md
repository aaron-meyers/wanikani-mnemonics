# Artifacts
- Radical meaning images
- Kanji meaning images
- Kanji reading images
- Vocabulary meaning images
- Vocabulary reading images

## Community image URIs
Primary:
https://wk-mnemonic-images.b-cdn.net/{Radicals|Kanji|Vocabulary}/{Meaning|Reading}/{subjectId}{.png|-thumb.jpg}

Submissions:
https://wk-mnemonic-images.b-cdn.net/{Radicals|Kanji|Vocabulary}/{subjectId}_{r|k|v}{m|r}{seq}_{chars?}-{timestamp}.png

## Discord submission required info
- Subject type (radical, kanji, vocabulary)
- Subject name (radicals) or characters (kanji, vocabulary)
- Meaning or Reading or Both
- Prompt and Source (DALL-E 2 etc)
- Image

## User notes
### Creation note
Discord submission/To-Do template note format:
```
TODO <subject-chars-or-meaning> <meaning|reading> <subject-id>

/submit char:<text> type:<Kanji|Radical|Vocab> source:DALL-E 2 mnemonictype:<Meaning|Reading|Both>

<wanikani-subject-url>
```

Append in shortcut:
```
prompt:<prompt text with no delimeters>
```

Missing:
```
image:<path>
```

Discord show submissions format:
```
/show submissions char:<text> type:<Kanji|Radical|Vocab>
```

### Image mnemonic note
Accepted image:
```
image <url>
```

Otherwise just url.

## Potential JSON representation
Extending WaniKani's subject JSON representation:
```json
{
    id: <number>,
    object: "<radical|kanji|vocabulary>", // needed?
    url: "https://api.wanikani.com/v2/subjects/<id>", // needed?
    data: {
        level: <number>, // needed?
        meaning_mnemonic_images: [
            {
                url: "<url>",
                metadata: {
                    source: "<community_primary|community_submission>",
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

## User state JSON representation
```json
{
    id: <number>,
    state: "<new|pending|completed>", // pending = added creation note, completed = creation note deleted
    data : {
        meaning_mnemonic_images: [
            {
                url: "<url>",
                state: "<new|pending|accepted|rejected>" // pending = added user note, accepted = 'image ' prefix, rejected = user note deleted
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
1. Share Discord submission text to search shortcut (extracts char & type)
   1. If an existing submission is sufficient, skip to last step
2. Select mnemonic text for prompt
3. Share to shortcut
   1. Edit prompt text if needed
   2. Opens bing.com/create with prompt filled in
4. Refine prompt as needed to get desired image
5. Save image
6. Copy prompt text
7. In Tsurukame, share Discord submission text (meaning or reading user note) to shortcut
   1. Get prompt text from clipboard
   2. Append prompt to Discord submission text
   3. Copy to clipboard
   4. Open Discord app
8. In Discord submission channel, paste submission text and add image
9. Copy image upload URL and paste as user note in Tsurukame (with 'image ' prefix)

## Deferred flow
1. In Tsurukame, share Discord submission text to To-Do (should include URL to WaniKani subject page)
2. From To-Do, open WaniKani subject page
3. Select mnemonic text for prompt
4. (On iOS) Share to Bing Create shortcut
   (On PC) Open bing.com/create and paste mnemonic text
5. Continue from step 4 of direct to Discord flow

# Review flow - review images
## Current flow (images in iCloud)
1. Select Primary meaning in Tsurukame
2. Share to Radical/Kanji/Vocabulary shortcut
   - Opens iCloud images with search on {primary}.{r|k|v} -- may find duplicates across/within levels (this may not be a bad thing)

## Desired flow using user notes
- Meaning/reading notes with image links - select link and 'Open Link'
- Or select link and share to shortcut to search iCloud
  1. Extract subjectId from link
  2. Search Files for 'mnemonic-{subjectId}'
- Prepend 'image ' to identify preferred image
- Delete unneeded image link notes

# Things to build
## Shortcuts
- Bing Image Creator
  - Start with input text
  - Show text editor prompt
  - Open https://bing.com/create?q={url-encoded-text}

- Discord show submissions

- Discord submit image

- Search iCloud for image (from image URL text)

## Scripts
- Add creation user notes
  - Parameters: Level
  - Store state to avoid re-adding note after it was deleted

- Import community primary images
  1. Scrape progress data from Discord channels
  2. Download image to check if exists (don't need to store)
  3. Update repo data

- Sync user notes with repo data

- Export/Sync images to iCloud

- Generate statistics

# Execution plan
1. (DONE) Add existing submissions to WaniKani user notes ('image {url}')
2. Upload existing images to Discord and add to WaniKani user notes ('image {url}')
   - script:
     1. loop over images in pending-upload
     2. find corresponding subject data
     3. output Discord submission command: ```/submit char:towel type:Radical source:DALL-E 2 prompt:<don't remember> mnemonictype:Meaning image:```
     4. output WaniKani item URL
   - manual (for each image):
     1. copy Discord submission command from script and open WaniKani item URL
     2. drop image and submit
     3. move image to 'archived' folder
     4. copy image upload URL and paste into WaniKani note (with 'image ' prefix)
     5. close WaniKani item page
3. Script - Import community primary images
4. Script - Sync user notes with repo data
3. Script - Add creation user notes
4. Shortcut - Discord show submissions
5. Shortcut - Bing Image Creator
5. Shortcut - Discord submit image
6. Script - Export/Sync images to iCloud
7. Shortcut - Search iCloud for image (from image URL text)
8. Script - Generate statistics