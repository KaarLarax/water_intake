String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString(); // year
  String month = dateTime.month.toString().padLeft(2, '0'); // month
  String day = dateTime.day.toString().padLeft(2, '0'); // day
  return year + month + day;
}
