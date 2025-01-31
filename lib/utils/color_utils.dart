import 'package:flutter/material.dart';

// Function to darken a color using HSL color model.
// [color]: The color to be darkened.
// [factor]: The factor by which to darken the color (default is 0.1).
Color darkenColorHSL(Color color, {double factor = 0.1}) {
  // Convert the color to HSL format.
  HSLColor hslColor = HSLColor.fromColor(color);

  // Decrease the lightness by the factor, and clamp it within the range 0.0 to 1.0.
  hslColor = hslColor.withLightness((hslColor.lightness - factor).clamp(0.0, 1.0));

  // Increase the hue by 15 degrees, wrapping around at 360 degrees for continuity.
  hslColor = hslColor.withHue((hslColor.hue + 15.0) % 360.0);

  // Decrease the saturation by the factor, clamping within the range 0.0 to 1.0.
  hslColor = hslColor.withSaturation((hslColor.saturation - factor).clamp(0.0, 1.0));

  // Convert the modified HSL color back to a Color object and return.
  return hslColor.toColor();
}

// Function to lighten a color using HSL color model.
// [color]: The color to be lightened.
// [factor]: The factor by which to lighten the color (default is 0.1).
Color lightenColorHSL(Color color, {double factor = 0.1}) {
  // Convert the color to HSL format.
  HSLColor hslColor = HSLColor.fromColor(color);

  // Increase the lightness by the factor, and clamp it within the range 0.0 to 1.0.
  hslColor = hslColor.withLightness((hslColor.lightness + factor).clamp(0.0, 1.0));

  // Decrease the hue by 10 degrees, wrapping around at 360 degrees for continuity.
  hslColor = hslColor.withHue((hslColor.hue - 10.0) % 360.0);

  // Increase the saturation by the factor, clamping within the range 0.0 to 1.0.
  hslColor = hslColor.withSaturation((hslColor.saturation + factor).clamp(0.0, 1.0));

  // Convert the modified HSL color back to a Color object and return.
  return hslColor.toColor();
}
