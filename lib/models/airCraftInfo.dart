// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Aircraftinfo {
  final String registration;
  final String manufacturerName;
  final String manufacturerIcao;
  final String model;
  final String typecode;
  final String serialNumber;
  final String lineNumber;
  final String icaoAircraftClass;

  final String selCal;
  final String opeerator;

  final String operatorCallsign;

  final String operatorIcao;
  final String operatorIATA;
  final String owner;

  final String categoryDescription;
  final String country;
  final String icao24;

  final int timeStamp;

  Aircraftinfo(
      this.registration,
      this.manufacturerName,
      this.manufacturerIcao,
      this.model,
      this.typecode,
      this.serialNumber,
      this.lineNumber,
      this.icaoAircraftClass,
      this.selCal,
      this.opeerator,
      this.operatorCallsign,
      this.operatorIcao,
      this.operatorIATA,
      this.owner,
      this.categoryDescription,
      this.country,
      this.icao24,
      this.timeStamp);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'registration': registration,
      'manufacturerName': manufacturerName,
      'manufacturerIcao': manufacturerIcao,
      'model': model,
      'typecode': typecode,
      'serialNumber': serialNumber,
      'lineNumber': lineNumber,
      'icaoAircraftClass': icaoAircraftClass,
      'selCal': selCal,
      'opeerator': opeerator,
      'operatorCallsign': operatorCallsign,
      'operatorIcao': operatorIcao,
      'operatorIATA': operatorIATA,
      'owner': owner,
      'categoryDescription': categoryDescription,
      'country': country,
      'icao24': icao24,
      'timeStamp': timeStamp,
    };
  }

  factory Aircraftinfo.fromMap(Map<String, dynamic> map) {
    return Aircraftinfo(
      map['registration'] as String,
      map['manufacturerName'] as String,
      map['manufacturerIcao'] as String,
      map['model'] as String,
      map['typecode'] as String,
      map['serialNumber'] as String,
      map['lineNumber'] as String,
      map['icaoAircraftClass'] as String,
      map['selCal'] as String,
      map['opeerator'] as String,
      map['operatorCallsign'] as String,
      map['operatorIcao'] as String,
      map['operatorIATA'] as String,
      map['owner'] as String,
      map['categoryDescription'] as String,
      map['country'] as String,
      map['icao24'] as String,
      map['timeStamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Aircraftinfo.fromJson(String source) =>
      Aircraftinfo.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Aircraftinfo.empty() => Aircraftinfo(
      '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0);
}
