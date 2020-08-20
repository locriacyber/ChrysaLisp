;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; tokens - ChrysaLisp YAML Reader
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import 'lib/xtras/xtras.inc)
(import 'lib/yaml-data/reader.lisp)

; STREAM-START
; STREAM-END
; DOCUMENT-START
; DOCUMENT-END
; BLOCK-SEQUENCE-START
; BLOCK-MAPPING-START
; BLOCK-END
; FLOW-SEQUENCE-START
; FLOW-MAPPING-START
; FLOW-SEQUENCE-END
; FLOW-MAPPING-END
; BLOCK-ENTRY
; FLOW-ENTRY
; KEY
; VALUE
; SCALAR(value, plain, style)
; DIRECTIVE(name, value)    ----- NOT SUPPORTED
; ALIAS(value)              ----- NOT SUPPORTED
; ANCHOR(value)             ----- NOT SUPPORTED
; TAG(value)                ----- NOT SUPPORTED


(defun Token (ttype sm em)
  (properties
      :type       ttype
      :start_mark sm
      :end_mark   sm))

(defun StreamStart (&optional sm em)
  (Token :stream_start sm em))

(defun StreamEnd (&optional sm em)
  (Token :stream_end sm em))

(defun DocumentStart (&optional sm em)
  (Token :document_start sm em))

(defun DocumentEnd (&optional sm em)
  (Token :document_end sm em))

(defun BlockSequenceStart (sm)
  (Token :blockseq_start sm sm))

(defun BlockMappingStart ()
  (Token :blockmap_start nil nil))

(defun BlockEntry (sm em)
  (Token :block_entry sm em))

(defun BlockEnd (mrks)
  (Token :block_end mrks mrks))

(defun FlowSequenceStart ()
  (Token :flowseq_start nil nil))

(defun FlowSequenceEnd ()
  (Token :flowseq_end nil nil))

(defun FlowMappingStart ()
  (Token :flowmap_start nil nil))

(defun FlowMappingEnd ()
  (Token :flowmap_end nil nil))

(defun FlowEntry ()
  (Token :flow_entry nil nil))

(defun Key ()
  (Token :key nil nil))

(defun Value ()
  (Token :value nil nil))

(defun Scalar (val plain sm em &optional style)
  (setsp! (Token :scalar sm em)
          :value val
          :plain plain
          :style style))

