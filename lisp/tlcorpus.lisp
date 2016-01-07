;;; -*- Mode: Common-Lisp -*-
;;;
;;; TlCorpus: The Tlingit corpus research utility.
;;;
;;; In progress.

(in-package :cl-user)

(require :cl-unicode)
(require :cl-ppcre)

(defpackage "TLCORPUS"
  (:use :common-lisp :cl-unicode :cl-ppcre)
  (:documentation
   "The TLCORPUS package is a research utility for parsing, processing, and
querying the Tlingit Corpus. This corpus is a set of text files with numbered
lines and minimally structured metadata that represents the transcribed and
translated Tlingit narratives and oratory collected by several scholars in the
20th and 21st centuries."))

(in-package :tlcorpus)

  ;;
;;;;;; Assorted constants and variables.
  ;;

(defvar *corpus-entries* nil
  "A list of corpus entries, each an instance of the class CORPUS-ENTRY.")

;;; FIXME: This should be obtained from CL-UNICODE or something.
(defconstant +whitespace+
  '(#\Space #\Tab #\Newline #\Linefeed #\CR #\Page)
  "A list of whitespace characters.")

  ;;
;;;;;; Orthographies.
  ;;

;;; FIXME: This should be read in from a corpus configuration file, e.g. named
;;; "orthography-config.txt" and containing lines like "{SWA = Swanton...}".
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

;;; This could just as easily be a cons, but as a class it has a known type.
(defclass corpus-keyval ()
  ((key   :type string
          :initarg :key)
   (value :type string
          :initarg :value))
  (:documentation
   "Representation of a corpus metadatum key-value pair. The KEY is the
element preceding the equals sign and the VALUE is the material following the
equals sign. Thus in {Page = 62} the KEY is Page and the VALUE is 62. Note
that both KEY and VALUE are strings."))

(defclass corpus-file-line ()
  ((type  :type (member :empty :data :meta :other)
          :initarg :type
          :documentation "The type of line: empty, data, metadata, or other.")
   (index :type fixnum
          :initarg :index
          :documentation "The index (raw line number) in the corpus file.")
   (raw   :type string
          :initarg :raw
          :documentation "The raw, unparsed line as read from the file."))
  (:documentation
   "Representation of a line in a corpus file. This class is only instantiated
when the TYPE is :OTHER. For the :EMPTY, :DATA, and :META types there are
subclasses to be used instead. The INDEX slot contains the offset of the line
from the beginning of the file, thus the raw line number in the file. This is
distinct from the TEXTNUM slot in the subclass CORPUS-FILE-LINE-DATA, q.v. The
RAQ slot contains the raw line as read from the file, without any whitespace
stripping or other processing."))

(defclass corpus-file-line-empty (corpus-file-line)
  ((type :initform   :empty
         :allocation :class))
  (:documentation
   "Representation of an empty line in a corpus file."))

(defclass corpus-file-line-data (corpus-file-line)
  ((type     :initform :data
             :allocation :class)
   (textnum  :type (or fixnum nil)
             :initarg :textnum
             :documentation "The line number in the original publication.")
   (contents :type string
             :initarg :contents
             :documentation "The contents of the line without the number."))
  (:documentation
   "Representation of a line in a corpus file which contains text from a
publication or manuscript. The TEXTNUM slot contains the line number at the
beginning of the line and the CONTENTS slot contains the rest of the line
excluding the #\Tab character that separates the two fields."))

(defclass corpus-file-line-meta (corpus-file-line)
  ((type   :initform :meta
           :allocation :class)
   (keyval :type corpus-keyval
           :initarg :keyval
           :documentation "The key-value pair of the line.")))

(defclass corpus-file ()
  ((pathname :type pathname
             :initarg :pathname
             :documentation "A relative pathname to where the file is located.")
   (name     :type string
             :initarg :name
             :documentation "The name of the corpus file, including extension.")
   (type     :type keyword
             :initarg :type
             :documentation "The type of corpus file.")
   (lines    :type (simple-vector corpus-file-line)
             :initarg :lines
             :documentation "The contents of the file as a vector of lines.")
   (length   :type fixnum
             :initarg :length
             :documentation "Length of the file in lines."))
  (:documentation
   "Representation of a file in the corpus."))

(defclass corpus-entry ()
  ((identifier  :type keyword)
   (number      :type fixnum)
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
;;;;;; Parsing.
  ;;

;;; A lot of the parsing in this section is so simple that it doesn't require
;;; any kind of real parser, or even regular expressions. That's because the
;;; format of the corpus is very simple.

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
      ;; FIXME: Also check for a final brace.
      ((equal (char l 0) #\{) :META)
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

(defun make-line (str idx)
  "Creates an instance of one of the subclasses of CORPUS-FILE-LINE depending
on the contents of the string STR. The argument IDX should be a positive
integer which is the index (raw line number) in the file."
  (declare (string str) (fixnum idx))
  (let ((type (parse-line-type str)))
    (cond ((eq type :EMPTY)
           (make-instance 'corpus-file-line-empty
                          :raw   str    ;even empty lines have content
                          :index idx))
          ((eq type :DATA)
           (make-instance 'corpus-file-line-data
                          :raw      str
                          :index    idx
                          :textnum  (parse-line-textnum str)
                          :contents (parse-line-contents str)))
          ((eq type :META)
           (make-instance 'corpus-file-line-meta
                          :raw    str
                          :index  idx
                          :keyval (make-instance 'corpus-keyval
                                                :key (parse-line-key str)
                                                :value (parse-line-value str))))
          ((eq type :OTHER)
           (make-instance 'corpus-file-line
                          :type  :other
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
                               :pathname (merge-pathnames file))))
    (with-open-file (s (merge-pathnames file)
                       :direction :input
                       ;;; FIXME: The value of EXTERNAL-FORMAT is not
                       ;;; standard. We probably need some read-time
                       ;;; conditionals for encoding stuff, but in the
                       ;;; meantime SBCL, CCL, ECL, ABCL, and CMUCL all
                       ;;; accept :UTF-8. CLISP doesn't.
                       :external-format :utf-8
                       :if-does-not-exist :error)
      (loop for line = (read-line s nil)
         for index from 0              ;should we count from 1 instead?
         until (null line)
         do (vector-push-extend (make-line line index)
                                (slot-value filobj 'lines))
         finally (setf (slot-value filobj 'length) index)))
    filobj))
