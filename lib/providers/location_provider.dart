import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ridesense/models/location_coordinate.dart';
import 'package:ridesense/utils/constants.dart';
import 'package:ridesense/utils/extensions.dart';
import 'package:ridesense/widgets/snackbar_helper.dart';

// Provider class to manage location-related data and state
class LocationProvider extends ChangeNotifier {
  // Current search type (e.g., city, address, coordinates)
  SearchType selectedType = SearchType.city;

  // User input fields
  String city = "";
  String address = "";
  String latitude = "";
  String longitude = "";

  // Error messages for user input validation
  String cityErrorText = "";
  String addressErrorText = "";
  String latitudeErrorText = "";
  String longitudeErrorText = "";

  // GeoCode instance for geocoding functionality
  GeoCode geoCode;

  // Loading state
  bool isLoading = false;

  // Current map display type
  MapType currentMapType = MapType.normal;

  // Location service instance
  Location location;

  // Constructor to initialize GeoCode and Location instances
  LocationProvider({required this.geoCode, required this.location});

  // Update the selected search type and notify listeners
  void updateSelectedType(SearchType selectedType) {
    try {
      this.selectedType = selectedType;
      notifyListeners();
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Validate the city input field
  void validateCityField() {
    try {
      if (city.isEmpty) {
        cityErrorText =
            ErrorMessage.cityErrorMessage; // Set error message if city is empty
        notifyListeners();
      }
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Validate the address input field
  void validateAddressField() {
    try {
      if (address.isEmpty) {
        addressErrorText = ErrorMessage
            .addressErrorMessage; // Set error message if address is empty
        notifyListeners();
      }
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Validate latitude and longitude input fields
  void validateCoordinates() {
    try {
      if (longitude.isEmpty) {
        longitudeErrorText = ErrorMessage
            .longErrorMessage; // Set error message if longitude is empty
        notifyListeners();
      }

      if (latitude.isEmpty) {
        latitudeErrorText = ErrorMessage
            .latiErrorMessage; // Set error message if latitude is empty
        notifyListeners();
      }
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Clear error messages based on the selected search type
  void clearErrorMessage(SearchType searchType) {
    try {
      switch (searchType) {
        case SearchType.city:
          cityErrorText = ""; // Clear city error message
          break;
        case SearchType.address:
          addressErrorText = ""; // Clear address error message
          break;
        case SearchType.coordinates:
          latitudeErrorText = ""; // Clear latitude error message
          longitudeErrorText = ""; // Clear longitude error message
          break;
      }
      notifyListeners(); // Notify listeners of the state change
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Clear all input values and error messages
  void clearAllValues() {
    try {
      // Reset input fields to empty strings
      city = "";
      address = "";
      latitude = "";
      longitude = "";

      // Reset error messages to empty strings
      cityErrorText = "";
      addressErrorText = "";
      latitudeErrorText = "";
      longitudeErrorText = "";

      // Notify listeners of the state change
      notifyListeners();
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Update the city input field with trimmed value
  void updateCity(String city) {
    try {
      this.city = city.trim(); // Trim whitespace from the city string
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Update the address input field with trimmed value
  void updateAddress(String address) {
    try {
      this.address = address.trim(); // Trim whitespace from the address string
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Update the latitude input field
  void updateLatitude(String latitude) {
    try {
      this.latitude = latitude; // Set the latitude value
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Update the longitude input field
  void updateLongitude(String longitude) {
    try {
      this.longitude = longitude; // Set the longitude value
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Validate the input fields based on the selected search type
  bool isFieldValidated() {
    try {
      if (selectedType == SearchType.city) {
        validateCityField(); // Validate the city field
        return cityErrorText.isEmpty; // Return true if no error
      } else if (selectedType == SearchType.address) {
        validateAddressField(); // Validate the address field
        return addressErrorText.isEmpty; // Return true if no error
      } else {
        validateCoordinates(); // Validate latitude and longitude fields
        return latitudeErrorText.isEmpty &&
            longitudeErrorText.isEmpty; // Return true if no error
      }
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
      return false; // Return false if an exception is caught
    }
  }

  // Validate if the given latitude and longitude are within valid ranges
  bool isValidCoordinates({required double lati, required double longi}) {
    try {
      // Latitude must be between -90 and 90; longitude must be between -180 and 180
      return (lati >= -90 && lati <= 90) && (longi >= -180 && longi <= 180);
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
      return false; // Return false if an exception is caught
    }
  }

  // Start loading state
  void startLoading() {
    try {
      isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners of the state change
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Stop loading state
  void stopLoading() {
    try {
      isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners of the state change
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Search for location based on selected type (city, address, or coordinates)
  Future<LocationCoordinates?> search() async {
    try {
      bool isValidated = isFieldValidated(); // Validate input fields

      if (isValidated) {
        startLoading(); // Start loading state

        // Determine search area based on selected type
        if (selectedType == SearchType.city ||
            selectedType == SearchType.address) {
          String searchArea =
              selectedType == SearchType.address ? address : city;

          // Perform geocoding to get coordinates
          Coordinates coordinates =
              await geoCode.forwardGeocoding(address: searchArea);

          // Check if latitude and longitude are valid
          if (coordinates.latitude != null && coordinates.longitude != null) {
            stopLoading(); // Stop loading state
            return LocationCoordinates(
              longitude: coordinates.longitude ?? 0,
              latitude: coordinates.latitude ?? 0,
            );
          }
        } else {
          // Parse latitude and longitude from strings
          double? latitude = double.tryParse(this.latitude);
          double? longitude = double.tryParse(this.longitude);

          // Validate coordinates and return LocationCoordinates if valid
          if (latitude != null &&
              longitude != null &&
              isValidCoordinates(lati: latitude, longi: longitude)) {
            stopLoading(); // Stop loading state
            return LocationCoordinates(
                latitude: latitude, longitude: longitude);
          }
        }
        stopLoading(); // Stop loading state if validation fails
        SnackbarHelper.showSnackbar("Invalid Location"); // Show error snackbar
      }
      return null; // Return null if not validated
    } on GeocodeException catch (_) {
      stopLoading(); // Stop loading state on geocode error
      SnackbarHelper.showSnackbar("Invalid Location"); // Show error snackbar
      return null; // Return null if geocode fails
    } catch (ex) {
      ex.logError(); // Log any other exceptions that occur
      stopLoading(); // Stop loading state
      SnackbarHelper.showSnackbar(
          "Something went wrong."); // Show error snackbar
      return null; // Return null on general error
    }
  }

  // Update the current map display type
  void updateMapType(MapType type) {
    try {
      currentMapType = type; // Set the new map type
      notifyListeners(); // Notify listeners of the state change
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    }
  }

  // Check if location services are enabled
  Future<bool> checkLocationService() async {
    startLoading(); // Start loading state
    try {
      // Check if the location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        // Request to enable location service if not enabled
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          SnackbarHelper.showSnackbar(
              "Please enable location services."); // Show error snackbar
          return false; // Return false if service is still not enabled
        }
      }
      return true; // Return true if service is enabled
    } finally {
      stopLoading(); // Stop loading state
    }
  }

  // Get location permission from the user
  Future<bool> getLocationPermission() async {
    startLoading(); // Start loading state
    try {
      // Check the current permission status
      PermissionStatus permissionGranted = await location.hasPermission();

      // If permission is granted or granted limited, return true
      if (permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited) {
        return true;
      }
      // If permission is denied, request permission
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.granted) {
          return true; // Return true if permission is granted
        } else {
          SnackbarHelper.showSnackbar(
              "Location permission is required."); // Show error snackbar
          return false; // Return false if permission is not granted
        }
      }

      // Handle the case where permission is denied forever
      if (permissionGranted == PermissionStatus.deniedForever) {
        SnackbarHelper.showSnackbar(
            "Location permission is denied forever. Please enable it in settings."); // Show error snackbar
        return false; // Return false if permission is denied forever
      }

      return false; // Return false for any other case
    } finally {
      stopLoading(); // Stop loading state
    }
  }

  // Get the current location of the device
  Future<LocationCoordinates?> getCurrentLocation() async {
    bool isServiceEnabled =
        await checkLocationService(); // Check if location service is enabled
    if (!isServiceEnabled) return null; // Return null if not enabled

    bool isPermissionGranted =
        await getLocationPermission(); // Get location permission
    if (!isPermissionGranted)
      return null; // Return null if permission is not granted

    startLoading(); // Start loading state
    try {
      // Get the current location data
      LocationData locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        // Return coordinates if latitude and longitude are available
        return LocationCoordinates(
          longitude: locationData.longitude!,
          latitude: locationData.latitude!,
        );
      } else {
        SnackbarHelper.showSnackbar(
            "Unable to get location data."); // Show error snackbar if data is unavailable
      }
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
    } finally {
      stopLoading(); // Stop loading state
    }

    return null; // Return null if location data is not available
  }
}
