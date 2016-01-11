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

Each file in an entry has the same basic format, namely a series of lines ending with the Unix-style [newline](https://en.wikipedia.org/wiki/Newline) character LF (Unicode U+000A Line Feed, ^J or "\n"). Note that Microsoft Windows uses a different two-character newline CR+LF (additional U+000D Carriage Return, ^M or "\r"). Since it is based on Unix, Mac OS X follows the Unix LF standard.

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

