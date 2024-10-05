import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ridesense/models/location_coordinate.dart';
import 'package:ridesense/providers/location_provider.dart';
import 'package:ridesense/screens/map_screen/map_screen.dart';
import 'package:ridesense/screens/search_screen/dependents/address_field.dart';
import 'package:ridesense/screens/search_screen/dependents/city_field.dart';
import 'package:ridesense/screens/search_screen/dependents/coordinates_field.dart';
import 'package:ridesense/utils/constants.dart';
import 'package:ridesense/widgets/search_dropdown.dart';

class LocationInputScreen extends StatefulWidget {
  const LocationInputScreen({super.key});

  @override
  State<LocationInputScreen> createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  // Controllers for text input fields
  final TextEditingController _cityFieldController = TextEditingController();
  final TextEditingController _addressFieldController = TextEditingController();
  final TextEditingController _longFieldController = TextEditingController();
  final TextEditingController _lateFieldController = TextEditingController();

  // Focus nodes to manage focus for input fields
  final FocusNode _cityFieldFocusNode = FocusNode();
  final FocusNode _addressFieldFocusNode = FocusNode();
  final FocusNode _longFieldFocusNode = FocusNode();
  final FocusNode _latiFieldFocusNode = FocusNode();

  late LocationProvider _locationProvider; // Instance of LocationProvider

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method

    // Listener for city field focus changes
    _cityFieldFocusNode.addListener(() {
      if (!_cityFieldFocusNode.hasFocus) {
        _locationProvider
            .validateCityField(); // Validate city field when focus is lost
      } else {
        _locationProvider.clearErrorMessage(
            SearchType.city); // Clear error message when focused
      }
    });

    // Listener for address field focus changes
    _addressFieldFocusNode.addListener(() {
      if (!_addressFieldFocusNode.hasFocus) {
        _locationProvider
            .validateAddressField(); // Validate address field when focus is lost
      } else {
        _locationProvider.clearErrorMessage(
            SearchType.address); // Clear error message when focused
      }
    });

    // Listener for latitude field focus changes
    _latiFieldFocusNode.addListener(() {
      if (!_latiFieldFocusNode.hasFocus) {
        _locationProvider
            .validateCoordinates(); // Validate coordinates when focus is lost
      } else {
        _locationProvider.clearErrorMessage(
            SearchType.coordinates); // Clear error message when focused
      }
    });

    // Listener for longitude field focus changes
    _longFieldFocusNode.addListener(() {
      if (!_longFieldFocusNode.hasFocus) {
        _locationProvider
            .validateCoordinates(); // Validate coordinates when focus is lost
      } else {
        _locationProvider.clearErrorMessage(
            SearchType.coordinates); // Clear error message when focused
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _locationProvider = Provider.of<LocationProvider>(
        context); // Get the LocationProvider instance

    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "RideSense App",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top,
                    left: 30.w,
                    right: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.w), // Spacer
                    Icon(
                      Icons.location_on, // Location icon
                      color: Colors.blueGrey,
                      size: 100.h,
                    ),
                    SizedBox(height: 10.w), // Spacer
                    Text("Search location", // Header text
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey)),
                    SizedBox(height: 30.h), // Spacer
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Select search type", // Prompt for search type
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10.h), // Spacer
                    // Dropdown for selecting search type
                    SearchDropdown(
                        dropDownItems: SearchType.values
                            .map((item) => item.name)
                            .toList(), // Map search types to dropdown items
                        selectedItem: locationProvider
                            .selectedType.name, // Current selection
                        onSelection: (String value) {
                          // Callback for selection change
                          SearchType searchType = SearchType.values
                              .byName(value); // Convert string to enum
                          locationProvider.updateSelectedType(
                              searchType); // Update provider with selected type
                          _clearFieldText(
                              searchType); // Clear fields based on selection
                        }),
                    SizedBox(height: 20.h), // Spacer
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Fill below field", // Prompt to fill fields
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10.h), // Spacer
                    // Conditional input fields based on selected search type
                    if (locationProvider.selectedType == SearchType.city)
                      CityField(
                        controller:
                            _cityFieldController, // City field controller
                        focusNode:
                            _cityFieldFocusNode, // Focus node for city field
                        onChange: (String value) {
                          // Callback for value change
                          locationProvider
                              .updateCity(value); // Update city in provider
                        },
                        errorMessage: locationProvider
                            .cityErrorText, // Display error message
                      ),
                    if (locationProvider.selectedType == SearchType.address)
                      AddressField(
                        controller:
                            _addressFieldController, // Address field controller
                        focusNode:
                            _addressFieldFocusNode, // Focus node for address field
                        onChange: (String value) => // Callback for value change
                            locationProvider.updateAddress(
                                value), // Update address in provider
                        errorMessage: locationProvider
                            .addressErrorText, // Display error message
                      ),
                    if (locationProvider.selectedType == SearchType.coordinates)
                      CoordinatesField(
                        longTextEditingController:
                            _longFieldController, // Longitude field controller
                        longFocusNode:
                            _longFieldFocusNode, // Focus node for longitude field
                        latiTextEditingController:
                            _lateFieldController, // Latitude field controller
                        latiFocusNode:
                            _latiFieldFocusNode, // Focus node for latitude field
                        onChangedLati:
                            (String value) => // Callback for latitude change
                                locationProvider.updateLatitude(
                                    value), // Update latitude in provider
                        onChangedLong:
                            (String value) => // Callback for longitude change
                                locationProvider.updateLongitude(
                                    value), // Update longitude in provider
                        longErrorMessage: locationProvider
                            .longitudeErrorText, // Display longitude error
                        latiErrorMessage: locationProvider
                            .latitudeErrorText, // Display latitude error
                      ),
                    SizedBox(height: 20.h), // Spacer
                    // Button to initiate location search
                    FilledButton(
                      onPressed: () async {
                        LocationCoordinates? locationCoordinates =
                            await locationProvider.search(); // Execute search

                        if (locationCoordinates != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapScreen(
                                      location:
                                          locationCoordinates))); // Navigate to MapScreen with found coordinates
                        }
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          fixedSize: Size(300.w, 40.h)),
                      child: Text("Search", // Button label
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                    // Button to get current location
                    TextButton(
                      style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: Colors.white),
                      onPressed: () async {
                        LocationCoordinates? locationCoordinates =
                            await locationProvider
                                .getCurrentLocation(); // Fetch current location

                        if (locationCoordinates != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapScreen(
                                      location:
                                          locationCoordinates))); // Navigate to MapScreen with current coordinates
                        }
                      },
                      child: const Text(
                        "Get Current Location", // Button label
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              // Loading indicator overlay
              if (locationProvider.isLoading)
                Container(
                  height: MediaQuery.sizeOf(context)
                      .height, // Full height for overlay
                  width: MediaQuery.sizeOf(context)
                      .width, // Full width for overlay
                  color: Colors.black
                      .withOpacity(.25), // Semi-transparent background
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: Colors.black), // Loading spinner
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
  void _clearFieldText(SearchType type) {
    switch (type) {
      case SearchType.city:
        _addressFieldController.clear(); // Clear the address field
        _lateFieldController.clear(); // Clear the latitude field
        _longFieldController.clear(); // Clear the longitude field
        break;
      case SearchType.address:
        _cityFieldController.clear(); // Clear the city field
        _lateFieldController.clear(); // Clear the latitude field
        _longFieldController.clear(); // Clear the longitude field
        break;
      case SearchType.coordinates:
        _cityFieldController.clear(); // Clear the city field
        _addressFieldController.clear(); // Clear the address field
        break;
    }
    _locationProvider.clearAllValues(); // Reset all values in the LocationProvider
  }

}
