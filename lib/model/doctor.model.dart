// To parse this JSON data, do
//
//     final doctorProfile = doctorProfileFromJson(jsonString);

import 'dart:convert';

DoctorProfile doctorProfileFromJson(String str) => DoctorProfile.fromJson(json.decode(str));

String doctorProfileToJson(DoctorProfile data) => json.encode(data.toJson());

class DoctorProfile {
    bool success;
    String message;
    DoctorData data;

    DoctorProfile({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DoctorProfile.fromJson(Map<String, dynamic> json) => DoctorProfile(
        success: json["success"],
        message: json["message"],
        data: DoctorData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class DoctorData {
    int id;
    String userId;
    String primaryEmail;
    dynamic legalname;
    String gender;
    DateTime dob;
    String about;
    String status;
    List<String> specialization;
    String regNo;
    String displayPicPath;
    String documentPath;
    String address;
    String cityId;
    String stateId;
    String documentTypeId;

    DoctorData({
        required this.id,
        required this.userId,
        required this.primaryEmail,
        this.legalname,
        required this.gender,
        required this.dob,
        required this.about,
        required this.status,
        required this.specialization,
        required this.regNo,
        required this.displayPicPath,
        required this.documentPath,
        required this.address,
        required this.cityId,
        required this.stateId,
        required this.documentTypeId,
    });

    factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
        id: json["id"],
        userId: json["user_id"],
        primaryEmail: json["primary_email"],
        legalname: json["legalname"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        about: json["about"],
        status: json["status"],
        specialization: List<String>.from(json["specialization"].map((x) => x)),
        regNo: json["reg_no"],
        displayPicPath: json["display_pic_path"],
        documentPath: json["document_path"],
        address: json["address"],
        cityId: json["city_id"],
        stateId: json["state_id"],
        documentTypeId: json["document_type_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "primary_email": primaryEmail,
        "legalname": legalname,
        "gender": gender,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "about": about,
        "status": status,
        "specialization": List<dynamic>.from(specialization.map((x) => x)),
        "reg_no": regNo,
        "display_pic_path": displayPicPath,
        "document_path": documentPath,
        "address": address,
        "city_id": cityId,
        "state_id": stateId,
        "document_type_id": documentTypeId,
    };
}
