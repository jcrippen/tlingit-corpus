Tlingit Corpus Notes
====================

== Introduction ==

This document is a beginning guide to the use of the Tlingit language
corpus.  The corpus is under active development and things change quickly.
If you keep a personal copy, always ensure that you update it regularly.
Until better documentation is written, this document contains the most
up-to-date information available.

== Structure ==

The format of the corpus is relatively simple. It is composed of a number of
individual entries, each identified by a number. A particular entry has one
or more associated files which begin with the number of the text.

(1)	Entry 001: “Ḵákʼw / Basket Bay”
	001 Zuboff R - Basket Bay - Gloss.txt
	001 Zuboff R - Basket Bay - Text.txt
	001 Zuboff R - Basket Bay - Translation.txt

In the above example a single entry is given along with its various files.
Within each file there are many lines. Each line consists of either data or
metadata.

(2)	Example line of data (003 “Ḵaax̱ʼachgóok”):
	431	Wáa sá kwshí yándei s kagux̱dayáa?

Lines of data are preceded by a sequential number and a tab (U+0009
Character Tabulation), after which the data is given. Lines are not limited
to any particular length. Unlike entry numbers, line numbers are not zero
padded, meaning that they are not preceded by a certain number of zeroes
to ensure an equal number of digits. This is because the number of lines
varies from text to text and hence there is no fixed number of possible
digits.

Each file in an entry has exactly the same line numbers for the data. Thus
line 112 in the “Text” file is the same line as line 112 in the
“Translation” file.  It is important to note that the lines numbers referred
to are not the actual lines as counted by a program, but are instead the
line numbers given for each line of the original text.

Metadata lines begin with { and end with }. They are discussed below. These
lines are not freeform comments, but are instead an integral part of each
file with certain structure.

Each file for an entry has a specific purpose. The “Text” file is the
primary text for the entry which has been copied relatively faithfully from
the original source. Only minor emendations have been made in adapting
primary texts, mostly consisting of punctuation changes and differentiation
of punctuation versus diacritics. Notably the original orthograhy of a 
primary text is maintained.

The “Translation” file is the English (or other!) translation originally
given for the text. This translation may not actually be correct or even
accurate, however even an inaccurate translation provides clues to analysis
of the text. If no original translation existed there may be one added after
the text has been analyzed, but this is not guaranteed.

The “Gloss” file contains a detailed morphological segmentation and gloss
along with an original translation into English. The English translation
given in the “Gloss” file is meant to be linguistically faithful to the
Tlingit original rather than an aesthetically pleasing literary work, hence
it does not necessarily supersede other translations of the same text.

The “Transliteration” file contains a transliteration of the original text
into the Revised Popular orthography. Texts which already exist in this
orthography will not be transliterated. Transliteration may be done
automatically in the future, but at the moment it must be done by hand and
hence is not available for most texts that need it. Feel free to contribute.

== Metadata ==

Metadata occur on single lines beginning with an opening curly brace { and
ending with a closing curly brace } (U+007B Left Curly Bracket and U+007D
Right Curly Bracket). Metadata consist of information about a particular
text which may or may not be available in the text itself.  Metadata may be
either freeform or key-value pairs. Metadata which exist as key-value pairs
consist of a key followed by an equals = follwed by a value.  Keys are given
in Title Case. The following example demonstrates this.

(1)	{Key = Value}

The key must be in Title Case, but the value need not be, as shown below.

(2)	{Key = a lowercase value}

Lowercase values may be useful for example in tags, where a number of
arbitrary textual values are separated by commas.

(3)	{Tags = narrative, quoted speech, directionals, Haida language}

Where a metadata key-value pair has two values, one of which is in Tlingit
and the other English, then the Tlingit is given first followed by a forward
slash /, and then the English value is given. The next few examples show how
this is done.

(4)	{Title = Ḵákʼw / Basket Bay}
(5)	{Title = Táaxʼaa / Mosquito}
(6)	{Glosser = Dzéiwsh / James A. Crippen}

Where a key-value pair has only one value it is given alone, regardless
of whether it is in Tlingit or English. Thus the next example.

(7)	{Title = Ḵaax̱ʼachgóok}

=== Number ===

This is simply a key-value pair which indicates the number of the text in
the corpus. This number is unique to a text but is the same between different
files associated with the text.

(1)	{Number = 001}
(2)	{Number = 042}
(3)	{Number = 456}

Numbers are zero padded, meaning that zeroes precede the number if it is not
normally the maximum number of digits. At present only three digits are
alloted however this may grow in the distant future if more than 999 texts
are added to the corpus.

=== Type ===

The Type element indicates the type of a particular file. This is
necessary because there are multiple files for any particular text.  

(1)	{Type = Text}

The “Text” type is the fundamental type of file in the corpus. It consists of
a 

(2)	{Type = Translation}
(3)	{Type = Gloss}

=== Title ===

The Title element gives a nonunique title for the text. There are many
retellings of the “Táaxʼaa / Mosquito” story which have been recorded, and a
few exist in the written record. These are essentially the same story
although they are different narratives. Titles need not be unique since each
entry in the corpus has a unique numeric identifier. Using the same title for
several different narratives helps corpus users identify common stories for
comparison.

Non-narrative texts may not have an original “title” as such. In such cases
a descriptive title is given. A transcribed conversation might have a
description like “Conversation, Juneau, 17 January 1996”. Collections of
sentences from a dictionary, e.g. the “Tlingit Verb Dictionary” by Naish &
Story (1973), are simply named after their source document. Collections of
sentences transcribed from field notes are given a descriptive title which
includes the collector, an approximate date, and some indication of the
provenance, e.g. “Boas, notes with Shotridge, 16 June 1915”.

=== Personal names ===

Personal names occur in metadata key-value pairs such as Author, Translator,
Glosser, and Transcriber. For people who have both a Tlingit name and an
English name, both are given in the same format as for a bilingual Title.

(1)	{Glosser =  Dzéiwsh / James A. Crippen}
(2)	{Author = Stoowuḵáa / Louis Shotridge}
(3)	{Transcriber = Wéihaa / Jeff Leer}

Where only an English name or a Tlingit name is available, only that is
given. Where a particular Tlingit name is only approximately known, it can
be given in double quotes (scare quotes).

(4)	{Author = “Shquindy” / William L. Paul Sr.}

As the previous example shows, commas are not used to offset “Sr.”, “Jr.”,
or similar parts of English names. Instead commas are used to separate
multiple names.

(5)	{Transcriber = Constance Naish, Gillian Story}

Names in languages other than English or Tlingit should be transcribed in
the Latin script in a manner which is commonly used in historical or
linguistic literature written in English.

(6)	{Transcriber = Ivan Veniaminov}

The most important goal in providing names is to ensure that they are
consistent throughout the corpus. A name which already exists in the corpus
and which is spelled incorrectly or otherwise is inaccurate must be changed
throughout the entire corpus metadata and not only in one or two texts.

=== Orthography ===

This particular metadata key-value is only used with texts, and not with
translations or glosses. It indicates the orthography or transcription
system that the original text was written in. The following values are
proposed:

* SWA: Swanton, as in “Tlingit Myths and Texts”.
* BOA: Boas, as in “Grammatical Notes on the Language of the Tlingit Indians”.
* NS1: Naish-Story 1, as in the Gospel of John and the first edition of their
       noun dictionary.
* NS2: Naish-Story 2, as used in their “Tlingit Verb Dictionary”.
* RP:  Revised Popular, as used by the Dauenhauers and the second edition of
       the N&S noun dictionary. (Final vowel length may vary.)
* CAN: Canadian, as used in “Gágiwduł.àt” and the “Interior Tlingit Noun
       Dictionary”.

Some texts may be adapted from their original orthographies.

=== Source ===

The Source metadata key-value pair is a complex but conventional reference
to published and/or unpublished materials. The first part of the Source is
an author abbreviation such as “D&D” for “Dauenhauer and Dauenhauer”. The
second part is the publication year or (estimated) year of production for
unpublished sources. The third part is separated by a colon from the year,
and consists of initial and final page numbers. This third part is optional,
and where page numbers are not given it can be assumed that the entire
source is covered. Unusual page numbers are possible, e.g. “ii–xi,34,68–70”
for a single source. Specific page numbers can be given in the text using
the {Page = ...} metadata element. Note that page ranges are separated by an
en-dash (U+2013 En Dash), not a hyphen (U+002D Hyphen-Minus) or other dash.

Sources:

D 1974
	Dauenhauer, Richard. 1974. Text and context of Tlingit oral
	tradition. Madison: University of Wisconsin at Madison PhD
	dissertation.
D&D 1981
	Dauenhauer, Nora Marks & Richard Dauenhauer, eds. “Because we
	cherish you”: Sealaska elders speak to the future. Juneau: Sealaska
	Heritage Foundation.
D&D 1987
	Dauenhauer, Nora Marks & Richard Dauenhauer. 1987. Haa shuká: Our
	ancestors. Seattle: University of Washington Press. ISBN 0-295-
	96495-2.
D&D 1990
	Dauenhauer, Nora Marks & Richard Dauenhauer. 1990. Haa tuwunáagu
	yís: For healing our spirit. Seattle: University of Washington
	Press.
D&D 1998
	Dauenhauer, Nora Marks & Richard Dauenhauer. 1998. Tracking “Yuwaan
	Gagéets”: A Russian fairy tale in Tlingit oral tradition. Oral
	Tradition 13(1): 58–91.
D&D 2002
	Dauenhauer, Nora Marks & Richard Dauenhauer. 2002. Lingít x̱ʼéináx̱
	sá! Say it in Tlingit: A Tlingit phrasebook. Juneau: Sealaska
	Heritage Institute. ISBN 0-9679311-1-8.
D&D 2008
	Dauenhauer, Nora Marks, Richard Dauenhauer, & Lydia Black. 2008.
	Anóoshi Lingít Aaní ká: Russians in Tlingit America. Seattle:
	University of Washington Press. ISBN 978-0-295-96801-2.
N&S 1973
	Naish, Constance & Gillian Story. Tlingit verb dictionary.
	Fairbanks: Alaska Native Language Center.

=== Comments ===

Comments are given with the “Comment” key. There may be multiple comments
in a file, or none at all. The format of a comment value is freeform, but
necessarily cannot include the } character. Use of = is permitted, however.

== Encoding ==

All text in the corpus is in the Unicode character set. UTF-8 is the only
encoding used in the corpus. Text in any other encoding or character set
must be converted to Unicode UTF-8 before being added.

The underscore diacritic used in most modern Tlingit orthographies is
encoded in Unicode as U+0331 Combining Macron Below. Use of U+1E34 Latin
Capital Letter K with Line Below and U+1E35 Latin Small Letter K with Line
Below is permissible since these are canonically equivalent with the base
letter plus U+0331.

The use of precomposed characters (canonical composites) versus independent
base characters and diacritic characters is largely irrelevant to most
users. The corpus maintainer will ensure that a single Unicode normalization
form is used. At this point it is unclear which one is most appropriate,
though NFC will probably be adopted as it is already in use. Conversion to
other normalization forms is available using existing software.
	
The orthographic apostrophe is encoded as U+02BC Modifier Letter Apostrophe,
the semantics of which is specified by Unicode as a modifier letter rather
than punctuation. The U+0027 Apostrophe must not be used for this purposes
because that character is specified as punctuation rather than a letter.
Furthermore, U+2019 Right Single Quotation Mark also must not be used as the
orthographic apostrophe in Tlingit text.

In general the Unicode quotation mark characters (U+2018 ‘, U+2019 ’,
U+201C “, and U+201D ”) should be used instead of the ASCII quotation mark
characters (U+0027 ' and U+0022 "). This eases the burden of working
programmatically with the corpus since the ASCII quotation mark characters
have special meaning in programming languages, markup languages, and regular
expressions.

Although preserving the punctuation of original texts is important, for
unpublished texts it may be useful to adopt guillemets (U+2039 ‹, U+203A ›
U+00AB «, and U+00BB ») for quotation marks in Tlingit text. These have the
same orthographic function as English-style quotation marks, but are
visually distinct from the orthographic apostrophe used to indicate
ejectives and the vowel-final glottal stop. The French arrangement of «...»
is probably better than the German arrangement of »...« due to similarity
with “...” and (...).  European custom is to separate guillemets from the
quoted text with spaces for typographic aesthetic reasons, this is not
necessary here since the object is not fine typography nor is there a
tradition with which to conform.

The Unix convention of line breaking is used, with U+000A Line Feed
representing the end of a line (LF). Microsoft Windows usually uses U+000D
Carriage Return in addition to U+000A Line Feed (CRLF), and Mac OS X
traditionally uses a mix of both the “newer” Unix-style and the “older” Mac
OS convention of just U+000D Carriage Return (CR). Conversion between the
CR, CRLF, and LF line breaking conventions is left to the user, the corpus
will only use the LF line breaking convention.

== Use ==

This section documents some possible uses for the corpus.

=== Scripts ===

There are a small number of scripts included as illustration of what can be
done with the corpus.

The simplest script included is "wordcount.sh" which counts the number of
orthographic words (words separated by whitespace) in a given file. This is
a Unix shell script and so will only run on Unix-based systems such as Mac
OS X or Linux (or Windows running a Unix-compatible shell such as Cygwin).

(1)	Count the number of orthographic words in the primary texts:
	$ ./wordcount.sh *Text*
	    3630
