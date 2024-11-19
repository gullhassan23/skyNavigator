class ALLState {
  final String icao24;
  final String callsign;
  final String originCountry;
  final int timePosition;
  final int lastContact;
  final double? longitude;
  final double? latitude;
  final double? baroAltitude;
  final bool onGround;
  final double? velocity;
  final String sensors;
  final double? verticalRate;
  final double? trueTract;
  final double? geoAltituce;
  final String quawk;
  final bool spi;
  final int positionSource;
  ALLState({
    this.icao24 = '',
    this.callsign = '',
    this.originCountry = '',
    this.timePosition = 0,
    this.lastContact = 0,
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.baroAltitude = 0.0,
    this.onGround = false,
    this.velocity = 0.0,
    this.sensors = '',
    this.verticalRate,
    this.trueTract = 0.0,
    this.geoAltituce = 0.0,
    this.quawk = '',
    this.spi = false,
    this.positionSource = 0,
  });

  factory ALLState.fromJson(dynamic json) {
    if (json == null) {
      return ALLState();
    }

    // Helper function to safely parse doubles
    double? parseDouble(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is int) {
        return value.toDouble();
      }
      if (value is double) {
        return value;
      }
      return null;
    }

    return ALLState(
      icao24: json[0] ?? '',
      callsign: json[1] != null ? json[1] as String : '',
      originCountry: json[2] ?? '',
      timePosition: json[3] != null ? json[3] as int : 0,
      lastContact: json[4] != null ? json[4] as int : 0,
      longitude: parseDouble(json[5]),
      latitude: parseDouble(json[6]),
      baroAltitude: parseDouble(json[7]),
      onGround: json[8] != null ? json[8] as bool : false,
      velocity: parseDouble(json[9]),
      trueTract: parseDouble(json[10]),
      verticalRate: parseDouble(json[11]),
      sensors: json[12] ?? '',
      geoAltituce: parseDouble(json[13]),
      quawk: json[14] ?? '',
      spi: json[15] != null ? json[15] as bool : false,
      positionSource: json[16] != null ? json[16] as int : 0,
    );
  }
}
