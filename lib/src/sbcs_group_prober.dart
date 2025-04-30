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

class SBCSGroupProber extends CharSetGroupProber {
  SBCSGroupProber() : super(mProbers: _createSBProbers()) {
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

  static List<CharSetProber> _createSBProbers() {
    /* We create more probers than sequence models because of Hebrew handling,
   * making Windows_1255HebrewModel and Ibm862HebrewModel used twice, while
   * Iso_8859_8HebrewModel is currently unused.
   */
    return [
      SingleByteCharSetProber(model: Windows_1251RussianModel),
      SingleByteCharSetProber(model: Koi8_RRussianModel),
      SingleByteCharSetProber(model: Iso_8859_5RussianModel),
      SingleByteCharSetProber(model: Mac_CyrillicRussianModel),
      SingleByteCharSetProber(model: Ibm866RussianModel),
      SingleByteCharSetProber(model: Ibm855RussianModel),

      SingleByteCharSetProber(model: Iso_8859_7GreekModel),
      SingleByteCharSetProber(model: Windows_1253GreekModel),
      SingleByteCharSetProber(model: Cp737GreekModel),

      SingleByteCharSetProber(model: Iso_8859_5BulgarianModel),
      SingleByteCharSetProber(model: Windows_1251BulgarianModel),
      HebrewProber(),

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
      SingleByteCharSetProber(model: Ibm862HebrewModel, reversed: false),

      // Visual Hebrew
      SingleByteCharSetProber(model: Ibm862HebrewModel, reversed: true),

      SingleByteCharSetProber(model: Tis_620ThaiModel),
      SingleByteCharSetProber(model: Iso_8859_11ThaiModel),

      SingleByteCharSetProber(model: Iso_8859_1FrenchModel),
      SingleByteCharSetProber(model: Iso_8859_15FrenchModel),
      SingleByteCharSetProber(model: Windows_1252FrenchModel),

      SingleByteCharSetProber(model: Iso_8859_1SpanishModel),
      SingleByteCharSetProber(model: Iso_8859_15SpanishModel),
      SingleByteCharSetProber(model: Windows_1252SpanishModel),

      SingleByteCharSetProber(model: Iso_8859_2HungarianModel),
      SingleByteCharSetProber(model: Windows_1250HungarianModel),

      SingleByteCharSetProber(model: Iso_8859_1GermanModel),
      SingleByteCharSetProber(model: Windows_1252GermanModel),

      SingleByteCharSetProber(model: Iso_8859_3EsperantoModel),

      SingleByteCharSetProber(model: Iso_8859_3TurkishModel),
      SingleByteCharSetProber(model: Iso_8859_9TurkishModel),

      SingleByteCharSetProber(model: Iso_8859_6ArabicModel),
      SingleByteCharSetProber(model: Windows_1256ArabicModel),

      SingleByteCharSetProber(model: VisciiVietnameseModel),
      SingleByteCharSetProber(model: Windows_1258VietnameseModel),

      SingleByteCharSetProber(model: Iso_8859_15DanishModel),
      SingleByteCharSetProber(model: Iso_8859_1DanishModel),
      SingleByteCharSetProber(model: Windows_1252DanishModel),
      SingleByteCharSetProber(model: Ibm865DanishModel),

      SingleByteCharSetProber(model: Iso_8859_13LithuanianModel),
      SingleByteCharSetProber(model: Iso_8859_10LithuanianModel),
      SingleByteCharSetProber(model: Iso_8859_4LithuanianModel),

      SingleByteCharSetProber(model: Iso_8859_13LatvianModel),
      SingleByteCharSetProber(model: Iso_8859_10LatvianModel),
      SingleByteCharSetProber(model: Iso_8859_4LatvianModel),

      SingleByteCharSetProber(model: Iso_8859_1PortugueseModel),
      SingleByteCharSetProber(model: Iso_8859_9PortugueseModel),
      SingleByteCharSetProber(model: Iso_8859_15PortugueseModel),
      SingleByteCharSetProber(model: Windows_1252PortugueseModel),

      SingleByteCharSetProber(model: Iso_8859_3MalteseModel),

      SingleByteCharSetProber(model: Windows_1250CzechModel),
      SingleByteCharSetProber(model: Iso_8859_2CzechModel),
      SingleByteCharSetProber(model: Mac_CentraleuropeCzechModel),
      SingleByteCharSetProber(model: Ibm852CzechModel),

      SingleByteCharSetProber(model: Windows_1250SlovakModel),
      SingleByteCharSetProber(model: Iso_8859_2SlovakModel),
      SingleByteCharSetProber(model: Mac_CentraleuropeSlovakModel),
      SingleByteCharSetProber(model: Ibm852SlovakModel),

      SingleByteCharSetProber(model: Windows_1250PolishModel),
      SingleByteCharSetProber(model: Iso_8859_2PolishModel),
      SingleByteCharSetProber(model: Iso_8859_13PolishModel),
      SingleByteCharSetProber(model: Iso_8859_16PolishModel),
      SingleByteCharSetProber(model: Mac_CentraleuropePolishModel),
      SingleByteCharSetProber(model: Ibm852PolishModel),

      SingleByteCharSetProber(model: Iso_8859_1FinnishModel),
      SingleByteCharSetProber(model: Iso_8859_4FinnishModel),
      SingleByteCharSetProber(model: Iso_8859_9FinnishModel),
      SingleByteCharSetProber(model: Iso_8859_13FinnishModel),
      SingleByteCharSetProber(model: Iso_8859_15FinnishModel),
      SingleByteCharSetProber(model: Windows_1252FinnishModel),

      SingleByteCharSetProber(model: Iso_8859_1ItalianModel),
      SingleByteCharSetProber(model: Iso_8859_3ItalianModel),
      SingleByteCharSetProber(model: Iso_8859_9ItalianModel),
      SingleByteCharSetProber(model: Iso_8859_15ItalianModel),
      SingleByteCharSetProber(model: Windows_1252ItalianModel),

      SingleByteCharSetProber(model: Windows_1250CroatianModel),
      SingleByteCharSetProber(model: Iso_8859_2CroatianModel),
      SingleByteCharSetProber(model: Iso_8859_13CroatianModel),
      SingleByteCharSetProber(model: Iso_8859_16CroatianModel),
      SingleByteCharSetProber(model: Mac_CentraleuropeCroatianModel),
      SingleByteCharSetProber(model: Ibm852CroatianModel),

      SingleByteCharSetProber(model: Windows_1252EstonianModel),
      SingleByteCharSetProber(model: Windows_1257EstonianModel),
      SingleByteCharSetProber(model: Iso_8859_4EstonianModel),
      SingleByteCharSetProber(model: Iso_8859_13EstonianModel),
      SingleByteCharSetProber(model: Iso_8859_15EstonianModel),

      SingleByteCharSetProber(model: Iso_8859_1IrishModel),
      SingleByteCharSetProber(model: Iso_8859_9IrishModel),
      SingleByteCharSetProber(model: Iso_8859_15IrishModel),
      SingleByteCharSetProber(model: Windows_1252IrishModel),

      SingleByteCharSetProber(model: Windows_1250RomanianModel),
      SingleByteCharSetProber(model: Iso_8859_2RomanianModel),
      SingleByteCharSetProber(model: Iso_8859_16RomanianModel),
      SingleByteCharSetProber(model: Ibm852RomanianModel),

      SingleByteCharSetProber(model: Windows_1250SloveneModel),
      SingleByteCharSetProber(model: Iso_8859_2SloveneModel),
      SingleByteCharSetProber(model: Iso_8859_16SloveneModel),
      SingleByteCharSetProber(model: Mac_CentraleuropeSloveneModel),
      SingleByteCharSetProber(model: Ibm852SloveneModel),

      SingleByteCharSetProber(model: Iso_8859_1SwedishModel),
      SingleByteCharSetProber(model: Iso_8859_4SwedishModel),
      SingleByteCharSetProber(model: Iso_8859_9SwedishModel),
      SingleByteCharSetProber(model: Iso_8859_15SwedishModel),
      SingleByteCharSetProber(model: Windows_1252SwedishModel),

      SingleByteCharSetProber(model: Iso_8859_15NorwegianModel),
      SingleByteCharSetProber(model: Iso_8859_1NorwegianModel),
      SingleByteCharSetProber(model: Windows_1252NorwegianModel),
      SingleByteCharSetProber(model: Ibm865NorwegianModel),
      SingleByteCharSetProber(model: Iso_8859_1EnglishModel),
      SingleByteCharSetProber(model: Windows_1252EnglishModel),

      SingleByteCharSetProber(model: Windows_1251BelarusianModel),
      SingleByteCharSetProber(model: Iso_8859_5BelarusianModel),

      SingleByteCharSetProber(model: Windows_1251UkrainianModel),

      SingleByteCharSetProber(model: Windows_1251SerbianModel),
      SingleByteCharSetProber(model: Iso_8859_5SerbianModel),

      SingleByteCharSetProber(model: Windows_1251MacedonianModel),
      SingleByteCharSetProber(model: Ibm855MacedonianModel),
      SingleByteCharSetProber(model: Iso_8859_5MacedonianModel),

      SingleByteCharSetProber(model: Iso_8859_1CatalanModel),
      SingleByteCharSetProber(model: Windows_1252CatalanModel),

      SingleByteCharSetProber(model: Georgian_AcademyGeorgianModel),
      SingleByteCharSetProber(model: Georgian_PsGeorgianModel),
    ];
  }
}
