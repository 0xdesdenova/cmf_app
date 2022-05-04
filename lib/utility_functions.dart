String parseTime(String timeString) {
  List timeVector = timeString.split(':');

  String hour = int.parse(timeVector[0]) == 0 || int.parse(timeVector[0]) == 12
      ? '12'
      : int.parse(timeVector[0]) < 12
          ? int.parse(timeVector[0]).toString()
          : (int.parse(timeVector[0]) - 12).toString();

  String meridian = int.parse(timeVector[0]) < 12 ? 'am' : 'pm';
  String paredTime = '$hour:${timeVector[1]}$meridian';

  return paredTime;
}

String parseDuration(String timeString) {
  List timeVector = timeString.split(':');

  String paredTime =
      '${int.parse(timeVector[0]) * 60 + int.parse(timeVector[1])}m';

  return paredTime;
}

String calculateDistance(
    {required double latitude, required double longitude}) {
  return '12';
}
