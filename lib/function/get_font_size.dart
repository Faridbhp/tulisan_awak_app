import 'package:tulisan_awak_app/constants/constants.dart';

FontStore getFontStore(String fontSize) {
  switch (fontSize) {
    case "Extra Small":
      return FontStore.extraSmall; 
    case "Big":
      return FontStore.big; 
    default:
      return FontStore.small; 
  }
}
