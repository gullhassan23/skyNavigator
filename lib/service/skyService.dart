import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skynavigator/models/AirportModel.dart';
import 'package:skynavigator/models/FlightRoutes.dart';
import 'package:skynavigator/models/airCraftInfo.dart';
import 'package:skynavigator/models/allState.dart';

class SkyNavigator {
  Dio dio = Dio();

  // Future<List<ALLState>> getAllStateBounds(LatLng sw, LatLng ne) async {
  //   double latMid = (sw.latitude + ne.latitude) / 2;
  //   double lonMid = (sw.longitude + ne.longitude) / 2;

  //   // Break down into 4 smaller regions
  //   final regions = [
  //     LatLngBounds(southwest: sw, northeast: LatLng(latMid, lonMid)),
  //     LatLngBounds(
  //         southwest: LatLng(latMid, sw.longitude),
  //         northeast: LatLng(ne.latitude, lonMid)),
  //     LatLngBounds(
  //         southwest: LatLng(sw.latitude, lonMid),
  //         northeast: LatLng(latMid, ne.longitude)),
  //     LatLngBounds(southwest: LatLng(latMid, lonMid), northeast: ne),
  //   ];

  //   List<ALLState> allData = [];

  //   for (var region in regions) {
  //     final String url =
  //         "https://opensky-network.org/api/states/all?lamin=${region.southwest.latitude}&lomin=${region.southwest.longitude}&lamax=${region.northeast.latitude}&lomax=${region.northeast.longitude}";

  //     try {
  //       final response = await dio.get(url);
  //       List<ALLState> data = (response.data['states'] as List).map((e) {
  //         return ALLState.fromJson(e);
  //       }).toList();
  //       allData.addAll(data);
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //     await Future.delayed(
  //         Duration(seconds: 5)); // Delay to prevent rate-limiting
  //   }

  //   return allData;
  // }

  Future<List<ALLState>> getAllStateBounds(LatLng sw, LatLng ne) async {
    final String url =
        "https://opensky-network.org/api/states/all?lamin=${sw.latitude}&lomin=${sw.longitude}&lamax=${ne.latitude}&lomax=${ne.longitude}";

    try {
      return await _makeRequestWithRetry(url);
    } catch (e) {
      print('Error: $e');
      return List.empty();
    }
  }

  Future<Flightroutes> getRoutes(String flight, String icao24) async {
    final String url =
        "https://opensky-network.org/api/routes?callsign=${flight.trim()}";

    try {
      final response = await dio.get(url);
      Flightroutes routes = Flightroutes.fromJson(response.data);
      Airportmodel fromInfo = await getAirPortInfo(routes.route.fromAirport);
      Airportmodel toInfo = await getAirPortInfo(routes.route.toAirport);
      Aircraftinfo info = await getAircraftInfo(icao24);
      ALLState state = await getState(icao24);
      routes.airportInfoFrom = fromInfo;
      routes.airportInfoTo = toInfo;
      routes.aircraftinfo = info;
      routes.state = state;
      return routes;
    } catch (e) {
      print(e);
      return Flightroutes(
        callSign: '',
        route: Route('', ''),
        updateTime: 0,
        operatorIata: '',
        flightNumber: 0,
      );
    }
  }

  Future<Airportmodel> getAirPortInfo(String icao24) async {
    final String url = "https://opensky-network.org/api/airports/?icao=$icao24";
    try {
      final response = await dio.get(url);
      return Airportmodel.fromJson(response.data);
    } catch (error) {
      return Airportmodel.empty();
    }
  }

  Future<Aircraftinfo> getAircraftInfo(String icao24) async {
    final String url =
        "https://opensky-network.org/api/metadata/aircraft/icao/$icao24";
    try {
      final response = await dio.get(url);
      return Aircraftinfo.fromJson(response.data);
    } catch (error) {
      return Aircraftinfo.empty();
    }
  }

  Future<ALLState> getState(String icao24) async {
    final String url =
        "https://opensky-network.org/api/states/all?icao24=$icao24";
    try {
      final response = await dio.get(url);
      return ALLState.fromJson(response.data);
    } catch (error) {
      return ALLState();
    }
  }

  Future<List<ALLState>> _makeRequestWithRetry(String url,
      {int retries = 3}) async {
    try {
      final response = await dio.get(url);
      print('Response: ${response.data}');

      List<ALLState> data = (response.data['states'] as List).map((e) {
        print('State data: $e');
        return ALLState.fromJson(e);
      }).toList();

      return data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 && retries > 0) {
        // Get the retry-after duration from headers
        int retryAfterSeconds = int.parse(
            e.response?.headers.value('X-Rate-Limit-Retry-After-Seconds') ??
                '5');

        print(
            'Rate limit exceeded. Retrying after $retryAfterSeconds seconds...');

        // Wait before retrying
        await Future.delayed(Duration(seconds: retryAfterSeconds));

        // Retry the request
        return _makeRequestWithRetry(url, retries: retries - 1);
      } else {
        throw e; // Re-throw the exception if retries are exhausted
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
