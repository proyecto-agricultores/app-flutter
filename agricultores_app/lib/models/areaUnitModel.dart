class AreaUnit {
  String abbreviation;
  String fullName;

  AreaUnit(String abbreviation, String fullName) {
    this.abbreviation = abbreviation;
    this.fullName = fullName;
  }

  static List<AreaUnit> getAreaUnits() {
    return [AreaUnit('hm2', 'hectáreas'), AreaUnit('m2', 'metros cuadrados')];
  }
}