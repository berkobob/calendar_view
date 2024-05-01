enum DaysOfWeek {
  notUsedMondayIs1,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  @override
  String toString() =>
      "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
