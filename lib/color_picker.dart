import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
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

  final Color? selectedColor; // ส่งสีที่เลือกเข้ามาจากภายนอก
  final ValueChanged<Color> onColorSelected;

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
        color: const Color(0xFFf2f2f2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: colors.map((color) => _buildColorOption(color)).toList(),
          ),
        ],
      ),
    );
  }

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
            color: selectedColor == color ? const Color(0xFF9b9a8c) : Colors.transparent, // เปลี่ยนสีกรอบตามสีที่เลือก
            width: 2,
          ),
        ),
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}
