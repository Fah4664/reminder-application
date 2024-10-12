import 'package:flutter/material.dart';

// ColorPicker widget that allows users to select a color from a list of predefined colors
class ColorPicker extends StatelessWidget {
  // List of available colors for selection
  static const List<Color> colors = [
    Color(0xFFede3e3),
    Color(0xFFffb4bb),
    Color(0xFFffdfb9),
    Color(0xFFffffb9),
    Color(0xFFbaffc9),
    Color(0xFFc0d7ff),
    Color(0xFF73d1ea),
    Color(0xFFbf9adf),
    Color(0xFFd0d0d0),
    Color(0xFF9b9a8c),
  ];

  // The currently selected color (passed from outside the widget)
  final Color? selectedColor; // ส่งสีที่เลือกเข้ามาจากภายนอก
  // Callback function when a color is selected
  final ValueChanged<Color> onColorSelected;

  // Constructor for ColorPicker, taking in the selected color and the onColorSelected callback
  const ColorPicker({
    super.key, // ใช้ super.key
    this.selectedColor, // รับสีที่เลือกเข้ามา
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(
            0xFFf2f2f2), // Light gray background color for the picker
        borderRadius:
            BorderRadius.circular(15.0), // Rounded corners for the container
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5), // Add some vertical space
          // Wrap widget arranges the color options in a grid-like structure with spacing
          Wrap(
            spacing:
                30.0, // Space between colors horizontally ช่องว่างระหว่างสี
            runSpacing:
                8.0, //Space between rows of colors ช่องว่างระหว่างบรรทัด
            children: colors
                .map((color) => _buildColorOption(color))
                .toList(), // Build each color option
          ),
        ],
      ),
    );
  }

  // Helper method to build each individual color option as a circular selectable button
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      // Handle the tap event when a color is selected
      onTap: () => onColorSelected(color),
      child: Container(
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          color: color, // Set the background color to the color option
          shape: BoxShape.circle, // Make the option a circle
          border: Border.all(
            // Show a border around the selected color
            color: selectedColor == color
                ? const Color(0xFFede3e3)
                : Colors
                    .transparent, // Change border color based on selected color เปลี่ยนสีกรอบตามสีที่เลือก
            width: 2, // Border width
          ),
        ),
        // Show a check icon if the color is selected, otherwise display nothing
        child: selectedColor == color
            ? const Icon(Icons.check,
                color:
                    Colors.white) // Check icon inside the selected color circle
            : null,
      ),
    );
  }
}
