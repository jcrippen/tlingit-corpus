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

Each file in an entry has the same basic format, namely a series of lines ending with the Unix-style [newline](https://en.wikipedia.org/wiki/Newline) character LF (Unicode U+000A Line Feed, a.k.a `^J` or `"\n"`). Note that Microsoft Windows uses a different two-character newline CR+LF (additional U+000D Carriage Return, a.k.a. `^M` or `"\r"`). Since it is based on Unix, Mac OS X follows the Unix LF standard.

Each line in a file can be either data or metadata. Data lines represent the original lines in the published text. Metadata lines are unique to the Tlingit Corpus, representing information about the text which has been added by the corpus compilers. The following examples contrast a data line and a metadata line.

* example data line from 003 “Ḵaax̱ʼachgóok”:
  * `431	Wáa sá kwshí yánde s kagux̱dayáa?`
* example metadata line from 003 “Ḵaax̱ʼachgóok”:
  * `{Transcriber = Ḵeixwnéi / Nora Marks Dauenhauer}`

Data and metadata lines have consistent formats. A data line always begins with a number that represents the original line numbering in the source text. The data line number is followed by a tab (Unicode U+0009 Character Tabulation), and then the rest of the line contains text. If the original publication lacks line numbers then these are created for the corpus, starting from 1. The line divisions of the original publication are maintained even when these are simply due to typesetting as in e.g. Velten’s transcriptions.

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

In general there is no specific structure to a metadata value, but some particular metadata keys are associated with special constraints on the structure of their keys. Bilingual names are given with Tlingit first and English second, separated by spaces and a forward slash.

* `Dzéiwsh / James A. Crippen`
* `Ḵeixwnéi / Nora Marks Dauenhauer`
* `Kéet Yanaayí / Willie Marks`

If an English name contains an additional “Sr.” or the like, this is *not* separated from the rest of the name by a comma.

* `Shkwínde / William L. Paul Sr.`

Instead, commas are used to separate multiple names. In such cases, the precedence of `/` is higher than the precedence of `,` so that pairs of Tlingit/English are separated by commas.

* `Seidayaa / Elizabeth Nyman, Weiháa / Jeff Leer`

# Unicode

All text in the Tlingit Corpus is in [Unicode](http://www.unicode.org/) using the [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. This section documents some Unicode usage practices particular to Tlingit text. Particular issues are the representation of underscore diacritics, the representation of the orthographic apostrophe for ejectives, and the representation of quotation marks.

## Underscore diacritic

The Revised Popular orthography used in the corpus has an underscore diacritic indicating that the sound is uvular rather than velar. Thus orthographic `x̱` stands for the uvular fricative /χ/ in contrast with orthographic `x` that stands for the velar fricative /x/. The underscore diacritics in letters like `x̱` and `G̱` are represented using the Unicode diacritic character [U+0331 Combining Macron Below](https://en.wikipedia.org/wiki/Macron_below) following the appropriate base character like U+0058 Latin Capital Letter X. The U+0331 Combining Macron Below diacritic must not be confused with the similar U+0320 Combining Low Line. The latter is meant to connect between letters, whereas Combining Macron Below never connects between letters. Use of any other character for the underscore diacritic is a bug.

The letters `Ḵ` and `ḵ` are  represented differently from `X̱`/`x̱` and `G̱`/`g̱` because of how Unicode is structured. Unicode defines [precomposed characters](https://en.wikipedia.org/wiki/Precomposed_character) that are single characters which can be decomposed into multiple characters. There are no precomposed equivalents for any of `X̱`, `x̱`, `G̱`, or `g̱`, but there are precomposed forms of U+1E34 Latin Capital Letter K With Line Below for `Ḵ` and U+1E35 Latin Small Letter K With Line Below for `ḵ`. The corpus text should be entirely in Unicode’s [NFC normalization](https://en.wikipedia.org/wiki/Unicode_equivalence#Normalization), thus preferring the precomposed variants. Use of any other normal form is a bug.

## Apostrophe

The orthographic apostrophe in Tlingit indicates ejective phonation of the preceding symbol. In Unicode this should only ever be represented with the character [U+02BC Modifier Letter Apostrophe](https://en.wikipedia.org/wiki/Modifier_letter_apostrophe) `ʼ`. The ‘easy’ apostrophe U+0027 Apostrophe `'` is specified with the Unicode property Po `Other_Punctuation`, so it is not a letter but rather a kind of punctuation just like the double quote or exclamation point. This contrasts with U+02BC `ʼ` which has the property Lm `Modifier_Letter` meaning that it is a true letter and not a punctuation symbol. In general the U+0027 Apostrophe `'` should never be used in the corpus as detailed in the following section.

## Quotation marks

Quotation marks in the corpus must be formed with the directional pairs `“`/`”` and `‘`/`’` which are U+201C & U+201D {Left, Right} Double Quotation Mark and U+2018 & U+2019 {Left, Right} Single Quotation Mark.
