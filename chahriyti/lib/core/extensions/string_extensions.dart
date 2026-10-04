extension StringExtensions on String {
  /// Replaces Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) with Latin digits (0-9).
  String toLatinDigits() {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = this;
    for (var i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], '$i');
    }
    return result;
  }
}
