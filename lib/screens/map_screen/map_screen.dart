import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ridesense/models/location_coordinate.dart';
import 'package:ridesense/providers/location_provider.dart';
import 'package:ridesense/utils/extensions.dart';

class MapScreen extends StatefulWidget {
  final LocationCoordinates location;

  const MapScreen({super.key, required this.location});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _locationCoordinates;

  @override
  void initState() {
    super.initState();

    _locationCoordinates =
        LatLng(widget.location.latitude, widget.location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 30.w,
          title: Text(
            "Map View",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.blueGrey,
          actions: [
            PopupMenuButton<MapType>(
              onSelected: (MapType type) =>
                  locationProvider.updateMapType(type), // Update the map type
              color: Colors.white,
              iconColor: Colors.white,
              itemBuilder: (BuildContext context) {
                // index increased as eliminating the MapType.none
                return List.generate(
                  MapType.values.length - 1,
                  (index) => PopupMenuItem(
                    value: MapType.values[index + 1],
                    child: Text(
                        MapType.values[index + 1].name.capitalizeFirstLetter()),
                  ),
                );
              },
            ),
          ],
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _locationCoordinates,
            zoom: 14.0,
          ),
          mapType: locationProvider.currentMapType,
          markers: {
            Marker(
              markerId: const MarkerId('locationMarker'),
              position: _locationCoordinates,
              infoWindow: InfoWindow(
                  title:
                      "${widget.location.latitude} - ${widget.location.longitude}"),
            ),
          },
        ),
      ),
    );
  }
}
