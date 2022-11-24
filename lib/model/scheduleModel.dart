class ScheduleModel {
  final Map<String, ScheduleTimingModel> scheduleData;

  ScheduleModel(this.scheduleData);
}

class ScheduleTimingModel {
  List<String> earlyMorningShift = [];
  List<String> morningShift = [];
  List<String> afternoonShift = [];
  List<String> eveningShift = [];
  List<String> midNightShift = [];

  ScheduleTimingModel(
      {required this.earlyMorningShift,
      required this.morningShift,
      required this.afternoonShift,
      required this.eveningShift,
      required this.midNightShift});

  void setEarlyMorning(String time) {
    this.earlyMorningShift.add(time);
  }

  void setMorning(String time) {
    this.morningShift.add(time);
  }

  void setAfternoon(String time) {
    this.afternoonShift.add(time);
  }

  void setEvening(String time) {
    this.eveningShift.add(time);
  }

  void setMidNight(String time) {
    this.midNightShift.add(time);
  }
}
