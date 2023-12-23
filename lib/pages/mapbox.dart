import 'dart:convert';

import 'package:finder/data/firefighter.dart';
import 'package:finder/data/hospitals.dart';
import 'package:finder/data/pharmacy.dart';
import 'package:finder/data/police.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapBoxPage extends StatefulWidget {
  const MapBoxPage({super.key});

  @override
  State<MapBoxPage> createState() => _MapBoxPageState();
}

class _MapBoxPageState extends State<MapBoxPage> {
  bool isVisible = false;
  void getroutes(userlat, userlong, destinationLat, destinationLong) async {
    var v1 = userlat;
    var v2 = userlong;
    var v3 = destinationLat;
    var v4 = destinationLong;
    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    print(response.body);
    setState(() {
      polylines = [];
      var ruter =
          jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < ruter.length; i++) {
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        polylines.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      isVisible = !isVisible;
      print(polylines);
    });
  }

  double iconsizeheight = 80.0.h;
  double iconsizewidth = 80.0.w;
  MapController mapController = MapController();
  Map<String, dynamic> userlocation = {
    'latitude': 27.86339061300621,
    'longitude': 34.30290753897982,
    "name": 'بيت الشباب'
  };
  List<LatLng> polylines = [LatLng(27.86339061300621, 34.30290753897982)];
  var search = TextEditingController();
  List<Marker> list = [
    Marker(
      width: 50.0.w,
      height: 50.0.h,
      point: LatLng(27.86339061300621, 34.30290753897982),
      child: GestureDetector(
        onTap: () {
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("here"));
        },
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                width: double.infinity,
                child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        maxZoom: 90,
                        initialCenter: LatLng(userlocation['latitude'],
                            userlocation['longitude']),
                        initialZoom: 13.0,
                        keepAlive: true),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: polylines,
                            color: Colors.red,
                            strokeWidth: 9.0,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: list,
                      ),
                    ]),
              ),
              Positioned(
                top: 550.h,
                left: 0,
                right: 0,
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              list = [
                                Marker(
                                  width: 50.0.w,
                                  height: 50.0.h,
                                  point: const LatLng(
                                      27.86339061300621, 34.30290753897982),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                ),
                              ];
                              for (var element in hospitals) {
                                list.add(
                                  Marker(
                                    width: iconsizewidth,
                                    height: iconsizeheight,
                                    point:
                                        LatLng(element['lat'], element['long']),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          getroutes(
                                              27.86339061300621,
                                              34.30290753897982,
                                              element['lat'],
                                              element['long']);
                                          print(polylines);
                                        });
                                      },
                                      child: SizedBox(
                                        height: iconsizeheight,
                                        width: iconsizewidth,
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.local_hospital,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              element['name'],
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_hospital_outlined),
                                  Text("مستشفي",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                list = [
                                  Marker(
                                    width: 50.0.w,
                                    height: 50.0.h,
                                    point: const LatLng(
                                        27.86339061300621, 34.30290753897982),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                  ),
                                ];
                                for (var element in police) {
                                  list.add(
                                    Marker(
                                      width: iconsizewidth,
                                      height: iconsizeheight,
                                      point: LatLng(
                                          element['lat'], element['long']),
                                      child: GestureDetector(
                                        onTap: () {
                                          getroutes(
                                              27.86339061300621,
                                              34.30290753897982,
                                              element['lat'],
                                              element['long']);
                                          print(polylines);
                                        },
                                        child: SizedBox(
                                          height: iconsizeheight,
                                          width: iconsizewidth,
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.local_police,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                element['name'],
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.local_police_outlined),
                                    Text(
                                      "شرطة",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                list = [
                                  Marker(
                                    width: 50.0.w,
                                    height: 50.0.h,
                                    point: const LatLng(
                                        27.86339061300621, 34.30290753897982),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ];
                                for (var element in pharmacy) {
                                  list.add(
                                    Marker(
                                      width: iconsizewidth,
                                      height: iconsizeheight,
                                      point: LatLng(
                                          element['lat'], element['long']),
                                      child: GestureDetector(
                                        onTap: () {
                                          getroutes(
                                              27.86339061300621,
                                              34.30290753897982,
                                              element['lat'],
                                              element['long']);
                                          print(polylines);
                                        },
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.local_pharmacy_outlined,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              element['name'],
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.local_pharmacy),
                                    Text(
                                      "صيدلية",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                list = [
                                  Marker(
                                    width: 50.0.w,
                                    height: 50.0.h,
                                    point: const LatLng(
                                        27.86339061300621, 34.30290753897982),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                  ),
                                ];
                                for (var element in firefighter) {
                                  list.add(
                                    Marker(
                                      width: iconsizewidth,
                                      height: iconsizeheight,
                                      point: LatLng(
                                          element['lat'], element['long']),
                                      child: GestureDetector(
                                        onTap: () {
                                          getroutes(
                                              27.86339061300621,
                                              34.30290753897982,
                                              element['lat'],
                                              element['long']);
                                          print(polylines);
                                        },
                                        child: SizedBox(
                                          height: iconsizeheight,
                                          width: iconsizewidth,
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.local_fire_department,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                element['name'],
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.fire_truck),
                                    Text("إطفائية",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                child: Container(
                  height: 100.h,
                  width: 360.w,
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: search,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                        hintText: "ادخل العنوان",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: GestureDetector(
                            onTap: () async {
                              List<Location> locations =
                                  await locationFromAddress(search.text);
                              print(locations[0]);
                              setState(() {
                                userlocation['latitude'] =
                                    locations[0].latitude;
                                userlocation['longitude'] =
                                    locations[0].longitude;
                                userlocation['name'] = search.text;
                                list = [
                                  Marker(
                                    width: 80.0.w,
                                    height: 80.0.h,
                                    point: LatLng(locations[0].latitude,
                                        locations[0].longitude),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                  ),
                                ];

                                mapController.move(
                                    LatLng(locations[0].latitude,
                                        locations[0].longitude),
                                    7);
                              });
                            },
                            child: Icon(Icons.search)),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
