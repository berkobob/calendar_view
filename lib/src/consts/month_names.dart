enum MonthNames {
  jan,
  feb,
  mar,
  apr,
  may,
  jun,
  jul,
  aug,
  sep,
  oct,
  nov,
  dec;

  @override
  String toString() {
    return "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
  }
}
