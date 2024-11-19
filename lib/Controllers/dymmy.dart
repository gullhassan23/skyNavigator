// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:itsoftapp/STATIC/Models/Models.dart';
// import '../../Controller.dart';
// import '../Screens/POH.dart';
// import '../static.dart';
// import 'CBN.dart';
// import 'loading.dart';

// class SBar extends StatefulWidget {
//   final String ftable;
//   final MenuItem? mm;
//   final String mapkey;
//   final String? fieldname;
//   final Map<String, dynamic> bodymap;
//   const SBar(
//       {Key? key,
//       required this.ftable,
//       this.mm,
//       required this.mapkey,
//       this.fieldname,
//       required this.bodymap})
//       : super(key: key);
//   @override
//   State<SBar> createState() => _SBarState();
// }

// class _SBarState extends State<SBar> {
//   List<Map<String, dynamic>> datalist = [];
//   List<Map<String, dynamic>> filterlist = [];
//   late TextEditingController tec_search;
//   late StreamController<bool> loading;
//   String FindOn = "";
//   String Filter = "Open";

//   Future<void> FetchData() async {
//     String fTable = widget.ftable;

//     if (widget.ftable == 'DC' && Filter == 'Pending') {
//       fTable = 'pendingdc';
//     }

//     loading.sink.add(true);
//     datalist.clear();
//     filterlist.clear();
//     await GetListData(fTable, null, widget.bodymap).then((response) {
//       loading.sink.add(false);
//       if (response != null) {
//         if (response.statusCode == 200) {
// //          print(widget.mapkey);
//           //         print(response.body);
//           datalist = List<Map<String, dynamic>>.from(
//                   json.decode(response.body)['data'])
//               .toList();
//           filterlist = datalist;
//           //start e
//         }
//         setState(() {});
//       }
//     });
//   }
// }
