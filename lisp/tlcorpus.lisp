;;; -*- Mode: Common-Lisp -*-
;;;
;;; TlCorpus: The Tlingit corpus research utility.
;;;
;;; This program is still in progress and is not yet usable. Eventually it
;;; will be a utility for exploring the corpus with regular expressions,
;;; statistical analysis, and recursive functions. In particular the data
;;; structure representations are designed so that context is easy to access,
;;; and so it is easy to switch between text, translation, and other files in
;;; corpus entries.
;;;
;;; The primary development platform is SBCL on Mac OS X, but the code is
;;; regularly tested in Clozure CL and occasionally also ECL, CMUCL, and ABCL.

(in-package :cl-user)

;;; We don't use these yet, but we will at some point.
(require :cl-unicode)
(require :cl-ppcre)
(require :cl-interpol)

(defpackage "TLCORPUS"
  (:use :common-lisp :cl-unicode :cl-ppcre :cl-interpol)
  (:documentation
   "The TLCORPUS package is a research utility for parsing, processing, and
querying the Tlingit Corpus. This corpus is a set of text files with numbered
lines and minimally structured metadata that represents the transcribed and
translated Tlingit narratives and oratory collected by several scholars in the
20th and 21st centuries."))

(in-package :tlcorpus)

;;; Debugging.
(defvar foo nil)
(defvar foodir "../")
(defvar foofile "001 Zuboff R - Basket Bay - Text.txt")
(defvar foopath (merge-pathnames (concatenate 'string foodir foofile)))

  ;;
;;;;;; Assorted constants and variables.
  ;;

(defvar *corpus-entries* nil
  "A list of corpus entries, each an instance of the class CORPUS-ENTRY.")

(defconstant +whitespace+
  (list-all-characters "White_Space")
  "A list of whitespace characters. These are obtained from CL-UNICODE by
listing all Unicode characters with the White_Space property.")

  ;;
;;;;;; Orthographies.
  ;;

;;; FIXME: This should be read in from ../metadata/orthography-list.txt.
(defconstant +orthographies+
  '(("SWA" . "Swanton as in _Tlingit Myths and Texts_")
    ("BS"  . "Boas, Shotridge, and Velten.")
    ("NS1" . "Naish-Story 1, as in _Gospel of John_")
    ("NS1" . "Naish-Story 2, as in _Tlingit Verb Dictionary_")
    ("RP"  . "Revised Popular as used by the Dauenhauers")
    ("YNL" . "Yukon Native Language Centre as in Leer & Nyman 1993")
    ("EML" . "Email orthography as used variously online")))

(defun lookup-orthography (str)
  "Fetches an entry in the alist +ORTHOGRAPHIES+ with the key STR which must
be a string."
  (declare (string str))
  (assoc str +orthographies+ :test #'equal))

(defun orthography-description (str)
  "Fetches the description of an orthography in the alist +ORTHOGRAPHIES+."
  (declare (string str))
  (cdr (lookup-orthography str)))

(defun orthographyp (str)
  "True if an orthography indicator string STR is known in the alist
+ORTHOGRAPHIES+. STR must be a string."
  (declare (string str))
  (if (not (null (lookup-orthography str)))
      t nil))

;;; TODO: Some functions to scan all entries and extract new orthographies from
;;; their metadata, then update the listing in metadata/orthography-list.txt.
;;; This requires a metadata writer as well as the parser already implemented.

  ;;
;;;;;; Classes.
  ;;

;;; FIXME: The right way to do this would be to use the LOCAL-TIME library.
(defclass date ()
  ((year    :type fixnum)
   (month   :type string)
   (daynum  :type fixnum)
   (dayname :type string)))

(defclass place ()
  ((identifier   :type keyword)
   (tlingit-name :type string)
   (english-name :type string)
   (dialects     :type list)))

(defclass person ()
  ((identifier    :type keyword
                  :documentation "A unique keyword identifier for this person.")
   (given-name    :type string
                  :documentation "The person's given (first) name.")
   (family-name   :type string
                  :documentation "The person's family (last) name.")
   (tlingit-p     :type boolean
                  :documentation "Whether the person is Tlingit-like or not.")
   ;; The following slots can be NIL if TLINGIT-P is NIL.
   (clan          :type (or string nil)
                  :documentation "The person's clan in Tlingit.")
   (house         :type (or string nil)
                  :documentation "The person's house in Tlingit.")
   (moiety        :type (member :raven :wolf/eagle)
                  :documentation "A keyword representing one of the moieties.")
   (paternal-clan :type (or string nil)
                  :documentation "The person's paternal clan in Tlingit."))
  (:documentation
   "Representation of a person identified in the corpus."))

(defclass corpus-source ()
  ((abbrev :type string
           :documentation "A unique abbreviation, usually initials and a year.")
   (author :type (list person)
           :documentation "An author or authors of a source.")
   (date   :type date
           :documentation "A date of publication or manuscript production.")
   (title  :type string
           :documentation "A tile identifying the publication or manuscript."))
  (:documentation
   "Representation of a bibliographic source for a text and/or translation.
This representation is quite primitive, including only the material necessary
to easily identify a publication or manuscript. This could be much richer but
there are only so many sources to consider for Tlingit text so not much data
is necessary to uniquely identify a particular bibliographic source."))

(defclass corpus-file-line ()
  ((type  :type     (member :empty :data :meta :other)
          :initarg  :type
          :accessor line-type
          :documentation "The type of line: empty, data, metadata, or other.")
   (file  :type     corpus-file
          :initarg  :file
          :accessor line-file
          :documentation "The CORPUS-FILE instance containing this object.")
   (raw   :type     string
          :initarg  :raw
          :accessor line-raw
          :documentation "The raw, unparsed line as read from the file.")
   (index :type     fixnum
          :initarg  :index
          :accessor line-index
          :documentation "The index (raw line number) in the corpus file."))
  (:documentation
   "Representation of a line in a corpus file. This class is only instantiated
when the TYPE is :OTHER. For the :EMPTY, :DATA, and :META types there are
subclasses to be used instead. The INDEX slot contains the offset of the line
from the beginning of the file, thus the raw line number in the file. This is
distinct from the TEXTNUM slot in the subclass CORPUS-FILE-LINE-DATA, q.v. The
RAW slot contains the raw line as read from the file, without any whitespace
stripping or other processing."))

(defclass corpus-file-line-empty (corpus-file-line)
  ((type :initform   :empty
         :allocation :class))
  (:documentation
   "Representation of an empty line in a corpus file."))

(defclass corpus-file-line-data (corpus-file-line)
  ((type     :initform   :data
             :allocation :class)
   (textnum  :type       (or fixnum nil)
             :initarg    :textnum
             :accessor   data-textnum
             :documentation "The line number in the original publication.")
   (contents :type       string
             :initarg    :contents
             :accessor   data-contents
             :documentation "The contents of the line without the number."))
  (:documentation
   "Representation of a line in a corpus file which contains text from a
publication or manuscript. The TEXTNUM slot contains the line number at the
beginning of the line and the CONTENTS slot contains the rest of the line
excluding the #\Tab character that separates the two fields."))

(defclass corpus-file-line-meta (corpus-file-line)
  ((type  :initform   :meta
          :allocation :class)
   (key   :type       string
          :initarg    key
          :accessor   meta-key)
   (value :type       string
          :initarg    value
          :accessor   meta-value)))

(defclass corpus-file ()
  ((pathname :type    pathname
             :initarg :pathname
             :documentation "A pathname to where the file is located.")
   (name     :type    string
             :initarg :name
             :documentation "The name of the corpus file.")
   (type     :type    string
             :initarg :type
             :documentation "The type of corpus file.")
   (title    :type    string
             :initarg :title
             :documentation "The title of the text in the corpus file.")
   (lines    :type    (vector corpus-file-line)
             :initarg :lines
             :documentation "The contents of the file as a vector of lines.")
   (length   :type    fixnum
             :initarg :length
             :documentation "Length of the file in lines."))
  (:documentation
   "Representation of a file in the corpus. The slot PATHNAME contains a
pathname for the file, and the slot NAME contains just the file's name. The
slot TYPE contains a string extracted from the file's header metadata that is
e.g. Text or Translation. The TITLE slot is the title of the text, also
extracted from the header metadata. The LINES slot contains a vector of all of
the raw lines in the file, in order. This is a vector rather than a list so
that each line's position can be easily obtained, and so that fill pointers
can be used to track position while processing lines. The LENGTH slot contains
a fixnum that is the total number of raw lines in the file. The length of the
vector LINES may be larger than the LENGTH slot because the vector is
adjustable and Lisp implementations may allocate a larger size than necessary
for adjustable vectors."))

(defclass corpus-entry ()
  ((number      :type fixnum)
   (title       :type string)
   (author      :type person)
   (transcriber :type person)
   (translator  :type person)
   (glosser     :type person)
   (source      :type source)
   (pages-start :type fixnum)
   (pages-end   :type fixnum)
   (orthography :type string)
   (dialect     :type string)
   (date        :type date)
   (text-file   :type (or corpus-file nil))
   (trans-file  :type (or corpus-file nil))
   (orig-file   :type (or corpus-file nil))
   (gloss-file  :type (or corpus-file nil)))
  (:documentation
   "Representation of an entry in the corpus, a single narrative or oratory
performance transcribed and translated in some publication or manuscript.  A
corpus entry relates a few files together, namely a TEXT-FILE that contains
the text in the Revised Popular orthography, a TRANS-FILE that contains the
corresponding line-by-line English translation, an ORIG-FILE that contains
the text in its original orthography if this was not RP, and a GLOSS-FILE
that contains a simple interlinear gloss of the Tlingit text."))

  ;;
;;;;;; Line parsing.
  ;;

;;; A lot of the parsing in this section is so simple that it doesn’t require
;;; any kind of real parser, or even just regular expressions. That’s because
;;; the format of the corpus is very simple.

(defun tabspot (str)
  "Return the position of the first tab in a string. Used for parsing data lines,
separating the text line number from the text content."
  (declare (string str))
  (position #\Tab str))

(defun parse-line-type (line)
  "Determines whether a string LINE contains metadata enclosed in {}s, or if
it contains data (an original line in a text), or if it is empty. Returns one
of the three keywords :META, :DATA, or :EMPTY. These keywords are acceptable
values for the TYPE slot of an instance of CORPUS-FILE-LINE."
  (declare (string line))
  (let ((l (string-trim +whitespace+ line)))
    (cond
      ((eq (length l) 0) :EMPTY)
      ((equal (char l 0) #\{)
       (progn
         (if (not (equal (char l (1- (length l))) #\}))
             (warn "Missing closing brace.")) ;FIXME: file, line number?
         :META))
      ;; FIXME: This is hackish.
      ((numberp (values (parse-integer (subseq l 0 (tabspot l))))) :DATA)
      (t :OTHER))))

(defun parse-line-textnum (line)
  "Returns the textual line number of a string LINE if it is of type :DATA. If
there is no number, if the number is invalid, or if the LINE is not :DATA then
returns NIL."
  (declare (string line))
  (if (not (eq (parse-line-type line) :DATA))
      nil
      (let ((l (string-trim +whitespace+ line)))
        (values (parse-integer (subseq l 0 (tabspot l)))))))

(defun parse-line-contents (line)
  "Returns the contents of a line, excluding the textual line number and tab
that precede the contents. If the line is not :DATA then returns NIL."
  (declare (string line))
  (if (not (eq (parse-line-type line) :DATA))
      nil
      (let ((l (string-trim +whitespace+ line)))
        (subseq l (1+ (tabspot l))))))

(defun parse-line-key (line)
  "Returns the key of a metadata key-value pair as a string, or NIL if one
could not be found."
  (declare (string line))
  (if (not (eq (parse-line-type line) :META))
      nil
      (string-trim +whitespace+
                   (subseq line (1+ (position #\{ line))
                                (1- (position #\= line))))))

(defun parse-line-value (line)
  "Returns the value of a metadata key-value pair as a string, or NIL if one
could not be found."
  (declare (string line))
  (if (not (eq (parse-line-type line) :META))
      nil
      (string-trim +whitespace+
                   (subseq line (1+ (position #\= line))
                                (position #\} line)))))

(defun make-line (str idx file)
  "Creates an instance of one of the subclasses of CORPUS-FILE-LINE depending
on the contents of the string STR. The argument IDX is a positive integer
which is the index (raw line number) in the file. The argument FILE is an
instance of CORPUS-FILE which contains the line."
  (declare (string str) (fixnum idx))
  (let ((type (parse-line-type str)))
    (cond ((eq type :EMPTY)
           (make-instance 'corpus-file-line-empty
                          :file  file
                          :raw   str    ;even empty lines have content
                          :index idx))
          ((eq type :DATA)
           (make-instance 'corpus-file-line-data
                          :file     file
                          :raw      str
                          :index    idx
                          :textnum  (parse-line-textnum str)
                          :contents (parse-line-contents str)))
          ((eq type :META)
           (make-instance 'corpus-file-line-meta
                          :file  file
                          :raw   str
                          :index idx
                          :key   (parse-line-key str)
                          :value (parse-line-value str)))
          ((eq type :OTHER)
           (make-instance 'corpus-file-line
                          :type  :other
                          :file  file
                          :raw   str
                          :index idx))
          ;; Can't happen.
          (t nil))))

(defun parse-file (file)
  "Parses a file with pathname FILE and returns an instance of CORPUS-FILE
representing the parsed file. Calls MAKE-LINE on each line in the file and
stores the result in the LINES slot of the CORPUS-FILE object."
  (let ((filobj (make-instance 'corpus-file
                               :lines (make-array 0
                                              :element-type 'corpus-file-line
                                              :adjustable t
                                              :fill-pointer t)
                               :name (file-namestring (merge-pathnames file))
                               :pathname (merge-pathnames file))))
    (with-open-file (s (merge-pathnames file)
                       :direction :input
                       ;; FIXME: The value :UTF-8 for :EXTERNAL-FORMAT
                       ;; is not standard. We probably need some read-time
                       ;; conditionals for this, but in the meantime SBCL,
                       ;; CCL, ECL, ABCL, and CMUCL all accept :UTF-8.
                       ;; CLISP notably doesn’t. Allegro? LispWorks?
                       ;; Corman? GCL? Scieneer?
                       :external-format :utf-8
                       :if-does-not-exist :error)
      (loop for line = (read-line s nil)
         for index from 0              ;should we count from 1 instead? nah.
         until (null line)
         do (vector-push-extend (make-line line index filobj)
                                (slot-value filobj 'lines))
            finally (setf (slot-value filobj 'length) index)))
    filobj))

  ;;
;;;;;; File metadata processing.
  ;;

;;;; The functions in this section look in a CORPUS-FILE instance to find
;;;; metadata lines with particular keys or values. In a single file some keys
;;;; are unique like "Number" and "Type", other keys appear multiple times
;;;; like "Page" and "Comment". The unique keys need to be parsed out of the
;;;; file and stored in slots in the CORPUS-FILE instance for efficient
;;;; querying. Although all of these functions take a CORPUS-FILE instance
;;;; as an argument, there's no point in creating generic functions because
;;;; they will never be used on anything other than a CORPUS-FILE. The extra
;;;; dispatch indirection with generic functions is thus unnecessary.

(defun get-file-metadata-lines (file)
  "Returns a list of all metadata lines in the CORPUS-FILE instance FILE. This
checks against the class CORPUS-FILE-LINE-META and not the :TYPE slot."
  (declare (corpus-file file))
  (loop for l across (slot-value file 'lines)
        when (typep l 'corpus-file-line-meta)
          collect l))

(defun get-file-header-lines (file)
  "Returns a list of all metadata lines in the header of the CORPUS-FILE
instance FILE. The segment of the file before the text data begins is called
the header. The last metadatum in the header is actually the first Page
metadatum of the text data so all Page metadata are excluded from the result."
  (declare (corpus-file file))
  (loop for l across (slot-value file 'lines)
        until (and (not (typep l 'corpus-file-line-meta)))
        when (typep l 'corpus-file-line-meta)
          when (not (equal (slot-value l 'key) "Page"))
            collect l))

(defun get-file-header-alist (file)
  "Returns an association list of the header metadata keyvals in the
CORPUS-FILE instance FILE. Only searches the header as defined by the function
GET-FILE-METADATA-HEADER-LINES."
  (declare (corpus-file file))
  (let ((metadata (get-file-header-lines file)))
    (loop for m in metadata
          collect (cons (meta-key m) (meta-value m))))))

(defun get-file-header-key-list (file)
  "Returns a list of the header metadata keys in the CORPUS-FILE instance
FILE. Only searches the header as defined by GET-FILE-METADATA-HEADER-LINES."
  (declare (corpus-file file))
  (let ((metadata (get-file-header-lines file)))
    (loop for m in metadata
          collect (meta-key m)))))

(defun get-file-header-value-list (file)
  "Returns a list of the header metadata values in the CORPUS-FILE instance
FILE. Only searches the header as defined by GET-FILE-METADATA-HEADER-LINES."
  (declare (corpus-file file))
  (let ((metadata (get-file-header-lines file)))
    (loop for m in metadata
          collect (meta-value m)))))

(defun get-file-header-value (file key)
  "Returns the header metadatum value corresponding to the keyval KEY in the
CORPUS-FILE instance FILE. Only searches the header as defined by the function
GET-FILE-METADATA-HEADER-LINES. If no match then returns NIL. Note that this
only returns the first instance of KEY, not any later ones."
  (declare (corpus-file file)
           (string key))
  (let* ((metadata (get-file-header-lines file))
         (metadatum (find-if #'(lambda (m) (equal (meta-key m) key)))
                             metadata))
    (if (not (null metadatum))
        (meta-value metadatum)
        nil)))

  ;;
;;;;;; Corpus file and entry creation.
  ;;
