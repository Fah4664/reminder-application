import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ใช้สำหรับการเก็บข้อมูล

class ColorPicker extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    Key? key,
    this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> colors = [
    Colors.pink[100]!,
    Colors.redAccent[100]!,
    Colors.orange[100]!,
    Colors.yellow[100]!,
    Colors.greenAccent[100]!,
    Colors.blue[100]!,
    Colors.blueAccent[100]!,
    Colors.purple[100]!,
    Colors.grey[100]!,
    Colors.brown[300]!,
  ];

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _loadSelectedColor();
  }

  Future<void> _loadSelectedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('selectedColor');
    if (colorValue != null) {
      setState(() {
        _selectedColor = Color(colorValue);
      });
    }
  }

  Future<void> _saveSelectedColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', color.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colors[index];
                });
                widget.onColorSelected(colors[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == colors[index] ? Colors.white : Colors.transparent,
                    width: 3.0,
                  ),
                ),
                child: _selectedColor == colors[index]
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedColor != null) {
              _saveSelectedColor(_selectedColor!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Color saved!')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
