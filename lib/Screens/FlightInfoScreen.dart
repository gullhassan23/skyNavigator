import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:skynavigator/Controllers/flight.dart';
import 'package:skynavigator/models/allState.dart';

class FlightInfoScreen extends StatelessWidget {
  final FlightRoutesController flightRoutesController =
      Get.put(FlightRoutesController());
  final ALLState info;

  FlightInfoScreen({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.navigate_before,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/plane.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Obx(() {
                      if (flightRoutesController.isLoading.value) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (flightRoutesController
                          .errorMessage.isNotEmpty) {
                        return Text(
                          'Error: ${flightRoutesController.errorMessage.value}',
                          style: TextStyle(color: Colors.red),
                        ); // Show error message if there's an error
                      } else {
                        return Text(
                          "Flight ${flightRoutesController.flightRoutes.value.operatorIata}",
                        ); // Show the flight operatorIata once data is loaded
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
