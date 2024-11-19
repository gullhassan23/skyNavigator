import 'dart:convert';

import 'package:skynavigator/models/AirportModel.dart';
import 'package:skynavigator/models/airCraftInfo.dart';
import 'package:skynavigator/models/allState.dart';

class Flightroutes {
  final String callSign;
  final Route route;
  final int updateTime;
  final String operatorIata;
  final int flightNumber;

  Airportmodel? airportInfoFrom;
  Airportmodel? airportInfoTo;
  Aircraftinfo? aircraftinfo;
  ALLState? state;

  Flightroutes({
    required this.callSign,
    required this.route,
    required this.updateTime,
    required this.operatorIata,
    required this.flightNumber,
    this.airportInfoFrom,
    this.airportInfoTo,
    this.aircraftinfo,
    this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callSign': callSign,
      'route': route.toMap(),
      'updateTime': updateTime,
      'operatorIata': operatorIata,
      'flightNumber': flightNumber,
      'airportInfoFrom': airportInfoFrom?.toMap(),
      'airportInfoTo': airportInfoTo?.toMap(),
      'aircraftinfo': aircraftinfo?.toMap(),
      'state': state, // Assuming ALLState has a toJson method
    };
  }

  factory Flightroutes.fromMap(Map<String, dynamic> map) {
    return Flightroutes(
      callSign: map['callSign'] as String,
      route: Route.fromMap(map['route'] as Map<String, dynamic>),
      updateTime: map['updateTime'] as int,
      operatorIata: map['operatorIata'] as String,
      flightNumber: map['flightNumber'] as int,
      airportInfoFrom: map['airportInfoFrom'] != null
          ? Airportmodel.fromMap(map['airportInfoFrom'] as Map<String, dynamic>)
          : null,
      airportInfoTo: map['airportInfoTo'] != null
          ? Airportmodel.fromMap(map['airportInfoTo'] as Map<String, dynamic>)
          : null,
      aircraftinfo: map['aircraftinfo'] != null
          ? Aircraftinfo.fromMap(map['aircraftinfo'] as Map<String, dynamic>)
          : null,
      state: map['state'] != null
          ? ALLState.fromJson(map['state'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Flightroutes.fromJson(String source) =>
      Flightroutes.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Route {
  final String fromAirport;
  final String toAirport;
  Route(this.fromAirport, this.toAirport);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromAirport': fromAirport,
      'toAirport': toAirport,
    };
  }

  factory Route.fromMap(Map<String, dynamic> map) {
    return Route(
      map['fromAirport'] as String,
      map['toAirport'] as String,
    );
  }
  String toJson() => json.encode(toMap());
  factory Route.fromJson(String source) =>
      Route.fromMap(json.decode(source) as Map<String, dynamic>);
}
