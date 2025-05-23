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

/********* Language model for: Lithuanian *********/

/// Generated by BuildLangModel.py
/// On: 2022-12-15 00:05:02.243777
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
const _kIso_8859_4_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 4X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 6X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM, 28, 67, 68,SYM, 69, 59,SYM,SYM, 21, 62, 70, 71,SYM, 22,SYM, /* AX */
  SYM, 28,SYM, 72,SYM, 73, 59,SYM,SYM, 21, 62, 74, 75, 76, 22, 77, /* BX */
   48, 37, 51, 55, 38, 49, 57, 30, 25, 34, 31, 46, 17, 39, 56, 54, /* CX */
   78, 79, 44, 80, 47, 66, 35,SYM, 64, 20, 53, 63, 40, 81, 27, 50, /* DX */
   48, 37, 51, 55, 38, 49, 57, 30, 25, 34, 31, 46, 17, 39, 56, 54, /* EX */
   82, 83, 44, 84, 47, 66, 35,SYM, 64, 20, 53, 63, 40, 85, 27,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_10_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 4X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 6X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM, 28, 62, 86, 54, 87, 88,SYM, 59, 89, 21, 90, 22,SYM, 27, 91, /* AX */
  SYM, 28, 62, 92, 54, 93, 94,SYM, 59, 95, 21, 96, 22, 52, 27, 97, /* BX */
   48, 37, 51, 55, 38, 49, 57, 30, 25, 34, 31, 46, 17, 39, 56, 58, /* CX */
   98, 99, 44, 41, 47, 66, 35,100, 64, 20, 53, 63, 40,101,102, 50, /* DX */
   48, 37, 51, 55, 38, 49, 57, 30, 25, 34, 31, 46, 17, 39, 56, 58, /* EX */
  103,104, 44, 41, 47, 66, 35,105, 64, 20, 53, 63, 40,106,107,108, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_13_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 4X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  1, 18, 23, 12,  5, 26, 16, 29,  0, 15,  9, 10, 11,  6,  3, /* 6X */
   14, 36,  4,  2,  7,  8, 13, 33, 32, 19, 24,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 64,SYM,109,SYM,SYM,SYM,SYM, 57, /* AX */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 64,SYM,110,SYM,SYM,SYM,SYM, 57, /* BX */
   28, 30, 48, 43, 38, 49, 31, 62, 25, 34, 65, 17,111,112, 54, 59, /* CX */
   21, 61,113, 41, 44, 66, 35,SYM, 20, 42, 60, 27, 40, 45, 22, 50, /* DX */
   28, 30, 48, 43, 38, 49, 31, 62, 25, 34, 65, 17,114,115, 54, 59, /* EX */
   21, 61,116, 41, 44, 66, 35,SYM, 20, 42, 60, 27, 40, 45, 22,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

// const _kUnicode_Char_size = 74;
const _kUnicode_CharOrder =
[
   65,  1,  66, 18,  67, 23,  68, 12,  69,  5,  70, 26,  71, 16, 72, 29,
   73,  0,  74, 15,  75,  9,  76, 10,  77, 11,  78,  6,  79,  3, 80, 14,
   81, 36,  82,  4,  83,  2,  84,  7,  85,  8,  86, 13,  87, 33, 88, 32,
   89, 19,  90, 24,  97,  1,  98, 18,  99, 23, 100, 12, 101,  5,102, 26,
  103, 16, 104, 29, 105,  0, 106, 15, 107,  9, 108, 10, 109, 11,110,  6,
  111,  3, 112, 14, 113, 36, 114,  4, 115,  2, 116,  7, 117,  8,118, 13,
  119, 33, 120, 32, 121, 19, 122, 24, 201, 34, 214, 35, 233, 34,246, 35,
  260, 28, 261, 28, 268, 25, 269, 25, 278, 17, 279, 17, 280, 31,281, 31,
  302, 30, 303, 30, 352, 21, 353, 21, 362, 27, 363, 27, 370, 20,371, 20,
  381, 22, 382, 22,
];


/* Model Table:
 * Total considered sequences: 1159 / 1369
 * - Positive sequences: first 556 (0.9950187236479393)
 * - Probable sequences: next 217 (773-556) (0.003987547510905687)
 * - Neutral sequences: last 596 (0.000993728841155006)
 * - Negative sequences: 210 (off-ratio)
 * Negative sequences(todo): 
 */
const _kLithuanianLangModel =
[
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,2,0,1,3,2,1,0,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,1,3,3,3,3,3,3,1,0,3,1,0,2,3,1,0,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,3,3,3,3,1,1,3,2,3,2,3,3,3,3,2,0,2,2,1,1,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,2,0,3,3,3,3,3,3,0,0,3,0,0,2,3,0,0,1,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,0,2,2,2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,3,3,0,3,3,3,3,3,3,0,0,2,2,0,3,3,0,0,2,
  3,3,3,3,3,3,3,3,3,3,2,2,3,3,1,2,3,3,3,3,3,2,3,3,3,3,3,2,3,2,3,3,0,1,2,1,1,
  3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,2,3,3,3,3,3,2,2,2,2,1,2,3,3,3,3,3,0,1,2,1,1,
  3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,1,3,2,0,3,3,3,3,3,2,0,0,2,0,0,2,2,0,0,1,
  3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,2,2,3,2,3,3,3,2,3,0,2,1,3,3,3,3,3,0,1,1,1,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,3,3,3,3,2,3,3,0,1,2,2,0,
  3,3,3,3,2,3,2,3,3,3,3,3,2,2,3,2,1,3,3,3,3,2,3,2,2,1,2,3,3,1,1,3,0,1,2,1,0,
  3,3,3,3,3,3,2,2,3,3,2,3,2,3,2,2,2,3,2,3,3,1,3,1,3,0,2,3,3,2,3,3,0,2,2,0,0,
  3,3,3,3,3,3,2,1,3,1,3,1,3,0,3,2,2,3,0,3,3,0,0,1,3,2,2,3,3,1,1,3,0,0,1,1,0,
  3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,2,3,2,3,2,3,2,2,0,1,1,2,2,3,2,3,0,1,1,2,0,
  3,3,1,3,2,3,2,2,3,1,0,0,2,1,1,0,1,3,1,1,3,1,0,1,0,0,0,3,3,0,3,3,0,0,1,2,0,
  3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,0,2,3,2,3,3,2,3,1,3,0,1,3,3,2,2,3,0,1,1,1,0,
  1,0,3,1,3,0,3,3,0,3,3,3,3,3,2,3,3,0,2,0,0,3,3,2,3,2,0,0,0,1,0,0,0,0,0,0,0,
  3,3,3,3,3,3,2,3,3,2,3,1,3,2,1,2,0,3,2,3,3,1,1,2,2,1,0,3,3,2,1,3,0,0,1,1,0,
  2,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,0,3,1,0,3,3,2,3,3,1,0,0,1,0,0,1,0,0,0,0,
  0,0,2,0,0,0,1,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,1,3,3,2,3,3,2,1,1,0,3,0,2,2,0,3,2,0,0,0,0,0,
  3,3,3,3,2,3,3,3,3,3,2,3,3,3,2,2,2,3,2,3,2,1,0,0,0,0,2,2,2,0,2,2,0,0,0,0,0,
  3,3,2,3,3,3,1,3,3,3,3,2,1,1,1,1,1,2,2,2,1,0,0,2,2,0,1,3,2,3,0,0,0,1,1,0,1,
  3,3,0,3,2,3,2,2,3,1,2,3,3,2,1,1,2,3,2,3,3,0,0,0,2,0,0,1,2,1,0,2,0,0,1,1,0,
  3,3,0,2,0,3,1,0,2,2,0,0,1,0,1,0,0,2,0,2,1,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,
  3,3,2,3,3,3,1,2,3,2,3,2,1,0,2,2,2,2,2,2,1,0,0,3,1,0,2,0,1,1,0,0,0,0,1,0,1,
  0,1,3,0,3,0,3,3,1,3,3,3,3,2,2,1,3,0,2,0,0,3,2,0,3,3,0,0,0,0,0,0,0,0,0,0,0,
  0,0,3,0,2,0,1,0,0,1,2,2,0,2,0,3,0,0,0,0,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  3,3,2,3,3,3,3,3,3,1,2,3,1,1,1,1,1,2,1,3,2,0,0,1,0,0,1,1,1,1,0,0,0,1,1,1,0,
  0,2,3,0,3,1,0,3,0,3,2,3,2,3,3,2,3,1,1,0,0,2,3,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
  0,0,3,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  3,2,0,1,0,1,0,2,1,0,1,0,0,3,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,3,1,1,0,0,
  3,3,2,3,2,3,2,0,1,1,1,1,1,0,0,0,1,0,1,1,0,0,0,0,0,0,1,0,0,2,0,0,0,1,0,1,0,
  0,0,2,0,2,1,2,2,1,1,1,1,1,1,1,1,2,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,1,
  0,0,2,0,2,0,2,1,0,1,1,1,0,2,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,
  1,1,0,0,0,0,0,0,3,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
];
// dart format on

const Iso_8859_4LithuanianModel = SequenceModel.cpp(
  _kIso_8859_4_CharToOrderMap,
  _kLithuanianLangModel,
  37,
  0.999006271158845,
  true,
  Encoding.iso_8859_4,
  Language.lithuanian,
);

const Iso_8859_10LithuanianModel = SequenceModel.cpp(
  _kIso_8859_10_CharToOrderMap,
  _kLithuanianLangModel,
  37,
  0.999006271158845,
  true,
  Encoding.iso_8859_10,
  Language.lithuanian,
);

const Iso_8859_13LithuanianModel = SequenceModel.cpp(
  _kIso_8859_13_CharToOrderMap,
  _kLithuanianLangModel,
  37,
  0.999006271158845,
  true,
  Encoding.iso_8859_13,
  Language.lithuanian,
);

const LithuanianModel = LanguageModel.cpp(
  Language.lithuanian,
  _kUnicode_CharOrder,
  74,
  _kLithuanianLangModel,
  37,
  5,
  0.45060945079854764,
  23,
  0.0315125725614535,
);
