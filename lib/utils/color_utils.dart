import 'package:flutter/material.dart';

// Function to convert a hex color string into a Color object.
Color colorFromString(String colorString) {
  // Remove the '#' character from the start of the string, if present.
  if (colorString.startsWith('#')) {
    colorString = colorString.substring(1);
  }
  // If the string is 6 characters long (e.g., 'FFFFFF').
  //assume it's RGB and prepend 'FF' for full opacity.
  if (colorString.length == 6) {
    colorString = 'FF' + colorString;
    // If the string is not 8 characters (ARGB format), throw an error.
  } else if (colorString.length != 8) {
    throw const FormatException('Invalid color format');
  }
  // Try to parse the string as a hexadecimal integer and convert it to a Color object.
  try {
    return Color(int.parse(colorString, radix: 16));
    // If parsing fails, throw an error indicating an invalid color value.
  } catch (e) {
    throw const FormatException('Invalid color value');
  }
}