// ignore_for_file: avoid_print
extension Capitalize on String {
  /// Capitalizes the first letter of the string.
  /// Returns the original string if it's empty.
  String capitalizeFirstLetter() {
    try {
      if (isEmpty) return this; // Check if the string is empty

      // Capitalize the first letter and concatenate with the rest of the string
      return substring(0, 1).toUpperCase() + substring(1);
    } catch (ex) {
      ex.logError(); // Log any exceptions that occur
      return ""; // Return an empty string in case of an error
    }
  }
}

extension ExceptionHandle on Object {
  /// Logs the error message to the console.
  void logError() {
    print("##-_ ERROR LOGGED _-##"); // Log start marker
    print(toString()); // Print the error message
    print("##-_ ERROR LOGGED _-##"); // Log end marker
  }
}
