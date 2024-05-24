enum DaysOfWeek {
  notUsedMondayIs1,
  mon,
  tues,
  wed,
  thur,
  fri,
  sat,
  sun;

  @override
  String toString() =>
      "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
