# RideSense Location Checker App

## Overview

The App allows users to input a location (city name, address, or coordinates) and visualize it on a Google Map. Users can also switch between different map types and see their current location. This app is built using Flutter and utilizes the following packages:

- **geocode**: Used for converting the location input into geographic coordinates.
- **google_maps_flutter**: Integrates Google Maps into the app for location display.
- **location**: Detects the user's current location.

## Features

1. **Location Input Screen**: 
   - Users are prompted to enter a location in a text field.
   - Basic validation ensures the input field is not empty.
   - A button navigates to the map display screen after the location is entered.

2. **Map Display Screen**:
   - Loads a Google Map and displays the user-entered location with a marker.
   - Users can switch between different map types (e.g., satellite, terrain).
   - The app detects and displays the user’s current location on the map.

3. **Error Handling**:
   - Gracefully handles invalid or non-existent locations.

## Setup Instructions

To run the app, follow these steps:

### Prerequisites
- Ensure you have Flutter installed on your machine.
- Set up your development environment for Flutter according to the [official documentation](https://flutter.dev/docs/get-started/install).

### Google Maps API Key

1. **Obtain a Google Maps API key** by following the [Google Maps Platform documentation](https://developers.google.com/maps/gmp-get-started).

2. **Add the API key in `AndroidManifest.xml`**:
   ```xml
   <manifest>
       <application>
           <meta-data
               android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_API_KEY_HERE"/>
       </application>
   </manifest>
3. **Add the API key in `AppDelegate.swift` for iOS**:
   ```swift
    import UIKit
    import Flutter
    import GoogleMaps
    
    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GMSServices.provideAPIKey("API_KEY")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    }

# Download the App

You can download the  App from the following Google Drive link:

[Download RideSense Location Checker](https://drive.google.com/file/d/1-2P74GRkrttukPHlfRNHjG11-swHqrEd/view?usp=drivesdk)

# Screenshots

![Location Checker View](https://github.com/user-attachments/assets/0ddee8e1-1250-4f14-98ba-b8132feef3d6)


