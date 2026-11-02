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
 * The Original Code is Mozilla Universal charset detector code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2001
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
 *          Shy Shalom <shooshX@gmail.com>
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

import 'dart:typed_data';

import './charset_group_prober.dart';
import "./charset_prober.dart";
import './hebrew_prober.dart';
import "./lang_models/lang_arabic_model.dart";
import "./lang_models/lang_belarusian_model.dart";
import "./lang_models/lang_bulgarian_model.dart";
import "./lang_models/lang_catalan_model.dart";
import "./lang_models/lang_croatian_model.dart";
import "./lang_models/lang_czech_model.dart";
import "./lang_models/lang_danish_model.dart";
import "./lang_models/lang_english_model.dart";
import "./lang_models/lang_esperanto_model.dart";
import "./lang_models/lang_estonian_model.dart";
import "./lang_models/lang_finnish_model.dart";
import "./lang_models/lang_french_model.dart";
import "./lang_models/lang_georgian_model.dart";
import "./lang_models/lang_german_model.dart";
import "./lang_models/lang_greek_model.dart";
import "./lang_models/lang_hebrew_model.dart";
import "./lang_models/lang_hungarian_model.dart";
import "./lang_models/lang_irish_model.dart";
import "./lang_models/lang_italian_model.dart";
import "./lang_models/lang_latvian_model.dart";
import "./lang_models/lang_lithuanian_model.dart";
import "./lang_models/lang_macedonian_model.dart";
import "./lang_models/lang_maltese_model.dart";
import "./lang_models/lang_norwegian_model.dart";
import "./lang_models/lang_polish_model.dart";
import "./lang_models/lang_portuguese_model.dart";
import "./lang_models/lang_romanian_model.dart";
import "./lang_models/lang_russian_model.dart";
import "./lang_models/lang_serbian_model.dart";
import "./lang_models/lang_slovak_model.dart";
import "./lang_models/lang_slovene_model.dart";
import "./lang_models/lang_spanish_model.dart";
import "./lang_models/lang_swedish_model.dart";
import "./lang_models/lang_thai_model.dart";
import "./lang_models/lang_turkish_model.dart";
import "./lang_models/lang_ukrainian_model.dart";
import "./lang_models/lang_vietnamese_model.dart";
import './sbcs_prober.dart';
import './internal_types.dart';
import './types.dart';

class SBCSGroupProber extends CharSetGroupProber {
  SBCSGroupProber({Set<Encoding>? candidateEncodings})
    : super(mProbers: _createSBProbers(candidateEncodings)) {
    reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    //apply filter to original buffer, and we got new buffer back
    //depend on what script it is, we will feed them the new buffer
    //we got after applying proper filter
    //this is done without any consideration to KeepEnglishLetters
    //of each prober since as of now, there are no probers here which
    //recognize languages with English characters.
    var newBuf = filterWithoutEnglishLetters(aBuf);
    if (newBuf.isEmpty) {
      return mState;
    }

    return super.feed(newBuf);
  }

  static List<CharSetProber> _createSBProbers(
    Set<Encoding>? candidateEncodings,
  ) {
    bool allows(Encoding encoding) =>
        candidateEncodings?.contains(encoding) ?? true;
    SingleByteCharSetProber? createProber(
      SequenceModel model, {
      bool reversed = false,
    }) =>
        allows(model.mEncoding)
            ? SingleByteCharSetProber(model: model, reversed: reversed)
            : null;
    /* We create more probers than sequence models because of Hebrew handling,
   * making Windows_1255HebrewModel and Ibm862HebrewModel used twice, while
   * Iso_8859_8HebrewModel is currently unused.
   */
    return <CharSetProber?>[
      createProber(Windows_1251RussianModel),
      createProber(Koi8_RRussianModel),
      createProber(Iso_8859_5RussianModel),
      createProber(Mac_CyrillicRussianModel),
      createProber(Ibm866RussianModel),
      createProber(Ibm855RussianModel),

      createProber(Iso_8859_7GreekModel),
      createProber(Windows_1253GreekModel),
      createProber(Cp737GreekModel),

      createProber(Iso_8859_5BulgarianModel),
      createProber(Windows_1251BulgarianModel),
      if (allows(Encoding.windows1255) || allows(Encoding.iso_8859_8))
        HebrewProber(candidateEncodings: candidateEncodings),

      /* XXX: I should verify a bit more closely the Hebrew case. It doesn't look to
   * me like the additional data handling in nsHebrewProber is really needed
   * ("Final letter analysis for logical-visual decision").
   * For this new support of Hebrew with IBM-862, aka CP862, I just directly use
   * the direct model (in 2 modes, reversed or not, so that it handles both the
   * logical and visual hebrew cases (Wikipedia says: "Hebrew text encoded using
   * code page 862 was usually stored in visual order; nevertheless, a few DOS
   * applications, notably a word processor named EinsteinWriter, stored Hebrew
   * in logical order.")
   */
      // Logical Hebrew
      createProber(Ibm862HebrewModel, reversed: false),

      // Visual Hebrew
      createProber(Ibm862HebrewModel, reversed: true),

      createProber(Tis_620ThaiModel),
      createProber(Iso_8859_11ThaiModel),

      createProber(Iso_8859_1FrenchModel),
      createProber(Iso_8859_15FrenchModel),
      createProber(Windows_1252FrenchModel),

      createProber(Iso_8859_1SpanishModel),
      createProber(Iso_8859_15SpanishModel),
      createProber(Windows_1252SpanishModel),

      createProber(Iso_8859_2HungarianModel),
      createProber(Windows_1250HungarianModel),

      createProber(Iso_8859_1GermanModel),
      createProber(Windows_1252GermanModel),

      createProber(Iso_8859_3EsperantoModel),

      createProber(Iso_8859_3TurkishModel),
      createProber(Iso_8859_9TurkishModel),

      createProber(Iso_8859_6ArabicModel),
      createProber(Windows_1256ArabicModel),

      createProber(VisciiVietnameseModel),
      createProber(Windows_1258VietnameseModel),

      createProber(Iso_8859_15DanishModel),
      createProber(Iso_8859_1DanishModel),
      createProber(Windows_1252DanishModel),
      createProber(Ibm865DanishModel),

      createProber(Iso_8859_13LithuanianModel),
      createProber(Iso_8859_10LithuanianModel),
      createProber(Iso_8859_4LithuanianModel),

      createProber(Iso_8859_13LatvianModel),
      createProber(Iso_8859_10LatvianModel),
      createProber(Iso_8859_4LatvianModel),

      createProber(Iso_8859_1PortugueseModel),
      createProber(Iso_8859_9PortugueseModel),
      createProber(Iso_8859_15PortugueseModel),
      createProber(Windows_1252PortugueseModel),

      createProber(Iso_8859_3MalteseModel),

      createProber(Windows_1250CzechModel),
      createProber(Iso_8859_2CzechModel),
      createProber(Mac_CentraleuropeCzechModel),
      createProber(Ibm852CzechModel),

      createProber(Windows_1250SlovakModel),
      createProber(Iso_8859_2SlovakModel),
      createProber(Mac_CentraleuropeSlovakModel),
      createProber(Ibm852SlovakModel),

      createProber(Windows_1250PolishModel),
      createProber(Iso_8859_2PolishModel),
      createProber(Iso_8859_13PolishModel),
      createProber(Iso_8859_16PolishModel),
      createProber(Mac_CentraleuropePolishModel),
      createProber(Ibm852PolishModel),

      createProber(Iso_8859_1FinnishModel),
      createProber(Iso_8859_4FinnishModel),
      createProber(Iso_8859_9FinnishModel),
      createProber(Iso_8859_13FinnishModel),
      createProber(Iso_8859_15FinnishModel),
      createProber(Windows_1252FinnishModel),

      createProber(Iso_8859_1ItalianModel),
      createProber(Iso_8859_3ItalianModel),
      createProber(Iso_8859_9ItalianModel),
      createProber(Iso_8859_15ItalianModel),
      createProber(Windows_1252ItalianModel),

      createProber(Windows_1250CroatianModel),
      createProber(Iso_8859_2CroatianModel),
      createProber(Iso_8859_13CroatianModel),
      createProber(Iso_8859_16CroatianModel),
      createProber(Mac_CentraleuropeCroatianModel),
      createProber(Ibm852CroatianModel),

      createProber(Windows_1252EstonianModel),
      createProber(Windows_1257EstonianModel),
      createProber(Iso_8859_4EstonianModel),
      createProber(Iso_8859_13EstonianModel),
      createProber(Iso_8859_15EstonianModel),

      createProber(Iso_8859_1IrishModel),
      createProber(Iso_8859_9IrishModel),
      createProber(Iso_8859_15IrishModel),
      createProber(Windows_1252IrishModel),

      createProber(Windows_1250RomanianModel),
      createProber(Iso_8859_2RomanianModel),
      createProber(Iso_8859_16RomanianModel),
      createProber(Ibm852RomanianModel),

      createProber(Windows_1250SloveneModel),
      createProber(Iso_8859_2SloveneModel),
      createProber(Iso_8859_16SloveneModel),
      createProber(Mac_CentraleuropeSloveneModel),
      createProber(Ibm852SloveneModel),

      createProber(Iso_8859_1SwedishModel),
      createProber(Iso_8859_4SwedishModel),
      createProber(Iso_8859_9SwedishModel),
      createProber(Iso_8859_15SwedishModel),
      createProber(Windows_1252SwedishModel),

      createProber(Iso_8859_15NorwegianModel),
      createProber(Iso_8859_1NorwegianModel),
      createProber(Windows_1252NorwegianModel),
      createProber(Ibm865NorwegianModel),
      createProber(Iso_8859_1EnglishModel),
      createProber(Windows_1252EnglishModel),

      createProber(Windows_1251BelarusianModel),
      createProber(Iso_8859_5BelarusianModel),

      createProber(Windows_1251UkrainianModel),

      createProber(Windows_1251SerbianModel),
      createProber(Iso_8859_5SerbianModel),

      createProber(Windows_1251MacedonianModel),
      createProber(Ibm855MacedonianModel),
      createProber(Iso_8859_5MacedonianModel),

      createProber(Iso_8859_1CatalanModel),
      createProber(Windows_1252CatalanModel),

      createProber(Georgian_AcademyGeorgianModel),
      createProber(Georgian_PsGeorgianModel),
    ].whereType<CharSetProber>().toList();
  }
}
