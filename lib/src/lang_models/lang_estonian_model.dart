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

/********* Language model for: Estonian *********/

/// Generated by BuildLangModel.py
/// On: 2022-12-14 23:54:01.496691
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
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 4X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 6X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM, 58, 59, 60,SYM, 61, 62,SYM,SYM, 29, 41, 63, 64,SYM, 30,SYM, /* AX */
  SYM, 65,SYM, 66,SYM, 67, 68,SYM,SYM, 29, 41, 69, 70, 71, 30, 72, /* BX */
   36, 35, 73, 74, 18, 38, 46, 75, 49, 33, 76, 32, 77, 40, 78, 34, /* CX */
   79, 52, 47, 80, 81, 19, 24,SYM, 39, 82, 51, 83, 21, 84, 37, 54, /* DX */
   36, 35, 85, 86, 18, 38, 46, 87, 49, 33, 88, 32, 89, 40, 90, 34, /* EX */
   91, 52, 47, 92, 93, 19, 24,SYM, 39, 94, 51, 95, 21, 96, 37,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_13_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 4X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 6X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 39,SYM, 97,SYM,SYM,SYM,SYM, 46, /* AX */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 39,SYM, 98,SYM,SYM,SYM,SYM, 46, /* BX */
   99,100, 36, 50, 18, 38,101, 41, 49, 33,102,103,104,105, 34,106, /* CX */
   29,107, 52, 42, 47, 19, 24,SYM,108, 48,109, 37, 21, 56, 30, 54, /* DX */
  110,111, 36, 50, 18, 38,112, 41, 49, 33,113,114,115,116, 34,117, /* EX */
   29,118, 52, 42, 47, 19, 24,SYM,119, 48,120, 37, 21, 56, 30,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kIso_8859_15_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 4X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 6X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,CTR, /* 7X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 8X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM, 29,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM, 30,121,SYM,SYM, 30,SYM,SYM,SYM,122,123,124,SYM, /* BX */
   53, 35,125,126, 18, 38, 46, 44, 45, 33, 55, 32,127, 40,128,129, /* CX */
  130, 43,131, 42,132, 19, 24,SYM, 39,133, 51,134, 21, 57,135, 54, /* DX */
   53, 35,136,137, 18, 38, 46, 44, 45, 33, 55, 32,138, 40,139,140, /* EX */
  141, 43,142, 42,143, 19, 24,SYM, 39,144, 51,145, 21, 57,146,147, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kWindows_1252_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 4X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 6X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,CTR, /* 7X */
  SYM,ILL,SYM,148,SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM,149,ILL, 30,ILL, /* 8X */
  ILL,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, 29,SYM,150,ILL, 30,151, /* 9X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* AX */
  SYM,SYM,SYM,SYM,SYM,152,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* BX */
   53, 35,153,154, 18, 38, 46, 44, 45, 33, 55, 32,155, 40,156,157, /* CX */
  158, 43,159, 42,160, 19, 24,SYM, 39,161, 51,162, 21, 57,163, 54, /* DX */
   53, 35,164,165, 18, 38, 46, 44, 45, 33, 55, 32,166, 40,167,168, /* EX */
  169, 43,170, 42,171, 19, 24,SYM, 39,172, 51,173, 21, 57,174,175, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

const _kWindows_1257_CharToOrderMap =
[
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,RET,CTR,CTR,RET,CTR,CTR, /* 0X */
  CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR,CTR, /* 1X */
  SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM,SYM, /* 2X */
  NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,NUM,SYM,SYM,SYM,SYM,SYM,SYM, /* 3X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 4X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,SYM, /* 5X */
  SYM,  0, 20, 23, 10,  1, 22, 15, 17,  2, 16,  8,  5, 12,  7,  9, /* 6X */
   14, 31, 11,  3,  4,  6, 13, 26, 27, 25, 28,SYM,SYM,SYM,SYM,CTR, /* 7X */
  SYM,ILL,SYM,ILL,SYM,SYM,SYM,SYM,ILL,SYM,ILL,SYM,ILL,SYM,SYM,SYM, /* 8X */
  ILL,SYM,SYM,SYM,SYM,SYM,SYM,SYM,ILL,SYM,ILL,SYM,ILL,SYM,SYM,ILL, /* 9X */
  SYM,ILL,SYM,SYM,SYM,ILL,SYM,SYM, 39,SYM,176,SYM,SYM,SYM,SYM, 46, /* AX */
  SYM,SYM,SYM,SYM,SYM,177,SYM,SYM, 39,SYM,178,SYM,SYM,SYM,SYM, 46, /* BX */
  179,180, 36, 50, 18, 38,181, 41, 49, 33,182,183,184,185, 34,186, /* CX */
   29,187, 52, 42, 47, 19, 24,SYM,188, 48,189, 37, 21, 56, 30, 54, /* DX */
  190,191, 36, 50, 18, 38,192, 41, 49, 33,193,194,195,196, 34,197, /* EX */
   29,198, 52, 42, 47, 19, 24,SYM,199, 48,200, 37, 21, 56, 30,SYM, /* FX */
];
/*X0  X1  X2  X3  X4  X5  X6  X7  X8  X9  XA  XB  XC  XD  XE  XF */

// const _kUnicode_Char_size = 64;
const _kUnicode_CharOrder =
[
   65,  0,  66, 20,  67, 23,  68, 10,  69,  1,  70, 22,  71, 15, 72, 17,
   73,  2,  74, 16,  75,  8,  76,  5,  77, 12,  78,  7,  79,  9, 80, 14,
   81, 31,  82, 11,  83,  3,  84,  4,  85,  6,  86, 13,  87, 26, 88, 27,
   89, 25,  90, 28,  97,  0,  98, 20,  99, 23, 100, 10, 101,  1,102, 22,
  103, 15, 104, 17, 105,  2, 106, 16, 107,  8, 108,  5, 109, 12,110,  7,
  111,  9, 112, 14, 113, 31, 114, 11, 115,  3, 116,  4, 117,  6,118, 13,
  119, 26, 120, 27, 121, 25, 122, 28, 196, 18, 213, 19, 214, 24,220, 21,
  228, 18, 245, 19, 246, 24, 252, 21, 352, 29, 353, 29, 381, 30,382, 30,
];


/* Model Table:
 * Total considered sequences: 876 / 1024
 * - Positive sequences: first 431 (0.9950077226033445)
 * - Probable sequences: next 157 (588-431) (0.003997910901044732)
 * - Neutral sequences: last 436 (0.000994366495610799)
 * - Negative sequences: 148 (off-ratio)
 * Negative sequences(todo): 
 */
const _kEstonianLangModel =
[
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,2,3,3,3,3,1,3,3,2,2,1,2,1,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,3,2,3,3,2,3,3,3,2,2,2,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3,3,2,3,3,1,1,2,3,2,2,1,1,
  3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,1,0,1,1,1,1,
  3,3,3,3,3,3,3,3,3,3,0,3,3,3,3,2,3,3,3,3,1,3,1,2,3,2,1,1,2,3,0,0,
  3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,3,2,2,3,1,1,1,1,1,0,
  3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,1,2,3,2,2,2,0,1,0,1,1,1,0,0,
  3,3,3,3,3,3,3,3,3,3,3,3,2,3,2,3,2,3,3,3,2,2,3,3,1,2,1,1,2,1,2,1,
  3,3,3,3,3,3,3,3,3,3,2,3,3,3,2,2,3,2,3,3,1,3,1,1,2,1,1,0,0,1,0,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,0,3,2,3,3,1,2,3,2,2,1,0,1,
  3,3,3,3,3,3,3,3,3,3,2,3,3,3,2,2,3,2,0,0,1,2,2,1,1,1,2,0,1,0,3,0,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1,1,0,0,0,
  3,3,3,3,3,3,3,3,3,3,1,2,3,2,3,2,2,2,3,3,3,3,1,2,3,2,1,1,0,0,0,0,
  3,3,3,3,2,3,3,3,3,3,1,2,2,2,2,2,1,2,3,3,0,2,0,0,3,1,0,0,0,0,0,0,
  3,3,3,3,3,3,3,3,2,3,1,3,3,1,3,1,2,3,3,3,1,3,1,0,3,1,0,0,1,0,0,0,
  3,3,3,3,2,3,3,3,3,3,1,3,3,2,2,2,2,3,0,0,1,3,1,0,0,2,1,0,0,0,0,0,
  3,3,2,1,3,0,3,2,1,3,0,0,3,0,2,0,0,0,3,3,0,2,0,0,1,0,0,0,0,0,0,0,
  3,3,3,2,3,3,3,3,3,3,2,2,3,3,1,0,3,3,3,3,1,3,1,1,1,3,2,0,1,0,0,2,
  2,3,3,3,3,3,0,3,3,2,3,3,3,3,3,3,1,3,3,0,3,0,0,1,0,0,0,0,0,0,0,0,
  0,3,3,3,3,3,3,3,2,1,3,3,3,2,3,3,3,3,0,3,3,0,0,0,0,0,0,0,0,0,0,0,
  3,3,3,2,2,3,3,2,2,3,1,3,1,1,1,1,3,1,1,0,2,2,1,2,0,2,1,0,0,0,0,0,
  2,1,0,3,3,3,0,3,3,2,3,3,3,3,3,3,1,3,0,0,3,3,1,1,0,0,0,0,0,0,0,0,
  3,3,3,2,3,3,3,2,1,3,0,3,1,0,0,1,1,0,3,0,0,3,3,1,2,0,0,0,1,0,0,0,
  3,3,3,2,3,2,3,1,3,3,1,2,3,1,0,1,0,3,0,0,1,0,0,2,0,2,0,1,0,0,0,1,
  2,3,2,3,3,2,0,3,3,1,3,3,2,2,3,2,1,1,0,0,2,0,1,0,3,1,1,0,0,0,0,1,
  3,2,1,2,2,3,2,3,1,2,2,2,2,0,2,2,0,0,0,0,1,0,1,2,0,0,1,1,0,0,0,0,
  3,3,3,2,2,0,1,2,1,2,1,2,1,0,0,1,0,2,0,0,1,0,2,1,0,1,2,0,0,0,0,0,
  2,0,2,0,1,1,1,0,1,1,1,0,1,1,1,0,0,2,0,0,1,0,0,2,0,1,0,1,0,0,0,0,
  2,2,2,1,1,0,2,1,1,2,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
  2,3,2,0,1,0,2,1,1,2,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
  2,1,2,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,1,2,1,0,1,3,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
];
// dart format on

const Iso_8859_4EstonianModel = SequenceModel.cpp(
  _kIso_8859_4_CharToOrderMap,
  _kEstonianLangModel,
  32,
  0.9990056335043892,
  true,
  Encoding.iso_8859_4,
  Language.estonian,
);

const Iso_8859_13EstonianModel = SequenceModel.cpp(
  _kIso_8859_13_CharToOrderMap,
  _kEstonianLangModel,
  32,
  0.9990056335043892,
  true,
  Encoding.iso_8859_13,
  Language.estonian,
);

const Iso_8859_15EstonianModel = SequenceModel.cpp(
  _kIso_8859_15_CharToOrderMap,
  _kEstonianLangModel,
  32,
  0.9990056335043892,
  true,
  Encoding.iso_8859_15,
  Language.estonian,
);

const Windows_1252EstonianModel = SequenceModel.cpp(
  _kWindows_1252_CharToOrderMap,
  _kEstonianLangModel,
  32,
  0.9990056335043892,
  true,
  Encoding.windows1252,
  Language.estonian,
);

const Windows_1257EstonianModel = SequenceModel.cpp(
  _kWindows_1257_CharToOrderMap,
  _kEstonianLangModel,
  32,
  0.9990056335043892,
  true,
  Encoding.windows1257,
  Language.estonian,
);

const EstonianModel = LanguageModel.cpp(
  Language.estonian,
  _kUnicode_CharOrder,
  64,
  _kEstonianLangModel,
  32,
  4,
  0.41592966773057316,
  18,
  0.035005595045841234,
);
