class PriceUnit {
  String abbreviation;
  String fullName;

  PriceUnit(String abbreviation, String fullName) {
    this.abbreviation = abbreviation;
    this.fullName = fullName;
  }

  static List<PriceUnit> getPriceUnits() {
    return [PriceUnit('ton', 'toneladas'), PriceUnit('kg', 'kilogramos')];
  }
}