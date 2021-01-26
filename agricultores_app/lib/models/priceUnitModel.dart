class PriceUnit {
  String abbreviation;
  String fullName;

  PriceUnit(String abbreviation, String fullName) {
    this.abbreviation = abbreviation;
    this.fullName = fullName;
  }

  static List<PriceUnit> getPriceUnits() {
    return [PriceUnit('sac', 'el saco'), PriceUnit('kg', 'el kilo'), PriceUnit('g', 'el gramo')];
  }
}