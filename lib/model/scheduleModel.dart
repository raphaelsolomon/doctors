class ScheduleModel {
  final Map<DateTime, List<ScheduleTimingModel>> scheduleData;
  bool isEdit;

  ScheduleModel(this.scheduleData, {this.isEdit = false});

  setIsEdit(bool b) {
    this.isEdit = b;
  }
}

class ScheduleTimingModel {
  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  ScheduleTimingModel({required this.timeStart,  required this.timeEnd});

  void setStart(DateTime time){
    this.timeStart = time;
  }

  void setEnd(DateTime time){
    this.timeEnd = time;
  }
}
