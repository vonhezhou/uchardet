/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
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
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 1998
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
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

enum Encoding {
  ascii,
  big5,
  cp737,
  eucJP,
  eucKR,
  eucTW,
  gb18030,
  georgianPS,
  georgianAcademy,
  hzGB2312,
  ibm852,
  ibm855,
  ibm862,
  ibm865,
  ibm866,
  iso2022CN,
  iso2022JP,
  iso2022KR,
  iso_8859_1,
  iso_8859_2,
  iso_8859_3,
  iso_8859_4,
  iso_8859_5,
  iso_8859_6,
  iso_8859_7,
  iso_8859_8,
  iso_8859_9,
  iso_8859_10,
  iso_8859_11,
  iso_8859_13,
  iso_8859_15,
  iso_8859_16,
  johab,
  koi8R,
  macCentraleurope,
  macCyrillic,
  shiftJIS,
  tis620,
  uhc,
  utf8,
  utf16le,
  utf16be,
  utf32le,
  utf32be,
  viscii,
  windows1250,
  windows1251,
  windows1252,
  windows1253,
  windows1255,
  windows1258,
  windows1256,
  windows1257,
}

extension EncodingExtension on Encoding {
  String get name {
    switch (this) {
      case Encoding.ascii:
        return "ASCII";
      case Encoding.big5:
        return "BIG5";
      case Encoding.cp737:
        return "CP737";
      case Encoding.eucJP:
        return "EUC-JP";
      case Encoding.eucKR:
        return "EUC-KR";
      case Encoding.eucTW:
        return "EUC-TW";
      case Encoding.gb18030:
        return "GB18030";
      case Encoding.georgianPS:
        return "GEORGIAN-PS";
      case Encoding.georgianAcademy:
        return "GEORGIAN-ACADEMY";
      case Encoding.hzGB2312:
        return "HZ-GB-2312";
      case Encoding.ibm852:
        return "IBM852";
      case Encoding.ibm855:
        return "IBM855";
      case Encoding.ibm862:
        return "IBM862";
      case Encoding.ibm865:
        return "IBM865";
      case Encoding.ibm866:
        return "IBM866";
      case Encoding.iso2022CN:
        return "ISO-2022-CN";
      case Encoding.iso2022JP:
        return "ISO-2022-JP";
      case Encoding.iso2022KR:
        return "ISO-2022-KR";
      case Encoding.iso_8859_1:
        return "ISO-8859-1";
      case Encoding.iso_8859_2:
        return "ISO-8859-2";
      case Encoding.iso_8859_3:
        return "ISO-8859-3";
      case Encoding.iso_8859_4:
        return "ISO-8859-4";
      case Encoding.iso_8859_5:
        return "ISO-8859-5";
      case Encoding.iso_8859_6:
        return "ISO-8859-6";
      case Encoding.iso_8859_7:
        return "ISO-8859-7";
      case Encoding.iso_8859_8:
        return "ISO-8859-8";
      case Encoding.iso_8859_9:
        return "ISO-8859-9";
      case Encoding.iso_8859_10:
        return "ISO-8859-10";
      case Encoding.iso_8859_11:
        return "ISO-8859-11";
      case Encoding.iso_8859_13:
        return "ISO-8859-13";
      case Encoding.iso_8859_15:
        return "ISO-8859-15";
      case Encoding.iso_8859_16:
        return "ISO-8859-16";
      case Encoding.johab:
        return "JOHAB";
      case Encoding.koi8R:
        return "KOI8-R";
      case Encoding.macCentraleurope:
        return "MAC-CENTRALEUROPE";
      case Encoding.macCyrillic:
        return "MAC-CYRILLIC";
      case Encoding.shiftJIS:
        return "SHIFT_JIS";
      case Encoding.tis620:
        return "TIS-620";
      case Encoding.uhc:
        return "UHC";
      case Encoding.utf8:
        return "UTF-8";
      case Encoding.utf16le:
        return "UTF-16LE";
      case Encoding.utf16be:
        return "UTF-16BE";
      case Encoding.utf32le:
        return "UTF-32LE";
      case Encoding.utf32be:
        return "UTF-32BE";
      case Encoding.viscii:
        return "VISCII";
      case Encoding.windows1250:
        return "WINDOWS-1250";
      case Encoding.windows1251:
        return "WINDOWS-1251";
      case Encoding.windows1252:
        return "WINDOWS-1252";
      case Encoding.windows1253:
        return "WINDOWS-1253";
      case Encoding.windows1255:
        return "WINDOWS-1255";
      case Encoding.windows1258:
        return "WINDOWS-1258";
      case Encoding.windows1256:
        return "WINDOWS-1256";
      case Encoding.windows1257:
        return "WINDOWS-1257";
    }
  }
}

enum Language {
  arabic,
  belarusian,
  bulgarian,
  catalan,
  chinese,
  croatian,
  czech,
  danish,
  english,
  esperanto,
  estonian,
  finnish,
  french,
  georgian,
  german,
  greek,
  hebrew,
  hindi,
  hungarian,
  irish,
  italian,
  japanese,
  korean,
  latvian,
  lithuanian,
  macedonian,
  maltese,
  norwegian,
  polish,
  portuguese,
  romanian,
  russian,
  serbian,
  slovak,
  slovene,
  spanish,
  swedish,
  thai,
  turkish,
  ukrainian,
  vietnamese,
}

extension LanguageNameExtension on Language {
  /// return the ISO 639-1 code for the language
  String get iso6391Code {
    switch (this) {
      case Language.arabic:
        return "ar";
      case Language.belarusian:
        return "be";
      case Language.bulgarian:
        return "bg";
      case Language.catalan:
        return "ca";
      case Language.chinese:
        return "zh";
      case Language.croatian:
        return "hr";
      case Language.czech:
        return "cs";
      case Language.danish:
        return "da";
      case Language.english:
        return "en";
      case Language.esperanto:
        return "eo";
      case Language.estonian:
        return "et";
      case Language.finnish:
        return "fi";
      case Language.french:
        return "fr";
      case Language.georgian:
        return "ka";
      case Language.german:
        return "de";
      case Language.greek:
        return "el";
      case Language.hebrew:
        return "he";
      case Language.hindi:
        return "hi";
      case Language.hungarian:
        return "hu";
      case Language.irish:
        return "ga";
      case Language.italian:
        return "it";
      case Language.japanese:
        return "ja";
      case Language.korean:
        return "ko";
      case Language.latvian:
        return "lv";
      case Language.lithuanian:
        return "lt";
      case Language.macedonian:
        return "mk";
      case Language.maltese:
        return "mt";
      case Language.norwegian:
        return "no";
      case Language.polish:
        return "pl";
      case Language.portuguese:
        return "pt";
      case Language.romanian:
        return "ro";
      case Language.russian:
        return "ru";
      case Language.serbian:
        return "sr";
      case Language.slovak:
        return "sk";
      case Language.slovene:
        return "sl";
      case Language.spanish:
        return "es";
      case Language.swedish:
        return "sv";
      case Language.thai:
        return "th";
      case Language.turkish:
        return "tr";
      case Language.ukrainian:
        return "uk";
      case Language.vietnamese:
        return "vi";
    }
  }
}

enum LanguageFilterType {
  kChineseSimplified,
  kChineseTraditional,
  kJapanese,
  kKorean,
  kNonCjk,
}

class LanguageFilter {
  static const all = LanguageFilter(0x7FFFFFFF);

  // max 31 bits
  final int _languageFilter;

  const LanguageFilter(int languageFilter) : _languageFilter = languageFilter;

  LanguageFilter.some(List<LanguageFilterType> list)
    : this(list.fold(0, (prev, ii) => prev | ii.bitMask));

  bool isEnabled(LanguageFilterType t) {
    return (_languageFilter & t.bitMask) != 0;
  }

  bool isOnly(LanguageFilterType t) {
    return _languageFilter == t.bitMask;
  }
}

extension _LanguageFilterTypeExtension on LanguageFilterType {
  int get bitMask {
    return 0x1 << index;
  }
}

class CharSetCandidate {
  final Encoding encoding;

  /// for ascii, UTF-8 with BOM, UTF-16le, utf-16be, utf-32le, utf-32be,
  /// the language is always null
  /// for utf-8, the language is detected
  /// based on character frequency and sequence frequency,
  /// should work on most of the cases
  final Language? language;

  final double confidence;

  // withBom is true if the BOM is present
  final bool hasBom;

  @override
  String toString() {
    return "{ encoding: $encoding, language: $language, confidence: $confidence, bom: $hasBom }";
  }

  const CharSetCandidate({
    required this.encoding,
    required this.language,
    required this.confidence,
    this.hasBom = false,
  });
}
