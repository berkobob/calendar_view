enum MonthNames {
  notUsedJanIs1,
  jan,
  feb,
  march,
  april,
  may,
  june,
  july,
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
