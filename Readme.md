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

* `num<TAB>text`
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

##### Comment values

The `Comment` metadata represent the corpus compiler’s commentary about the data. Comment lines immediately precede the lines to which they refer. A comment value should start with a reference to a line number or sequence of line numbers.

* `{Comment = Line 88 has waa instead of wáa.}`
* `88	wáa sá teeyí.`

In the example above, the comment line refers to the data in the following line numbered 88. Comments are often used to note misspellings, mistranscriptions, and typos in the original documents. The data have the modified form, with the comment giving enough detail to identify how the original erred.

Some comments give details on the original formatting that has been obscureed in the transition to the corpus format. These are ignorable by most corpus users, but some users may be interested in verifying exactly how the corpus text differs from the original.

* `{Comment = Line 147 has the final “perhaps during the night” on the next page.}`
* `147	That’s how she brought them to him, perhaps during the night.`

##### Special values

Some metadata in the corpus consist of restricted lists of possible values. Examples of these include `Orthography` and `Source`. The possible values for these kinds of metadata should be enumerated in lists in the `metadata` subdirectory. Eventually there will be a program that automatically updates these lists based on the values used in the corpus, but for now the value list files are maintained by hand.

The format of the metadata value list files is special. The keys in these value list files are the values that will be used in the corpus files. The values in the value list files are descriptive summaries meant for human reading and consequently have unpredictable content except for the lack of braces `{` and `}`.

## Orthography

All corpus files of the type `Text` use the same orthography, the modern Revised Popular orthography. If the original publication used a markedly different orthography then there is an `Original` file that contains the original text. The intent is that users should be able to search all `Text` files with the expectation that all words will be represented the same way throughout. Users interested in verifying the corpus transliteration can refer to the `Original` files.

The Revised Popular orthography has changed slightly since the Dauenhauers first started publishing their material. The following subsections detail a few differences between the corpus representation and the original materials published by the Dauenhauers.

### Variable length vowels

Originally all word-final vowels that have variable length were written long, a practice dating back to the second Naish-Story orthography. Today these variable length vowels are written short instead, even when followed by consonantal suffixes.

* `aanée` → `aaní`
* `héendei` → `héende`
* `atkʼátskʼooch` → `atkʼátskʼuch`
* `hítxʼee sáani` → `hítxʼi sáani`
* `yóo héen` → `yú héen`
* `yéi áwéi` → `yéi áwé`

This regularization is only ever applied to vowels that vary in length. Word-final vowels that are always short or always long are never modified. There are not many of these minimal pairs in the Tlingit lexicon.

* `tʼá` ‘king salmon’ ≠ `tʼáa` ‘board’

Regularized shortening of word-final vowels is applied regardless of any variation in the original publication. The Dauenhauers for example would sometimes attend to variation in the speech of a single speaker, writing the vowels long when the speaker pronounced them long and short otherwise. But they were not consistent enough in this to be linguistically reliable. Regularization ensures consistency for automated processing of text. In future work the published forms may be included as `Original` type files.

### Blank lines

The Dauenhauers used blank lines to separate discourse units in the story. Other transcribers also sometimes included blank lines for similar purposes, but often blank lines are simply spurious or due to typesetting exigencies. For simplicity in parsing and automated processing of text the corpus omits all blank lines, regardless of their purpose. Researchers interested in the original presentations are directed to the publications.

### Line breaks

In some Dauenhauer transcriptions there are long lines that span multiple physical lines on the printed page but which are only assigned a single line number.

* `198	Wé smallest ḵu.aa áwé, ax̱áa ash shóode`
* `		awusháadin,`

These occur in English translations as well as in Tlingit texts.

* `205	Probably he came to him, I guess; that little`
* `		brother-in-law of his`

For consistency of representation these multi-line units have been converted in the corpus to single long lines. There is no indication of the original line breaking.

* `198	Wé smallest ḵu.aa áwé, ax̱áa ash shóode awusháadin,`
* `205	Probably he came to him, I guess; that little brother-in-law-of-his`

The multi-line units used by the Dauenhauers represent stylistic behaviours of the speakers in speech rate and intonation. This kind of information is not easily represented in text, so researchers interested in such phenomena are encouraged to review the original audio files. The Dauenhauer recordings are now all digitized and available at the University of Alaska Southeast, the Alaska Native Language Archive, and the Sealaska Heritage Institute.

### Word breaking

The Dauenhauers were conscientious about never breaking Tlingit words across line boundaries, but this is not always the case for other researchers. When words have been broken across lines, the `Original` type of file retains this along with any hyphenation. But the `Text` file instead ‘unbreaks’ words for ease of searching. A rejoined word appears at the end of the first line where it occurs, and is deleted from the following line.

The ‘word’ in this context is the orthographic word separated from other words by whitespace. This is in contrast with the more fuzzy linguistic definitions of ‘word’ which may or may not include additional units like proclitics and enclitics. Thus the phrase `ax̱ yoo x̱ʼatángi` ‘my speech’ consists of three orthographic words even though it is only two syntactic words, with the proclitic `yoo` as part of the syntactic noun. Automated text recognition must therefore compensate for constituents like `yoo x̱ʼatánk` that may be broken across line boundaries.

## Unicode

All text in the Tlingit Corpus is in [Unicode](http://www.unicode.org/) using the [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. This section documents some Unicode usage practices particular to Tlingit text. Particular issues are the representation of underscore diacritics, the representation of the orthographic apostrophe for ejectives, and the representation of quotation marks.

### Underscore diacritic

The Revised Popular orthography used in the corpus has an underscore diacritic indicating that the sound is uvular rather than velar. Thus orthographic `x̱` stands for the uvular fricative /χ/ in contrast with orthographic `x` that stands for the velar fricative /x/. The underscore diacritics in letters like `x̱` and `G̱` must be represented using the Unicode diacritic character [U+0331 Combining Macron Below](https://en.wikipedia.org/wiki/Macron_below) following the appropriate base character like U+0058 Latin Capital Letter X. The U+0331 Combining Macron Below diacritic must not be confused with the similar U+0320 Combining Low Line. The latter is meant to connect between letters, whereas the Combining Macron Below never connects between letters. Use of any other character for the underscore diacritic is a bug.

The letters `Ḵ` and `ḵ` are  represented differently from `X̱`/`x̱` and `G̱`/`g̱` because of how Unicode is structured. Unicode defines [precomposed characters](https://en.wikipedia.org/wiki/Precomposed_character) that are single characters which can be decomposed into multiple characters. There are no precomposed equivalents for any of `X̱`, `x̱`, `G̱`, or `g̱`, but there are precomposed forms of U+1E34 Latin Capital Letter K With Line Below for `Ḵ` and U+1E35 Latin Small Letter K With Line Below for `ḵ`. The corpus text should be entirely in Unicode’s [NFC normalization](https://en.wikipedia.org/wiki/Unicode_equivalence#Normalization), thus preferring the precomposed variants. Use of any other normal form is a bug.

### Apostrophe

The orthographic apostrophe in Tlingit indicates ejective phonation of the preceding symbol. In Unicode this should only ever be represented with the character [U+02BC Modifier Letter Apostrophe](https://en.wikipedia.org/wiki/Modifier_letter_apostrophe) `ʼ`. The ‘ordinary’ apostrophe [U+0027 Apostrophe](http://unicode.org/cldr/utility/character.jsp?a=0027) `'` is specified with the Unicode property Po `Other_Punctuation`, so it is not a letter but rather a kind of punctuation just like the double quote or exclamation point. This contrasts with U+02BC `ʼ` which has the property Lm `Modifier_Letter` meaning that it is a true letter and not a punctuation symbol. In general the U+0027 Apostrophe `'` must never be used in the corpus as detailed in the following section.

### Quotation marks

Quotation marks in the corpus must be formed with the directional pairs `“`/`”` and `‘`/`’` which are U+201C & U+201D {Left, Right} Double Quotation Mark and U+2018 & U+2019 {Left, Right} Single Quotation Mark. This is because the quotation marks in Tlingit are only used in balanced pairs to open and close quoted speech. They are never used for phonological contraction because this could be potentially confused with the representation of ejectives. Using the dedicated quotation marks also relieves programmers of the escaping burden since quotation marks are also used as type delimiters (strings, characters) in most programming languages, markup languages, and regular expressions languages.

If a published text does not have balanced quotation marks then they must be changed to be balanced in the corpus. This ensures that algorithmic processing of text can easily identify the beginning and end of quotations. The absence of a closing quotation mark on a line then entails that the quoted speech spans multiple lines, and thus a program can search forward through successive lines until the closing quotation mark is reached.

The U+2019 Right Single Quotation Mark must never be used for the orthographic apostrophe that indicates ejective phonation. This is only ever represented by U+02BC Modifier Letter Apostrophe. Most fonts have an identical appearance for both characters, so it is necessary to check new additions to the corpus using string matching programs like `grep` or text editors like `emacs` and `vim` to ensure that no spurious quotation marks creep in for orthographic apostrophes or vice versa.

Although preserving the punctuation of original texts is important, for unpublished and new texts it may be useful to adopt guillemets – a.k.a. angle quotation marks – instead of the English-style comma quotation marks. These are U+2039 & U+203A Single {Left, Right}-Pointing Angle Quotation Mark and U+00AB & U+00BB {Left, Right}-Pointing Double Angle Quotation Mark in Unicode. They should be used with the points outward in the French arrangement as `«…»` and `‹…›` rather than in the German style of points inward as e.g. `»…«`. This is because with points outward they more closely resemble the curvature of the comma quotation marks like `“…”`. European custom is generally to separate the guillemets from the rest of the text with whitespace, but this is not necessary here since fine typography is largely irrelevant for corpus work.

### Period or full stop

All modern Tlingit orthographies use the period or full stop as an orthographic letter. It has two purposes: (i) glottal stop and (ii) grapheme separator. Both are represented in the corpus with the same Unicode character [U+002E Full Stop](http://unicode.org/cldr/utility/character.jsp?a=002E), which is the ordinary period. Unfortunately this character is specified as Po `Other_Punctuation` but there is no equivalent character with the Lm `Modifier_Letter` or Lo `Other_Letter` properties.

The `.` as glottal stop (IPA /ʔ/) only appears before a vowel, although there is a labialized variant `.w` (IPA /ʔʷ/) that occurs before vowels. The `.` as grapheme separator only appears between consonants. The grapheme separator appears at syllable boundaries where a sequence of two graphemes is confusable with a digraph: `s.h` ≠ `sh`, `t.s` ≠ `ts`. In both glottal stop and grapheme separator functions the period `.` is either word-medial or very rarely word-initial. Parsers can rely on word-final periods – i.e. periods followed by whitespace or line endings – to be punctuation and not letters in Tlingit text.
