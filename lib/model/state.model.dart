// To parse this JSON data, do
//
//     final stateCityModel = stateCityModelFromJson(jsonString);

import 'dart:convert';

StateCityModel stateCityModelFromJson(String str) => StateCityModel.fromJson(json.decode(str));

String stateCityModelToJson(StateCityModel data) => json.encode(data.toJson());

class StateCityModel {
    bool success;
    String message;
    List<StateData> data;

    StateCityModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory StateCityModel.fromJson(Map<String, dynamic> json) => StateCityModel(
        success: json["success"],
        message: json["message"],
        data: List<StateData>.from(json["data"].map((x) => StateData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class StateData {
    int id;
    String name;
    List<City> cities;

    StateData({
        required this.id,
        required this.name,
        required this.cities,
    });

    factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        id: json["id"],
        name: json["name"],
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
    };
}

class City {
    int id;
    String name;

    City({
        required this.id,
        required this.name,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
