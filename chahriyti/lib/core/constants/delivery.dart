/// Delivery prices in DZD per wilaya code, generated from the landing page's
/// Tarifs_Wilayas_Domicile_Bureau.json so the app and the website charge the same.
/// A missing wilaya or a 0 price means that delivery type isn't available there.
const Map<int, ({int home, int desk})> deliveryFees = {
  1: (home: 1100, desk: 600), // Adrar
  2: (home: 700, desk: 400), // Chlef
  3: (home: 900, desk: 500), // Laghouat
  4: (home: 800, desk: 400), // Oum El Bouaghi
  5: (home: 800, desk: 400), // Batna
  6: (home: 600, desk: 400), // Béjaïa
  7: (home: 900, desk: 500), // Biskra
  8: (home: 1100, desk: 600), // Béchar
  9: (home: 500, desk: 350), // Blida
  10: (home: 450, desk: 350), // Bouira
  11: (home: 1300, desk: 800), // Tamanrasset
  12: (home: 800, desk: 400), // Tébessa
  13: (home: 800, desk: 400), // Tlemcen
  14: (home: 700, desk: 400), // Tiaret
  15: (home: 600, desk: 400), // Tizi Ouzou
  16: (home: 500, desk: 350), // Alger
  17: (home: 800, desk: 500), // Djelfa
  18: (home: 700, desk: 400), // Jijel
  19: (home: 600, desk: 400), // Sétif
  20: (home: 800, desk: 400), // Saïda
  21: (home: 700, desk: 400), // Skikda
  22: (home: 800, desk: 400), // Sidi Bel Abbès
  23: (home: 700, desk: 400), // Annaba
  24: (home: 800, desk: 400), // Guelma
  25: (home: 700, desk: 400), // Constantine
  26: (home: 650, desk: 400), // Médéa
  27: (home: 700, desk: 400), // Mostaganem
  28: (home: 650, desk: 500), // M'Sila
  29: (home: 700, desk: 400), // Mascara
  30: (home: 1000, desk: 500), // Ouargla
  31: (home: 700, desk: 400), // Oran
  32: (home: 1000, desk: 500), // El Bayadh
  33: (home: 1300, desk: 600), // Illizi
  34: (home: 600, desk: 400), // Bordj Bou Arreridj
  35: (home: 600, desk: 400), // Boumerdès
  36: (home: 800, desk: 400), // El Tarf
  37: (home: 1300, desk: 600), // Tindouf
  38: (home: 700, desk: 400), // Tissemsilt
  39: (home: 900, desk: 500), // El Oued
  40: (home: 800, desk: 500), // Khenchela
  41: (home: 800, desk: 500), // Souk Ahras
  42: (home: 700, desk: 400), // Tipaza
  43: (home: 700, desk: 400), // Mila
  44: (home: 700, desk: 400), // Aïn Defla
  45: (home: 1000, desk: 500), // Naâma
  46: (home: 800, desk: 400), // Aïn Témouchent
  47: (home: 900, desk: 500), // Ghardaïa
  48: (home: 800, desk: 400), // Relizane
  49: (home: 1300, desk: 600), // Timimoun
  51: (home: 900, desk: 500), // Ouled Djellal
  52: (home: 1300, desk: 0), // Beni Abbes
  53: (home: 1300, desk: 600), // In Salah
  55: (home: 900, desk: 500), // Touggourt
  57: (home: 900, desk: 0), // El M'Ghair
  58: (home: 1000, desk: 500), // El Meniaa
};

enum DeliveryType {
  /// Pick up at the delivery company's office (cheaper)
  desk('bureau'),

  /// Delivered to the door
  home('domicile');

  /// Value stored on the lead and sent to WooCommerce, same as the website
  final String apiValue;
  const DeliveryType(this.apiValue);
}

/// Price of [type] delivery to [wilayaCode], or null when it isn't offered.
int? deliveryFee(int wilayaCode, DeliveryType type) {
  final fees = deliveryFees[wilayaCode];
  if (fees == null) return null;
  final fee = type == DeliveryType.home ? fees.home : fees.desk;
  return fee > 0 ? fee : null;
}
