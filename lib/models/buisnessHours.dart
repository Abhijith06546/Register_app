class BusinessHours {
  Map<String, List<String>> hours;

  BusinessHours() : hours = {
    'mon': [],
    'tue': [],
    'wed': [],
    'thu': [],
    'fri': [],
    'sat': [],
    'sun': [],
  };

  void addHours(String day, String time) {
    if (hours.containsKey(day)) {
      hours[day]!.add(time);
    }
  }

  Map<String, List<String>> toJson() {
    return hours;
  }
}
