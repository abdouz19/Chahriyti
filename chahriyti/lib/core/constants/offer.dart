/// Book + lifetime licence, one payment (DZD, delivery not included).
const offerPrice = 2700;

/// The price spread over a single year, rounded up.
int get offerPricePerDay => (offerPrice / 365).ceil();
