import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:ridesense/providers/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:ridesense/screens/search_screen/location_input_screen.dart';
import 'package:ridesense/widgets/snackbar_helper.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(geoCode: GeoCode(), location: Location()),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: MaterialApp(
            scaffoldMessengerKey: SnackbarHelper.scaffoldMessengerKey,
            title: 'Ride Sense',
            debugShowCheckedModeBanner: false,
            home: const LocationInputScreen()),
      ),
    );
  }
}
