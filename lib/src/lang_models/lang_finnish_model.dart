// ignore_for_file: constant_identifier_names

/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Mozilla Communicator client code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 1998
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

library;

import "../internal_types.dart";
import '../types.dart';

/********* Language model for: Finnish *********/

/// Generated by BuildLangModel.py
/// On: 2022-12-14 23:54:09.799915
///

/* Character Mapping Table:
 * ILL: illegal character.
 * CTR: control character specific to the charset.
 * RET: carriage/return.
 * SYM: symbol (punctuation) that does not belong to word.
 * NUM: 0 - 9.
 *
 * Other characters are ordered by probabilities
 * (0 is the most common character in the language).
 *
 * Orders are generic to a language. So the codepoint with order X in
 * CHARSET1 maps to the same character as the codepoint with the same
 * order X in CHARSET2 for the same language.
 * As such, it is possible to get missing order. For instance the
 * ligature of 'o' and 'e' exists in ISO-8859-15 but not in ISO-8859-1
 * even though they are both used for French. Same for the euro sign.
 */

// dart format off
const _kIso_8859_1_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM,SYM, 76,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* BX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27, 77, 45, 78, 38, 47, 65, /* CX */
   53, 51, 79, 31, 49, 75, 21,SYM, 52, 80, 39, 68, 34, 69, 71, 62, /* DX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27, 81, 45, 82, 38, 47, 65, /* EX */
   53, 51, 83, 31, 49, 75, 21,SYM, 52, 84, 39, 68, 34, 69, 71, 85, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_4_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM, 72, 86, 67,SYM, 87, 88,SYM,SYM, 29, 43, 89, 90,SYM, 33,SYM, /* AX */
  SYM, 72,SYM, 67,SYM, 91, 92,SYM,SYM, 29, 43, 93, 94, 44, 33, 44, /* BX */
   35, 30, 60, 63, 12, 42, 40, 95, 48, 27, 64, 45, 96, 38, 47, 46, /* CX */
   97, 58, 56, 66, 49, 75, 21,SYM, 52, 98, 39, 68, 34, 99, 57, 62, /* DX */
   35, 30, 60, 63, 12, 42, 40,100, 48, 27, 64, 45,101, 38, 47, 46, /* EX */
  102, 58, 56, 66, 49, 75, 21,SYM, 52,103, 39, 68, 34,104, 57,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_9_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM,SYM,105,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* BX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,106, 45,107, 38, 47, 65, /* CX */
   55, 51,108, 31, 49, 75, 21,SYM, 52,109, 39, 68, 34,110,111, 62, /* DX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,112, 45,113, 38, 47, 65, /* EX */
   55, 51,114, 31, 49, 75, 21,SYM, 52,115, 39, 68, 34, 74,116,117, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_13_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 52,SYM, 67,SYM,SYM,SYM,SYM, 40, /* AX */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 52,SYM, 67,SYM,SYM,SYM,SYM, 40, /* BX */
   72,118, 35, 61, 12, 42, 64, 43, 48, 27, 59,119,120, 66, 46,121, /* CX */
   29, 36, 58, 31, 56, 75, 21,SYM,122, 32, 50, 57, 34, 70, 33, 62, /* DX */
   72,123, 35, 61, 12, 42, 64, 43, 48, 27, 59,124,125, 66, 46,126, /* EX */
   29, 36, 58, 31, 56, 75, 21,SYM,127, 32, 50, 57, 34, 70, 33,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_15_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM, 29,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM, 33,128,SYM,SYM, 33,SYM,SYM,SYM, 73, 73,129,SYM, /* BX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,130, 45,131, 38, 47, 65, /* CX */
   53, 51,132, 31, 49, 75, 21,SYM, 52,133, 39, 68, 34, 69, 71, 62, /* DX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,134, 45,135, 38, 47, 65, /* EX */
   53, 51,136, 31, 49, 75, 21,SYM, 52,137, 39, 68, 34, 69, 71,138, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kWindows_1252_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 4X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 22, 18,  4, 23, 19, 16,  1, 14,  9,  6, 11,  3,  7, /* 6X */
   15, 28, 10,  5,  2,  8, 13, 24, 26, 17, 25,SYM,SYM,SYM,SYM,CTR, /* 7X */
  SYM,ILL,SYM,139,SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM, 73,ILL, 33,ILL, /* 8X */
  ILL,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM, 73,ILL, 33,140, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM,SYM,141,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* BX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,142, 45,143, 38, 47, 65, /* CX */
   53, 51,144, 31, 49, 75, 21,SYM, 52,145, 39, 68, 34, 69, 71, 62, /* DX */
   54, 30, 60, 63, 12, 42, 40, 41, 37, 27,146, 45,147, 38, 47, 65, /* EX */
   53, 51,148, 31, 49, 75, 21,SYM, 52,149, 39, 68, 34, 69, 71,150, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

// const _kUnicode_Char_size = 58;
const _kUnicode_CharOrder =
[
   65,  0,  66, 20,  67, 22,  68, 18,  69,  4,  70, 23,  71, 19, 72, 16,
   73,  1,  74, 14,  75,  9,  76,  6,  77, 11,  78,  3,  79,  7, 80, 15,
   81, 28,  82, 10,  83,  5,  84,  2,  85,  8,  86, 13,  87, 24, 88, 26,
   89, 17,  90, 25,  97,  0,  98, 20,  99, 22, 100, 18, 101,  4,102, 23,
  103, 19, 104, 16, 105,  1, 106, 14, 107,  9, 108,  6, 109, 11,110,  3,
  111,  7, 112, 15, 113, 28, 114, 10, 115,  5, 116,  2, 117,  8,118, 13,
  119, 24, 120, 26, 121, 17, 122, 25, 196, 12, 201, 27, 214, 21,228, 12,
  233, 27, 246, 21,
];


/* Model Table:
 * Total considered sequences: 1146 / 841
 * - Positive sequences: first 417 (0.9950442901604022)
 * - Probable sequences: next 226 (643-417) (0.003959181230548281)
 * - Neutral sequences: last 198 (0.0009965286090495296)
 * - Negative sequences: -305 (off-ratio)
 * Negative sequences(todo): 
 */
const _kFinnishLangModel =
[
  3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,1,3,3,3,3,2,0,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,1,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,3,3,1,2,2,3,3,2,2,2,0,2,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,0,1,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,2,3,0,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,3,3,3,2,2,3,0,2,2,
  3,3,3,2,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,3,3,2,3,2,1,1,2,1,
  3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,0,3,3,3,2,2,0,1,
  3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,3,3,2,3,3,3,1,3,3,2,2,2,1,1,
  3,3,3,3,3,3,3,3,3,3,3,3,3,2,1,2,3,3,1,2,1,3,1,2,2,1,0,1,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,2,2,2,2,
  3,3,2,2,3,3,2,3,3,2,2,3,3,1,2,3,2,3,1,2,3,2,2,2,2,2,1,2,1,
  3,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,3,1,1,1,1,1,1,0,0,0,0,
  3,3,1,1,3,2,2,3,3,1,2,1,3,1,1,0,1,3,2,1,0,0,1,1,0,0,0,1,0,
  3,3,2,2,3,2,2,3,3,2,1,2,3,1,0,1,1,3,1,0,1,3,1,2,0,0,0,1,0,
  3,3,3,2,3,3,3,3,3,2,3,2,3,1,1,3,3,3,2,1,1,3,1,2,1,1,0,2,0,
  3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,1,1,3,3,1,1,2,1,1,2,3,0,2,0,
  3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,2,2,3,2,2,1,1,1,0,0,
  3,3,2,2,3,3,2,3,3,0,3,2,3,3,2,2,3,3,2,2,2,2,2,2,2,2,0,2,1,
  3,3,2,3,3,2,3,3,3,2,3,2,1,1,1,2,3,3,2,2,2,2,1,1,2,1,0,1,0,
  3,3,2,3,3,3,3,3,3,2,3,2,1,1,2,1,2,3,2,1,3,1,3,0,1,0,0,2,1,
  2,3,3,3,1,3,3,2,1,3,3,3,3,3,3,3,3,3,2,1,1,3,1,1,1,0,0,0,0,
  3,3,3,2,3,2,3,3,3,3,3,2,0,0,1,1,3,2,2,1,1,0,2,1,1,2,0,1,2,
  3,3,3,1,3,2,3,3,3,0,3,2,1,1,1,1,1,2,0,2,1,2,2,3,1,0,0,1,0,
  3,3,2,2,3,3,2,3,1,2,2,1,2,0,0,2,2,2,1,1,1,1,3,1,2,0,0,0,1,
  3,3,2,2,3,2,1,2,2,1,2,2,0,1,1,2,2,2,1,1,2,0,2,1,1,2,1,1,1,
  2,3,2,0,2,1,1,2,1,0,0,1,0,2,0,1,1,1,0,0,1,0,2,2,0,0,1,0,0,
  1,0,2,2,2,2,2,2,1,1,2,1,0,1,0,2,0,0,2,2,1,0,2,1,0,1,1,0,0,
  2,1,0,0,0,1,0,0,3,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
];
// dart format on

const Iso_8859_1FinnishModel = SequenceModel.cpp(
  _kIso_8859_1_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.iso_8859_1,
  Language.finnish,
);

const Iso_8859_4FinnishModel = SequenceModel.cpp(
  _kIso_8859_4_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.iso_8859_4,
  Language.finnish,
);

const Iso_8859_9FinnishModel = SequenceModel.cpp(
  _kIso_8859_9_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.iso_8859_9,
  Language.finnish,
);

const Iso_8859_13FinnishModel = SequenceModel.cpp(
  _kIso_8859_13_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.iso_8859_13,
  Language.finnish,
);

const Iso_8859_15FinnishModel = SequenceModel.cpp(
  _kIso_8859_15_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.iso_8859_15,
  Language.finnish,
);

const Windows_1252FinnishModel = SequenceModel.cpp(
  _kWindows_1252_CharToOrderMap,
  _kFinnishLangModel,
  29,
  0.9990034713909505,
  true,
  Encoding.windows1252,
  Language.finnish,
);

const FinnishModel = LanguageModel.cpp(
  Language.finnish,
  _kUnicode_CharOrder,
  58,
  _kFinnishLangModel,
  29,
  4,
  0.4128194501284014,
  17,
  0.03274349583630724,
);
