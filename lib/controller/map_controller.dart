import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:traffic_jam_mobile/data_source/api_data_source.dart';
import 'package:traffic_jam_mobile/dto/client_model.dart';
import 'package:traffic_jam_mobile/dto/enum_topic.dart';
import 'package:traffic_jam_mobile/dto/location.dart';
import 'package:traffic_jam_mobile/dto/response.dart';

class TrafficController extends GetxController {
  final ApiDataSource api;

  final MapController mapController;

  TrafficController({required this.api, required this.mapController});

  final RxBool isError = RxBool(false);

  final RxBool isLoading = RxBool(false);

  final RxList<ClientModel> clients = RxList();

  void callback(String? data, bool loading) {
    isLoading.value = loading;

    if (data == null) {
      isError.value = true;
      print(isError.value.toString());
      return;
    }

    isError.value = false;

    try {
      final convert = jsonDecode(data);

      final rs = ResponseModel.fromMap(convert);

      switch (rs.topic) {
        case Topic.getClients:
          final List<ClientModel> list = (rs.data as List)
              .map((e) => ClientModel.fromMap(e as Map<String, dynamic>))
              .toList();

          clients.clear();

          clients.addAll(list);

          for (var c in list) {
            final geo = GeoPoint(
                latitude: c.location?.lat ?? 0,
                longitude: c.location?.long ?? 0);
            mapController.addMarker(
                markerIcon: MarkerIcon(
                  icon: Icon(
                    Icons.directions_car_filled,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                geo);
          }

          break;

        case Topic.getClient:
          break;
        case Topic.getId:
          break;
        case Topic.getTrafficJam:
          final locStart =LocationModel.fromMap(rs.data['startLocation']);
          final locEnd = LocationModel.fromMap(rs.data['endLocation']);
          final start = GeoPoint(latitude: locStart.lat??0, longitude: locStart.long??0);
          final end = GeoPoint(latitude: locEnd.lat??0, longitude: locEnd.long??0);

          mapController.drawRoadManually([start, end,],
            RoadOption(
            roadColor: Colors.red,
            roadWidth: 5.0,  )
          );

          break;
        case Topic.updateClient:
          final ClientModel c = ClientModel.fromMap(rs.data);

          final i = clients.indexWhere((e) => e.id == c.id);

          if (i != -1) {
            final oldGeo = GeoPoint(
                latitude: clients[i].location?.lat ?? 0,
                longitude: clients[i].location?.long ?? 0);

            final newGeo = GeoPoint(
                latitude: c.location?.lat ?? 0,
                longitude: c.location?.long ?? 0);

            clients[i] = c;

            mapController.changeLocationMarker(
                oldLocation: oldGeo, newLocation: newGeo);
          } else {
            clients.add(c);

            final geo = GeoPoint(
                latitude: c.location?.lat ?? 0,
                longitude: c.location?.long ?? 0);

            mapController.addMarker(
                markerIcon: MarkerIcon(
                  icon: Icon(
                    Icons.directions_car_filled,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                geo);
          }

          break;
        case Topic.removeId:
          try {
            final id = rs.data['id'];

            final c = clients.singleWhere((e) => e.id == id);

            final GeoPoint geo = GeoPoint(
                latitude: c.location?.lat ?? 0,
                longitude: c.location?.long ?? 0);

            mapController.removeMarker(geo);

            clients.removeWhere((e) => e.id == id);
          } catch (e) {
            log('Error removeId');
          }
          break;
      }

      log(rs.data.toString());
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }
  }

  void connect() {
    api.connect(callback);
  }

  @override
  void onInit() {
    connect();
    super.onInit();
  }
}
