-*- Mode: GFM -*-

# The Tlingit Corpus

The Tlingit Corpus is a collection of narrative and oratory texts for linguistic research on the Tlingit language (Na-Dene family) of southeastern Alaska and neighbouring parts of British Columbia and the Yukon. The texts in this corpus come from a variety of published and unpublished sources, with the majority being from the work by Richard and Nora Marks Dauenhauer.

## Structure

The corpus is structured at the highest level by entries, each identified by a unique number. An entry represents some transcription of a unique performance of narrative or oratory. Each entry is divided into a number of files, all of which have filenames beginning with the entry number.

* Entry 001: “Ḵákʼw / Basket Bay” by Shaadaaxʼ / Robert Zuboff.
  * `001 Zuboff R - Basket Bay - Text.txt`
  * `001 Zuboff R - Basket Bay - Translation.txt`

Entries must have at least one file, and should have at least two: the text and the translation. The Text type of file represents the Tlingit text of the narrative or oratory in the Revised Popular (‘Coastal’) orthography. The Translation file type represents the English translation of the narrative or oratory. The complete list of file types is given below. New types may be added in the future.

* `Text`: the text of the narrative or oratory in RP orthography
* `Translation`: English translation (either original or added)
* `Original`: original form of the Tlingit text if in a different orthography
* `Gloss`: linguistic segmentation and gloss of the Tlingit text

Each file in an entry has the same basic format, namely a series of lines ending with the Unix-style [newline](https://en.wikipedia.org/wiki/Newline) character LF known in Unicode as U+000A Line Feed, a.k.a `^J` or `\n`. Note that Microsoft Windows uses a different two-character newline CR+LF with the addition of U+000D Carriage Return, a.k.a. `^M` or `\r`. Since it is based on Unix, Mac OS X follows the Unix LF standard.

The following diagram illustrates the hierarchical structure of corpus entries.

```
entry
 |
 +- file
 |   |
 |   +- metadata line
 |   |   |
 |   |   +- key
 |   |   |
 |   |   +- value
 |   |
 |   +- data line
 |       |
 |       +- number
 |       |
 |       +- content
 |
 +- file
 |   |
 |   +- lines...
 |
 ...
```

### Line formats

Each line in a file can be either data or metadata. Data lines represent the original lines in the published text. Metadata lines are unique to the Tlingit Corpus, representing information about the text which has been added by the corpus compilers. The following examples contrast a data line and a metadata line.

* example data line from 003 “Ḵaax̱ʼachgóok”:
  * `431	Wáa sá kwshí yánde s kagux̱dayáa?`
* example metadata line from 003 “Ḵaax̱ʼachgóok”:
  * `{Transcriber = Ḵeixwnéi / Nora Marks Dauenhauer}`

#### Data format

A data line always begins with a number that represents the original line numbering in the source text. The data line number is followed by a tab (Unicode U+0009 Character Tabulation), and then the rest of the line contains text.

* `num⁝⁝<TAB>text`
* `27	akag̱ag̱ataag̱ít ḵa has akag̱ax̱laxaashít.`

If the original publication lacks line numbers then these are created for the corpus, starting from 1. The line divisions of the original publication are maintained even when these are simply due to typesetting as in e.g. Velten’s transcriptions.

Data lines may be of arbitrary length. They are often less than 80 characters, but this is entirely dependent on their representation in the source texts. The Dauenhauers have a few instances of very long lines in their texts and the corpus replicates these as published.

#### Metadata format

A metadata line always begins with an open brace `{` and always ends with a close brace `}`. Within these braces they have additional structure, specifically a key-value pair. The equals sign `=` delineates the boundary between the key and the value. Keys are members of a small set whereas values can be anything. The list of keys is given below, but new keys may be added in the future.

* `Number`: entry number
* `Type`: file type
* `Title`: standardized title of narrative or oratory
* `Author`: person who performed narrative or oratory
* `Clan`: clan information about author
* `Source`: publication or archival reference
* `Transcriber`: person who transcribed speech
* `Translator`: person who translated Tlingit into English
* `Glosser`: person who glossed text
* `Orthography`: orthography in which data is written
* `Page`: page number in original publication
* `Tags` : descriptive tags for searching and indexing
* `Note`: general note that applies to an entire file
* `Comment`: specific note that applies to a particular line

Keys are always expressed in Title Case with an initial uppercase character and other letters lowercase in the word. There are no multiple word keys in the corpus at present but this is not guaranteed in the future. Programs parsing metadata in the corpus should only rely on the braces `{`/`}` and equals sign `=` to distinguish between keys and values.

There is no general structure to a metadata value, but some particular metadata keys are associated with special constraints on the structure of their values. These special constraints are described individually below.

Ideally all metadata lines should be shorter than 80 characters including punctuation for ease of reading in text editors and terminal emulators. This is not mandatory however, so the occasional metadata line can be longer if there is no reasonable abbreviation possible.

There is a logical division between header and body in a corpus file. The header is an uninterrupted block of metadata lines that contain keys like `Number`, `Type`, and `Author` which apply to the entire file. After this header the data lines begin and this is the body. In the body the metadata lines refer to the local data context, usually the following line, and not to the entire file. The first line of the body is not actually a data line, but rather a metadata line with a `Page` key indicating the first page of the text. Parsers can read forward until a data line is encountered, then back up until the first `Page` metadata is encountered. At this point all previous lines are header and all following lines are body.

##### Numeric values

Numeric values can be zero padded or unpadded. Zero padded numeric values are used for the `Number` key that indicates the entry number in a file.

* `{Number = 001}`
* `{Number = 042}`
* `{Number = 123}`

This entails a maximum of 999 entries. It may be that in the future there are more than 999 Tlingit narratives in the corpus, at which time the zero padding must be revised to use four digits. If ever necessary, this should be easy to change programmatically. File names will also have to be modified at the same time for consistency.

Page numbers are never zero padded. The maximum page number varies with each publication depending on the size of the original publication context (book, journal, notebook, etc.).

* `{Page = 17}`
* `{Page = 105}`
* `{Page = 1024}`

The metadata line indicating a change of page always precedes the first data line from that page. This means that the current page context of a data line can be retrieved by searching backward in the file.

##### List values

Values that consist of an ordered or unordered list of items are expressed with commas.

* `{Tags = narrative, quoted speech, directionals, Haida}`

There is no forseen necessity for lists with embedded commas, so semicolons should not be parsed as separators in metadata values. This may change in the future, however.

##### Name values

Bilingual names are given with Tlingit first and English second, separated by spaces and a forward slash.

* `Dzéiwsh / James A. Crippen`
* `Ḵeixwnéi / Nora Marks Dauenhauer`
* `Kéet Yanaayí / Willie Marks`

If an English name contains an additional “Sr.” or the like, this is *not* separated from the rest of the name by a comma.

* `Shgwínde / William L. Paul Sr.`

Instead, commas are used to separate multiple names. In such cases, the precedence of `/` is higher than the precedence of `,` so that pairs of Tlingit/English are separated by commas.

* `Seidayaa / Elizabeth Nyman, Weiháa / Jeff Leer`

Monolingual names are given alone without a slash.

* `Franz Boas`
* `Henry Velten`

Bilingual and monolingual names can be combined in a list, in any order.

* `Stoowuḵáa / Louis Shotridge, Franz Boas`
* `Henry Velten, Yeex̱aas / Lester Roberts`

##### Special values

Some metadata in the corpus consist of restricted lists of possible values. Examples of these include `Orthography` and `Source`. The possible values for these kinds of metadata should be enumerated in lists in the `metadata` subdirectory. Eventually there will be a program that automatically updates these lists based on the values used in the corpus, but for now the value list files are maintained by hand.

The format of the metadata value list files is special. The keys in these value list files are the values that will be used in the corpus files. The values in the value list files are descriptive summaries meant for human reading and consequently have unpredictable content except for the lack of braces `{` and `}`.

## Unicode

All text in the Tlingit Corpus is in [Unicode](http://www.unicode.org/) using the [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. This section documents some Unicode usage practices particular to Tlingit text. Particular issues are the representation of underscore diacritics, the representation of the orthographic apostrophe for ejectives, and the representation of quotation marks.

### Underscore diacritic

The Revised Popular orthography used in the corpus has an underscore diacritic indicating that the sound is uvular rather than velar. Thus orthographic `x̱` stands for the uvular fricative /χ/ in contrast with orthographic `x` that stands for the velar fricative /x/. The underscore diacritics in letters like `x̱` and `G̱` must be represented using the Unicode diacritic character [U+0331 Combining Macron Below](https://en.wikipedia.org/wiki/Macron_below) following the appropriate base character like U+0058 Latin Capital Letter X. The U+0331 Combining Macron Below diacritic must not be confused with the similar U+0320 Combining Low Line. The latter is meant to connect between letters, whereas the Combining Macron Below never connects between letters. Use of any other character for the underscore diacritic is a bug.

The letters `Ḵ` and `ḵ` are  represented differently from `X̱`/`x̱` and `G̱`/`g̱` because of how Unicode is structured. Unicode defines [precomposed characters](https://en.wikipedia.org/wiki/Precomposed_character) that are single characters which can be decomposed into multiple characters. There are no precomposed equivalents for any of `X̱`, `x̱`, `G̱`, or `g̱`, but there are precomposed forms of U+1E34 Latin Capital Letter K With Line Below for `Ḵ` and U+1E35 Latin Small Letter K With Line Below for `ḵ`. The corpus text should be entirely in Unicode’s [NFC normalization](https://en.wikipedia.org/wiki/Unicode_equivalence#Normalization), thus preferring the precomposed variants. Use of any other normal form is a bug.

### Apostrophe

The orthographic apostrophe in Tlingit indicates ejective phonation of the preceding symbol. In Unicode this should only ever be represented with the character [U+02BC Modifier Letter Apostrophe](https://en.wikipedia.org/wiki/Modifier_letter_apostrophe) `ʼ`. The ‘easy’ apostrophe U+0027 Apostrophe `'` is specified with the Unicode property Po `Other_Punctuation`, so it is not a letter but rather a kind of punctuation just like the double quote or exclamation point. This contrasts with U+02BC `ʼ` which has the property Lm `Modifier_Letter` meaning that it is a true letter and not a punctuation symbol. In general the U+0027 Apostrophe `'` must never be used in the corpus as detailed in the following section.

### Quotation marks

Quotation marks in the corpus must be formed with the directional pairs `“`/`”` and `‘`/`’` which are U+201C & U+201D {Left, Right} Double Quotation Mark and U+2018 & U+2019 {Left, Right} Single Quotation Mark. This is because the quotation marks in Tlingit are only used in balanced pairs to open and close quoted speech. They are never used for phonological contraction because this could be potentially confused with the representation of ejectives. Using the dedicated quotation marks also relieves programmers of the escaping burden since quotation marks are also used as type delimiters (strings, characters) in most programming languages, markup languages, and regular expressions languages.

If a published text does not have balanced quotation marks then they must be changed to be balanced in the corpus. This ensures that algorithmic processing of text can easily identify the beginning and end of quotations. The absence of a closing quotation mark on a line then entails that the quoted speech spans multiple lines, and thus a program can search forward through successive lines until the closing quotation mark is reached.

The U+2019 Right Single Quotation Mark must never be used for the orthographic apostrophe that indicates ejective phonation. This is only ever represented by U+02BC Modifier Letter Apostrophe. Most fonts have an identical appearance for both characters, so it is necessary to check new additions to the corpus using string matching programs like `grep` or text editors like `emacs` and `vim` to ensure that no spurious quotation marks creep in for orthographic apostrophes or vice versa.

Although preserving the punctuation of original texts is important, for unpublished and new texts it may be useful to adopt guillemets – a.k.a. angle quotation marks – instead of the English-style comma quotation marks. These are U+2039 & U+203A Single {Left, Right}-Pointing Angle Quotation Mark and U+00AB & U+00BB {Left, Right}-Pointing Double Angle Quotation Mark in Unicode. They should be used with the points outward in the French arrangement as `«…»` and `‹…›` rather than in the German style of points inward as e.g. `»…«`. This is because with points outward they more closely resemble the curvature of the comma quotation marks like `“…”`. European custom is generally to separate the guillemets from the rest of the text with whitespace, but this is not necessary here since fine typography is largely irrelevant for corpus work.
