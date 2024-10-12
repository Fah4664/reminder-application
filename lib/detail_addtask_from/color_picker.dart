import 'package:flutter/material.dart';

// ColorPicker widget that allows users to select a color from a list of predefined colors.
class ColorPicker extends StatelessWidget {
  // These colors are predefined for users to choose from.
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

  // This color is used to highlight the currently selected color option.
  final Color? selectedColor;
  // This function is called with the selected color when a user selects an option.
  final ValueChanged<Color> onColorSelected;

  // Constructor for ColorPicker, taking in the selected color and the onColorSelected callback.
  const ColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFf2f2f2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5),
          Wrap(
            spacing: 30.0,
            runSpacing: 8.0,
            children: colors
              // Build each color option.
              .map((color) => _buildColorOption(color))
              .toList(),
          ),
        ],
      ),
    );
  }

  // Helper method to build each individual color option as a circular selectable button.
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color
                ? const Color(0xFFede3e3)
                : Colors.transparent, width: 2,
          ),
        ),
        // Show a check icon if the color is selected, otherwise display nothing.
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white) // Check icon inside the selected color circle.
            : null,
      ),
    );
  }
}
