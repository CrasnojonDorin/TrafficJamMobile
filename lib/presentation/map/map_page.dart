import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:traffic_jam_mobile/controller/map_controller.dart';
import 'package:traffic_jam_mobile/data_source/api_data_source.dart';
import 'package:traffic_jam_mobile/presentation/login/login_dialog.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ApiDataSource _api = ApiDataSourceImpl();

  late TrafficController _controller;

  final option = OSMOption();

  final controller = MapController.withUserPosition(
      trackUserLocation: UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
      useExternalTracking: true);

  final RxBool isInitDone= RxBool(false);

  final List<GeoPoint> geoPoints = [];

  @override
  void initState() {
    // _controller = Get.put(TrafficController(api: _api));
    //
    // WidgetsBinding.instance.addPostFrameCallback((d) {
    //   controller.setZoom(zoomLevel: 12.0);
    //
    //   controller.moveTo(
    //       GeoPoint(latitude: 47.0383999758066, longitude: 28.852587763215183));
    //
    //   _controller = Get.put(TrafficController(api: _api));
    //
    //   _controller.clients.listen((e) {
    //     for (var c in e) {
    //       final geo = GeoPoint(
    //           latitude: c.location?.lat ?? 0, longitude: c.location?.long ?? 0);
    //
    //       geoPoints.add(geo);
    //
    //       if (controller.isAllLayersVisible) {
    //         controller.addMarker(
    //             markerIcon: MarkerIcon(
    //               icon: Icon(
    //                 Icons.location_on,
    //                 color: Colors.red,
    //                 size: 48,
    //               ),
    //             ),
    //             geo);
    //       }
    //     }
    //
    //     if (!controller.isAllLayersVisible) {
    //       return;
    //     }
    //
    //     if (e.isEmpty) {
    //       geoPoints.clear();
    //       controller.removeMarkers(geoPoints);
    //     }
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: option,
            onMapIsReady: (a) async{
            await  controller.moveTo(
                  GeoPoint(latitude: 47.0383999758066, longitude: 28.852587763215183),animate: true);

             await controller.setZoom(zoomLevel: 18);

              _controller = Get.put(TrafficController(api: _api, mapController: controller));

              // _controller.clients.listen((e) {
              //
              //   for (var c in e) {
              //     final index = geoPoints.indexWhere((e)=>e.latitude == geo.latitude && e.longitude == geo.longitude);
              //
              //     if(index == -1){
              //     controller.removeMarkers(geoPoints);}
              //
              //     final geo = GeoPoint(
              //         latitude: c.location?.lat ?? 0, longitude: c.location?.long ?? 0);
              //
              //     if(geoPoints.indexWhere((e)=>e.latitude == geo.latitude && e.longitude == geo.longitude) == -1){
              //     geoPoints.add(geo);
              //
              //
              //       controller.addMarker(
              //           markerIcon: MarkerIcon(
              //             icon: Icon(
              //               Icons.directions_car_filled,
              //               color: Colors.red,
              //               size: 28,
              //             ),
              //           ),
              //           geo);}
              //   }
              // });

              isInitDone.value = true;
            },
          ),

          Obx(
            ()=>
              (!isInitDone.value)? SizedBox.shrink(): LoginDialog()
          )
        ],
      ),
    );
  }
}
