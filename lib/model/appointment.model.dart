// To parse this JSON data, do
//
//     final doctorAppointment = doctorAppointmentFromJson(jsonString);

import 'dart:convert';

DoctorAppointment doctorAppointmentFromJson(String str) => DoctorAppointment.fromJson(json.decode(str));

String doctorAppointmentToJson(DoctorAppointment data) => json.encode(data.toJson());

class DoctorAppointment {
  bool success;
  String message;
  AppointmentData data;

  DoctorAppointment({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) => DoctorAppointment(
        success: json["success"],
        message: json["message"],
        data: AppointmentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class AppointmentData {
  int currentPage;
  List<AppointmentDatum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  AppointmentData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) => AppointmentData(
        currentPage: json["current_page"],
        data: List<AppointmentDatum>.from(json["data"].map((x) => AppointmentDatum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class AppointmentDatum {
  String legalname;
  String name;
  dynamic profilePicture;
  DateTime appointmentDate;
  DateTime bookingDate;
  DateTime? confirmationDate;
  String? amount;
  dynamic followUp;
  String status;
  String? meetingType;
  late bool isLoading;

  AppointmentDatum({
    required this.legalname,
    required this.name,
    this.profilePicture,
    required this.appointmentDate,
    required this.bookingDate,
    this.confirmationDate,
    this.amount,
    this.followUp,
    required this.status,
    this.meetingType,
    this.isLoading = false,
  });

  setIsLoading(bool value) {
    this.isLoading = value;
  }

  factory AppointmentDatum.fromJson(Map<String, dynamic> json) => AppointmentDatum(
        legalname: json["legalname"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        appointmentDate: DateTime.parse(json["appointment_date"]),
        bookingDate: DateTime.parse(json["booking_date"]),
        confirmationDate: json["confirmation_date"] == null ? null : DateTime.parse(json["confirmation_date"]),
        amount: json["amount"],
        followUp: json["follow_up"],
        status: json["status"],
        meetingType: json["meeting_type"],
      );

  Map<String, dynamic> toJson() => {
        "legalname": legalname,
        "name": name,
        "profile_picture": profilePicture,
        "appointment_date": appointmentDate.toIso8601String(),
        "booking_date": bookingDate.toIso8601String(),
        "confirmation_date": confirmationDate?.toIso8601String(),
        "amount": amount,
        "follow_up": followUp,
        "status": status,
        "meeting_type": meetingType,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
