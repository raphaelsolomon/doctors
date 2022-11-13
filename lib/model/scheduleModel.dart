class ScheduleModel {
  final Map<String, ScheduleTimingModel> scheduleData;

  ScheduleModel(this.scheduleData);
}

class ScheduleTimingModel {
  List<String> morningShift = [];
  List<String> afternoonShift = [];
  List<String> eveningShift = [];
  List<String> midNightShift = [];

  ScheduleTimingModel(
      {required this.morningShift,
      required this.afternoonShift,
      required this.eveningShift,
      required this.midNightShift});

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
