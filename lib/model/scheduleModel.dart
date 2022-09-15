class ScheduleModel {
  final Map<DateTime, List<ScheduleTimingModel>> scheduleData;
  bool isEdit;

  ScheduleModel(this.scheduleData, {this.isEdit = false});

  setIsEdit(bool b) {
    this.isEdit = b;
  }
}

class ScheduleTimingModel {
  final DateTime timeStart;
  final DateTime timeEnd;

  ScheduleTimingModel({required this.timeStart, required this.timeEnd});
}
