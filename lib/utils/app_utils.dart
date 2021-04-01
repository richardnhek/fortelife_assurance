import 'package:forte_life/constants/constants.dart';

class AppUtils {
  static String getFontFamily(String language) {
    switch (language) {
      case LANGUAGE_KHMER:
        {
          return FONT_KANTUMRUY;
        }
      case LANGUAGE_ENGLISH:
        {
          return FONT_KANO;
        }
      default:
        {
          return FONT_KANO;
        }
    }
  }
}
