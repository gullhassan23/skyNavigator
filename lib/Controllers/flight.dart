import 'package:get/get.dart';
import 'package:skynavigator/models/FlightRoutes.dart';
import 'package:skynavigator/service/skyService.dart';

class FlightRoutesController extends GetxController {
  var isLoading = true.obs;
  var flightRoutes = Flightroutes(
    callSign: '',
    route: Route('', ''),
    updateTime: 0,
    operatorIata: '',
    flightNumber: 0,
  ).obs;
  var errorMessage = ''.obs;

  final SkyNavigator flightService = SkyNavigator();

  @override
  void onInit() {
    super.onInit();
    getFlightRoutes(
        'flight_number', 'icao24_code'); // Pass the correct arguments
  }

  void getFlightRoutes(String flight, String icao24) async {
    try {
      isLoading(true);
      var response = await flightService.getRoutes(flight, icao24);
      flightRoutes.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
