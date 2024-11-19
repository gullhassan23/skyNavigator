import 'dart:convert';

class Airportmodel {
  final String icao;
  final String iata;
  final String name;
  final Position position;
  final String continent;
  final String country;

  final String region;

  final String municipality;
  final String gpsCode;

  final String homePage;

  final String wikipedia;
  Airportmodel({
    this.icao = '',
    this.iata = '',
    this.name = '',
    required this.position,
    this.continent = '',
    this.country = '',
    this.region = '',
    this.municipality = '',
    this.gpsCode = '',
    this.homePage = '',
    this.wikipedia = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icao': icao,
      'iata': iata,
      'name': name,
      'position': position.toMap(),
      'continent': continent,
      'country': country,
      'region': region,
      'municipality': municipality,
      'gpsCode': gpsCode,
      'homePage': homePage,
      'wikipedia': wikipedia,
    };
  }

  factory Airportmodel.fromMap(Map<String, dynamic> map) {
    return Airportmodel(
      icao: map['icao'] as String,
      iata: map['iata'] as String,
      name: map['name'] as String,
      position: Position.fromMap(map['position'] as Map<String, dynamic>),
      continent: map['continent'] as String,
      country: map['country'] as String,
      region: map['region'] as String,
      municipality: map['municipality'] as String,
      gpsCode: map['gpsCode'] as String,
      homePage: map['homePage'] as String,
      wikipedia: map['wikipedia'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Airportmodel.fromJson(String source) =>
      Airportmodel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Airportmodel.empty() =>
      Airportmodel(position: Position(0.0, 0.0, 0.0, false));
}

class Position {
  final double lat;
  final double lng;
  final double altitude;
  final bool reasonable;

  Position(this.lat, this.lng, this.altitude, this.reasonable);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
      'altitude': altitude,
      'reasonable': reasonable,
    };
  }

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      map['lat'] as double,
      map['lng'] as double,
      map['altitude'] as double,
      map['reasonable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Position.fromJson(String source) =>
      Position.fromMap(json.decode(source) as Map<String, dynamic>);
}
